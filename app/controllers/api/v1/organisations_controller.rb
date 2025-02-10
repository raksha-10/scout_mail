module Api
    module V1
      class OrganisationsController < ApplicationController
        before_action :authenticate_user!
        def index
          organisations = current_user.organisations
          render json: {
            status: 200,
            organisations: organisations&.any? ? OrganisationSerializer.new(organisations) : []
          }, status: :ok
        end

        def create
          organisation = Organisation.new(organisation_params)
          role = Role.find_or_create_by(name: "Owner")
          if organisation.save
            user_organisation = UserOrganisation.create(
              user: current_user,
              organisation: organisation,
              role: role # Assigning the Owner role
            )
        
            if user_organisation.persisted?
              render json: { status: 201, message: "Organisation created successfully", organisation: OrganisationSerializer.new(organisation) }, status: :created
            else
              render json: { status: 422, errors: user_organisation.errors.full_messages }, status: :unprocessable_entity
            end
          else
            render json: { status: 422, errors: organisation.errors.full_messages }, status: :unprocessable_entity
          end
        end
        
			
				private
			
				def organisation_params
					params.require(:organisation).permit(:name)
				end
      end
    end
  end
  