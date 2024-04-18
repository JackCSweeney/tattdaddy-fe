require "rails_helper"

RSpec.describe "User's My Profile Page", type: :feature do
  describe "As a logged-in user" do

    before do
      json_response_1 = File.read("spec/fixtures/user/user.json")
      json_response_2 = File.read("spec/fixtures/user/identity_prefs.json")
      json_response_3 = File.read("spec/fixtures/user/dashboard_tattoos.json")
      json_response_4 = File.read("spec/fixtures/sessions/successful_user_sign_in.json")

      stub_request(:get, "http://localhost:3000/api/v0/users/25")
        .to_return(status: 200, body: json_response_1)
      stub_request(:get, "http://localhost:3000/api/v0/users/25/identities")
        .to_return(status: 200, body: json_response_2)
      stub_request(:get, "http://localhost:3000/api/v0/tattoos?user=25")
        .to_return(status: 200, body: json_response_3)
      stub_request(:post, "http://localhost:3000/api/v0/sign_in")
        .to_return(status: 200, body: json_response_4)
        
        visit root_path
          expect(page).to have_button("Sign In as User")
          fill_in "Email", with: "jesusa@spinka.test"
          fill_in "Password", with: "123Password"
          click_on "Sign In as User"

      visit user_path(id: 25)
    end

    it "displays user's current information" do
      within "#user_info" do
       expect(page).to have_content("Name: Ruby Gem")
       expect(page).to have_content("Email: jesusa@spinka.test")
       expect(page).to have_content("Location: 9705 Fishers District Dr, Fishers, IN 46037")
       expect(page).to have_content("Search Radius: 25 miles")
      end

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
       
        stub_request(:get, "http://localhost:3000/api/v0/users/25")
          .to_return(status: 200, body: json_response_1)
        
        visit user_path(id: 25)

        expect(page).to have_link("Dashboard")
        click_on "Dashboard"

        expect(current_path).to eq(user_dashboard_path(user_id: 25))
      end
    end

    describe "displays buttons to" do
      it "delete user's account" do
        stub_request(:delete, "http://localhost:3000/api/v0/users/25")
        .to_return(status: 204)
        
        expect(page).to have_button("Delete Account")
        click_on "Delete Account"

        expect(current_path).to eq(root_path)
        within "#mainBody" do
          expect(page).to have_content("User account successfully deleted")
        end
      end
    end

    it "'Edit Profile' button to update account"  do
      json_response_3 = File.read("spec/fixtures/identities_list.json")
      stub_request(:get, "http://localhost:3000/api/v0/identities")
        .to_return(status: 200, body: json_response_3)

      expect(page).to have_button("Edit Profile")
      click_on "Edit Profile"

      expect(current_path).to eq(edit_user_path(id: 25))
    end
  end
end