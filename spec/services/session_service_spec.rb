require "rails_helper"

RSpec.describe SessionService do
  describe "authenticate(sign_in_credentials)" do
    it "returns user's id if valid sign_in credentials given" do
      json_response = File.read("spec/fixtures/sessions/successful_user_sign_in.json")
      sign_in_credentials = {
        sign_in: {
          email: "jesusa@spinka.test",
          password: "123Password",
          type: "Sign In as User"
        }
      }

      stub_request(:post, "http://localhost:3000/api/v0/sign_in")
        .to_return(status: 200, body: json_response)

      response = SessionService.authenticate(sign_in_credentials)

      expect(response).to be_a(Hash)
      expect(response[:data]).to be_a(Hash)
      expect(response[:data][:id]).to eq(25)
      expect(response[:data][:type]).to eq("user")
    end

    it "returns artist's id if valid sign_in credentials given" do
      json_response = File.read("spec/fixtures/sessions/successful_artist_sign_in1.json")
      sign_in_credentials = {
        sign_in: {
          email: "darci@waters-mills.example",
          password: "123Password",
          type: "Sign In as Artist"
        }
      }

      stub_request(:post, "http://localhost:3000/api/v0/sign_in")
        .to_return(status: 200, body: json_response)

      response = SessionService.authenticate(sign_in_credentials)

      expect(response).to be_a(Hash)
      expect(response[:data]).to be_a(Hash)
      expect(response[:data][:id]).to eq(1)
      expect(response[:data][:type]).to eq("artist")
    end

    it "returns error message if invalid artist or user credentials given" do
      incorrect_user_credentials = {
        sign_in: {
          email: "jesusa@spinka.test",
          password: "Wrong_Password",
          type: "Sign In as User"
        }
      }

      incorrect_artist_credentials = {
        sign_in: {
          email: "darci@waters-mills.example",
          password: "Wrong_Password",
          type: "Sign In as Artist"
        }
      }

      stub_request(:post, "http://localhost:3000/api/v0/sign_in")
        .to_return(status: 422, body: '{"error": "Invalid Parameters for Sign In"}')

      response = SessionService.authenticate(incorrect_user_credentials)
      expect(response).to be_a(Hash)
      expect(response[:error]).to eq("Invalid Parameters for Sign In")

      response = SessionService.authenticate(incorrect_artist_credentials)
      expect(response).to be_a(Hash)
      expect(response[:error]).to eq("Invalid Parameters for Sign In")
    end
  end
end