require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller(ApplicationController) do
    before_action :authenticate_user

    def index
      render plain: 'Authenticated'
    end
  end

  describe 'authenticate_user' do
    it 'allows access when user is logged in' do
      user = FactoryBot.create(:user)
      session[:user_id] = user.id
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'denies access when user is not logged in' do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
