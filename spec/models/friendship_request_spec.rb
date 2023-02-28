require 'rails_helper'

RSpec.describe FriendshipRequest, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  # This is important enough to ensure it is never allowed.
  context 'when two people request friendship with each other' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    it 'raises an error' do
      user1.sent_friend_requests.create(recipient: user2)
      duplicate = user2.sent_friend_requests.build(recipient: user1)

      expect { duplicate.save }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
