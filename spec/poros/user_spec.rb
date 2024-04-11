require "rails_helper"

RSpec.describe User do
  it "creates User object from parsed JSON data" do
    data = {
      id: "25", 
      type: "user", 
      attributes: {
        name: "Ruby Gem", 
        location: "9705 Fishers District Dr, Fishers, IN 46037", 
        email: "jesusa@spinka.test", 
        search_radius: 25, 
        password: nil
        }
      }

    user = User.new(data)

    expect(user).to be_a(User)
    expect(user.id).to eq("25")
    expect(user.name).to eq("Ruby Gem")
    expect(user.location).to eq("9705 Fishers District Dr, Fishers, IN 46037")
    expect(user.email).to eq("jesusa@spinka.test")
    expect(user.search_radius).to eq(25)
  end
end