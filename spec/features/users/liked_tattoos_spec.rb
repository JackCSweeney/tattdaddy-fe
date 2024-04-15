require "rails_helper"

RSpec.describe "Liked Tattoos Page", type: :feature do
  describe "As a logged-in user" do

    before do
      json_response = File.read("spec/fixtures/user/liked_tattoos.json")

      stub_request(:get, "http://localhost:3000/api/v0/users/25/tattoos")
        .to_return(status: 200, body: json_response)

      visit user_tattoos_path(user_id: 25)
    end

    it "displays all tattoos user has 'liked'" do
      expect(page).to have_css("img", count: 5)
      expect(page).to have_content("Cost:", count: 5)
      expect(page).to have_content("Duration:", count: 5)
      expect(page).to have_content("Distance:", count: 5)
    end

    it "has option to 'remove' a liked tattoo" do
      expect(page).to have_button("Remove", count: 5)
      click_on "Remove", match: :first
      expect(current_path).to eq(user_tattoos_path(user_id: 25))
    end

    it "has option to 'Schedule Appointment' under each tattoo" do
      expect(page).to have_button("Schedule Appointment", count: 5)
    end
  end
end