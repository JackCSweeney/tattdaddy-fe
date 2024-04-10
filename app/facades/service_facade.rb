class ServiceFacade

  def artists
    service = ArtistService.new
    json = service.find_artists
    json[:data].map do |json_data|
      data = artist_data(json_data)

      Artist.new(data)
    end
  end

  def artist_data(artist_json)
    data = {
      id: artist_json[:id],
      name: artist_json[:attributes][:name],
      location: artist_json[:attributes][:location],
      email: artist_json[:attributes][:email],
      identity: artist_json[:attributes][:identity],
      password_digest: artist_json[:attributes][:password_digest],
    }
  end
end