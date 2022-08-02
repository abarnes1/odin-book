require 'rails_helper'

RSpec.describe 'authenication' do
  context 'when not logged in' do
    it 'routes to the sign in page' do
      visit root_path
      expect(page).to have_selector('form#new_user')
    end
  end

  context 'when logged in' do
    let(:user) { build(:user) }

    it 'routes to the user posts page' do
      sign_in user
      visit root_path

      expect(page).to have_content('User posts placeholder')
    end
  end
end
