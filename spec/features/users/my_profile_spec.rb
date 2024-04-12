require "rails_helper"

RSpec.describe "User's My Profile Page", type: :feature do
  describe "As a logged-in user" do

    before do
      json_response_1 = File.read("spec/fixtures/user/user.json")
      json_response_2 = File.read("spec/fixtures/user/identity_prefs.json")
      # json_response_2 = File.read("spec/fixtures/user/dashboard_tattoos.json")

      stub_request(:get, "http://localhost:3000/api/v0/users/25")
        .to_return(status: 200, body: json_response_1)
      stub_request(:get, "http://localhost:3000/api/v0/users/25/identities")
        .to_return(status: 200, body: json_response_2)

      visit user_path(id: 25)
    end

    it "displays user's current information" do
      expect(page).to have_content("Name: Ruby Gem")
      expect(page).to have_content("Email: jesusa@spinka.test")
      expect(page).to have_content("Location: 9705 Fishers District Dr, Fishers, IN 46037")
      expect(page).to have_content("Search Radius: 25 miles")

      within ".identity_pref" do
        expect(page).to have_content("I would like to support artists who are:")
        expect(page).to have_content("Female")
        expect(page).to have_content("Asian")
        expect(page).to_not have_content("None")
      end
    end

    describe "displays links to" do
      it "return to dashboard" do
        json_response_1 = File.read("spec/fixtures/user/user.json")
        json_response_2 = File.read("spec/fixtures/user/dashboard_tattoos.json")

        stub_request(:get, "http://localhost:3000/api/v0/users/25")
          .to_return(status: 200, body: json_response_1)
        stub_request(:get, "http://localhost:3000/api/v0/tattoos?user=25")
          .to_return(status: 200, body: json_response_2)

        expect(page).to have_link("Dashboard")
        click_on "Dashboard"

        expect(current_path).to eq(user_dashboard_path(user_id: 25))
      end

      it "delete user's account" do
        expect(page).to have_link("Delete Account")
        click_on "Delete Account"

        expect(current_path).to eq(root_path)
        expect(page).to have_content("User account successfully deleted")
      end
    end

    it "'Edit Profile' button to update account"  do
      expect(page).to have_button("Edit Profile")
      click_on "Edit Profile"

      expect(current_path).to eq(edit_user_path(id: 25))
    end
  end
end