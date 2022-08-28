require 'rails_helper'

RSpec.describe 'creating a comment' do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let(:top_level_comment) { 'top level comment' }

  before do
    sign_in user
    visit posts_path
  end

  context 'when fields are not valid' do
    it 'does not create the comment' do
      click_on 'Create Comment'

      expect(page).to have_content('Comment Creation Error')
    end
  end

  context 'when commenting on posts' do
    it 'creates the comment' do
      fill_in 'Comment:', with: top_level_comment
      click_on 'Create Comment'

      within '.comment-container' do
        expect(page).to have_content(top_level_comment)
      end
    end
  end

  context 'when commenting on comments' do
    let(:child_comment) { 'child comment' }

    before do
      fill_in 'Comment:', with: top_level_comment
      click_on 'Create Comment'
    end

    it 'is a thing' do
      click_on 'Reply'
      fill_in 'Comment:', with: child_comment
      click_on 'Create Comment'

      within all('.comment-container')[1] do
        expect(page).to have_content(child_comment)
      end
    end
  end
end
