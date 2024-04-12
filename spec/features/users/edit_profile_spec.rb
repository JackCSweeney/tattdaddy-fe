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

      visit edit_user_path(id: 25)
    end

    describe "shows a form to update user's" do
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
        end
      end
    end
  end
end