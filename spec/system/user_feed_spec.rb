require 'rails_helper'

RSpec.describe 'user feed', type: :system do
  let!(:user) { create(:user) }
  let!(:user_post) { create(:post, user: user, created_at: Time.now) }
  let!(:friend) { create(:user) }
  let!(:friend_post) { create(:post, user: friend, created_at: Time.now - 5.minutes) }
  let!(:not_friend) { create(:user) }
  let!(:not_friend_post) { create(:post, user: not_friend) }

  before do
    user.sent_friend_requests.create(recipient: friend, status: 'accepted')
    sign_in user
    visit feed_path
  end

  it 'shows the user posts' do
    expect(page).to have_content(user_post.content)
  end

  it 'shows the user friend posts' do
    expect(page).to have_content(friend_post.content)
  end

  it 'does not show posts for non-friends' do
    expect(page).to_not have_content(not_friend_post.content)
  end

  it 'lists newest posts first' do
    within find('.post-container', match: :first) do
      expect(page).to have_content(user_post.content)
    end
  end

  it 'shows only 5 posts' do
    create(:post, user: user, created_at: Time.now)
    create(:post, user: user, created_at: Time.now)
    create(:post, user: user, created_at: Time.now)
    create(:post, user: user, created_at: Time.now)
    create(:post, user: user, created_at: Time.now)
    create(:post, user: user, created_at: Time.now)

    visit feed_path

    page.assert_selector('.post-container', count: 5)
  end
end
