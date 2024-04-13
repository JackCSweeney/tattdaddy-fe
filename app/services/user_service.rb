class UserService
  def self.get_user_data(user_id)
    get_url("/api/v0/users/#{user_id}")
  end

  def self.dashboard_tattoos(user_id)
    get_url("/api/v0/tattoos?user=#{user_id}")
  end

  def self.get_artist_identity_pref(user_id)
    get_url("/api/v0/users/#{user_id}/identities")
  end

  def self.get_liked_tattoos(user_id)
    get_url("/api/v0/users/#{user_id}/tattoos")
  end

  def self.delete_user(user_id)
    delete_url("/api/v0/users/#{user_id}")
  end

  def self.get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.delete_url(url)
    response = conn.delete(url)
  end

  def self.conn
    Faraday.new(url: "http://localhost:3000")
  end
end