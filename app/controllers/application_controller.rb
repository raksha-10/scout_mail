class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers
  before_action :authenticate_user! # Ensure authentication for protected routes
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  protect_from_forgery with: :null_session 
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name])
    # devise_parameter_sanitizer.permit(:account_update, keys: %i[name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[:name, :password, :password_confirmation])
  end

  private

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    if token.blank?
      return render json: { error: 'Token missing' }, status: :unauthorized
    end
  
    begin
      secret_key = Rails.application.credentials.secret_key_base
      decoded_token = JWT.decode(token, secret_key, true, { algorithm: 'HS256' }).first
  
      user = User.find_by(id: decoded_token['user_id'])
  
      # Ensure user exists and check if jti matches
      if user.nil? || user.jti != decoded_token['jti']
        return render json: { error: 'Token invalid or expired' }, status: :unauthorized
      end
  
      @current_user = user
    rescue JWT::ExpiredSignature
      render json: { error: 'Token expired' }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { error: 'Token invalid' }, status: :unauthorized
    end
  end
  
  
end
