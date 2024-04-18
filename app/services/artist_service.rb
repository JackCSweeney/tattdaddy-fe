class ArtistService
  def connection
    Faraday.new(url: "http://localhost:3000")
  end

  def get_url(uri)
    response = connection.get(uri)
    JSON.parse(response.body, symbolize_names: true)
  end

  def post_url_tattoos(uri, attributes)
    response = connection.post(uri) do |req|
      req.body = { tattoo: attributes }
    end
    JSON.parse(response.body, symbolize_names: true)
  end 

  def delete_url(uri)
    connection.delete(uri)
  end

  def find_artists
    get_url("/api/v0/artists")
  end

  def find_artist(id)
    get_url("/api/v0/artists/#{id}")
  end

  def artist_tattoos(id)
    get_url("/api/v0/artists/#{id}/tattoos")
  end
  
  def send_new_artist_tattoo(attributes)
    post_url_tattoos("/api/v0/tattoos", attributes)
  end

  def find_tattoo(id)
    get_url("/api/v0/tattoos/#{id}")
  end

  def update_tattoo(id, attributes)
    response = connection.patch("/api/v0/tattoos/#{id}") do |req|
      req.body = { tattoo: attributes }
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def post_url(url, params)
    response = connection.post(url, params)
    JSON.parse(response.body, symbolize_names: true)
  end

  def update_url(url, params)
    response = connection.patch(url) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = params.to_json
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.update_url(url, params)
    ArtistService.new.update_url(url, params)
  end

  def create_artist(artist_attributes)
    post_url("/api/v0/artists", {artist: artist_attributes})
  end

  def create_artist_identities(identities, artist_id)
    identities.map do |identity_id|
      post_url("/api/v0/artist_identities", {artist_identity: {artist_id: artist_id, identity_id: identity_id}})
    end
  end 

  def artist_identities(id)
    get_url("/api/v0/artists/#{id}/identities")
  end

  def delete_artist(id)
    delete_url("/api/v0/artists/#{id}")
  end

  def self.update_artist_data(artist_id, updated_data)
    update_url("/api/v0/artists/#{artist_id}", updated_data)
  end

  def self.delete_artist_identity(artist_and_identity_ids)
    delete_url_with_body("/api/v0/artist_identities", artist_and_identity_ids)
  end

  def self.create_artist_identity(artist_and_identity_ids)
    new.post_url("/api/v0/artist_identities", artist_and_identity_ids)
  end

  def self.delete_url_with_body(url, body_data)
    new.delete_url_with_body(url, body_data)
  end

  def delete_url_with_body(url, body_data)
    connection.delete(url) do |req|
      req.body = (body_data)
    end
  end 

  def delete_tattoo(id)
    delete_url("/api/v0/tattoos/#{id}")
  end
end