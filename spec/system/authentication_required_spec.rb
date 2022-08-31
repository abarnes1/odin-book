require 'rails_helper'

RSpec.describe 'authenication' do
  context 'when not logged in' do
    it 'routes to the sign in page' do
      visit unauthenticated_root_path
      expect(page).to have_selector(:link_or_button, 'Log in')
    end

    it 'requires a sign in to access protected resources' do
      visit feed_path
      expect(page).to have_content('You need to sign in or sign up before continuing.')
      expect(page).to have_selector(:link_or_button, 'Log in')
    end
  end

  context 'when logged in' do
    let(:user) { create(:user) }

    it 'routes to the user feed page' do
      sign_in user
      visit root_path

      expect(page).to have_content('User Feed')
    end
  end
end
