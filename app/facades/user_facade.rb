class UserFacade
  def self.user_data(user_id)
    json = UserService.user_data(user_id)
    User.new(json[:data])

  end

  def self.dashboard_tattoos(user_id)
    json = UserService.dashboard_tattoos(user_id)
    json[:data].map do |tattoo_data|
      Tattoo.new(tattoo_data)
    end
  end
end