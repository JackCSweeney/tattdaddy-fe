require 'rails_helper'

RSpec.describe ArtistFacade do
  describe "Instance method" do
    before do
      json_response_0 = File.read("spec/fixtures/artist/artists.json")
      stub_request(:get, "http://localhost:3000/api/v0/artists")
        .to_return(status: 200, body:json_response_0)
      
      json_response_1 = File.read("spec/fixtures/artist/artist.json")
      stub_request(:get, "http://localhost:3000/api/v0/artists/5")
        .to_return(status: 200, body: json_response_1)

      json_response_2 = File.read("spec/fixtures/artist/artist_tattoos.json")
      stub_request(:get, "http://localhost:3000/api/v0/artists/5/tattoos")
        .to_return(status: 200, body: json_response_2)

      json_response_4 = File.read("spec/fixtures/artist/tattoo_2.json")
      stub_request(:get, "http://localhost:3000/api/v0/tattoos/2")
        .to_return(status: 200, body: json_response_4)
    end

    it "artist_data returns a hash in the desired format" do
      artist_json = {
        id: "322458",
        type: "artist",
        attributes: {
          name: "Tattoo artists",
          location: "1400 U Street NW",
          email: "tatart@gmail.com",
          identity: "LGBTQ+ Friendly",
          password_digest: "unreadable hash"
        }
      }

      facade = ArtistFacade.new
      expect(facade.artist_data(artist_json)).to be_a(Hash)
      expect(facade.artist_data(artist_json)[:id]).to be_a(String)
      expect(facade.artist_data(artist_json)[:name]).to be_a(String)
      expect(facade.artist_data(artist_json)[:location]).to be_a(String)
      expect(facade.artist_data(artist_json)[:email]).to be_a(String)
      expect(facade.artist_data(artist_json)[:identity]).to be_a(String)
      expect(facade.artist_data(artist_json)[:password_digest]).to be_a(String)
    end

    it "artists returns an array of artist objects" do
      artists = ArtistFacade.new.artists

      expect(artists).to be_an(Array)
      artists.each { |artist| expect(artist).to be_an(Artist)}
    end

    it "find_artist returns an artist object with the given id" do
      artist = ArtistFacade.new.find_artist("5")

      expect(artist).to be_an(Artist)
    end

    it "find_artist_tattoos returns an array of tattoos uploaded from the artist of the given id" do
      tattoos = ArtistFacade.new.find_artist_tattoos("5")

      expect(tattoos).to be_an(Array)
      tattoos.each { |tattoo| expect(tattoo).to be_a(Tattoo)}
    end

    it "find_tattoo returns a tattoo object" do

      tattoo = ArtistFacade.new.find_tattoo("2")
      expect(tattoo).to be_a(Tattoo)
    end

    it "update_tattoo returns a tattoo object" do
      attributes = {tattoo: {"artist_id"=>"5", "image_url"=>"app/assets/images/bronto.jpeg", "price"=>"200", "time_estimate"=>"2", id: "2"}}

      allow_any_instance_of(ArtistService).to receive(:update_tattoo).with("2", attributes)

      tattoo = ArtistFacade.new.update_tattoo(attributes)
      expect(tattoo).to be_a(Tattoo)
    end
  end
end