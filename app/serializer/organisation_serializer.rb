class OrganisationSerializer
    include JSONAPI::Serializer
    attributes :id, :name, :created_at, :updated_at, :mobile, :location,
             :linkedin_url, :email, :organisation_type_id, :twitter_url,
             :facebook_url, :tax_id
  end
  