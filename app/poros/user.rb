class User
  attr_reader :id,
              :name,
              :location,
              :email,
              :search_radius

  def initialize(attributes)
    @id = attributes[:id]
    @name = attributes[:attributes][:name]
    @location = attributes[:attributes][:location]
    @email = attributes[:attributes][:email]
    @search_radius = attributes[:attributes][:search_radius]
  end

  def attributes
    [@id, @name, @location, @email, @search_radius]
  end
end