require 'rails_helper'
require_relative 'concerns/shared/pageable'

RSpec.describe Post, type: :model do
  it_behaves_like Pageable

  describe '#comments_count' do
    let!(:user) { create(:user) }
    let!(:post) { create(:post, user: user) }
    let!(:comment) { create(:comment, post: post, user: user) }

    context 'when top level comments are added' do
      it 'increments the counter' do
        expect(post.comments_count).to eq(1)
      end
    end

    context 'when top level comments are removed' do
      it 'decrements the counter' do
        comment.destroy
        expect(post.comments_count).to eq(0)
      end
    end

    context 'when comment replies are added' do
      it 'does not change' do
        create(:comment, post: comment.post, parent_comment: comment)
        expect(post.comments_count).to eq(1)
      end
    end
  end

  describe '#total_comments_count' do
    let!(:user) { create(:user) }
    let!(:post) { create(:post, user: user) }
    let!(:comment) { create(:comment, post: post, user: user) }

    context 'when top level comments are added' do
      it 'increments the counter' do
        expect(post.total_comments_count).to eq(1)
      end
    end

    context 'when top level comments are removed' do
      it 'decrements the counter' do
        comment.destroy
        expect(post.total_comments_count).to eq(0)
      end
    end

    context 'when comment replies are added' do
      it 'increments the counter' do
        comment_reply = create(:comment, post: comment.post, parent_comment: comment)
        expect(post.total_comments_count).to eq(2)
      end
    end

    context 'when comment replies are removed' do
      it 'decrements the counter' do
        comment_reply = create(:comment, post: comment.post, parent_comment: comment)
        comment_reply.destroy
        expect(post.total_comments_count).to eq(1)
      end
    end
  end
end
