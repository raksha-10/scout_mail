class Api::V1::UsersController < ApplicationController
    before_action :authenticate_user!
    skip_before_action :authenticate_user!, only: [:accept_invitation]

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
    
    def accept_invitation
      token = params[:invitation_token]
      user = User.find_by_invitation_token(token, true)
  
      if user
        user.accept_invitation!
        render json: { redirect_url: "http://localhost:3000/login" }, status: :ok
      else
        render json: { error: "Invalid or expired invitation token" }, status: :unprocessable_entity
      end
    end
   
  end
  