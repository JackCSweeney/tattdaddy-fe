require 'rails_helper'

RSpec.describe 'Artist Dashboard Page', type: :feature do
  describe 'As a logged-in artist' do
    before do
      json_response_1 = File.read("spec/fixtures/artist/artist.json")
      json_response_2 = File.read("spec/fixtures/artist/artist_tattoos.json")

      stub_request(:get, "http://localhost:3000/api/v0/artists/5")
        .to_return(status: 200, body: json_response_1)
      stub_request(:get, "http://localhost:3000/api/v0/artists/5/tattoos")
        .to_return(status: 200, body: json_response_2)

      visit artist_dashboard_path(artist_id: 5)
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

      it "view 'Appointments'" do
        expect(page).to have_link("Appointments")
        click_on "Appointments"

        expect(current_path).to eq(artist_appointments_path(artist_id: 5))
      end

      it "view 'Add a new Tattoo'" do
        within ".artist_dashboard_tattoos" do
          expect(page).to have_button("Add New Tattoo")
          click_on "Add New Tattoo"
        end

        expect(current_path).to eq(new_artist_tattoo_path(artist_id: 5))
      end
    end

    describe "displays tattoos the artist uploaded" do
      it "with each tattoo's info" do
        within ".artist_dashboard_tattoos" do
          within "#tattoo-5" do
            expect(page).to have_css("img")
            expect(page).to have_content("Price:")
            expect(page).to have_content("Duration:")
          end
        end
      end

      it "with the option to 'edit' each tattoo" do
        within ".artist_dashboard_tattoos" do
          within "#tattoo-5" do
            expect(page).to have_link("Edit")
          end
        end
      end

      it "with the option to 'delete' each tattoo" do
        within ".artist_dashboard_tattoos" do
          within "#tattoo-5" do
            expect(page).to have_link("Delete")
          end
        end
      end
    end
  end
end