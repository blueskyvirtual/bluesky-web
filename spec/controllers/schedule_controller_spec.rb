# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduleController, type: :controller do

  describe 'GET #index' do

    before :each do
      type = Airline::Flight::Type.find_by(name: 'Scheduled')
      @flights = create_list(:airline_flight, 5, flight_type: type)
    end

    it 'sets "Scheduled" flights as a default search option' do
      get :index
      expect(assigns(:q).flight_type_name_eq).to eq 'Scheduled'
    end

    it 'sets @flights' do
      get :index
      expect(assigns(:flights)).to eq @flights
    end

    it 'sets @result_count' do
      get :index
      expect(assigns(:result_count)).to eq @flights.size
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET|POST #search' do

    it 'responds to GET requests' do
      get :search
      expect(response).to render_template :index
    end

    it 'responds to POST requests' do
      post :search, params: { q: nil }
      expect(response).to render_template :index
    end

  end

end
