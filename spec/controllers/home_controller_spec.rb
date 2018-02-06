# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    it 'retrieves the number of Airline::Flights in the database' do
      get :index
      expect(assigns(:flight_count)).to eq Airline::Flight.count
    end

    it 'sets the number of awards that can be earned'

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end
end
