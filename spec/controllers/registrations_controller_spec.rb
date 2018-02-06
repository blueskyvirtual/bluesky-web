# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'POST #create' do
    before :each do
      post :create, params: { user: attributes_for(:user) }
    end

    it 'renders the confirmation instructions' do
      expect(response).to render_template 'devise/mailer/confirmation_instructions'
    end

    it 'redirects to the welcome path' do
      expect(response).to redirect_to welcome_path
    end
  end

  describe 'GET #show' do
    context 'via direct browsing' do
      it 'redirects to the root_path if no flash messages are set' do
        get :show
        expect(response).to redirect_to root_path
      end
    end

    context 'after user registration' do
      before :each do
        post :create, params: { user: attributes_for(:user) }
      end

      it 'renders the welcome view' do
        get :show
        expect(response).to render_template 'devise/registrations/welcome'
      end
    end
  end

  describe '#check_captcha' do
    before :all do
      Recaptcha.configuration.skip_verify_env.delete('test')
      Rails.configuration.x.google_recaptcha.enabled = true
      Rails.configuration.x.google_recaptcha.secret_key = 'TEST'
    end

    after :all do
      Recaptcha.configuration.skip_verify_env.push('test')
      Rails.configuration.x.google_recaptcha.enabled = false
    end

    it 're-renders the form if reCAPTCHA verification fails' do
      post :create, params: { user: attributes_for(:user) }
      expect(response).to render_template :new
    end

    it 'allows registration to continue if reCAPTCHA verification succeeds' do
      stub_request(
        :get,
        'https://www.google.com/recaptcha/api/siteverify?remoteip=0.0.0.0&response=TEST&secret=TEST'
      ).to_return(body: '{"success":true}')

      post :create, params: { user: attributes_for(:user), 'g-recaptcha-response': 'TEST' }
      expect(response).to redirect_to welcome_path
    end
  end
end
