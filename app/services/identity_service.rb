class IdentityService
  def self.get_all_identities
    get_url("/api/v0/identities")
  end

  def self.get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn
    Faraday.new(url: "https://tattdaddy-be.onrender.com")
  end
end