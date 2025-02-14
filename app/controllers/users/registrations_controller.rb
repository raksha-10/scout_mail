# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json
  skip_before_action :authenticate_user!, only: [:create,:verify,:resend_otp]

  def create
    ActiveRecord::Base.transaction do
      organisation = Organisation.new(
        name: params[:user][:organisation],
        organisation_type: params[:user][:organisation_type]
      )
  
      unless organisation.save
        puts organisation.errors.full_messages # Debugging: Log errors to the console
        render json: { errors: organisation.errors.full_messages }, status: :unprocessable_entity and return
      end
  
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
        raise ActiveRecord::Rollback # Rollback organisation creation
      end
  
      otp = generate_otp(user.id)
      UserMailer.send_otp(user, otp).deliver_later
  
      render json: { message: 'OTP sent to email', user_id: user.id }, status: :ok
    end
  end
  

  def verify
    otp_record = Otp.find_by(user_id: params[:user_id], code: params[:otp])
    if otp_record && otp_record.expires_at > Time.current
      user = otp_record.user
      user.update!(activated: true)
      otp_record.destroy # OTP used, so remove it
  
      token = generate_jwt_token(user) # Generate authentication token
  
      render json: { message: 'Account activated successfully', token: user.generate_jwt_token, user: user }, status: :ok
    else
      render json: { error: 'Invalid or expired OTP' }, status: :unprocessable_entity
    end
  end

  def resend_otp
    user = User.find_by(email: params[:email])

    if user.nil?
      return render json: { error: "User not found" }, status: :not_found
    end

    # Check if an OTP already exists and has expired
    existing_otp = Otp.find_by(user_id: user.id)
    if existing_otp
      existing_otp.destroy # Remove expired OTP
    end

    # Generate a new OTP
    otp = generate_otp(user.id)

    # Send OTP to email
    UserMailer.send_otp(user, otp).deliver_later 

    render json: { message: 'New OTP sent to email' }, status: :ok
  end

    private

    def sign_up_params
      params.require(:user).permit(:name, :email, :password, :mobile, :role_id)
    end
  
    def generate_otp(user_id)
      otp = rand(100000..999999) # Generate 6-digit OTP
      Otp.create!(user_id: user_id, code: otp, expires_at: 10.minutes.from_now)
      otp
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
