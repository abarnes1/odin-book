require 'rails_helper'
require_relative 'concerns/shared/pageable'

RSpec.describe Comment, type: :model do
  it_behaves_like Pageable

  describe '#top_level?' do
    context 'when comment is a post comment' do
      it 'returns true' do
        comment = build_stubbed(:comment)

        expect(comment.top_level?).to be true
      end
    end

    context 'when comment is a comment reply' do
      it 'returns false' do
        comment = build_stubbed(:comment)
        comment_reply = build_stubbed(:comment, post: comment.post, parent_comment: comment)

        expect(comment_reply.top_level?).to be false
      end
    end
  end

  describe '#owner' do
    context 'when comment is a post comment' do
      it 'returns the post' do
        comment = build_stubbed(:comment)

        expect(comment.owner).to eq(comment.post)
      end
    end

    context 'when comment is a comment reply' do
      it 'returns the parent comment' do
        comment = build_stubbed(:comment)
        comment_reply = build_stubbed(:comment, post: comment.post, parent_comment: comment)

        expect(comment_reply.owner).to eq(comment)
      end
    end
  end

  describe 'counter caches' do
    let!(:comment) { create(:comment) }
    let!(:comment_reply) { create(:comment, post: comment.post, parent_comment: comment) }

    context 'when comment replies are added' do
      it 'increments the counter' do
        expect(comment.comments_count).to eq(1)
      end
    end

    context 'when comments are removed' do
      it 'decrements the counter' do
        comment_reply.destroy
        expect(comment.comments_count).to eq(0)
      end
    end
  end
end
