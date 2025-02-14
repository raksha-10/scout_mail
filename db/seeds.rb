["Owner", "Admin", "Full Member", "Limited Full Member", "Read-Only User"].each do |role_name|
    Role.find_or_create_by(name: role_name.strip)
  end  

  organisation_types = ["Startup", "Enterprise", "IT Software", "Government", "Education"]
  organisation_types.each do |type|
    OrganisationType.find_or_create_by(name: type.strip)
  end