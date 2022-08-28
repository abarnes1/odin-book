require 'rails_helper'

RSpec.describe 'editing a comment' do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:comment) { create(:comment, post: post, user: user) }

  before do
    user.posts << post
    post.comments << comment
    sign_in user

    visit posts_path
    click_on 'Edit'
  end

  context 'when fields are not valid' do
    it 'does not update the comment' do
      fill_in 'Comment:', with: ''
      click_on 'Update Comment'
      expect(page).to have_content('Comment Update Error')
    end
  end

  context 'when fields are valid' do
    let(:new_comment_message) { 'updated comment' }

    it 'updates the comment' do
      fill_in 'Comment:', with: new_comment_message
      click_on 'Update Comment'

      within '.comment-container' do
        expect(page).to have_content(new_comment_message)
      end
    end
  end
end
