require 'rails_helper'

RSpec.describe Api::V1::ApiTokensController, type: :request do
  let!(:user) { create(:user) }
  let!(:api_token) { create(:api_token, user: user) }

  describe "DELETE /api/v1/api_tokens/revoke" do
    context 'when authenticated' do
      it 'revokes a valid API token provided as a parameter' do
        delete "/api/v1/api_tokens/revoke", params: { token: api_token.token }, headers: { 'Authorization': "Bearer #{JwtService.encode(user_id: user.id)}" }
        expect(response).to have_http_status(:ok)
        expect(ApiToken.find_by(token: api_token.token)).to be_nil
      end
    end

    context 'when not authenticated' do
      it 'returns unauthorized' do
        delete "/api/v1/api_tokens/revoke", params: { token: api_token.token }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    it 'returns an error for an invalid API token' do
      delete "/api/v1/api_tokens/revoke", params: { token: 'invalid_token' }, headers: { 'Authorization': "Bearer #{JwtService.encode(user_id: user.id)}" }
      expect(response).to have_http_status(:not_found)
    end

    it 'returns an error when token parameter is not provided' do
      delete "/api/v1/api_tokens/revoke", headers: { 'Authorization': "Bearer #{JwtService.encode(user_id: user.id)}" }
      expect(response).to have_http_status(:bad_request)
    end
  end
end
