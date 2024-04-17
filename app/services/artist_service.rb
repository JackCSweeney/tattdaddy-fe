class ArtistService
  def connection
    Faraday.new(url: "http://localhost:3000")
  end

  def get_url(uri)
    response = connection.get(uri)
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

  def post_url(url, params)
    response = connection.post(url, params)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.update_url(url, params)
    response = conn.patch(url)
    JSON.parse(response.body, symbolize_names: true)
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
    body = JSON.generate(artist_and_identity_ids)
    post_url("/api/v0/artist_identities", body)
  end
end