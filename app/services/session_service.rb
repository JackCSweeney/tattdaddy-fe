class SessionService
  def self.authenticate(sign_in_credentials)
    post_url("/api/v0/sign_in", sign_in_credentials)
  end

  def self.post_url(url, params)
    response = conn.post(url, params)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.sign_out#(current_user_information)
    delete_url("/api/v0/sign_out")
  end

  def self.delete_url(url)
    response = conn.delete(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn
    Faraday.new(url: "https://tattdaddy-be.onrender.com")
  end
end