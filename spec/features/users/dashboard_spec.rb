require "rails_helper"

RSpec.describe "Dashboard Page", type: :feature do
  describe "As a logged-in user" do
    before do
      json_response_1 = File.read("spec/fixtures/user/user.json")
      json_response_2 = File.read("spec/fixtures/user/dashboard_tattoos.json")

      stub_request(:get, "http://localhost:3000/api/v0/users/25")
        .to_return(status: 200, body: json_response_1)
      stub_request(:get, "http://localhost:3000/api/v0/tattoos?user=25")
        .to_return(status: 200, body: json_response_2)

      user_dashboard_path(user_id: 25)
    end

    describe "displays links to" do
      it "view 'My Profile'" do
        save_and_open_page
        expect(page).to have_link("My Profile")
        click on "My Profile"

        expect(current_path).to eq(user_path(id: 25))
      end

      it "view 'Liked Tattoos'" do
        expect(page).to have_link("Liked Tattoos")
        click on "Liked Tattoos"
        
        expect(current_path).to eq(user_tattoos_path(id: 25))
      end

      it "view 'Appointments'" do
        expect(page).to have_link("Appointments")
        click on "Appointments"

        expect(current_path).to eq(user_appointments_path(id: 25))
      end

      it "view 'Sign Out'" do
        expect(page).to have_link("Sign Out")
        click on "Sign Out"

        expect(current_path).to eq(root_path)
      end
    end

    describe "displays tattoos based on user's preferences" do
      it "with each tattoo's info" do
        within ".user_tattoo_options" do
          expect(page).to have_css("img", count: 15)
          expect(page).to have_content("Cost:", count: 15)
          expect(page).to have_content("Time:", count: 15)
          expect(page).to have_content("Distance:", count: 15)
        end
      end

      it "with the option to 'dislike' a tattoo" do
        within ".user_tattoo_options" do
          expect(page).to have_button("Like", count: 15)
        end
      end

      it "with the option to 'like' a tattoo" do
        within ".user_tattoo_options" do
          expect(page).to have_button("Dislike", count: 15)
        end
      end

      it "with the option to schedule an apointment for a tattoo" do
        within ".user_tattoo_options" do
          expect(page).to have_button("Schedule Appointment", count: 15)
        end
      end
    end

    describe "displays forms to update" do
      it "user's location" do
        expect(page).to have_field("Location")
      end

      it "search radius" do
        expect(page).to have_field("Search Radius")
      end
    end
  end
end