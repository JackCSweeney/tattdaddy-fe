require 'rails_helper'

RSpec.describe 'Tattoos Edit Page', type: :feature do
  describe 'As a logged-in artist' do
    before do
      json_response_0 = File.read("spec/fixtures/artist/artist.json")
      stub_request(:get, "http://localhost:3000/api/v0/artists/5")
        .to_return(status: 200, body: json_response_0)

      @json_response_1 = File.read("spec/fixtures/artist/artist_tattoos_2.json")
      
      @json_response_2 = File.read("spec/fixtures/artist/tattoo_incorrect.json")
      
      @json_response_3 = File.read("spec/fixtures/artist/tattoo_2.json")

      @json_response_4 = File.read("spec/fixtures/artist/tat.json")  
      
      stub_request(:get, "http://localhost:3000/api/v0/tattoos/2")
        .to_return(status: 200, body: @json_response_4)

      stub_request(:get, "http://localhost:3000/api/v0/tattoos/5")
        .to_return(status: 200, body: @json_response_3)

      stub_request(:patch, "http://localhost:3000/api/v0/tattoos/5")
        .to_return(status: 200, body: @json_response_3) 
      
      stub_request(:get, "http://localhost:3000/api/v0/artists/5/tattoos")
        .to_return(status: 200, body: @json_response_1)

      allow_any_instance_of(ActiveStorage::Blob).to receive(:url)
        .and_return("app/assets/images/bronto.jpeg")
    
      visit edit_artist_tattoo_path(artist_id: 5, id: 2)
    end

    describe "displays links to" do
      it "view 'Sign Out'" do
        expect(page).to have_button("Sign Out")
        click_on "Sign Out"

        expect(current_path).to eq(root_path)
      end

      it "view 'My Profile'" do
        expect(page).to have_link("My Profile")
        
        json_response_identities = File.read("spec/fixtures/artist/identities.json")  
        stub_request(:get, "http://localhost:3000/api/v0/artists/5/identities")
        .to_return(status: 200, body: json_response_identities)
        
        click_on "My Profile"
        expect(current_path).to eq(artist_path(id: 5))
      end
    end

    describe "the form to edit a new tattoo " do
      it "has a price, time and image_file fields" do
        expect(page).to have_field('Price')
        expect(page).to have_field('Time estimate')
        expect(page).to have_content('Upload New Image')
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
        fill_in "Time estimate", with: "60"
        click_button "Save"
        expect(current_path).to eq(artist_dashboard_path(artist_id: 5))
        
        expect(page).to have_text("Tattoo updated successfully")
        within ".artist_dashboard_tattoos" do
          within "#tattoo-2" do
            expect(page).to have_content("60")
          end
        end
      end

      it "successfully updates tattoo's url locally and in WS3" do
        old_tattoo = ArtistFacade.new.find_tattoo("2")
        old_blob = ActiveStorage::Blob.find_by(key: old_tattoo.image_url)
        
        attributes = {artist_id: "5", image_url: "app/assets/images/bronto.jpeg", price: "50", time_estimate: "2"}
        
        allow_any_instance_of(ArtistService).to receive(:post_url).with("/api/v0/tattoos", attributes)
          .and_return(status: 200, body: "")
        
        attach_file "img_file", 'app/assets/images/bronto.jpeg'
        click_button "Save"

        new_tattoo = ArtistFacade.new.find_tattoo("5")
        new_blob = ActiveStorage::Blob.find_by(key: new_tattoo.image_url)

        expect(old_blob).to be(nil)
      end

      it "handles sad path on form fields and sends back to edit form" do
        json_response_0 = File.read("spec/fixtures/artist/tattoo_incorrect.json")
        stub_request(:patch, "http://localhost:3000/api/v0/tattoos/2")
          .to_return(status: 404, body: json_response_0)

        stub_request(:patch, "http://localhost:3000/api/v0/tattoos/5")
          .to_return(status: 404, body: json_response_0)

        fill_in "Price", with: "a"
        fill_in "Time estimate", with: 2
        click_button "Save"

        expect(current_path).to eq(edit_artist_tattoo_path(artist_id: 5, id: 5))
        expect(page).to have_text("Tattoo could not be updated")
      end
    end
  end
end
