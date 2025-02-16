require 'open-uri'
require 'base64'
class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:accept_invitation, :otp_password_set]
  before_action :set_user, only: [:toggle_user_status]
  before_action :set_organisation, only: [:invite_user, :resend_invite]
  before_action :authorize_owner_or_admin, only: [:toggle_user_status]

  def show_current_user
    if @current_user
      render json: UserSerializer.new(@current_user).serializable_hash[:data][:attributes], status: :ok
    else
      render json: { error: "User not found" }, status: :unauthorized
    end
  end
  def update
    begin
      if params[:user][:image].present?
        image_data = params[:user][:image]
  
        if image_data.start_with?("data:image") # Base64 image
          attach_base64_image(image_data)
        elsif image_data.start_with?("http") # Image URL
          attach_remote_image(image_data)
        elsif image_data.is_a?(ActionDispatch::Http::UploadedFile) || image_data.is_a?(Rack::Test::UploadedFile)
          attach_direct_file(image_data)
        else
          return render json: { error: "Invalid image format." }, status: :unprocessable_entity
        end
      end
    rescue StandardError => e
      return render json: { error: "Image upload failed: #{e.message}" }, status: :unprocessable_entity
    end
  
    if current_user.update(user_params.except(:image))
      render json: {
        message: "User updated successfully",
        user: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: { error: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
    
  def invite_user
    user = User.find_or_initialize_by(email: user_create_params[:email])
  
    if user.persisted?
      return render json: { message: "User already exists. Please resend the invitation if needed." }, status: :unprocessable_entity
    end
  
    # Assign attributes and save the user
    user.assign_attributes(user_create_params.merge(organisation_id: @organisation.id, invited_by: current_user))
  
    if user.save(validate: false)  # Save the new user before calling send_invitation
      send_invitation(user, "User created successfully. Please check your email to activate your account.")
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  

  def resend_invite
    user = User.find_by(email: user_create_params[:email])
    return render json: { error: "User not found." }, status: :not_found unless user
    send_invitation(user, "Activation email has been re-sent.")
  end
  

  def invited_users
    active_invited_users = User.where(
      invited_by: current_user, 
      organisation_id: current_user.organisation_id
    )
    render json: InvitedUserSerializer.new(active_invited_users).serializable_hash, status: :ok
  end

  def toggle_user_status
    if @user.deactivated_at.nil?
      @user.update_columns(deactivated_at: Time.current)
      render json: { message: "User deactivated successfully." }, status: :ok
    else
      @user.update_columns(deactivated_at: nil)
      render json: { message: "User reactivated successfully." }, status: :ok
    end
  end
  

  def accept_invitation
    user = User.find_by_activation_token(params[:invitation_token])
    if user
      user.update(activation_token: nil) # Save OTP
      Otp.where(user_id: user.id).update_all(expires_at: Time.current)
      otp = user.generate_otp
      user.send_otp_email(otp)
      frontend_url = "http://localhost:3000/otpConfirm?user_id=#{user.id}"
      redirect_to frontend_url
    end
  end

  def otp_password_set
    otp_record = Otp.find_valid_otp(params[:user_id], params[:otp])  
    if params[:otp].blank?
      return render json: { error: "Otp cannot be blank" }, status: :unprocessable_entity
    end
    if params[:password].blank?
      return render json: { error: "Password cannot be blank" }, status: :unprocessable_entity
    end
    if otp_record
      user = otp_record.user  
      if user.update(activated: true, password: params[:password],password_confirmation: params[:password], invitation_accepted_at: Time.current)
        render json: { message: 'Account activated successfully'}, status: :ok
      else
        render json: { error: "Failed to activate account" }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid or expired OTP' }, status: :unprocessable_entity
    end
  end

    private

    def user_params
      params.require(:user).permit(:name, :mobile, :linkedin_url, :image)
    end

    def user_create_params
      params.require(:user).permit(:name, :mobile, :email, :role_id)
    end

    def set_user
      @user = User.find_by(id: params[:user_id])
      return render json: { error: "User not found." }, status: :not_found unless @user
    end
  
    def authorize_owner_or_admin
      unless current_user.has_role?("Owner") || current_user.has_role?("Admin")
        render json: { error: "You are not authorized to perform this action." }, status: :forbidden
      end
    end

    # Handle direct file upload (multipart/form-data)
    def attach_direct_file(uploaded_file)
      content_type = uploaded_file.content_type
      return render json: { error: "Invalid file type." }, status: :unprocessable_entity unless content_type.start_with?("image/")
    
      current_user.image.purge if current_user.image.attached?
      current_user.image.attach(uploaded_file)
    end
    
    # Handle Base64 Image Upload
    def attach_base64_image(base64_string)
      match = base64_string.match(/^data:image\/(\w+);base64,(.*)$/)
      return render json: { error: "Invalid Base64 format." }, status: :unprocessable_entity unless match
    
      ext = match[1] # Extract file extension
      decoded_data = Base64.decode64(match[2]) # Decode Base64
    
      filename = "profile.#{ext}"
      io = StringIO.new(decoded_data)
    
      current_user.image.purge if current_user.image.attached?
      current_user.image.attach(io: io, filename: filename, content_type: "image/#{ext}")
    end
    def attach_remote_image(image_url)
      downloaded_image = URI.open(image_url)
      filename = File.basename(URI.parse(image_url).path) || "profile.jpg"
      content_type = downloaded_image.content_type || "image/jpeg"
    
      current_user.image.purge if current_user.image.attached?
      current_user.image.attach(io: downloaded_image, filename: filename, content_type: content_type)
    end
 
    
  
    # Generate Base64-Encoded Image from ActiveStorage
    def generate_base64_image(image)
      return nil unless image.attached?
  
      blob = image.blob
      image_data = blob.download
      base64_data = Base64.strict_encode64(image_data)
      "data:#{blob.content_type};base64,#{base64_data}"
    end
    
    def set_organisation
      @organisation = current_user.organisation
    end

    def send_invitation(user, success_message)
      unless user.persisted?
        return render json: { error: "User must be saved before sending an invitation." }, status: :unprocessable_entity
      end
    
      user.update(organisation_id: @organisation.id, invited_by_id: current_user.id) # Use `update` instead of `update_columns`
      user.generate_activation_token
      user.save(validate: false)  
      user.send_activation_email
    
      render json: { message: success_message }, status: :ok
    end
    
  
   
  end
  