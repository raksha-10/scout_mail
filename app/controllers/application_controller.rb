class ApplicationController < ActionController::Base
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
    return render json: { error: 'Token missing or invalid' }, status: :unauthorized if token.blank?
  
    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key, true, { algorithm: 'HS256' })
      user_id = decoded_token[0]['sub']
      @current_user = User.find_by(id: user_id)
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: 'Token invalid or user not found' }, status: :unauthorized
    end
  end
end
