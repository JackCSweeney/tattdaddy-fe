require 'rails_helper'

RSpec.describe SearchService do
  describe "Instance methods" do
    before do
      @uri = "artists"
      allow_any_instance_of(SearchService).to receive(:get_url).with(@uri).and_return(
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
      connection = Faraday.new(url: "http://localhost:3000/api/v0")
      allow_any_instance_of(SearchService).to receive(:connection).and_return(connection)
    end
    
    it "returns a Faraday connection object" do
      connection = SearchService.new.connection
      
      expect(connection).to be_a(Faraday::Connection)
      expect(connection.url_prefix.to_s).to eq("http://localhost:3000/api/v0")
    end
    

    it "gets URL, populating API records into JSON" do
      parsed_artists = SearchService.new.get_url(@uri)

      expect(parsed_artists[:data]).to be_an(Array)
      expect(parsed_artists[:data].first).to be_a(Hash)
      expect(parsed_artists[:data].first[:id]).to be_a(String)
      expect(parsed_artists[:data].first[:type]).to eq("artist")
      expect(parsed_artists[:data].first[:attributes]).to be_a(Hash)
    end

    it "finds all of the artists" do
      parsed_artists = SearchService.new.find_artists

      expect(parsed_artists[:data].first[:type]).to eq("artist")
      expect(parsed_artists[:data].first[:attributes]).to be_a(Hash)
      expect(parsed_artists[:data].first[:attributes][:name]).to eq("Tattoo artists")
      expect(parsed_artists[:data].first[:attributes][:location]).to eq("1400 U Street NW")
      expect(parsed_artists[:data].first[:attributes][:email]).to eq("tatart@gmail.com")
      expect(parsed_artists[:data].first[:attributes][:Identity]).to eq("LGBTQ+ Friendly")
      expect(parsed_artists[:data].first[:attributes][:password_digest]).to eq("unreadable hash")
    end

    it "verifies a user's login credentials and return the user data with correct status" do
      params = {
        sign_in: {
          email: "tatart@gmail.com",
          password: "12345",
          type: "Sign In as Artist"
        }
      }

      stub_request(:post, "http://localhost:3000/api/v0/sign_in").
      with(
        body: "{\"sign_in\":{\"email\":\"tatart@gmail.com\",\"password\":\"12345\",\"type\":\"Sign In as Artist\"}}",
        headers: {
       'Accept'=>'*/*',
       'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       'Content-Type'=>'application/json',
       'User-Agent'=>'Faraday v2.9.0'
        }).
      to_return(status: 200, body: "", headers: {})

      parsed_artists = SearchService.new.verify_artist_sign_in(params)
    end
  end
end