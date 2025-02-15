module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user
  end

  private

  def authenticate_user
    if conflicting_authorization_methods?
      render json: { error: "Conflicting authorization methods" }, status: :bad_request
      return
    end

    if session[:user_id]
      authenticate_with_session
      return if @current_user
    end

    if request.headers["Authorization"].present?
      authenticate_with_jwt
    end

    if request.headers["X-API-TOKEN"].present?
      authenticate_with_api_token
    end

    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end

  def authenticate_with_api_token
    token = request.headers["X-API-TOKEN"]
    api_token = ApiTokenService.validate_token(token)
    if api_token
      @current_user = api_token.user
    end
  end

  def authenticate_with_jwt
    token = request.headers["Authorization"].split(" ").last
    decoded_token = JwtService.decode(token)
    if decoded_token
      @current_user = User.find_by(id: decoded_token["user_id"])
    end
  end

  def authenticate_with_session
    @current_user = User.find_by(id: session[:user_id])
  end

  def conflicting_authorization_methods?
    request.headers["Authorization"].present? && request.headers["X-API-TOKEN"].present?
  end
end
