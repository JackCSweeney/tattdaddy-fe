class ArtistService
  def connection
    Faraday.new(url: "http://localhost:3000")
  end

  def get_url(uri)
    response = connection.get(uri)
    JSON.parse(response.body, symbolize_names: true)
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

  def create_artist(artist_attributes)
    post_url("/api/v0/artists", {artist: artist_attributes})
  end

  def create_artist_identities(identities, artist_id)
    identities.map do |identity_id|
      post_url("/api/v0/artist_identities", {artist_identity: {artist_id: artist_id, identity_id: identity_id}})
    end
  end
end