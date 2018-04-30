# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V2::AirportsController, type: :controller do
  describe 'GET #show' do
    login_user

    before :each do
      @airport = create(:airport)
    end

    it 'sets the appropriate @airport' do
      get :show, format: :json, params: { id: @airport.ident }
      expect(assigns(:airport)).to eq @airport
    end

    it 'renders JSON' do
      get :show, format: :json, params: { id: @airport.ident }
      expect(response.body).to eq @airport.as_json(include: :region).to_json
    end

    it 'renders XML' do
      get :show, format: :xml, params: { id: @airport.ident }
      expect(response.body).to eq @airport.as_json(include: :region).to_xml
    end

    it 'returns 404 when airport does not exist' do
      get :show, format: :json, params: { id: 'TEST' }
      expect(response.code).to eq '404'
    end
  end
end
