# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V2::RegionsController, type: :controller do
  describe 'GET #index' do
    login_user

    before :each do
      @country = create(:country)
      @regions = create_list(:region, 10, country: @country)

      @expected = @regions.as_json(only: %i[id code local_code name])
    end

    it 'sets the appropriate @regions' do
      get :index, format: :json, params: { country_id: @country.code }
      expect(assigns(:regions)).to eq @expected
    end

    it 'renders JSON' do
      get :index, format: :json, params: { country_id: @country.code }
      expect(response.body).to eq @expected.to_json
    end

    it 'renders XML' do
      get :index, format: :xml, params: { country_id: @country.code }
      expect(response.body).to eq @expected.to_xml
    end
  end

  describe 'GET #show' do
    login_user

    before :each do
      @region = create(:region)
      @expected = @region.as_json(only: %i[id code local_code name])

      @params = { country_id: @region.country.code, id: @region.code }
    end

    it 'sets the appropriate @region' do
      get :show, format: :json, params: @params
      expect(assigns(:region)).to eq @expected
    end

    it 'renders JSON' do
      get :show, format: :json, params: @params
      expect(response.body).to eq @expected.to_json
    end

    it 'renders XML' do
      get :show, format: :xml, params: @params
      expect(response.body).to eq @expected.to_xml
    end

    it 'returns 404 when airport does not exist' do
      get :show, format: :json, params: { country_id: 'TEST', id: 'TEST' }
      expect(response.code).to eq '404'
    end
  end
end
