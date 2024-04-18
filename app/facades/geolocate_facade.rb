class GeolocateFacade
  def self.find_coords
    response = GeolocateService.find_coords
    parse_coords(response) 
  end

  def self.parse_coords(response)
    coords = JSON.parse(response.body, symbolize_names: true)
    coords[:location].values.join(",")
  end

  def self.find_address(coords)
    response = GeolocateService.find_address(coords)

    parse_address(response)
  end

  def self.parse_address(response)
    address = JSON.parse(response.body, symbolize_names: true)
    address[:results].first[:formatted_address]
  end
end