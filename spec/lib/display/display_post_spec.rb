require 'rails_helper'

RSpec.describe Display::DisplayPost do
  let!(:user) { build(:user) }
  let!(:post) { build(:post, user: user) }
  let!(:displayed_comment) { build(:comment, post: post)}
  let!(:not_displayed_comment) { build(:comment, post: post)}

  describe '#display_comments' do
    context 'when has no display comments' do
      subject(:display_post) { described_class.new(post)}

      it 'returns an empty array' do
        expect(display_post.display_comments).to eq([])
      end
    end

    context 'when initialized with a single comment' do
      subject(:display_post_with_comment) { described_class.new(post, displayed_comment)}

      it 'returns an array of comments' do
        expect(display_post_with_comment.display_comments).to eq([displayed_comment])
      end
    end

    context 'when initialized with an array of comments' do
      let!(:displayed_comment_two) { build(:comment, post: post)}
      subject(:display_post_with_comments) { described_class.new(post, [displayed_comment, displayed_comment_two])}

      it 'returns an array of comments' do
        expect(display_post_with_comments.display_comments).to eq([displayed_comment, displayed_comment_two])
      end
    end
  end

  describe '#display_comments?' do
    context 'when has no display comments' do
      subject(:display_post) { described_class.new(post)}

      it 'returns false' do
        expect(display_post.display_comments?).to be false
      end
    end

    context 'when has display comments' do
      subject(:display_post_with_comment) { described_class.new(post, displayed_comment)}
      it 'returns true' do
        expect(display_post_with_comment.display_comments?).to be true
      end
    end
  end

  describe '#display_comments_count' do
    context 'when has no display comments' do
      subject(:display_post) { described_class.new(post)}

      it 'returns 0' do
        expect(display_post.display_comments_count).to eq(0)
      end
    end

    context 'when only some post comments are displayed' do
      subject(:display_post_with_comment) { described_class.new(post, displayed_comment) }
      it 'returns the correct count' do
        expect(display_post_with_comment.display_comments_count).to eq(1)
      end
    end
  end

  describe '#not_displayed_comments_count' do
    context 'when all comments are displayed' do
      subject(:display_post) { described_class.new(post, displayed_comment)}

      it 'returns 0' do
        allow(display_post).to receive(:comments_count).and_return(1)
        expect(display_post.not_displayed_comments_count).to eq(0)
      end
    end

    context 'when only some post comments are displayed' do
      subject(:display_post_with_comment) { described_class.new(post, displayed_comment) }
      it 'returns the correct count' do
        allow(display_post_with_comment).to receive(:comments_count).and_return(2)
        expect(display_post_with_comment.not_displayed_comments_count).to eq(1)
      end
    end
  end

  describe '#all_comments_displayed?' do
    context 'when all post comments are displayed' do
      let!(:post) { build(:post, user: user) }
      let!(:displayed_comment) { build(:comment, post: post)}
      subject(:display_post) { described_class.new(post, displayed_comment)}

      it 'returns true' do
        allow(display_post).to receive(:comments_count).and_return(1)
        expect(display_post.all_comments_displayed?).to be true
      end
    end

    context 'when all post comments are not displayed' do
      subject(:display_post) { described_class.new(post, displayed_comment)}

      it 'returns false' do
        allow(display_post).to receive(:comments_count).and_return(2)
        expect(display_post.all_comments_displayed?).to be false
      end
    end
  end

  describe '#oldest_display_comment' do
    context 'when no display comments' do
      subject(:display_post) { described_class.new(post) }
      it 'returns nil' do
        expect(display_post.oldest_display_comment).to be nil
      end
    end

    context 'when multiple display comments' do
      let!(:newer_post) { build(:comment, post: post, created_at: 1.minute.ago) }
      let!(:older_post) { build(:comment, post: post, created_at: 5.minutes.ago) }

      subject(:display_post) { described_class.new(post, [newer_post, older_post]) }
      it 'returns the oldest comment' do
        expect(display_post.oldest_display_comment).to eq(older_post)
      end
    end
  end

  describe '#likes_count' do
    subject(:display_post) { described_class.new(post) }

    context 'when post has no likes' do
      it 'returns 0' do
        allow(display_post).to receive(:likes).and_return([])

        expect(display_post.likes_count).to eq(0)
      end
    end

    context 'when post has likes' do
      it 'returns the likes count' do
        allow(display_post).to receive(:likes).and_return(['fake_like_1', 'fake_like_2'])

        expect(display_post.likes_count).to eq(2)
      end
    end
  end
end
