module Web
  class SessionsController < ApplicationController
    skip_before_action :authenticate_user, only: [ :create ]

    def create
      user = AuthenticationService.authenticate(params[:email], params[:password])
      if user
        session[:user_id] = user.id
        render json: { message: "Logged in successfully" }, status: :ok
      else
        render json: { error: "Invalid Credentials" }, status: :unauthorized
      end
    end

    def destroy
      session[:user_id] = nil
      render json: { message: "Logged out successfully" }
    end
  end
end
