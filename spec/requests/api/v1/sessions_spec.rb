require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :request do
  let!(:user) { create(:user) }

  describe "POST /api/v1/sessions" do
    it 'logs in a user with valid credentials and returns a JWT token' do
      post "/api/v1/sessions", params: { email: user.email, password: user.password }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('token')
    end

    it 'does not log in a user with invalid credentials' do
      post "/api/v1/sessions", params: { email: 'invalid@example.com', password: 'wrongpassword' }
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include('error')
    end

    it 'does not log in a user with an invalid password' do
      post "/api/v1/sessions", params: { email: user.email, password: 'wrongpassword' }
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include('error')
    end

    it 'does not log in a user with an invalid email' do
      post "/api/v1/sessions", params: { email: 'invalid@example.com', password: user.password }
      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include('error')
    end
  end
end
