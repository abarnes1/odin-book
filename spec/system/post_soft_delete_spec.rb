require 'rails_helper'

RSpec.describe 'soft deleting a post', type: :system do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  before do
    sign_in user
    visit feed_path
  end

  context 'when post is not soft deleted' do
    it 'can be soft deleted' do
      click_on 'Delete'

      within '.post-container' do
        expect(page).to have_content('post deleted by author')
      end
    end
  end

  context 'when post is soft deleted' do
    before do
      within '.post-container' do
        click_on 'Delete'
      end
    end

    it 'does not display the post content' do
      within '.post-container' do
        expect(page).not_to have_content(post.content)
      end
    end

    it 'can be restored' do
      click_on 'Undelete'

      within '.post-container' do
        expect(page).to have_content(post.content)
      end
    end
  end
end
