require 'rails_helper'

RSpec.describe 'Tattoos New Page', type: :feature do
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

        allow_any_instance_of(ArtistService).to receive(:post_url).with("/api/v0/tattoos", attributes)
          .and_return(status: 200, body: "")

      visit new_artist_tattoo_path(artist_id: 5)
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

    describe "the form to create a new tattoo " do
      it "has a price, time and image field" do
        expect(page).to have_field('Price')
        expect(page).to have_field('Time estimate')
        expect(page).to have_field('Img file')
      end

      it "when I fill the form correctly, upload an image and submit it takes me to the artist dashboard" do
        fill_in "Price", with: "50"
        fill_in "Time estimate", with: "2"
        attach_file "Img file", 'app/assets/images/bronto.jpeg'
        click_button "Save"

        expect(current_path).to eq(artist_dashboard_path(artist_id: 5))
        expect(page).to have_text("Tattoo created successfully")
      end

      it "handles sad path on form fields and sends back to new form" do
        fill_in "Price", with: "a"
        fill_in "Time estimate", with: 2
        attach_file "Img file", Rails.root.join('app/assets/images/', 'bronto.jpeg')
        click_button "Save"

        expect(current_path).to eq(new_artist_tattoo_path(artist_id: 5))
        expect(page).to have_text("Tattoo could not be uploaded")
      end
    end
  end
end