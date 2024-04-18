require "rails_helper"

RSpec.describe "Edit User Account Page", type: :feature do
  describe "As a logged-in user" do
    before do
      json_response_1 = File.read("spec/fixtures/user/user.json")
      json_response_2 = File.read("spec/fixtures/user/identity_prefs.json")
      json_response_3 = File.read("spec/fixtures/identities_list.json")

      stub_request(:get, "http://localhost:3000/api/v0/users/25")
        .to_return(status: 200, body: json_response_1)
      stub_request(:get, "http://localhost:3000/api/v0/users/25/identities")
        .to_return(status: 200, body: json_response_2)
      stub_request(:get, "http://localhost:3000/api/v0/identities")
        .to_return(status: 200, body: json_response_3)
      stub_request(:patch, "http://localhost:3000/api/v0/users/25")
        .to_return(status: 200, body: json_response_1)
      stub_request(:post, "http://localhost:3000/api/v0/user_identities")
        .to_return(status: 200, body: '{"message": "Identity successfully added to User"}')


      visit edit_user_path(id: 25)
    end

    describe "shows a update profile form prefilled with user's" do
      it "name" do
        expect(page).to have_field("Name", with: "Ruby Gem")
      end

      it "email" do
        expect(page).to have_field("Email", with: "jesusa@spinka.test")
      end

      it "location" do
        expect(page).to have_field("Location", with: "9705 Fishers District Dr, Fishers, IN 46037")
      end

      it "search radius" do
        expect(page).to have_field("Search Radius", with: "25")
      end

      it "identity preferences" do
        within "fieldset" do
          expect(page).to have_content("I want to support artists who are")
          expect(page).to have_selector("input[type='checkbox']", count: 7)
          expect(find_field("Female")).to be_checked
          expect(find_field("Asian")).to be_checked
          expect(find_field("None")).to_not be_checked
          expect(find_field("LGBTQ+")).to_not be_checked
        end
      end
    end

    describe "redirects submitted update form to My Profile" do
      before do
        stub_request(:delete, "http://localhost:3000/api/v0/user_identities")
          .with( body: {"{\"user_identity\":{\"user_id\":\"25\",\"identity_id\":\"6\"}}"=>nil})
          .to_return(status: 204)

      end
      it "updated info appears on My Profile" do
        fill_in :name, with: "Going to the Gem"
        fill_in :email, with: "wonder@wall.com"
        fill_in "Location", with: "412 Delaware St, Kansas City, MO 64105"
        page.check("Latino")
        page.uncheck("Asian")
        click_on "Save Changes"

        expect(current_path).to eq(user_path(id: 25))
        within "#mainBody" do
          expect(page).to have_content("Profile updated successfully")
        end
      end

      xit "all fields must be completed" do
        fill_in "Name", with: ""
        fill_in "Email", with: ""
        fill_in "Location", with: ""
        fill_in "Search Radius", with: ""
        uncheck "LGBTQ+"
        uncheck "Asian"
        click_on "Save Changes"

        expect(current_path).to eq(edit_user_path(id: 25))
        expect(page).to have_content("All fields must be completed")
      end
    end
  end
end