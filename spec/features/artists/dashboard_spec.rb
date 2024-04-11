require 'rails_helper'

RSpec.describe 'Artist Dashboard Page', type: :feature do
  describe 'As a logged-in artist' do
    before do
      json_response_1 = File.read("spec/fixtures/artist/artist.json")
      json_response_2 = File.read("spec/fixtures/artist/tattoos.json")

      stub_request(:get, "http://localhost:3000/api/v0/artists/13")
        .to_return(status: 200, body: json_response_1)
      stub_request(:get, "http://localhost:3000/api/v0/tattoos?artist=13")
        .to_return(status: 200, body: json_response_2)

      visit artist_dashboard_path(artist_id: 13)
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

        expect(current_path).to eq(artist_path(id: 13))
      end

      it "view 'Appointments'" do
        expect(page).to have_link("Appointments")
        click_on "Appointments"
        
        expect(current_path).to eq(artist_appointments_path(artist_id: 13))
      end
      
      it "view 'Add a new Tattoo'" do
        expect(page).to have_link("Add a new Tattoo")
        click_on "Add a new Tattoo"
        
        expect(current_path).to eq(artist_tattoos_path(artist_id: 13))
      end
    end

    describe "displays tattoos the artist uploaded" do
      it "with each tattoo's info" do
        within ".artist_dashboard_tattoos" do
          expect(page).to have_css("img", count: 15)
          expect(page).to have_content("Price:", count: 15)
          expect(page).to have_content("Time:", count: 15)
        end
      end

      it "with the option to 'edit' a tattoo" do
        within ".artist_dashboard_tattoos" do
          expect(page).to have_button("Edit", count: 15)
        end
      end

      it "with the option to 'delete' a tattoo" do
        within ".artist_dashboard_tattoos" do
          expect(page).to have_button("Delete", count: 15)
        end
      end

      it "with the option to schedule an apointment for a tattoo" do
        within ".user_dashboard_tattoos" do
          expect(page).to have_button("Schedule Appointment", count: 15)
        end
      end
    end
  end
end