require 'rails_helper'

RSpec.describe 'liking a post' do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  before do
    user.posts << post
    sign_in user
    visit feed_path
  end

  context 'when post is not liked' do
    it 'can be liked' do
      within '.post-container' do
        expect(page).to have_button(value: 'Like')
      end
    end

    it 'liking increments likes count' do
      within '.post-container' do
        expect(page).to have_content('0 Likes')
      end
    end
  end

  context 'when post is liked' do
    before do
      click_on 'Like'
    end

    it 'can be unliked' do
      within '.post-container' do
        expect(page).to have_button(value: 'Unlike')
      end
    end

    it 'liking decrements likes count' do
      within '.post-container' do
        expect(page).to have_content('1 Likes')
      end
    end
  end
end
