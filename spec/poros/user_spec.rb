require "rails_helper"

RSpec.describe User do
  it "creates User object from parsed JSON data" do
    data = {
     id: "25",
      type: "user",
      attributes: {
        name: "Ruby",
        location: "9705 Fishers District Dr, Fishers, IN 46037",
        email: "tatart@gmail.com",
        identity_preference: "LGBTQ+ Friendly",
        radius: "25",
        password_digest: "unreadable hash"
      }
    }

    user = User.new(data)

    expect(user).to be_a(User)
    expect(user.id).to eq("25")
    expect(user.name).to eq("Ruby")
    expect(user.location).to eq("9705 Fishers District Dr, Fishers, IN 46037")
    expect(user.email).to eq("tatart@gmail.com")
    expect(user.identity_preference).to eq("LGBTQ+ Friendly")
    expect(user.radius).to eq("25")
  end
end