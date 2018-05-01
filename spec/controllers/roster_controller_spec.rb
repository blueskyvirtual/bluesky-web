# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RosterController, type: :controller do
  describe 'GET #index' do
    before :each do
      @users = create_list(:user, 5)
    end

    it 'sets @users' do
      get :index
      expect(assigns(:users)).to eq @users
    end

    it 'renders the :index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @user = create(:user)
    end

    context 'by unauthenticated user' do
      it 'redirects to the login page' do
        delete :destroy, params: { id: @user }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'by authenticated user' do
      login_user

      it 'deletes the user' do
        expect do
          delete :destroy, params: { id: @user }
        end.to change(User, :count).by(-1)
      end

      it 'redirects to the roster index' do
        delete :destroy, params: { id: @user }
        expect(response).to redirect_to users_path
      end

      it 're-renders the edit page if the User cannot be deleted' do
        expect_any_instance_of(User).to receive(:destroy).and_return(false)
        delete :destroy, params: { id: @user }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'GET #edit' do
    before :each do
      @user = create(:user)
    end

    context 'by unauthenticated user' do
      it 'redirects to the login page' do
        get :edit, params: { id: @user }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'by authenticated user' do
      login_user

      it 'sets the appropriate @user' do
        get :edit, params: { id: @user }
        expect(assigns(:user)).to eq @user
      end

      it 'renders the :edit view' do
        get :edit, params: { id: @user }
        expect(response).to render_template :edit
      end

      it 'rescues from not found errors' do
        get :edit, params: { id: 'SHOULD_NEVER_EXIST' }
        expect { response }.to_not raise_error
      end

      it 'renders the not found view when the user is not found' do
        get :edit, params: { id: 'SHOULD_NEVER_EXIST' }
        expect(response).to render_template :not_found
      end
    end
  end

  describe 'POST #send_password_reset' do
    before :each do
      @user = create(:user)
    end

    context 'by unauthenticated user' do
      it 'redirects to the login page' do
        post :send_password_reset, params: { user_id: @user }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'by authenticated user' do
      login_user

      it 'selects the correct user' do
        post :send_password_reset, params: { user_id: @user }
        expect(assigns(:user)).to eq @user
      end

      it 'sends a password reset to the user' do
        expect_any_instance_of(User).to receive(:send_reset_password_instructions)
        post :send_password_reset, params: { user_id: @user }
      end

      it 'redirects to the user edit path' do
        post :send_password_reset, params: { user_id: @user }
        expect(response).to redirect_to edit_user_path(@user)
      end
    end
  end

  describe 'GET #show' do
    before :each do
      @user = create(:user)
    end

    context 'by unauthenticated user' do
      it 'redirects to the login page' do
        get :show, params: { id: @user }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'by authenticated user' do
      login_user

      it 'sets the appropriate @user' do
        get :show, params: { id: @user }
        expect(assigns(:user)).to eq @user
      end

      it 'renders the :show view' do
        get :show, params: { id: @user }
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

  describe 'PUT #update' do
    before :each do
      @user = create(:user)
    end

    context 'by unauthenticated user' do
      it 'redirects to the login page' do
        put :update, params: { id: @user, user: attributes_for(:user) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'by authenticated user' do
      login_user

      context 'with valid attributes' do
        it 'assigns the appropriate @user' do
          put :update, params: { id: @user, user: attributes_for(:user) }
          expect(assigns(:user)).to eq @user
        end

        it 'changes the @users attributes' do
          put :update, params: {
            id: @user, user: attributes_for(:user, first_name: 'Testing')
          }
          @user.reload
          expect(@user.first_name).to eq 'Testing'
        end

        it 'redirects to the updated @user' do
          put :update, params: { id: @user, user: attributes_for(:user) }
          expect(response).to redirect_to @user
        end
      end

      context 'with invalid attributes' do
        it 'assigns the appropriate @user' do
          put :update, params: { id: @user, user: attributes_for(:user, :invalid) }
          expect(assigns(:user)).to eq @user
        end

        it 'does not change the @users attributes' do
          put :update, params: { id: @user, user: attributes_for(:user, :invalid) }
          @user.reload
          expect(@user.first_name).to_not eq nil
        end

        it 're-renders the edit page' do
          put :update, params: { id: @user, user: attributes_for(:user, :invalid) }
          expect(response).to render_template :edit
        end
      end
    end
  end
end
