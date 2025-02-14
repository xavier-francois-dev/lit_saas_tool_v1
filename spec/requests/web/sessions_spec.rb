require 'rails_helper'

RSpec.describe Web::SessionsController, type: :request do
  let!(:user) { create(:user) }

  describe "login" do
    it 'logs in a user with valid credentials' do
      post "/web/sessions", params: { email: user.email, password: user.password }
      expect(response).to have_http_status(:ok)
      expect(session[:user_id]).to eq(user.id)
    end

    it 'does not log in a user with invalid credentials' do
      post "/web/sessions", params: { email: 'invalid@example.com', password: 'wrongpassword' }
      expect(response).to have_http_status(:unauthorized)
      expect(session[:user_id]).to be_nil
    end
  end

  describe 'logout' do
    it 'logs out a user' do
      post "/web/sessions", params: { email: user.email, password: user.password }
      delete "/web/sessions"
      expect(response).to have_http_status(:ok)
      expect(session[:user_id]).to be_nil
    end
  end
end
