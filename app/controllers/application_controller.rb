class ApplicationController < ActionController::API
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :authenticate_user

  private

  def authenticate_user
    @current_user = User.find_by(id: session[:user_id])
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end
end
