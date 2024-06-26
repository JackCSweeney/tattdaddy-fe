require 'rails_helper'

RSpec.describe 'Artist Dashboard Page', type: :feature do
  describe 'As a logged-in artist' do
    before do
      json_response_1 = File.read("spec/fixtures/artist/artist.json")
      json_response_2 = File.read("spec/fixtures/artist/artist_tattoos.json")
      json_response_3 = File.read("spec/fixtures/sessions/successful_artist_sign_in.json")

      stub_request(:get, "http://localhost:3000/api/v0/artists/5")
        .to_return(status: 200, body: json_response_1)
      stub_request(:get, "http://localhost:3000/api/v0/artists/5/tattoos")
        .to_return(status: 200, body: json_response_2)

      stub_request(:delete, "http://localhost:3000/api/v0/tattoos/5")
        .to_return(status: 204)
      
      json_response = File.read("spec/fixtures/artist/tat.json")  
      stub_request(:get, "http://localhost:3000/api/v0/tattoos/5")
        .to_return(status: 200, body: json_response)

      stub_request(:post, "http://localhost:3000/api/v0/sign_in")
        .to_return(status: 200, body: json_response_3)

        visit root_path
        expect(page).to have_button("Sign In as Artist")
          fill_in "Email", with: "tatart@gmail.com"
          fill_in "Password", with: "password"
          click_on "Sign In as Artist"
      visit artist_dashboard_path(artist_id: 5)
    end

    describe "displays links to" do
      it "view 'Sign Out'" do
        expect(page).to have_button("Sign Out")
        click_on "Sign Out"

        expect(current_path).to eq(root_path)
      end

      it "view 'My Profile'" do
        json_response = File.read("spec/fixtures/artist/identities.json")
        stub_request(:get, "http://localhost:3000/api/v0/artists/5/identities")
          .to_return(status: 200, body: json_response)
        
        expect(page).to have_link("My Profile")
        click_on "My Profile"

        expect(current_path).to eq(artist_path(id: 5))
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
            click_on "Edit"
            expect(current_path).to eq(edit_artist_tattoo_path(artist_id: 5, id: 5))
          end
        end
      end

      describe "with the option to 'delete' each tattoo" do
        it "when clicked, it redirects to artist dashboard and the deleted tattoo is no longer there" do
          within ".artist_dashboard_tattoos" do
            within "#tattoo-5" do
              click_on "Delete"
            end
            expect(current_path).to eq(artist_dashboard_path(artist_id: 5))

            expect(page).not_to have_content("#tattoo-5")
          end
        end
      end
    end
  end
end