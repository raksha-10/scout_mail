class InvitedUserSerializer 
    include JSONAPI::Serializer  
  
    attributes :id, :name, :email
  
    attribute :role do |user|
      user.role&.name
    end
  
    attribute :status do |user|
      user.invitation_accepted_at.nil? ? 'pending' : 'accepted'
    end
  
    attribute :active_status do |user|
      user.deactivated_at ? 'deactivated' : 'active'
    end
  end
  