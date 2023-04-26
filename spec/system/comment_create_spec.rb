require 'rails_helper'

RSpec.describe 'creating a comment', type: :system do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let(:top_level_comment) { 'This is a comment.' }

  before do
    sign_in user
    visit feed_path
  end

  context 'when fields are not valid' do
    it 'does not create the comment' do
      click_on 'Comment'
      
      post_comment('')
      message = page.find("#comment_message").native.attribute("validationMessage")
      expect(message).to eq('Please fill out this field.')
    end
  end

  context 'when commenting on posts' do
    it 'creates the comment' do
      click_on 'Comment'
      post_comment(top_level_comment)

      within '.comment-container' do
        expect(page).to have_content(top_level_comment)
      end
    end
  end

  context 'when commenting on comments' do
    let(:child_comment) { 'child comment' }

    before do
      click_on 'Comment'
      post_comment(top_level_comment)
    end

    it 'creates the comment' do
      click_on 'Reply'
      post_comment(child_comment)

      within '.comment-container' do
        expect(page).to have_content(child_comment)
      end
    end
  end
end
