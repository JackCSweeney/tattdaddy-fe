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
        it "as a user" do
          within ".sign_in" do
            expect(page).to have_button("Sign In as User")
          end
        end

        it "as an artist" do
          within ".sign_in" do
            expect(page).to have_button("Sign In as Artist")
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

  describe 'As an artist' do
    before do
      allow_any_instance_of(SearchService).to receive(:get_url).with("artists").and_return(
        {
          data: [
            {
              id: "322458",
              type: "artist",
              attributes: {
                name: "Tattoo artists",
                location: "1400 U Street NW",
                email: "tatart@gmail.com",
                Identity: "LGBTQ+ Friendly",
                password_digest: "c9wkrdrXdi/tpSPYNb+S3TIHQC+NnaTU/suyBCoxFjlBbRN30gL/WnC7k/L3nrSapm+vGpA0euRTry0Pnl5kUv02ro4ITg==--OQ456WGGpCuAf8ss--LnGEQSJGWhidXOH2nDQgWw=="
              }
            },
            {
              id: "322459",
              type: "artist",
              attributes: {
                name: "Tattoo Pot",
                location: "54541 Street CO",
                email: "tatpot@gmail.com",
                Identity: "LGBTQ+ Friendly",
                password_digest: "4Fry+l2HrBRdpJveWE5iApnMxeJXXkuqSRwbN40/oyDe5bIvSvC+nqXGee2zGFeCZm8JDiOVowNq0u/+yUWqkRcLnrI=--nUQTxqVuqxfE1jJ3--j1oYhY/+evkKCyU8udWhkQ=="
              }
            }
          ]
        }
      )
      data = {
            id: "322458",
            name: "Tattoo artists",
            location: "1400 U Street NW",
            email: "tatart@gmail.com",
            identity: "LGBTQ+ Friendly",
            password_digest: "123"
            }
      @artist_1 = Artist.new(data)
      
      visit root_path
    end

    describe "when credentials are a correct combination" do
      xit "allows to sign in and takes the artist to its dashboard page" do
        within ".sign_in" do
          fill_in('Email', with: "tatart@gmail.com")
          fill_in('Password', with: "123")
          click_button("Sign In as Artist")
          expect(current_path).to eq(artist_dashboard_path(@artist_1))
        end
      end
    end

    describe "when credentials or input values are not correct" do
      describe "when password is incorrect" do
        xit "does not allow an artist to sign in, flashes a detailed message and refreshes the welcome page" do
          within ".sign_in" do
            fill_in('Email', with: "tatart@gmail.com")
            fill_in('Password', with: "053")
            click_button("Sign In as Artist")
            expect(current_path).to eq(root_path)
            expect(page).to have_content("Incorrect credentials")
          end
        end
      end

      describe "when email is incorrect" do
        xit "does not allow an artist to sign in, flashes a detailed message and refreshes the welcome page" do
          within ".sign_in" do
            fill_in('Email', with: "tatartuu@gmail.com")
            fill_in('Password', with: "123")
            click_button("Sign In as Artist")
            expect(current_path).to eq(root_path)
            expect(page).to have_content("Incorrect credentials")
          end
        end
      end
    end
  end
end
