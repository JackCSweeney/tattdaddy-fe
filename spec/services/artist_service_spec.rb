require 'rails_helper'

RSpec.describe ArtistService do
  describe "Instance methods" do
    before do
      @uri = "/api/v0/artists"
      allow_any_instance_of(ArtistService).to receive(:get_url).with(@uri).and_return(
        {
          data: [
            {
              id: "322458",
              type: "artist",
              attributes: {
                name: "Tattoo artists",
                location: "1400 U Street NW",
                email: "tatart@gmail.com",
                Identity: "LGBTQ+ Friendly",
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
                Identity: "LGBTQ+ Friendly",
                password_digest: "unreadable hash"
              }
            }
          ]
        }
      )
    end

    it "stablishes a connection" do
      connection = Faraday.new(url: "http://localhost:3000")
      allow_any_instance_of(ArtistService).to receive(:connection).and_return(connection)
    end
    
    it "returns a Faraday connection object" do
      connection = ArtistService.new.connection
      
      expect(connection).to be_a(Faraday::Connection)
      expect(connection.url_prefix.to_s).to eq("http://localhost:3000/")
    end

    it "gets URL, populating API records into JSON" do
      parsed_artists = ArtistService.new.get_url(@uri)

      expect(parsed_artists[:data]).to be_an(Array)
      expect(parsed_artists[:data].first).to be_a(Hash)
      expect(parsed_artists[:data].first[:id]).to be_a(String)
      expect(parsed_artists[:data].first[:type]).to eq("artist")
      expect(parsed_artists[:data].first[:attributes]).to be_a(Hash)
    end

    it "finds all of the artists" do
      parsed_artists = ArtistService.new.find_artists

      expect(parsed_artists[:data].first[:type]).to eq("artist")
      expect(parsed_artists[:data].first[:attributes]).to be_a(Hash)
      expect(parsed_artists[:data].first[:attributes][:name]).to eq("Tattoo artists")
      expect(parsed_artists[:data].first[:attributes][:location]).to eq("1400 U Street NW")
      expect(parsed_artists[:data].first[:attributes][:email]).to eq("tatart@gmail.com")
      expect(parsed_artists[:data].first[:attributes][:Identity]).to eq("LGBTQ+ Friendly")
      expect(parsed_artists[:data].first[:attributes][:password_digest]).to eq("unreadable hash")
    end

    it "finds the artist of the given id" do
      json_response_1 = File.read("spec/fixtures/artist/artist.json")

      allow_any_instance_of(ArtistService).to receive(:get_url).with("/api/v0/artists/5")
        .and_return(status: 200, body: json_response_1)

      parsed_artist = ArtistService.new.find_artist("5")
      expect(parsed_artist[:body]).to eq(json_response_1)
    end

    it "finds the tattoos of the artist of the given id" do
      json_response_2 = File.read("spec/fixtures/artist/artist_tattoos.json")
      allow_any_instance_of(ArtistService).to receive(:get_url).with("/api/v0/artists/5/tattoos")
        .and_return(status: 200, body: json_response_2)

      parsed_artist = ArtistService.new.artist_tattoos("5")
      expect(parsed_artist[:body]).to eq(json_response_2)
    end

    it "sends the new artist tattoo" do
      attributes = {"artist_id"=>"5", "image_url"=>"https://gist.github.com/assets/149989113/fee274f7-0fa9-4606-855b-9c286fcb1661", "price"=>"50", "time_estimate"=>"2"}

      allow_any_instance_of(ArtistService).to receive(:post_url).with("/api/v0/tattoos", attributes)
        .and_return(status: 200, body: "")
        
      parsed_artist_tattoo = ArtistService.new.send_new_artist_tattoo(attributes)
      expect(parsed_artist_tattoo[:body]).to eq("")
      expect(parsed_artist_tattoo[:status]).to eq(200)
    end

    it "finds a tattoo given its id" do
      json_response_3 = File.read("spec/fixtures/artist/tattoo.json")
      allow_any_instance_of(ArtistService).to receive(:find_tattoo)
        .and_return(status: 200, body: json_response_3)

      parsed_tattoo = ArtistService.new.find_tattoo("2")
      expect(parsed_tattoo[:body]).to eq(json_response_3)
    end
  end
end