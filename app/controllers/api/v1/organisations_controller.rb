module Api
  module V1
    class OrganisationsController < ApplicationController
      skip_before_action :authenticate_user!, only: [:organisation_types]
      before_action :set_organisation, only: [:show, :update]

      def show
        render json: { organisation: @organisation }, status: :ok
      end

      def update
        if @organisation.update(organisation_params)
          render json: { message: 'Organisation updated successfully', organisation: @organisation }, status: :ok
        else
          render json: { errors: @organisation.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def organisation_types
        render json: OrganisationType.all.pluck(:id, :name).map { |id, name| { id: id, name: name } }
      end

      def organisations
        # Get all organisations the current user is linked to, along with their role
        user_organisation = @current_user.organisation
    
        organisations_with_roles = user_organisations.map do |user_org|
          {
            id: user_org.organisation.id,
            name: user_org.organisation.name,
            email: user_org.organisation.email,
            location: user_org.organisation.location,
            role: user_org.role # Assuming `user_organisations` table has a `role` column
          }
        end
    
        render json: { organisations: organisations_with_roles }, status: :ok
      end

      private

      def set_organisation
        @organisation = Organisation.find_by(id: params[:id])
        return render json: { error: 'Organisation not found' }, status: :not_found if @organisation.nil?
      end

      def organisation_params
        params.require(:organisation).permit(:name, :mobile, :location, :facebook_url, :tax_id,:linkedin_url, :email, :twitter_url,:organisation_type_id)
      end
    end
  end
end
  