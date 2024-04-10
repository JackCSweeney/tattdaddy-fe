class User
  attr_reader :id,
  :name,
  :location,
  :email,
  :identity_preference,
  :radius

  def initialize(attributes)
    @id, = attributes[:id]
    @name, = attributes[:attributes][:name]
    @location, = attributes[:attributes][:location]
    @email, = attributes[:attributes][:email]
    @identity_preference, = attributes[:attributes][:identity_preference]
    @radius = attributes[:attributes][:radius]
  end
end