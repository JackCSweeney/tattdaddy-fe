require "rails_helper"

RSpec.describe "User's My Profile Page", type: :feature do
  describe "As a logged-in user" do

    before do
      json_response_1 = File.read("spec/fixtures/user/user.json")
      json_response_2 = File.read("spec/fixtures/user/dashboard_tattoos.json")

      stub_request(:get, "http://localhost:3000/api/v0/users/25")
        .to_return(status: 200, body: json_response_1)
      stub_request(:get, "http://localhost:3000/api/v0/tattoos?user=25")
        .to_return(status: 200, body: json_response_2)
      
      visit user_path(id: 25)
    end

    xit "displays user's current information" do
      
    end

    describe "displays links to" do
      xit "return to dashboard" do
  
      end

      xit "delete " do
        
      end
    end

    xit "'Edit Profile' button to "  do

    end
  end
end