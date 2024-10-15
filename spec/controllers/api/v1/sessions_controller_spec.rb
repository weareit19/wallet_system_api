# spec/controllers/api/v1/sessions_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let!(:user) { create(:user, email: 'test@gmail.com', password: 'password') }

  describe 'POST #create' do
    context 'with valid credentials' do
      it 'signs in the user and sets the session' do
        post :create, params: { email: 'test@gmail.com', password: 'password' }

        expect(response).to have_http_status(:ok)
        expect(session[:user_id]).to eq(user.id)
        expect(JSON.parse(response.body)['message']).to eq('Signed in successfully')
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized status' do
        post :create, params: { email: 'test@gmail.com', password: 'wrongpassword' }

        expect(response).to have_http_status(:unauthorized)
        expect(session[:user_id]).to be_nil
        expect(JSON.parse(response.body)['error']).to eq('Invalid email or password')
      end
    end

    context 'with non-existent email' do
      it 'returns unauthorized status' do
        post :create, params: { email: 'nonexistent@example.com', password: 'password' }

        expect(response).to have_http_status(:unauthorized)
        expect(session[:user_id]).to be_nil
        expect(JSON.parse(response.body)['error']).to eq('Invalid email or password')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is signed in' do
      before do
        session[:user_id] = user.id
      end

      it 'signs out the user and clears the session' do
        delete :destroy

        expect(response).to have_http_status(:ok)
        expect(session[:user_id]).to be_nil
        expect(JSON.parse(response.body)['message']).to eq('Signed out successfully')
      end
    end

    context 'when no user is signed in' do
      it 'returns a bad request status' do
        delete :destroy

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('No user logged in')
      end
    end
  end
end
