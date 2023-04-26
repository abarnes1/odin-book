require 'rails_helper'

RSpec.describe 'soft deleting a comment', type: :system do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:comment) { create(:comment, post: post, user: user) }

  before do
    sign_in user
    visit feed_path
  end

  context 'when comment is not soft deleted' do
    it 'can be soft deleted' do
      within '.comment-container' do
        click_on 'Delete'
        expect(page).to have_content('comment deleted by author')
      end
    end
  end

  context 'when post is soft deleted' do
    before do
      within '.comment-container' do
        click_on 'Delete'
      end
    end

    it 'does not display the commnet message' do
      within '.comment-container' do
        expect(page).not_to have_content(comment.message)
      end
    end

    it 'can be restored' do
      within '.comment-container' do
        click_on 'Undelete'
        expect(page).to have_content(comment.message)
      end
    end
  end
end
