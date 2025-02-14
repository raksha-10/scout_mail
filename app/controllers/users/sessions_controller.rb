# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json
  # before_action :authenticate_user!, only: [:destroy]
  # skip_before_action :verify_signed_out_user, only: [:destroy]

  def create
    user = User.find_by(email: params[:user][:email])
    if user&.valid_password?(params[:user][:password])
      if user.activated?
        render json: { token: user.generate_jwt_token, message: "Login successful", user: user }, status: :ok
      else
        render json: { error: "Account not activated. Please verify OTP." }, status: :unauthorized
      end
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end  
  

  private
  def respond_with(resource, _opts = {})
    if resource.present? && resource.persisted?
      render json: {
        status: { code: 200, message: 'Logged in successfully.' },
        data: { user: UserSerializer.new(resource).serializable_hash[:data][:attributes] }
      }, status: :ok
    else
      render json: {
        status: { code: 401, message: 'Invalid email or password' }
      }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
      current_user = User.find(jwt_payload['sub'])
    end

    if current_user
      render json: {
        status: 200,
        message: 'Logged out successfully.'
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
