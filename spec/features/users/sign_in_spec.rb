require 'rails_helper'

RSpec.describe "User Sign In" do
  describe 'As a User' do
    before(:each) do
      json_response_1 = File.read("spec/fixtures/sessions/successful_user_sign_in.json")
      json_response_2 = File.read("spec/fixtures/user/user.json")
      json_response_3 = File.read("spec/fixtures/user/dashboard_tattoos.json")

      stub_request(:post, "http://localhost:3000/api/v0/sign_in")
        .to_return(status: 200, body: json_response_1)
      stub_request(:get, "http://localhost:3000/api/v0/users/25")
        .to_return(status: 200, body: json_response_2)
      stub_request(:get, "http://localhost:3000/api/v0/tattoos?user=25")
        .to_return(status: 200, body: json_response_3)

      visit root_path
    end

    it 'can sign in' do
      within ".sign_in" do
        expect(page).to have_button("Sign In as User")
        fill_in "Email", with: "jesusa@spinka.test"
        fill_in "Password", with: "123Password"
        click_on "Sign In as User"
      end
      expect(current_path).to eq(user_dashboard_path(user_id: 25))
    end

    it 'can sign in when they have an artist account with the same email address' do
      json_response_1 = File.read("spec/fixtures/artist/artist_2.json")
      json_response_2 = File.read("spec/fixtures/user/dashboard_tattoos.json")
            

      stub_request(:get, "http://localhost:3000/api/v0/artists/1")
        .to_return(status: 200, body: json_response_1)
      stub_request(:get, "http://localhost:3000/api/v0/artists/1/tattoos")
        .to_return(status: 200, body: json_response_2)

        within ".sign_in" do
          expect(page).to have_button("Sign In as User")
          fill_in "Email", with: "jesusa@spinka.test"
          fill_in "Password", with: "123Password"
          click_on "Sign In as User"
        end
        expect(current_path).to eq(user_dashboard_path(user_id: 25))
    end
    it 'cannot go to dashboard when not signed in' do
      visit user_dashboard_path(user_id: 25)
      expect(current_path).to eq(root_path)

      expect(page).to have_content("You need to login")

    end
  end
end