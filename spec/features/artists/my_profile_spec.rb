require "rails_helper"

RSpec.describe "Artist's My Profile Page", type: :feature do
  describe "As a logged-in artist" do

    before do
      json_response_1 = File.read("spec/fixtures/artist/artist.json")
      json_response_2 = File.read("spec/fixtures/artist/identities.json")

      stub_request(:get, "http://localhost:3000/api/v0/artists/5")
        .to_return(status: 200, body: json_response_1)
      stub_request(:get, "http://localhost:3000/api/v0/artists/5/identities")
        .to_return(status: 200, body: json_response_2)

      visit artist_path(id: 5)
    end

    it "displays artist's current information" do
      within ".artist_info" do
        expect(page).to have_content("Name: Tattoo artists")
        expect(page).to have_content("Email: tatart@gmail.com")
        expect(page).to have_content("Location: 1400 U Street NW, Washington, DC 20009")
      end

      within ".artist_identities" do
        expect(page).to have_content("I identify as:")
        expect(page).to have_content("LGBTQ+")
        expect(page).to have_content("Black")
        expect(page).to_not have_content("Native American")
        expect(page).to_not have_content("None")
      end
    end

    describe "displays links to" do
      it "return to dashboard" do
        json_response_1 = File.read("spec/fixtures/artist/artist.json")
        json_response_2 = File.read("spec/fixtures/artist/artist_tattoos.json")
  
        stub_request(:get, "http://localhost:3000/api/v0/artists/5")
          .to_return(status: 200, body: json_response_1)
        stub_request(:get, "http://localhost:3000/api/v0/artists/5/tattoos")
          .to_return(status: 200, body: json_response_2)

        expect(page).to have_link("Dashboard")
        click_on "Dashboard"

        expect(current_path).to eq(artist_dashboard_path(artist_id: 5))
      end
    end
    
    describe "displays buttons to" do
      it "delete artist's account" do
        stub_request(:delete, "http://localhost:3000/api/v0/artists/5")
        .to_return(status: 204)
        
        expect(page).to have_button("Delete Account")
        click_on "Delete Account"

        expect(current_path).to eq(root_path)
        within "#mainBody" do
         expect(page).to have_content("Artist account successfully deleted")
        end
      end
    end

    it "'Edit Profile' button to update account"  do
      json_response_3 = File.read("spec/fixtures/identities_list.json")
      stub_request(:get, "http://localhost:3000/api/v0/identities")
        .to_return(status: 200, body: json_response_3)

      expect(page).to have_button("Edit Profile")
      click_on "Edit Profile"

      expect(current_path).to eq(edit_artist_path(id: 5))
    end
  end
end