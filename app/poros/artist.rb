require 'bcrypt'

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
    @password_digest = BCrypt::Password.create(data[:password_digest])
  end

  def authenticate(input_password)
    BCrypt::Password.new(password_digest) == input_password
  end
end