require 'rails_helper'

RSpec.describe 'authenication' do
  context 'when not logged in' do
    it 'routes to the sign in page' do
      visit root_path

      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
  end

  context 'when logged in' do
    it 'routes to the user posts page' do
      pending 'not implemented'

      visit root_path

      expect(page).to have_content('User posts placeholder')
    end
  end
end