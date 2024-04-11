require "rails_helper"

RSpec.describe UserFacade do
  describe ".user_data(user_id)" do
    it "returns a user object given a user's id" do
      json_response = File.read("spec/fixtures/user/user.json")

      stub_request(:get, "http://localhost:3000/api/v0/users/25")
        .to_return(status: 200, body: json_response)

      user = UserFacade.user_data(25)
      
      expect(user).to be_a(User)
    end
  end

  describe ".dashboard_tattoos(user_id)" do
    it "returns tattoo objects matching a user's preferences" do
      json_response = File.read("spec/fixtures/user/dashboard_tattoos.json")

      stub_request(:get, "http://localhost:3000/api/v0/tattoos?user=25")
        .to_return(status: 200, body: json_response)

      tattoos = UserFacade.dashboard_tattoos(25)
      
      expect(tattoos).to be_an(Array)
      expect(tattoos).to all(be_a(Tattoo))
    end
  end
end