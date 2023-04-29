require 'rails_helper'

RSpec.describe 'user list', type: :system do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }

  before do
    sign_in user1
  end

  it 'does not list the current user' do
    visit users_path

    within '.listed-user-container' do
      expect(page).not_to have_content(user1.username)
    end
  end

  it 'lists other users' do
    visit users_path

    within '.listed-user-container' do
      expect(page).to have_content(user2.username)
    end
  end

  context 'when users are friends' do
    it 'displays remove friend text' do
      user1.sent_friend_requests.create(recipient: user2, status: 'accepted')

      visit users_path

      within "##{dom_id(user2)}" do
        expect(page).to have_button(value: 'Remove Friendship')
      end
    end
  end

  context 'when sent friend request' do
    it 'displays cancel friend request text' do
      user1.sent_friend_requests.create(recipient: user2)

      visit users_path

      within "##{dom_id(user2)}" do
        expect(page).to have_button(value: 'Cancel Request')
      end
    end
  end

  context 'when received friend request' do
    it 'displays accept friend request text' do
      user2.sent_friend_requests.create(recipient: user1)

      visit users_path

      within "##{dom_id(user2)}" do
        expect(page).to have_button(value: 'Accept Request')
      end
    end
  end

  context 'when no friend request' do
    it 'displays send friend request text' do
      visit users_path

      within "##{dom_id(user2)}" do
        expect(page).to have_button(value: 'Request Friendship')
      end
    end
  end

  context 'when filtering' do
    let!(:friend) { create(:user) }
    let!(:sent_friend_request_to) { create(:user) }
    let!(:received_friend_request_from) { create(:user) }

    before do
      user1.sent_friend_requests.create(recipient: friend, status: :accepted)
      user1.sent_friend_requests.create(recipient: sent_friend_request_to)
      user1.received_friend_requests.create(sender: received_friend_request_from)
    end

    context 'when by sent friend requests' do
      before do
        visit users_path(filter: :sent)
      end

      it 'lists users who were sent friend requests' do
        expect(page).to have_content(sent_friend_request_to.username)
      end

      it 'does not list users with no friend request' do
        expect(page).not_to have_content(user2.username)
      end

      it 'does not list friends' do
        expect(page).not_to have_content(friend.username)
      end

      it 'does not list users who sent friend requests' do
        expect(page).not_to have_content(received_friend_request_from.username)
      end
    end

    context 'when by received friend requests' do
      before do
        visit users_path(filter: :received)
      end

      it 'lists users who sent friend requests' do
        expect(page).to have_content(received_friend_request_from.username)
      end
      
      it 'does not list users with no friend request' do
        expect(page).not_to have_content(user2.username)
      end

      it 'does not list friends' do
        expect(page).not_to have_content(friend.username)
      end

      it 'does not list users who were sent friend requests' do
        expect(page).not_to have_content(sent_friend_request_to.username)
      end
    end
  end
end
