require 'open-uri'

class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!
 
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
   
  def update
    begin
      if params[:user][:image].present? && params[:user][:image].start_with?("http")
        downloaded_image = URI.open(params[:user][:image])
        
        filename = URI.parse(params[:user][:image]).path.split("/").last.presence || "profile.jpg"
        content_type = downloaded_image.content_type || "image/jpeg"
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

      render json: { message: "User updated successfully", user: current_user.as_json(only: [:id, :name, :email,:linkedin_url,:mobile]), organisation: current_user.organisation }, status: :ok
    else
      render json: { error: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

    private

    def user_params
      params.require(:user).permit(:name, :mobile, :linkedin_url)
    end
   
  end
  