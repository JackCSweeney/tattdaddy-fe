require 'rails_helper'

RSpec.describe "Create Artist Account" do
  describe 'As a Artist' do
    before(:each) do
      json_response_1 = File.read("spec/fixtures/artist/artist.json")
      stub_request(:post, "http://localhost:3000/api/v0/artists")
        .to_return(status: 200, body: json_response_1)
        
      stub_request(:get, "http://localhost:3000/api/v0/artists/5")
        .to_return(status: 200, body: json_response_1)

      json_response_2 = File.read("spec/fixtures/identities_list.json")
      stub_request(:get, "http://localhost:3000/api/v0/identities")
        .to_return(status: 200, body: json_response_2)


      json_response_3 = File.read("spec/fixtures/artist/artist_tattoos.json")
      stub_request(:get, "http://localhost:3000/api/v0/artists/5/tattoos")
        .to_return(status: 200, body: json_response_3)

      json_response_4 = File.read("spec/fixtures/artist/create_artist_identities.json")
      stub_request(:post, "http://localhost:3000/api/v0/artist_identities")
        .to_return(status: 200, body: json_response_4)
    end

    it 'can visit the page to see the form to create a new artist account' do
      visit "/artists/new"

      expect(page).to have_field("name")
      expect(page).to have_field("email")
      expect(page).to have_field("email_confirmation")
      expect(page).to have_field("password")
      expect(page).to have_field("password_confirmation")
      expect(page).to have_field("identities[]")
      expect(page).to have_field("location")
    end
    
    it 'can create a new account after filling in the form fields with valid info' do
      visit "/artists/new"
      fill_in "name", with: "Tattoo artists"
      fill_in "email", with: "tatart@gmail.com"
      fill_in "email_confirmation", with: "tatart@gmail.com"
      fill_in "password", with: "password"
      fill_in "password_confirmation", with: "password"
      fill_in "location", with: "1400 U Street NW, Washington, DC 20009"
      check "None"

      click_on "Create New Account"
      expect(current_path).to eq("/artists/5/dashboard")
    end
  end
end