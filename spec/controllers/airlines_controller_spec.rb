# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AirlinesController, type: :controller do
  describe 'GET #index' do
    before :each do
      @airlines = create_list(:airline, 1)
    end

    it 'sets @airlines' do
      get :index
      expect(assigns(:airlines)).to eq @airlines
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'POST #create' do
    context 'by unauthenticated user' do
      it 'redirects to the login page' do
        post :create, params: { airline: attributes_for(:airline) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'by authenticated user' do
      login_user

      context 'with valid attributes' do
        it 'creates the airline' do
          expect do
            post :create, params: { airline: attributes_for(:airline) }
          end.to change(Airline, :count).by(1)
        end

        it 'redirects to the new @airline' do
          attributes = attributes_for(:airline)
          post :create, params: { airline: attributes }
          @airline = Airline.friendly.find(attributes[:icao])
          expect(response).to redirect_to @airline
        end
      end

      context 'with invalid attributes' do
        it 'does not create the @airline' do
          expect do
            post :create, params: { airline: attributes_for(:airline, :invalid) }
          end.to_not change(Airline, :count)
        end

        it 're-renders the new page' do
          post :create, params: { airline: attributes_for(:airline, :invalid) }
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @airline = create(:airline)
    end

    context 'by unauthenticated user' do
      it 'redirects to the login page' do
        delete :destroy, params: { id: @airline }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'by authenticated user' do
      login_user

      it 'deletes the user' do
        expect do
          delete :destroy, params: { id: @airline }
        end.to change(Airline, :count).by(-1)
      end

      it 'redirects to the airline index' do
        delete :destroy, params: { id: @airline }
        expect(response).to redirect_to airlines_path
      end

      it 're-renders the edit page if the Airline cannot be deleted' do
        expect_any_instance_of(Airline).to receive(:destroy).and_return(false)
        delete :destroy, params: { id: @airline }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'GET #edit' do
    before :each do
      @airline = create(:airline)
    end

    context 'unauthenticated user' do
      it 'redirects to the login page' do
        get :edit, params: { id: @airline }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'authenticated user' do
      login_user

      it 'assigns the @airline object' do
        get :edit, params: { id: @airline }
        expect(assigns(:airline)).to eq @airline
      end

      it 'renders the new template' do
        get :edit, params: { id: @airline }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'GET #new' do
    context 'unauthenticated user' do
      it 'redirects to the login page' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'authenticated user' do
      login_user

      it 'assigns a new @airline object' do
        get :new
        expect(assigns(:airline).icao).to eq nil
        expect(assigns(:airline).iata).to eq nil
        expect(assigns(:airline).name).to eq nil
      end

      it 'renders the new template' do
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #route_map' do
    before :each do
      @airline = create(:airline)
      @flights = create_list(:airline_flight, 5, airline: @airline)
    end

    it 'sets @airline' do
      get :route_map, xhr: true, format: :js, params: { airline_id: @airline }
      expect(assigns(:airline)).to eq @airline
    end

    it 'sets @flights' do
      query   = 'DISTINCT ON (origin_id, destination_id) *'
      flights = @airline.flights.select(query)
      get :route_map, xhr: true, format: :js, params: { airline_id: @airline }
      expect(assigns(:flights)).to eq flights
    end

    it 'renders the route_map javascript partial' do
      get :route_map, xhr: true, format: :js, params: { airline_id: @airline }
      expect(response).to render_template '_route_map'
    end
  end

  describe 'GET #show' do
    before :each do
      @airline = create(:airline)
    end

    it 'sets @airline' do
      get :show, params: { id: @airline }
      expect(assigns(:airline)).to eq @airline
    end

    it 'renders the :index view' do
      get :show, params: { id: @airline }
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

  describe 'PUT #update' do
    before :each do
      @airline = create(:airline)
    end

    context 'by unauthenticated user' do
      it 'redirects to the login page' do
        put :update, params: { id: @airline, airline: attributes_for(:airline) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'by authenticated user' do
      login_user

      context 'with valid attributes' do
        it 'assigns the appropriate @airline' do
          put :update, params: { id: @airline, airline: attributes_for(:airline) }
          expect(assigns(:airline)).to eq @airline
        end

        it 'changes the @airline attributes' do
          put :update, params: {
            id: @airline, airline: attributes_for(:airline, name: 'Testing')
          }
          @airline.reload
          expect(@airline.name).to eq 'Testing'
        end

        it 'redirects to the updated @airline' do
          put :update, params: { id: @airline, airline: attributes_for(:airline) }
          @airline.reload
          expect(response).to redirect_to @airline
        end
      end

      context 'with invalid attributes' do
        it 'assigns the appropriate @airline' do
          put :update, params: { id: @airline, airline: attributes_for(:airline, :invalid) }
          expect(assigns(:airline)).to eq @airline
        end

        it 'does not change the @airline attributes' do
          put :update, params: { id: @airline, airline: attributes_for(:airline, :invalid) }
          @airline.reload
          expect(@airline.name).to_not eq nil
        end

        it 're-renders the edit page' do
          put :update, params: { id: @airline, airline: attributes_for(:airline, :invalid) }
          expect(response).to render_template :edit
        end
      end
    end
  end
end
