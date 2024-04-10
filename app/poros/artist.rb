class Artist
  attr_reader :id,
              :name,
              :location,
              :email,
              :identity,
              :password_digest

  def initialize(data)
    @id = data[:id]
    @name = data[:name]
    @location = data[:location]
    @email = data[:email]
    @identity = data[:identity]
    @password_digest = data[:password_digest]
  end
end