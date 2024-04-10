require 'rails_helper'

RSpec.describe Artist do
  describe "initialize" do
    before do
      data = {
        id: "322458",
        name: "Tattoo artists",
        location: "1400 U Street NW",
        email: "tatart@gmail.com",
        identity: "LGBTQ+ Friendly",
        password_digest: "unreadable hash"
      }

      @artist = Artist.new(data)
    end

    it "exists" do
      expect(@artist).to be_an(Artist)
    end

    it "populates attributes correctly" do
      expect(@artist.id).to eq("322458")
      expect(@artist.name).to eq("Tattoo artists")
      expect(@artist.location).to eq("1400 U Street NW")
      expect(@artist.email).to eq("tatart@gmail.com")
      expect(@artist.identity).to eq("LGBTQ+ Friendly")
      expect(@artist.password_digest).to eq("unreadable hash")
    end
  end
end