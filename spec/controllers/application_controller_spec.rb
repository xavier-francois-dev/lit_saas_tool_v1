require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller(ApplicationController) do
    before_action :authenticate_user

    def index
      render plain: 'Authenticated'
    end
  end

  describe 'authenticate_user' do
    let!(:user) { create(:user) }

    context 'with session-based authentication' do
      it 'allows access when user is logged in' do
        session[:user_id] = user.id
        get :index
        expect(response).to have_http_status(:ok)
      end

      it 'denies access when user is not logged in' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with JWT-based authentication' do
      it 'allows access when valid JWT token is provided' do
        token = JwtService.encode(user_id: user.id)
        request.headers['Authorization'] = "Bearer #{token}"
        get :index
        expect(response).to have_http_status(:ok)
      end

      it 'denies access when invalid JWT token is provided' do
        request.headers['Authorization'] = "Bearer invalid_token"
        get :index
        expect(response).to have_http_status(:unauthorized)
      end

      it 'denies access when no JWT token is provided' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
