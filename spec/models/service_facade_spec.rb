require 'rails_helper'

RSpec.describe ServiceFacade do
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

      facade = ServiceFacade.new
      expect(facade.artist_data(artist_json)).to be_a(Hash)
      expect(facade.artist_data(artist_json)[:id]).to be_a(String)
      expect(facade.artist_data(artist_json)[:name]).to be_a(String)
      expect(facade.artist_data(artist_json)[:location]).to be_a(String)
      expect(facade.artist_data(artist_json)[:email]).to be_a(String)
      expect(facade.artist_data(artist_json)[:identity]).to be_a(String)
      expect(facade.artist_data(artist_json)[:password_digest]).to be_a(String)
    end

    it "artists returns an array of artist objects" do
      artists = ServiceFacade.new.artists

      expect(artists).to be_an(Array)
      artists.each { |artist| expect(artist).to be_an(Artist)}
    end
  end
end