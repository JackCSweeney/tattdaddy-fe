require 'rails_helper'

RSpec.describe 'Welcome Index Page', type: :feature do
  describe 'As a visitor displays' do
    before do
      visit root_path
    end

    describe "page heading" do
      it "Welcome to TattDaddy" do
        expect(page).to have_content("Welcome to\nTattDaddy")
      end
    end

    describe "Sign In form with" do
      it "email and password fields" do
        within ".sign_in" do
          expect(page).to have_field('Email')
          expect(page).to have_field('Password')
        end
      end

      describe "option to sign in as" do
        describe "a user" do
          scenario "valid credentials" do
            json_response = File.read("spec/fixtures/sessions/successful_user_sign_in.json")
            json_response_1 = File.read("spec/fixtures/user/user.json")
            json_response_2 = File.read("spec/fixtures/user/dashboard_tattoos.json")

            stub_request(:post, "http://localhost:3000/api/v0/sign_in")
              .to_return(status: 200, body: json_response)
              stub_request(:get, "http://localhost:3000/api/v0/users/25")
                .to_return(status: 200, body: json_response_1)
              stub_request(:get, "http://localhost:3000/api/v0/tattoos?user=25")
                .to_return(status: 200, body: json_response_2)

              within ".sign_in" do
                expect(page).to have_button("Sign In as User")
                fill_in "Email", with: "jesusa@spinka.test"
                fill_in "Password", with: "123Password"
                click_on "Sign In as User"
              end
              expect(current_path).to eq(user_dashboard_path(user_id: 25))
          end

          scenario "invalid credentials" do
            stub_request(:post, "http://localhost:3000/api/v0/sign_in")
              .to_return(status: 422, body: '{"error": "Invalid Parameters for Sign In"}')

              within ".sign_in" do
                expect(page).to have_button("Sign In as User")
                fill_in "Email", with: "jesusa@spinka.test"
                fill_in "Password", with: "wrong_password"
                click_on "Sign In as User"
              end

              expect(current_path).to eq(root_path)
              expect(page).to have_content('Invalid email/password combination')
          end
        end

        describe "an artist" do
          scenario "valid credentials" do
            json_resonse = File.read("spec/fixtures/sessions/successful_artist_sign_in1.json")
            json_response_1 = File.read("spec/fixtures/artist/artist.json")
            json_response_2 = File.read("spec/fixtures/user/dashboard_tattoos.json")
            # any other stubs needed for artist dashboard?

            stub_request(:post, "http://localhost:3000/api/v0/sign_in")
              .to_return(status: 200, body: json_resonse)
              stub_request(:get, "http://localhost:3000/api/v0/artists/1")
                .to_return(status: 200, body: json_response_1)
              stub_request(:get, "http://localhost:3000/api/v0/artists/1/tattoos")
                .to_return(status: 200, body: json_response_2)

              within ".sign_in" do
                expect(page).to have_button("Sign In as Artist")
                fill_in "Email", with: "darci@waters-mills.example"
                fill_in "Password", with: "123Password"
                click_on "Sign In as Artist"
              end

            expect(current_path).to eq(artist_dashboard_path(artist_id: 1))
          end

          scenario "invalid credentials" do
            stub_request(:post, "http://localhost:3000/api/v0/sign_in")
              .to_return(status: 422, body: '{"error": "Invalid Parameters for Sign In"}')

              within ".sign_in" do
                expect(page).to have_button("Sign In as Artist")
                fill_in "Email", with: "darci@waters-mills.example"
                fill_in "Password", with: "wrong_password"
                click_on "Sign In as Artist"
              end

              expect(current_path).to eq(root_path)
              expect(page).to have_content('Invalid email/password combination')
          end
        end
      end
    end

    describe "option to Create Account as" do
      it "a user" do
        expect(page).to have_link("Create User Account")
      end

      it "an artist" do
        expect(page).to have_link("Create Artist Account")
      end
    end
  end
end
