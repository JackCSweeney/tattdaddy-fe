require 'rails_helper'

RSpec.describe 'Create User', type: :feature do 
  describe 'As a Visitor' do    
    before(:each) do
      json_response_1 = File.read("spec/fixtures/user/user.json")
      stub_request(:post, "http://localhost:3000/api/v0/users")
        .to_return(status: 200, body: json_response_1)

      stub_request(:get, "http://localhost:3000/api/v0/users/25")
        .to_return(status: 200, body: json_response_1)

      json_response_2 = File.read("spec/fixtures/identities_list.json")
      stub_request(:get, "http://localhost:3000/api/v0/identities")
        .to_return(status: 200, body: json_response_2)

      json_response_3 = File.read("spec/fixtures/user/liked_tattoos.json")
      stub_request(:get, "http://localhost:3000/api/v0/tattoos?user=25")
        .to_return(status: 200, body: json_response_3)

      json_response_4 = File.read("spec/fixtures/user/create_user_identities.json")
      stub_request(:post, "http://localhost:3000/api/v0/user_identities")
        .to_return(status: 200, body: json_response_4)

      json_response_5 = File.read("spec/fixtures/user/single_user_identity.json")
      stub_request(:get, "http://localhost:3000/api/v0/users/25/identities")
        .to_return(status: 200, body: json_response_5)
    end

    it 'can vist the page to register a new user account and see the fields to fill in' do
      visit "users/new"
      
      expect(page).to have_field("name")
      expect(page).to have_field("email")
      expect(page).to have_field("email_confirmation")
      expect(page).to have_field("password")
      expect(page).to have_field("password_confirmation")
      expect(page).to have_field("identities[]")
      expect(page).to have_field("location")
      expect(page).to have_field("search_radius")
    end
    
    it 'can fill in the fields with valid information, create the account, and be brought to their new dashboard' do
      visit "/users/new"

      fill_in "name", with: "Ruby Gem"
      fill_in "email", with: "jesusa@spinka.test"
      fill_in "email_confirmation", with: "jesusa@spinka.test"
      fill_in "password", with: "password"
      fill_in "password_confirmation", with: "password"
      fill_in "location", with: "9705 Fishers District Dr, Fishers, IN 46037"
      fill_in "search_radius", with: 25
      check "None"

      click_on "Create New Account"
      
      expect(current_path).to eq("/users/25/dashboard")
      within first(".container") do
        within first(".text-center") do
          expect(page).to have_content("Ruby Gem's Dashboard")
        end
      end

      within first(".form-group") do
        expect(page).to have_field("location", with: "9705 Fishers District Dr, Fishers, IN 46037")
      end

      within("#2") do
        expect(page).to have_field("search_radius", with: 25)
      end  

      visit edit_user_path(25)
      
      expect(find_field("None")).to be_checked
      expect(find_field("Female")).to_not be_checked
      expect(find_field("Asian")).to_not be_checked
      expect(find_field("LGBTQ+")).to_not be_checked
    end
  end
end