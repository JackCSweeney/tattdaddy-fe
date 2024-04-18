class GeolocateService
  def self.conn_coords
    Faraday.new("https://www.googleapis.com")
  end

  def self.find_coords
    conn_coords.post("/geolocation/v1/geolocate?key=#{Rails.application.credentials.google_maps_api}")
  end

  def self.conn_address
    Faraday.new("https://maps.googleapis.com")
  end

  def self.find_address(coords)
    conn_address.get("https://maps.googleapis.com/maps/api/geocode/json?latlng=#{coords}&key=#{Rails.application.credentials.google_maps_api}")
  end
end