require 'rails_helper'

RSpec.describe 'user list', type: :system do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  before do
    sign_in user1
  end

  it 'does not list the current user' do
    visit users_path

    expect(page).not_to have_selector("##{dom_id(user1)}")
  end

  it 'lists other users' do
    visit users_path

    expect(page).to have_selector("##{dom_id(user2)}")
  end

  context 'when users are friends' do
    it 'displays remove friend text' do
      user1.sent_friend_requests.create(recipient: user2, status: 'accepted')

      visit users_path

      within "##{dom_id(user2)}" do
        expect(page).to have_text 'Remove Friendship'
      end
    end
  end

  context 'when sent friend request' do
    it 'displays cancel friend request text' do
      user1.sent_friend_requests.create(recipient: user2)

      visit users_path

      within "##{dom_id(user2)}" do
        expect(page).to have_text 'Cancel Request'
      end
    end
  end

  context 'when received friend request' do
    it 'displays accept friend request text' do
      user2.sent_friend_requests.create(recipient: user1)

      visit users_path

      within "##{dom_id(user2)}" do
        expect(page).to have_text 'Accept Request'
      end
    end
  end

  context 'when no friend request' do
    it 'displays send friend request text' do
      visit users_path

      within "##{dom_id(user2)}" do
        expect(page).to have_text 'Request Friendship'
      end
    end
  end
end
