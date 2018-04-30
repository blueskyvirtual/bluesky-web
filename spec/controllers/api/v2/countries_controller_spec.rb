# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V2::CountriesController, type: :controller do
  describe 'GET #index' do
    login_user

    before :each do
      @countries = create_list(:country, 10)
    end

    it 'sets the appropriate @countries' do
      get :index, format: :json
      expect(assigns(:countries)).to eq Country.all
    end

    it 'renders JSON' do
      get :index, format: :json
      expect(response.body).to eq @countries.as_json.to_json
    end

    it 'renders XML' do
      get :index, format: :xml
      expect(response.body).to eq @countries.as_json.to_xml
    end
  end

  describe 'GET #show' do
    login_user

    before :each do
      @country = create(:country)
    end

    it 'sets the appropriate @country' do
      get :show, format: :json, params: { id: @country.code }
      expect(assigns(:country)).to eq @country
    end

    it 'renders JSON' do
      get :show, format: :json, params: { id: @country.code }
      expect(response.body).to eq @country.as_json.to_json
    end

    it 'renders XML' do
      get :show, format: :xml, params: { id: @country.code }
      expect(response.body).to eq @country.as_json.to_xml
    end

    it 'returns 404 when airport does not exist' do
      get :show, format: :json, params: { id: 'TEST' }
      expect(response.code).to eq '404'
    end
  end
end
