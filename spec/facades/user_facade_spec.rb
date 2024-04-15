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
  
  describe ".liked_tattoos(user_id)" do
    it "returns all tattos a user has 'liked'" do
      json_response = File.read("spec/fixtures/user/liked_tattoos.json")
      
      stub_request(:get, "http://localhost:3000/api/v0/users/25/tattoos")
        .to_return(status: 200, body: json_response)
      
      liked_tattoos = UserFacade.liked_tattoos(25)
      
      expect(liked_tattoos).to be_an(Array)
      expect(liked_tattoos).to all(be_a(Tattoo))
    end
  end

  describe ".identity_preferences(user_id)" do
    it "returns user's preferences for artists' identities" do
      json_response = File.read("spec/fixtures/user/identity_prefs.json")

      stub_request(:get, "http://localhost:3000/api/v0/users/25/identities")
        .to_return(status: 200, body: json_response)

      identities = UserFacade.identity_preferences(25)
      
      expect(identities).to be_an(Array)
      expect(identities).to all(be_an(Identity))
    end
  end

  describe ".update_data_and_identities(user_id, updated_user_data, identity_changes)" do
    it "passes data to update data and update identity methods" do
      user_id = 25
      updated_user_data = {name: "Sean", location: "Canada"}
      identity_changes = {post: ["1", "2"], delete: ["3"]}

      expect(UserFacade).to receive(:update_user_data).with(25, {name: "Sean", location: "Canada"})
      expect(UserFacade).to receive(:update_user_identities).with(25, {post: ["1", "2"], delete: ["3"]})
      UserFacade.update_data_and_identities(user_id, updated_user_data, identity_changes)
    end
  end

  describe ".update_user_data(user_id, user_params)" do
    it "updates a user's information" do
      json_response = File.read("spec/fixtures/user/user.json")
      stub_request(:patch, "http://localhost:3000/api/v0/users/25")
        .to_return(status: 200, body: json_response)

      updated_user = UserFacade.update_user_data("25", {:name=>"Ruby Gem"})
      expect(updated_user).to be_a(Hash)
      expect(updated_user[:data][:type]).to eq("user")
      expect(updated_user[:data][:attributes][:name]).to eq("Ruby Gem")
    end
  end

  describe ".update_user_identities(user_id, identity_changes)" do
    it "adds or removes user/identity relationships" do
      stub_request(:post, "http://localhost:3000/api/v0/user_identities")
        .to_return(status: 200, body: '{"message": "Identity successfully added to User"}')

      stub_request(:delete, "http://localhost:3000/api/v0/user_identities")
        .with( body: {"{\"user_identity\":{\"user_id\":\"25\",\"identity_id\":\"1\"}}"=>nil})
        .to_return(status: 204)

      identity_changes = {post: ["2", "3"], delete: ["1"]}
      UserFacade.update_user_identities("25", identity_changes)

      expect(WebMock).to have_requested(:post, "http://localhost:3000/api/v0/user_identities").twice
      expect(WebMock).to have_requested(:delete, "http://localhost:3000/api/v0/user_identities").once
    end
  end

  describe ".create_user_tattoo(user_tattoo_data)" do
    it "user_tattoo created from user liking or disliking a tattoo" do
      stub_request(:post, "http://localhost:3000/api/v0/user_tattoos")
        .to_return(status: 200, body: '{"message": "Tattoo successfully added to User"}')
      
      user_tattoo_data = {
        user_id: "25",
        tattoo_id: "2",
        type: "like"
      }

      response = UserFacade.create_user_tattoo(user_tattoo_data)
      expect(response[:message]).to eq("Tattoo successfully added to User")
    end
  end

  describe ".delete_user_tattoo" do
    it "deletes user_tattoo if user 'removes' a liked tattoo" do
      stub_request(:delete, "http://localhost:3000/api/v0/user_tattoos")
        .to_return(status: 204)

      user_id = "25",
      tattoo_id = "2"

      response = UserFacade.delete_user_tattoo(user_id, tattoo_id)
      expect(response.status).to eq(204)
    end
  end

  describe ".delete_user(user_id)" do
    it "deletes a user's account" do
      stub_request(:delete, "http://localhost:3000/api/v0/users/25")
        .to_return(status: 204)

      response = UserFacade.delete_user(25)
      expect(response.status).to eq(204)
    end
  end
end