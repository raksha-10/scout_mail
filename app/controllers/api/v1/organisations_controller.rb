module Api
    module V1
      class OrganisationsController < ApplicationController
        skip_before_action :authenticate_user!

        def organisation_types
          render json: OrganisationType.all.pluck(:id, :name).map { |id, name| { id: id, name: name } }
        end
      end
    end
  end
  