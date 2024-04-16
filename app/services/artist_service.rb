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

  def artist_identities(id)
    get_url("/api/v0/artists/#{id}/identities")
  end

  def delete_artist(id)
    delete_url("/api/v0/artists/#{id}")
  end
end