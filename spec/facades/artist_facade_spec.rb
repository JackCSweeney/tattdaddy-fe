require 'rails_helper'

RSpec.describe ArtistFacade do
  describe "Instance method" do
    describe "get methods" do
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

        json_response_3 = File.read("spec/fixtures/artist/identities.json")

        stub_request(:get, "http://localhost:3000/api/v0/artists/5")
          .to_return(status: 200, body: json_response_1)
        stub_request(:get, "http://localhost:3000/api/v0/artists/5/tattoos")
          .to_return(status: 200, body: json_response_2)
        stub_request(:get, "http://localhost:3000/api/v0/artists/5/identities")
          .to_return(status: 200, body: json_response_3)
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

      it "find_artist_identities returns an array of identities of the artist of the given id" do
        identities = ArtistFacade.new.find_artist_identities("5")

        expect(identities).to be_an(Array)
        identities.each { |identity| expect(identity).to be_an(Identity)}
      end
    end

    describe "delete methods" do
      it "deletes an artist's account" do
        stub_request(:delete, "http://localhost:3000/api/v0/artists/5")
          .to_return(status: 204)
      
        response = ArtistFacade.new.delete_artist(5)
        expect(response.status).to eq(204)
      end
    end
  end
end