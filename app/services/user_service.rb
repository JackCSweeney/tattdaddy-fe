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

  def self.update_user_data(user_id, updated_data)
    update_url("/api/v0/users/#{user_id}", {user: updated_data.to_h})
  end

  def self.create_user_identity(user_and_identity_ids)
    post_url("/api/v0/user_identities", user_and_identity_ids)
  end

  def self.create_user_tattoo(user_tattoo_data)
    body = JSON.generate(user_tattoo_data)
    post_url("/api/v0/user_tattoos", body)
  end

  def self.delete_user_identity(user_and_identity_ids)
    delete_url_with_body("/api/v0/user_identities", user_and_identity_ids)
  end

  def self.delete_user_tattoo(user_and_tattoo_ids)
    delete_url_with_body("/api/v0/user_tattoos", user_and_tattoo_ids)
  end

  def self.delete_user(user_id)
    delete_url("/api/v0/users/#{user_id}")
  end

  def self.get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.update_url(url, params)
    response = conn.patch(url, params)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.post_url(url, params)
    response = conn.post(url, params)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.delete_url(url)
    conn.delete(url)
  end

  def self.delete_url_with_body(url, body_data)
    conn.delete(url) do |req|
      req.body = JSON.generate(body_data)
    end
  end

  def self.conn
    Faraday.new(url: "http://localhost:3000")
  end
end