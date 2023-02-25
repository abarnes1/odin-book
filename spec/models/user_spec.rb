require 'rails_helper'
require_relative 'concerns/shared/pageable'

RSpec.describe User, type: :model do
  it_behaves_like Pageable

  describe '#friends' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }
    let(:not_friend) { create(:user) }

    it 'returns only accepted friend requests' do
      user.sent_friend_requests.create(recipient: friend, status: :accepted)
      user.sent_friend_requests.create(recipient: not_friend, status: :pending)

      expect(user.friends).to eq([friend])
    end

    it 'works with sent friend requests' do
      user.sent_friend_requests.create(recipient: friend, status: :accepted)

      expect(user.friends).to eq([friend])
    end

    it 'works with received friend requests' do
      user.received_friend_requests.create(sender: friend, status: :accepted)

      expect(user.friends).to eq([friend])
    end
  end

  describe '#feed_posts' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }
    let(:not_friend) { create(:user) }

    before do 
      allow(user).to receive(:friends).and_return([friend])
    end

    it 'contains self and friend posts' do
      user_post = create(:post, user: user)
      friend_post = create(:post, user: friend)
      create(:post, user: not_friend)

      expect(user.feed_posts).to match_array([user_post, friend_post])
    end

    it 'orders from newest to oldest' do
      create(:post, user: user, created_at: 10.minutes.ago)
      newest_post = create(:post, user: user, created_at: 1.minute.ago)
      create(:post, user: user, created_at: 5.minutes.ago)

      expect(user.feed_posts.first).to eq(newest_post)
    end
  end

  describe '#friends?' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }
    let(:not_friend) { create(:user) }

    before do 
      allow(user).to receive(:friends).and_return([friend])
    end

    context 'when friends' do
      it 'returns true' do
        expect(user.friends?(friend)).to be true
      end
    end

    context 'when not friends' do
      it 'returns false' do
        expect(user.friends?(not_friend)).to be false
      end
    end
  end

  describe '#requested_friendship_with?' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    context 'when friendship request was sent' do
      it 'returns true' do
        user.sent_friend_requests.create(recipient: other_user)

        expect(user.requested_friendship_with?(other_user)).to be true
      end
    end

    context 'when friendship request was received' do
      it 'returns false' do
        user.received_friend_requests.create(sender: other_user)

        expect(user.requested_friendship_with?(other_user)).to be false
      end
    end

    context 'when friend request is accepted' do
      it 'returns false' do
        user.sent_friend_requests.create(recipient: other_user, status: :accepted)
        
        expect(user.requested_friendship_with?(other_user)).to be false
      end
    end

    context 'when no friendship request exists' do
      it 'returns false' do
        expect(user.requested_friendship_with?(other_user)).to be false
      end
    end
  end

  describe '#friendship_requested_by?' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    context 'when friendship request was received' do
      it 'returns true' do
        user.received_friend_requests.create(sender: other_user)

        expect(user.friendship_requested_by?(other_user)).to be true
      end
    end

    context 'when friendship request was sent' do
      it 'returns false' do
        user.sent_friend_requests.create(recipient: other_user)

        expect(user.friendship_requested_by?(other_user)).to be false
      end
    end

    context 'when friend request is accepted' do
      it 'returns false' do
        user.sent_friend_requests.create(recipient: other_user, status: :accepted)
        
        expect(user.friendship_requested_by?(other_user)).to be false
      end
    end

    context 'when no friendship request exists' do
      it 'returns false' do
        expect(user.friendship_requested_by?(other_user)).to be false
      end
    end
  end
end
