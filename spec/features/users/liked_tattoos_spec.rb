require "rails_helper"

RSpec.describe "User's Liked Tattoos Page", type: :feature do
  describe "As a logged-in user" do

    before do
      json_response_1 = File.read("spec/fixtures/user/user.json")
      json_response_2 = File.read("spec/fixtures/user/liked_tattoos.json")

      stub_request(:get, "http://localhost:3000/api/v0/users/25")
        .to_return(status: 200, body: json_response_1)
      stub_request(:get, "http://localhost:3000/api/v0/users/25/tattoos")
        .to_return(status: 200, body: json_response_2)

      visit user_tattoos_path(user_id: 25)
    end

    it "displays all tattoos user has 'liked'" do
      expect(page).to have_css("img", count: 5)
      within ".user-liked-tattoos" do
        expect(page).to have_content("Cost:", count: 5)
        expect(page).to have_content("Duration:", count: 5)
      end
    end

    it "has option to 'remove' a liked tattoo" do
      stub_request(:delete, "http://localhost:3000/api/v0/user_tattoos")
        .to_return(status: 204)

      expect(page).to have_button("Remove", count: 5)
      click_on "Remove", match: :first
      expect(current_path).to eq(user_tattoos_path(user_id: 25))
    end

    it "has option to 'Schedule Appointment' under each tattoo" do
      expect(page).to have_button("Schedule Appointment", count: 5)
    end
  end
end