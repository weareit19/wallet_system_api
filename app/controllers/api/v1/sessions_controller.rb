# app/controllers/api/v1/sessions_controller.rb
class Api::V1::SessionsController < ApplicationController
  skip_before_action :require_login, only: [ :create, :destroy ]

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      render json: { message: "Signed in successfully" }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    if session[:user_id].present?
      session[:user_id] = nil
      render json: { message: "Signed out successfully" }, status: :ok
    else
      render json: { error: "No user logged in" }, status: :bad_request
    end
  end
end
