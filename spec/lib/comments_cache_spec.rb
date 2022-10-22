require 'rails_helper'

RSpec.describe CommentsCache do
  describe '#empty?' do
    context 'when no comments are stored' do
      subject(:empty_comments_cache) { described_class.new }

      it 'returns true' do
        expect(empty_comments_cache.empty?).to be true
      end
    end

    context 'when comments are stored' do
      subject(:comments_cache) { described_class.new }
      let(:post) { build_stubbed(:post) }
      let(:comments) { [build_stubbed(:comment, post: post)] }

      it 'returns false' do
        comments_cache.store_comments(comments)
        expect(comments_cache.empty?).to be false
      end
    end
  end

  describe '#retrieve' do
    subject(:comments_cache) { described_class.new }
    let(:post) { build_stubbed(:post) }
    let(:first_top_level_comment) { build_stubbed(:comment, post: post) }
    let(:second_top_level_comment) { build_stubbed(:comment, post: post) }

    context 'when post comments are stored' do
      it 'can retrieve the post comments' do
        comments = [first_top_level_comment, second_top_level_comment]
        comments_cache.store_comments(comments)
        expect(comments_cache.retrieve_comments_for(post)).to eq(comments)
      end
    end

    context 'when comment replies are stored' do
      let(:first_reply) { build_stubbed(:comment, parent_comment: first_top_level_comment) }
      let(:second_reply) { build_stubbed(:comment, parent_comment: first_top_level_comment) }
      let(:reply_to_different_comment) { build_stubbed(:comment, parent_comment: second_top_level_comment) }

      it 'can retrieve the comment replies' do
        comments = [first_child_comment, second_child_comment, comment_to_not_retrieve]
        comments_to_retrieve = [first_child_comment, second_child_comment]
        comments_cache.store_comments(comments)
        expect(comments_cache.retrieve_comments_for(first_top_level_comment)).to eq(comments_to_retrieve)
      end
    end

    context 'when no comments for owner are stored' do
      it 'returns an empty array' do
        expect(comments_cache.retrieve_comments_for(post)).to eq([])
      end
    end
  end
end
