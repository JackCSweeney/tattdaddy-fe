require 'rails_helper'

RSpec.describe Artist do
  before do
    data = {
      id: "322458",
      name: "Tattoo artists",
      location: "1400 U Street NW",
      email: "tatart@gmail.com",
      identity: "LGBTQ+ Friendly",
      password_digest: "12345"
    }

    @artist = Artist.new(data)
  end

  describe "initialize" do
    it "exists" do
      expect(@artist).to be_an(Artist)
    end

    it "populates attributes correctly" do
      expect(@artist.id).to eq("322458")
      expect(@artist.name).to eq("Tattoo artists")
      expect(@artist.location).to eq("1400 U Street NW")
      expect(@artist.email).to eq("tatart@gmail.com")
      expect(@artist.identity).to eq("LGBTQ+ Friendly")
      expect(@artist.password_digest).to eq("12345")
    end
  end

  describe "authenticate" do
    it "returns true when input password is correct" do
      expect(@artist.authenticate("12345")).to be(true)
    end
  end
end