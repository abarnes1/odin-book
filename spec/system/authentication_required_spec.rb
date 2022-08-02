require 'rails_helper'

# include Devise::Test::IntegrationHelpers

RSpec.describe 'authenication' do
  context 'when not logged in' do
    it 'routes to the sign in page' do
      visit root_path
      expect(page).to have_content('You need to sign in or sign up before continuing.')
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
