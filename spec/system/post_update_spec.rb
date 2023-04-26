require 'rails_helper'

RSpec.describe 'creating a post', type: :system do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  before do
    sign_in user
    visit feed_path
    click_on 'Edit'
  end

  context 'when fields are valid' do
    it 'updates the post' do
      post_content = 'This is my post.'
      update_post(post_content)

      within '.post-container' do
        expect(page).to have_content(post_content)
      end
    end
  end

  context 'when content field is blank' do
    it 'does not create the post' do
      update_post('')

      message = page.find("#post_content").native.attribute("validationMessage")
      expect(message).to eq('Please fill out this field.')
    end
  end
end
