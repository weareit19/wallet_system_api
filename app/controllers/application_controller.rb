class ApplicationController < ActionController::API
  before_action :require_login

  # Helper method to check current user
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  private

  # Ensure the user is logged in
  def require_login
    render json: { error: "Unauthorized access" }, status: :unauthorized unless current_user
  end
end
