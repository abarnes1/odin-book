require 'rails_helper'

RSpec.describe 'creating a post' do
  let!(:user) { create(:user) }

  before do
    sign_in user
    visit new_post_path
  end

  context 'when fields are valid' do
    it 'creates the post' do
      post_content = 'This is my post.'
      fill_in 'Content', with: post_content

      click_on 'Create Post'

      within '.post-container' do
        expect(page).to have_content(post_content)
      end
    end
  end

  context 'when content field is blank' do
    it 'does not create the post' do
      click_on 'Create Post'

      expect(page).to have_content('Post Creation Error')
    end
  end
end
