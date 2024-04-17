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

  def self.create_artist(artist_attributes)
    ArtistService.new.create_artist(artist_attributes)
  end

  def self.create_artist_identities(identities, artist_id)
    ArtistService.new.create_artist_identities(identities, artist_id)
  end

  def self.update_data_and_identities(artist_id, updated_artist_data, identity_changes)
    update_artist_data(artist_id, updated_artist_data)
    update_artist_identities(artist_id, identity_changes)
  end

  def self.update_artist_data(artist_id, artist_params)
    ArtistService.update_artist_data(artist_id, { artist: artist_params })
  end

  def self.update_artist_identities(artist_id, identity_changes)
    for key, values in identity_changes
      values.each do |identity_id|
        params = { artist_identity: { artist_id: artist_id, identity_id: identity_id }}

        ArtistService.create_artist_identity(params) if key == :post
        ArtistService.delete_artist_identity(params) if key == :delete
      end
    end
  end
end