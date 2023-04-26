require 'rails_helper'

RSpec.describe Likeable do
  describe '#liked_by?' do
    let(:user) { create(:user) }
    let(:likeable) { create(:post, user: user) }

    context 'when liked by user' do
      it 'returns true' do
        likeable.likes.create(user: user)
        expect(likeable.liked_by?(user)).to be true
      end
    end

    context 'when not liked by user' do
      it 'returns false' do
        expect(likeable.liked_by?(user)).to be false
      end
    end
  end
end