module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user
  end

  private

  def authenticate_user
    if session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      nil if @current_user
    end

    if request.headers["Authorization"].present?
      token = request.headers["Authorization"].split(" ").last
      decoded_token = JwtService.decode(token)
      if decoded_token
        @current_user = User.find_by(id: decoded_token["user_id"])
      end
    end

    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end
end
