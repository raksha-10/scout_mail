# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  include UserMailerUtils  
  respond_to :json
  skip_before_action :authenticate_user!, only: [:create,:verify,:verify_account]

   def create
    ActiveRecord::Base.transaction do
      existing_user = User.find_by(email: params[:user][:email])
  
      if existing_user&.activated == false
        Otp.where(user_id: existing_user.id).update_all(expires_at: Time.current)
        otp = existing_user.generate_otp
        UserMailerUtils.send_otp_email(existing_user, otp)  
        return render json: { message: 'Otp has been sent to your email, Please verify your account', user_id: existing_user.id }, status: :ok
      elsif existing_user
        return render json: { error: 'User already exists and is verified' }, status: :unprocessable_entity
      end
  
      # Create a new organisation
      organisation = Organisation.new(
        name: params[:user][:organisation],
        organisation_type_id: params[:user][:organisation_type_id]
      )  
      unless organisation.save
        render json: { errors: organisation.errors.full_messages }, status: :unprocessable_entity and return
      end
  
      # Create a new user
      user = User.new(
        name: params[:user][:name],
        email: params[:user][:email],
        password: params[:user][:password],
        mobile: params[:user][:mobile],
        organisation_id: organisation.id,
        role_id: Role.find_by(name: 'Owner')&.id,
        activated: false
      )
  
      unless user.save
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
  
      # Send OTP
      otp = user.generate_otp
      UserMailerUtils.send_otp_email(user, otp)  
      render json: { message: 'OTP sent to email', user_id: user.id }, status: :ok
    end
  end
  
  def verify
    otp_record = Otp.find_valid_otp(params[:user_id], params[:otp])  
    if otp_record
      user = otp_record.user  
      if user.update(activated: true)
        render json: { message: 'Account activated successfully', token: user.generate_jwt_token, user: user }, status: :ok
      else
        render json: { error: "Failed to activate account" }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid or expired OTP' }, status: :unprocessable_entity
    end
  end
  
  def verify_account
    user = User.find_by(id: params[:user_id])
    return render json: { error: "User not found" }, status: :not_found if user.nil? 
    Otp.where(user_id: user.id).update_all(expires_at: Time.current)
    otp = user.generate_otp
    UserMailerUtils.send_otp_email(user, otp)
    render json: { message: 'New OTP sent to email', user_id: user.id }, status: :ok
  end
  

    private

    def sign_up_params
      params.require(:user).permit(:name, :email, :password, :mobile, :role_id)
    end
  
    def respond_with(current_user, _opts = {})
      if resource.persisted?
        render json: {
          status: {code: 200, message: 'Signed up successfully.'},
          data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
        }
      else
        render json: {
          status: {message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}"}
        }, status: :unprocessable_entity
      end
    end
end
