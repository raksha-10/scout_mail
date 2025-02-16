class UserSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :email, :linkedin_url

  attribute :role do |user|
    user.role.name
  end

  attribute :image_url do |user|
    if user.image.attached?
      Rails.application.routes.url_helpers.url_for(user.image)
    end
  end

  attribute :image_base64 do |user|
    if user.image.attached?
      image_data = user.image.download
      encoded_image = Base64.strict_encode64(image_data)
      "data:#{user.image.blob.content_type};base64,#{encoded_image}"
    end
  end

  attribute :organisation do |user|
    OrganisationSerializer.new(user.organisation).serializable_hash[:data][:attributes]
  end
end
