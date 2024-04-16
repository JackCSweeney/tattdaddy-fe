class IdentityFacade
  def self.list_all_identities
    json = IdentityService.get_all_identities
    json[:data].map do |identity_data|
      Identity.new(identity_data)
    end
  end
end