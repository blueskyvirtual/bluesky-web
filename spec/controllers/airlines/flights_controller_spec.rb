# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Airlines::FlightsController, type: :controller do
  describe 'POST #create' do
    before :each do
      @attributes = build(:airline_flight)
      @airline    = @attributes.airline
      @attributes = @attributes.attributes.except('id')
    end

    context 'by unauthenticated user' do
      it 'redirects to the login page' do
        post :create, params: { airline_id: @airline, airline_flight: @attributes }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'by authenticated user' do
      login_user

      context 'with valid attributes' do
        it 'creates the flight' do
          expect do
            post :create, params: { airline_id: @airline, airline_flight: @attributes }
          end.to change(Airline::Flight, :count).by(1)
        end

        it 'redirects to the new @flight' do
          post :create, params: { airline_id: @airline, airline_flight: @attributes }
          @flight = Airline::Flight.find_by(airline: @airline, flight: @attributes['flight'])
          expect(response).to redirect_to airline_flight_path(@airline, @flight)
        end
      end

      context 'with invalid attributes' do
        before :each do
          @attributes.delete 'dep_time'
        end

        it 'does not create the @flight' do
          expect do
            post :create, params: { airline_id: @airline, airline_flight: @attributes }
          end.to_not change(Airline::Flight, :count)
        end

        it 're-renders the new page' do
          post :create, params: { airline_id: @airline, airline_flight: @attributes }
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @flight = create(:airline_flight)
    end

    context 'by unauthenticated user' do
      it 'redirects to the login page' do
        delete :destroy, params: { airline_id: @flight.airline, id: @flight }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'by authenticated user' do
      login_user

      it 'deletes the flight' do
        expect do
          delete :destroy, params: { airline_id: @flight.airline, id: @flight }
        end.to change(Airline::Flight, :count).by(-1)
      end

      it 'redirects to the airline show page' do
        delete :destroy, params: { airline_id: @flight.airline, id: @flight }
        expect(response).to redirect_to airline_path(@flight.airline)
      end

      it 're-renders the edit page if the Airline cannot be deleted' do
        expect_any_instance_of(Airline::Flight).to receive(:destroy).and_return(false)
        delete :destroy, params: { airline_id: @flight.airline, id: @flight }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'GET #edit' do
    before :each do
      @flight = create(:airline_flight)
    end

    context 'unauthenticated user' do
      it 'redirects to the login page' do
        get :edit, params: { airline_id: @flight.airline, id: @flight }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'authenticated user' do
      login_user

      it 'assigns the @flight object' do
        get :edit, params: { airline_id: @flight.airline, id: @flight }
        expect(assigns(:flight)).to eq @flight
      end

      it 'renders the new template' do
        get :edit, params: { airline_id: @flight.airline, id: @flight }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'GET #new' do
    before :each do
      @airline = create(:airline)
    end

    context 'unauthenticated user' do
      it 'redirects to the login page' do
        get :new, params: { airline_id: @airline }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'authenticated user' do
      login_user

      it 'assigns a new @flight object' do
        get :new, params: { airline_id: @airline }
        expect(assigns(:flight).flight).to eq nil
        expect(assigns(:flight).dep_time).to eq nil
        expect(assigns(:flight).arv_time).to eq nil
      end

      it 'renders the new template' do
        get :new, params: { airline_id: @airline }
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #not_found' do
    it 'recovers from flights not found' do
      expect do
        get :show, params: { airline_id: 'NONE', id: 'NONE' }
      end.to_not raise_exception
    end

    it 'renders the not found template' do
      get :show, params: { airline_id: 'NONE', id: 'NONE' }
      expect(response).to render_template :not_found
    end
  end

  describe 'GET #map' do
    before :each do
      @flight = create(:airline_flight)
    end

    it 'sets @flight' do
      get :map, xhr: true, format: :js, params: {
        airline_id: @flight.airline,
        flight_id:  @flight
      }
      expect(assigns(:flight)).to eq @flight
    end

    it 'renders the route_map javascript partial' do
      get :map, xhr: true, format: :js, params: {
        airline_id: @flight.airline,
        flight_id: @flight
      }
      expect(response).to render_template '_map'
    end
  end

  describe 'GET #show' do
    before :each do
      @flight = create(:airline_flight)
    end

    it 'sets @flight' do
      get :show, params: { airline_id: @flight.airline, id: @flight }
      expect(assigns(:flight)).to eq @flight
    end

    it 'renders the :show view' do
      get :show, params: { airline_id: @flight.airline, id: @flight }
      expect(response).to render_template :show
    end

    it 'rescues from not found errors' do
      get :show, params: { airline_id: 'NONE', id: 'SHOULD_NEVER_EXIST' }
      expect { response }.to_not raise_error
    end

    it 'renders the not found view when the user is not found' do
      get :show, params: { airline_id: 'NONE', id: 'SHOULD_NEVER_EXIST' }
      expect(response).to render_template :not_found
    end
  end

  describe 'PUT #update' do
    before :each do
      @flight = create(:airline_flight)
    end

    context 'by unauthenticated user' do
      it 'redirects to the login page' do
        put :update, params: {
          airline_id:     @flight.airline,
          id:             @flight,
          airline_flight: { arv_time: '00:00' }
        }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'by authenticated user' do
      login_user

      context 'with valid attributes' do
        it 'assigns the appropriate @flight' do
          put :update, params: {
            airline_id:     @flight.airline,
            id:             @flight,
            airline_flight: attributes_for(:airline_flight)
          }
          expect(assigns(:flight)).to eq @flight
        end

        it 'changes the @flight attributes' do
          attributes = attributes_for(:airline_flight)
          attributes['flight'] = 9999

          put :update, params: {
            airline_id:     @flight.airline,
            id:             @flight,
            airline_flight: attributes
          }
          @flight.reload
          expect(@flight.flight).to eq 9999
        end

        it 'redirects to the updated @flight' do
          put :update, params: {
            airline_id:     @flight.airline,
            id:             @flight,
            airline_flight: attributes_for(:airline_flight)
          }
          @flight.reload
          expect(response).to redirect_to airline_flight_path(@flight.airline, @flight)
        end
      end

      context 'with invalid attributes' do
        it 'assigns the appropriate @flight' do
          put :update, params: {
            airline_id:     @flight.airline,
            id:             @flight,
            airline_flight: attributes_for(:airline_flight, :invalid)
          }
          expect(assigns(:flight)).to eq @flight
        end

        it 'does not change the @flight attributes' do
          put :update, params: {
            airline_id:     @flight.airline,
            id:             @flight,
            airline_flight: attributes_for(:airline_flight, :invalid)
          }
          @flight.reload
          expect(@flight.origin).to_not eq nil
        end

        it 're-renders the edit page' do
          put :update, params: {
            airline_id:     @flight.airline,
            id:             @flight,
            airline_flight: attributes_for(:airline_flight, :invalid)
          }
          expect(response).to render_template :edit
        end
      end
    end
  end

  describe 'GET #upload' do
    context 'by unauthenticated user' do
      it 'redirects to the login page' do
        get :upload
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'by authenticated user' do
      login_user

      it 'renders the upload page' do
        get :upload
        expect(response).to render_template :upload
      end
    end
  end
end
