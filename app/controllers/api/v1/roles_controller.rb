class Api::V1::RolesController < ApplicationController
    skip_before_action :authenticate_user!

    def index
			roles = Role.where.not(name: "Owner")
			render json: roles
    end      
end