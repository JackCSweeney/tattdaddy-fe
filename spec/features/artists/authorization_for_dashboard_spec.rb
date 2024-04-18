require 'rails_helper'

RSpec.describe 'Artist authorization', type: :feature do
  describe 'As a logged_out artist' do
    it 'cannot go to dashboard when not signed in' do
      visit artist_dashboard_path(artist_id: 5)

      expect(current_path).to eq(root_path)
      
      expect(page).to have_content("You need to login")

    end
  end
end