# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json
  skip_before_action :authenticate_user!, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:destroy]
  skip_before_action :verify_signed_out_user, only: :destroy

  def create
    user = User.find_by(email: params[:user][:email])
  
    if user&.valid_password?(params[:user][:password])
      if user.deactivated_at.present?
        return render json: { error: "Your account has been deactivated. Please contact support." }, status: :unauthorized
      end
  
      if user.activated?
        user.update(jti: SecureRandom.uuid)
        return render json: {
          token: user.generate_jwt_token,
          message: "Login successful",
          user: UserSerializer.new(user).serializable_hash[:data][:attributes],
          organisation: OrganisationSerializer.new(user.organisation).serializable_hash[:data][:attributes]
        }, status: :ok
      else
        render json: { error: "Account not activated. Please verify OTP." }, status: :unauthorized
      end
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end
  
  
  def destroy
    respond_to_on_destroy
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
    token = request.headers['Authorization']&.split(' ')&.last
    current_user = nil
  
    if token.present?
      begin
        secret_key = Rails.application.credentials.secret_key_base
        jwt_payload = JWT.decode(token, secret_key, true, { algorithm: 'HS256' }).first
        current_user = User.find(jwt_payload['user_id'])
        current_user.update(jti: SecureRandom.uuid)
      rescue JWT::VerificationError, JWT::DecodeError => e
        # Token is invalid or signature verification failed
        Rails.logger.error("JWT error: #{e.message}")
        current_user = nil
      end
    end
    if current_user
      render json: { status: 200, message: 'Logged out successfully.' }, status: :ok
    else
      render json: { status: 401, message: "Couldn't find an active session." }, status: :unauthorized
    end
  end
  
end
