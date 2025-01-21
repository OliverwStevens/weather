require 'rails_helper'

RSpec.describe 'Locations', type: :system do
  let(:location) { create(:location) }  # Assuming you have FactoryBot set up

  before do
    driven_by(:selenium_chrome_headless)
  end

  describe 'index page' do
    it 'shows the locations header' do
      visit locations_path
      expect(page).to have_selector('h1', text: 'Locations')
    end
  end

  describe 'creating a location' do
    it 'creates a new location' do
      visit locations_path
      click_on 'New Location'

      fill_in 'Enter your IP address', with: location.ip_address
      fill_in 'Enter your zipcode', with: location.zipcode
      click_on 'Submit'

      expect(page).to have_text('Location was successfully created')
      click_on 'Back to Locations'
    end
  end

  describe 'updating a location' do
    it 'updates an existing location' do
      visit location_path(location)
      click_on 'Edit Location', match: :first

      fill_in 'Enter your IP address', with: location.ip_address
      fill_in 'Enter your zipcode', with: location.zipcode
      click_on 'Submit'

      expect(page).to have_text('Location was successfully updated')
      click_on 'Back to Locations'
    end
  end

  describe 'destroying a location' do
    it 'deletes the location' do
      visit location_path(location)
      click_on 'Destroy Location', match: :first

      expect(page).to have_text('Location was successfully destroyed')
    end
  end
end