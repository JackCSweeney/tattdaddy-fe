class ArtistFacade
  def artists
    json = artist_service.find_artists
    json[:data].map { |json_data| build_artist(json_data) }
  end

  def find_artist(id)
    json = artist_service.find_artist(id)
    build_artist(json[:data])
  end

  def find_artist_tattoos(id)
    json = artist_service.artist_tattoos(id)
    json[:data].map { |json_data| Tattoo.new(json_data) }
  end

  def update_tattoo(tattoo_attributes)
    begin
      data = artist_service.update_tattoo(tattoo_attributes[:tattoo][:id], tattoo_attributes)
      Tattoo.new(data[:data])
    rescue StandardError => e
      handle_error(e)
    end
  end

  def artist_service
    @artist_service ||= ArtistService.new
  end

  def build_artist(json_data)
    data = artist_data(json_data)
    Artist.new(data)
  end

  def find_artist_identities(id)
    json = artist_service.artist_identities(id)[:data].map do |json_data|
      Identity.new(json_data)
    end
  end

  def delete_artist(id)
    artist_service.delete_artist(id)
  end

  def artist_data(artist_json)
    {
      id: artist_json[:id],
      name: artist_json[:attributes][:name],
      location: artist_json[:attributes][:location],
      email: artist_json[:attributes][:email],
      identity: artist_json[:attributes][:identity],
      password_digest: artist_json[:attributes][:password_digest],
      scheduling_link: artist_json[:attributes][:scheduling_link]
    }
  end

  def find_tattoo(id)
    data = artist_service.find_tattoo(id)
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

  def find_tattoo(id)
    data = ArtistService.new.find_tattoo(id)
    Tattoo.new(data[:data])
  end

  def handle_error(error)
    puts "An error occurred: #{error.message}"
    nil
  end
end
