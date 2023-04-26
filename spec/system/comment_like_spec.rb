require 'rails_helper'

RSpec.describe 'liking a post' do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:comment) { create(:comment, post: post, user: user) }

  before do
    sign_in user
    visit feed_path
  end

  context 'when comment is not liked' do
    it 'can be liked' do
      within '.comment-container' do
        expect(page).to have_button('Like')
      end
    end

    it 'liking increments likes count' do
      within '.comment-container' do
        expect(page).to have_content('1')
      end
    end
  end

  context 'when comment is liked' do
    before do
      click_on 'Like'
    end

    it 'can be unliked' do
      within '.comment-container' do
        expect(page).to have_button('Unlike')
      end
    end

    it 'liking decrements likes count' do
      within '.comment-container' do
        expect(page).to have_content('0')
      end
    end
  end
end
