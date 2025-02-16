require 'open-uri'
require 'base64'
class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:accept_invitation, :otp_password_set]

  def show_current_user
    if @current_user
      base64_image = nil
      if @current_user.image.attached?
        image_blob = @current_user.image.blob
        # Optionally, process/resize the image before downloading if needed.
        image_data = @current_user.image.download
        encoded_image = Base64.strict_encode64(image_data)
        base64_image = "data:#{image_blob.content_type};base64,#{encoded_image}"
      end
  
      render json: {
        id: @current_user.id,
        name: @current_user.name,
        email: @current_user.email,
        role: @current_user.role.name,
        linkedin_url: @current_user.linkedin_url,
        image_url: @current_user.image.attached? ? url_for(@current_user.image) : nil,
        image_base64: base64_image,
        organisation: @current_user.organisation
      }, status: :ok
    else
      render json: { error: "User not found" }, status: :unauthorized
    end
  end
  
  def update
    begin
      # Handle image upload (Base64 or URL)
      if params[:user][:image].present?
        image_data = params[:user][:image]

        if image_data.start_with?("http")
          attach_remote_image(image_data)
        elsif image_data.start_with?("data:image")
          attach_base64_image(image_data)
        end
      end
    rescue StandardError => e
      return render json: { error: "Image upload failed: #{e.message}" }, status: :unprocessable_entity
    end

    # Update user attributes excluding image (already handled)
    if current_user.update(user_params.except(:image))
      base64_image = current_user.image.attached? ? generate_base64_image(current_user.image) : nil

      render json: {
        message: "User updated successfully",
        user: current_user.as_json(only: [:id, :name, :email, :linkedin_url, :mobile]),
        image_base64: base64_image,
        organisation: current_user.organisation
      }, status: :ok
    else
      render json: { error: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def invite_user
    organisation_id = current_user.organisation.id
    invited_user = User.find_by(email: user_create_params[:email])
    
    if invited_user.present?
      # Update inviter details and organisation (in case they changed)
      invited_user.invited_by = current_user
      invited_user.organisation_id = organisation_id
      invited_user.generate_activation_token  # Regenerate activation token
      invited_user.save(validate: false)       # Save without running validations
      invited_user.send_activation_email
      render json: { message: "User already exists. Activation email has been re-sent." }, status: :ok
    else
      user = User.new(user_create_params)
      user.organisation_id = organisation_id
      user.invited_by = current_user
      user.generate_activation_token  # Generate activation token
      if user.save(validate: false)
        user.send_activation_email
        render json: { message: "User created successfully. Please check your email to activate your account." }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
  
  def invited_users
    render json: { users: current_user.invited_users_with_status }, status: :ok
  end

  def delete_invited_user
    user = current_user.invited_users.find_by(id: params[:user_id])  
    if user
      if user.update(deactivate: true)
        render json: { message: 'User deactivated successfully' }, status: :ok
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'User not found ' }, status: :not_found
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

    def attach_remote_image(image_url)
      downloaded_image = URI.open(image_url)
      filename = File.basename(URI.parse(image_url).path) || "profile.jpg"
      content_type = downloaded_image.content_type || "image/jpeg"
  
      current_user.image.purge if current_user.image.attached?
      current_user.image.attach(io: downloaded_image, filename: filename, content_type: content_type)
    end
  
    # Handle Base64 Image Upload
    def attach_base64_image(base64_string)
      format, data = base64_string.split(',')
      ext = format.match(/image\/(\w+);base64/)[1]
      decoded_data = Base64.decode64(data)
  
      filename = "profile.#{ext}"
      io = StringIO.new(decoded_data)
  
      current_user.image.purge if current_user.image.attached?
      current_user.image.attach(io: io, filename: filename, content_type: "image/#{ext}")
    end
  
    # Generate Base64-Encoded Image from ActiveStorage
    def generate_base64_image(image)
      return nil unless image.attached?
  
      blob = image.blob
      image_data = blob.download
      base64_data = Base64.strict_encode64(image_data)
      "data:#{blob.content_type};base64,#{base64_data}"
    end
  
   
  end
  