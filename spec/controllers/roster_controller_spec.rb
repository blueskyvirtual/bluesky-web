# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RosterController, type: :controller do
  describe 'GET #index' do
    it 'sets @users' do
      get :index
      expect(assigns(:users)).to be_kind_of ActiveRecord::Relation
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before :each do
      @user = create(:user)
      @user.confirm
      @user.reload
    end

    it 'sets the appropriate @user' do
      get :show, params: { id: @user.pilot_id }
      expect(assigns(:user)).to eq @user
    end

    it 'renders the :show view' do
      get :show, params: { id: @user.pilot_id }
      expect(response).to render_template :show
    end

    it 'rescues from not found errors' do
      get :show, params: { id: 'SHOULD_NEVER_EXIST' }
      expect { response }.to_not raise_error
    end

    it 'renders the not found view when the user is not found' do
      get :show, params: { id: 'SHOULD_NEVER_EXIST' }
      expect(response).to render_template :not_found
    end
  end
end
