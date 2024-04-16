require 'rails_helper'

RSpec.describe ArtistFacade do
  describe "Instance method" do
    before do
      allow_any_instance_of(ArtistService).to receive(:find_artists).and_return(
        {
          data: [
            {
              id: "322458",
              type: "artist",
              attributes: {
                name: "Tattoo artists",
                location: "1400 U Street NW",
                email: "tatart@gmail.com",
                identity: "LGBTQ+ Friendly",
                password_digest: "unreadable hash"
              }
            },
            {
              id: "322459",
              type: "artist",
              attributes: {
                name: "Tattoo Pot",
                location: "54541 Street CO",
                email: "tatpot@gmail.com",
                identity: "LGBTQ+ Friendly",
                password_digest: "unreadable hash"
              }
            }
          ]
        }
      )

      json_response_1 = File.read("spec/fixtures/artist/artist.json")

      json_response_2 = File.read("spec/fixtures/artist/artist_tattoos.json")

      stub_request(:get, "http://localhost:3000/api/v0/artists/5")
        .to_return(status: 200, body: json_response_1)
        
      stub_request(:get, "http://localhost:3000/api/v0/artists/5/tattoos")
        .to_return(status: 200, body: json_response_2)

      stub_request(:post, "http://localhost:3000/api/v0/artists")
        .with(body: {artist: {name: "Tattoo artists", email: "tatart@gmail.com", password: "password", location: "1400 U Street NW, Washington, DC 20009"}})
        .to_return(status: 200, body: json_response_1)    
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
  end
  
  describe ".create_artist(artist_attributes)" do
    it "can create an artist" do
      artist_attributes = {name: "Tattoo artists", email: "tatart@gmail.com", password: "password", location: "1400 U Street NW, Washington, DC 20009"}
      
      json_response = File.read("spec/fixtures/artist/artist.json")
      stub_request(:post, "http://localhost:3000/api/v0/artists")
      .to_return(status: 200, body: json_response)
      
      response = ArtistFacade.create_artist(artist_attributes)

      expect(response).to have_key(:data)
      expect(response[:data]).to have_key(:attributes)

      attributes = response[:data][:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)

      expect(attributes).to have_key(:email)
      expect(attributes[:email]).to be_a(String)

      expect(attributes).to have_key(:location)
      expect(attributes[:location]).to be_a(String)
    end
  end

  describe ".create_artist_identities(identities, artist_id)" do
    it 'can create artist identity records' do
      json_response = File.read("spec/fixtures/artist/create_artist_identities.json")
      stub_request(:post, "http://localhost:3000/api/v0/artist_identities")
        .to_return(status: 200, body: json_response)

      response = ArtistFacade.create_artist_identities(["None"], 5)

      expect(response.first[:message]).to eq("Identity successfully added to Artist")
    end
  end
end