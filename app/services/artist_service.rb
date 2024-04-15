class ArtistService
  def connection
    Faraday.new(url: "http://localhost:3000")
  end

  def get_url(uri)
    response = connection.get(uri)
    JSON.parse(response.body, symbolize_names: true)
  end

  def post_url(uri, attributes)
    response = connection.post(uri)do |req|
      req.body = attributes
    end
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
  
  def send_new_artist_tattoo(attributes)
    post_url("/api/v0/tattoos", attributes)
  end
end