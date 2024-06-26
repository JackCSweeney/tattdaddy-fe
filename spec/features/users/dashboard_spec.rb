require "rails_helper"

RSpec.describe "Dashboard Page", type: :feature do
  describe "As a logged-in user" do
    before do
      json_response_1 = File.read("spec/fixtures/user/user.json")
      json_response_2 = File.read("spec/fixtures/user/dashboard_tattoos.json")
      json_response_3 = File.read("spec/fixtures/sessions/successful_user_sign_in.json")


      stub_request(:get, "http://localhost:3000/api/v0/users/25")
        .to_return(status: 200, body: json_response_1)
      stub_request(:get, "http://localhost:3000/api/v0/tattoos?user=25")
        .to_return(status: 200, body: json_response_2)
        stub_request(:post, "http://localhost:3000/api/v0/sign_in")
        .to_return(status: 200, body: json_response_3)

      visit root_path
      expect(page).to have_button("Sign In as User")
        fill_in "Email", with: "jesusa@spinka.test"
        fill_in "Password", with: "123Password"
        click_on "Sign In as User"
      visit user_dashboard_path(user_id: 25)
    end

    describe "displays links to" do
      it "view 'My Profile'" do
        json_response_2 = File.read("spec/fixtures/user/identity_prefs.json")

        stub_request(:get, "http://localhost:3000/api/v0/users/25/identities")
          .to_return(status: 200, body: json_response_2)

        expect(page).to have_link("My Profile")
        click_on "My Profile"

        expect(current_path).to eq(user_path(id: 25))
      end

      it "view 'Liked Tattoos'" do
        json_response = File.read("spec/fixtures/user/liked_tattoos.json")
      
        stub_request(:get, "http://localhost:3000/api/v0/users/25/tattoos")
          .to_return(status: 200, body: json_response)

        expect(page).to have_link("Liked Tattoos")
        click_on "Liked Tattoos"
        
        expect(current_path).to eq(user_tattoos_path(user_id: 25))
      end

      it "view 'Sign Out'" do
        expect(page).to have_button("Sign Out")
        click_on "Sign Out"

        expect(current_path).to eq(root_path)
      end
    end

    describe "displays tattoos based on user's preferences" do
      it "with each tattoo's info" do
        within ".user_dashboard_tattoos" do
          expect(page).to have_css("img", count: 15)
          expect(page).to have_content("Cost:", count: 15)
          expect(page).to have_content("Duration:", count: 15)
        end
      end

      it "with the option to 'dislike' a tattoo" do
        stub_request(:post, "http://localhost:3000/api/v0/user_tattoos")
          .to_return(status: 200, body: '{"message": "Tattoo successfully added to User"}')

        within ".user_dashboard_tattoos" do
          expect(page).to have_button("Like", count: 15)
          click_on "Like", match: :first
          expect(current_path).to eq(user_dashboard_path(user_id: 25))
        end
      end

      it "with the option to 'like' a tattoo" do
        stub_request(:post, "http://localhost:3000/api/v0/user_tattoos")
          .to_return(status: 200, body: '{"message": "Tattoo successfully added to User"}')

        within ".user_dashboard_tattoos" do
          expect(page).to have_button("Dislike", count: 15)
          click_on "Dislike", match: :first
          expect(current_path).to eq(user_dashboard_path(user_id: 25))
        end
      end

      it "with the option to schedule an apointment for a tattoo" do
        within ".user_dashboard_tattoos" do
          expect(page).to have_link("Schedule Appointment", count: 15)
        end
      end
    end

    describe "displays forms to update" do
      it "user's location" do
        expect(page).to have_field("Current Location")
      end

      it "search radius" do
        expect(page).to have_field("Search Radius")
      end
    end
  end
end