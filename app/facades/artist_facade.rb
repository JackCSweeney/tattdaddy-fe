class ArtistFacade

  def artists
    service = ArtistService.new
    json = service.find_artists
    json[:data].map do |json_data|
      data = artist_data(json_data)

      Artist.new(data)
    end
  end

  def find_artist(id)
    json = ArtistService.new.find_artist(id)
    data = artist_data(json[:data])
    Artist.new(data)
  end

  def find_artist_tattoos(id)
    service = ArtistService.new
    json = service.artist_tattoos(id)
    json[:data].map do |json_data|
      Tattoo.new(json_data)
    end
  end

  def find_artist_identities(id)
    service = ArtistService.new
    json = service.artist_identities(id)
    json[:data].map do |json_data|
      Identity.new(json_data)
    end
  end

  def delete_artist(id)
    ArtistService.new.delete_artist(id)
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

  def find_tattoo(id)
    data = ArtistService.new.find_tattoo(id)
    Tattoo.new(data[:data])
  end

  def update_tattoo(tattoo_attributes)
    ArtistService.new.update_tattoo(tattoo_attributes[:tattoo][:id], tattoo_attributes)
    tattoo = find_tattoo(tattoo_attributes[:tattoo][:id])
  end
end