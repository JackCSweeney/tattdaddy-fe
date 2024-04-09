require 'rails_helper'

RSpec.describe 'Welcome Index Page', type: :feature do
  describe 'As a visitor displays' do
    before do
      visit root_path
    end

    describe "page heading" do
      it "'Welcome to TattDaddy" do
        expect(page).to have_content("Welcome to\nTattDaddy")
      end
    end
    
    describe "Sign In form with" do
      it "email and password fields" do
        within ".sign_in" do
          expect(page).to have_field('Username')
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
        expect(page).to have_button("Create a User Account")
      end

      it "an artist" do
        expect(page).to have_button("Create a Artist Account")
      end
    end
  end
end