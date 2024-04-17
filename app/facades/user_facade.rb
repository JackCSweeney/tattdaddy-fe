class UserFacade
  def self.user_data(user_id)
    json = UserService.get_user_data(user_id)
    User.new(json[:data])
  end

  def self.dashboard_tattoos(user_id)
    json = UserService.dashboard_tattoos(user_id)
    json[:data].map do |tattoo_data|
      Tattoo.new(tattoo_data)
    end
  end

  def self.liked_tattoos(user_id)
    json = UserService.get_liked_tattoos(user_id)
    json[:data].map do |tattoo_data|
      Tattoo.new(tattoo_data)
    end
  end

  def self.identity_preferences(user_id)
    json = UserService.get_artist_identity_pref(user_id)
    json[:data].map do |identity_data|
      Identity.new(identity_data)
    end
  end

  def self.update_data_and_identities(user_id, updated_user_data, identity_changes)
    update_user_data(user_id, updated_user_data)
    update_user_identities(user_id, identity_changes)
  end

  def self.update_user_data(user_id, user_params)
    UserService.update_user_data(user_id, user_params)
  end

  def self.update_user_identities(user_id, identity_changes)
    for key, values in identity_changes
      values.each do |identity_id|
        params = { user_identity: { user_id: user_id, identity_id: identity_id }}

        UserService.create_user_identity(params) if key == :post
        UserService.delete_user_identity(params) if key == :delete
      end
    end
  end

  def self.create_user_tattoo(user_tattoo_data)
    UserService.create_user_tattoo(user_tattoo_data)
  end

  def self.delete_user_tattoo(user_id, tattoo_id)
    user_and_tattoo_ids = { user_tattoo: { user_id: user_id, tattoo_id: tattoo_id}}
    UserService.delete_user_tattoo(user_and_tattoo_ids)
  end

  def self.delete_user(user_id)
    UserService.delete_user(user_id)
  end

  def self.create_new_user(user_attributes)
    UserService.create_user(user_attributes)
  end

  def self.create_user_identities(identities, user_id)
    UserService.create_user_identities(identities, user_id)
  end
end