require 'open-uri'

class Api::V1::UsersController < ApplicationController
  # before_action :authenticate_user!, except: [:accept_invitation]
 
  def show_current_user
    if @current_user
      render json: {
        id: @current_user.id,
        name: @current_user.name,
        email: @current_user.email,
        role: @current_user.role.name,
        linkedin_url: @current_user.linkedin_url,
        image_url: @current_user.image.attached? ? url_for(@current_user.image) : nil, 
        organisation: @current_user.organisation
      }, status: :ok
    else
      render json: { error: "User not found" }, status: :unauthorized
    end
  end

    def invite_user
      @organisation = Organisation.find(params[:organisation_id])
      # Ensure only the Owner can invite users
      unless current_user.has_role?("Owner", @organisation)
        return render json: { error: 'You are not authorized to send invites.' }, status: :forbidden
      end
    
      # Check if the role exists, otherwise return an error
      role = Role.find_by(name: params[:role])
      return render json: { error: 'Invalid role provided.' }, status: :unprocessable_entity unless role
      # Invite the user and send an email
      user = User.invite!(
        email: params[:email],
        name: params[:name], # Assuming 'name' is a column in User
        password: params[:password] # If password is optional, Devise Invitable will generate one
      )
      # Associate the user with the organisation and assign them the selected role
      user_organisation = UserOrganisation.create(
        user: user,
        organisation: @organisation,
        role: role
      )
      if user_organisation.persisted?
        render json: { message: 'Invite sent successfully.' }, status: :created
      else
        render json: { error: 'Failed to associate the user with the organization.' }, status: :unprocessable_entity
      end
    end
    
    def update
      begin
        if params[:user][:image].present? && params[:user][:image].start_with?("http")
          downloaded_image = URI.open(params[:user][:image])
          
          filename = URI.parse(params[:user][:image]).path.split("/").last.presence || "profile.jpg"
          content_type = downloaded_image.content_type || MIME::Types.type_for(filename).first&.content_type || "image/jpeg"
          
          current_user.image.purge if current_user.image.attached?
          current_user.image.attach(io: downloaded_image, filename: filename, content_type: content_type)
        end
      rescue StandardError => e
        return render json: { error: "Failed to download image: #{e.message}" }, status: :unprocessable_entity
      end

      if current_user.update(user_params.except(:image))
        if user_params[:image].present?
          current_user.image.purge if current_user.image.attached?
          current_user.image.attach(user_params[:image])
        end

        render json: { message: "User updated successfully", user: current_user.as_json(only: [:id, :name, :email]) }, status: :ok
      else
        render json: { error: current_user.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    # def accept_invitation
    #   token = params[:invitation_token]
    #   user = User.find_by_invitation_token(token, true)
  
    #   if user
    #     user.accept_invitation!
    #     render json: { redirect_url: "http://localhost:3000/login" }, status: :ok
    #   else
    #     render json: { error: "Invalid or expired invitation token" }, status: :unprocessable_entity
    #   end
    # end

    private

    def user_params
      params.require(:user).permit(:name, :mobile, :linkedin_url)
    end
   
  end
  