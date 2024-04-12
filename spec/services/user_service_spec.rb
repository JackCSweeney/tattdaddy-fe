require "rails_helper"

RSpec.describe UserService do
  describe ".user_data(user_id)" do
    it "returns a user's data given the user's id" do
      json_response = File.read("spec/fixtures/user/user.json")

      stub_request(:get, "http://localhost:3000/api/v0/users/25")
        .to_return(status: 200, body: json_response)

      user = UserService.user_data(25)

      expect(user).to be_a(Hash)
      expect(user[:data]).to be_a(Hash)
      expect(user[:data][:type]).to eq("user")
    end
  end

  describe ".dashboard_tattoos(user_id)" do
    it "returns tattoo search results based on a user's preferences" do
      json_response = File.read("spec/fixtures/user/dashboard_tattoos.json")

      stub_request(:get, "http://localhost:3000/api/v0/tattoos?user=25")
        .to_return(status: 200, body: json_response)

      user_dashboard_tattoos = UserService.dashboard_tattoos(25)

      expect(user_dashboard_tattoos).to be_a(Hash)
      expect(user_dashboard_tattoos[:data]).to be_an(Array)
      expect(user_dashboard_tattoos[:data].size).to eq(15)
      expect(user_dashboard_tattoos[:data]).to all(be_a(Hash))
      expect(user_dashboard_tattoos[:data]).to all(include(type: "tattoos"))
    end
  end

  describe ".get_liked_tattoos(user_id)" do
    it "returns all tattoos that a user has 'liked'" do
      json_response = File.read("spec/fixtures/user/liked_tattoos.json")

      stub_request(:get, "http://localhost:3000/api/v0/users/25/tattoos")
        .to_return(status: 200, body: json_response)

      liked_tattoos = UserService.get_liked_tattoos(25)

      expect(liked_tattoos).to be_a(Hash)
      expect(liked_tattoos[:data]).to be_an(Array)
      expect(liked_tattoos[:data].size).to eq(5)
      expect(liked_tattoos[:data]).to all(be_a(Hash))
      expect(liked_tattoos[:data]).to all(include(type: "tattoos"))
    end
  end
end