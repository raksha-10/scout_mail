# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  # def create
  #   self.resource = User.find_by(email: params[:user][:email])
  #   if resource.nil? || !resource.valid_password?(params[:user][:password])
  #     render json: {
  #       status: { message: 'Invalid credentials. Please check your email and password.' }
  #     }, status: :unauthorized
  #     return
  #   end
  #   sign_in(resource_name, resource)
  #   respond_with(resource)
  # end
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
