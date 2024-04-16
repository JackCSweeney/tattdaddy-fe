require 'rails_helper'

RSpec.describe 'Tattoos Edit Page', type: :feature do
  describe 'As a logged-in artist' do
    before do
      json_response_1 = File.read("spec/fixtures/artist/artist.json")
      json_response_2 = File.read("spec/fixtures/artist/artist_tattoos.json")

      stub_request(:get, "http://localhost:3000/api/v0/artists/5")
        .to_return(status: 200, body: json_response_1)
      stub_request(:get, "http://localhost:3000/api/v0/artists/5/tattoos")
        .to_return(status: 200, body: json_response_2)

        attributes = {artist_id: "5", image_url: "app/assets/images/bronto.jpeg", price: "50", time_estimate: "2"}
      
        allow_any_instance_of(ActiveStorage::Blob).to receive(:url)
        .and_return("app/assets/images/bronto.jpeg")

        allow_any_instance_of(ArtistService).to receive(:update_tattoo).with("2", attributes)
          .and_return(status: 200, body: "")

      visit edit_artist_tattoo_path(artist_id: 5, id: 2)
    end

    describe "displays links to" do
      it "view 'Sign Out'" do
        expect(page).to have_link("Sign Out")
        click_on "Sign Out"

        expect(current_path).to eq(root_path)
      end

      it "view 'My Profile'" do
        expect(page).to have_link("My Profile")
        click_on "My Profile"

        expect(current_path).to eq(artist_path(id: 5))
      end
    end

    describe "the form to edit a new tattoo " do
      it "has a price and time fields all" do
        expect(page).to have_field('Price')
        expect(page).to have_field('Time estimate')
      end

      it "successfully updates tattoo's price" do
        fill_in "Price", with: "200"
        click_button "Save"
        expect(current_path).to eq(artist_dashboard_path(artist_id: 5))
        
        expect(page).to have_text("Tattoo updated successfully")
        within ".artist_dashboard_tattoos" do
          within "#tattoo-2" do
            expect(page).to have_content("200")
          end
        end
      end

      it "successfully updates tattoo's estimated time" do
        fill_in "Time estimate", with: "1"
        click_button "Save"
        expect(current_path).to eq(artist_dashboard_path(artist_id: 5))
        
        expect(page).to have_text("Tattoo updated successfully")
        within ".artist_dashboard_tattoos" do
          within "#tattoo-2" do
            expect(page).to have_content("1")
          end
        end
      end

      it "handles sad path on form fields and sends back to edit form" do
        fill_in "Price", with: "a"
        fill_in "Time estimate", with: 2
        click_button "Save"

        expect(current_path).to eq(edit_artist_tattoo_path(artist_id: 5, id: 2))
        expect(page).to have_text("Tattoo could not be edited")
      end
    end
  end
end
