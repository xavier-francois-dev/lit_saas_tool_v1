module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate_user, only: [ :create ]

      def create
        user = AuthenticationService.authenticate(params[:email], params[:password])
        if user
          token = JwtService.encode(user_id: user.id)
          render json: { token: token }, status: :ok
        else
          render json: { error: "Invalid Credentials" }, status: :unauthorized
        end
      end
    end
  end
end
