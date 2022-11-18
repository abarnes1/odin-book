require 'rails_helper'

RSpec.describe LoadComments do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  describe '#owner' do
    context 'when a post id is present' do
      it 'identifies the post as owner' do
        with_post_id = described_class.new(post_id: post.id)
        expect(with_post_id.owner).to eq(post)
      end
    end

    context 'when a comment id is present' do
      let!(:comment) { create(:comment, post: post, user: user) }

      it 'identifies the comment as owner' do
        with_comment_id = described_class.new(comment_id: comment.id)
        expect(with_comment_id.owner).to eq(comment)
      end
    end
  end

  describe '#oldest_comment' do
    context 'when not given an oldest comment id' do
      it 'return nil' do
        without_oldest_comment = described_class.new

        expect(without_oldest_comment.oldest_comment).to be_nil
      end
    end

    context 'when given an oldest comment id' do
      let!(:comment) { create(:comment, post: post, user: user) }
      it 'returns the oldest comment' do
        with_oldest_comment = described_class.new(older_than: comment.id)

        expect(with_oldest_comment.oldest_comment).to eq(comment)
      end
    end
  end

  describe '#load' do
    let!(:newest_post_comment) { create(:comment, user: user, post: post, created_at: 1.minute.ago) }
    let!(:middle_post_comment) { create(:comment, user: user, post: post, created_at: 2.minutes.ago) }
    let!(:oldest_post_comment) { create(:comment, user: user, post: post, created_at: 3.minutes.ago) }

    let!(:newest_comment_reply) { create(:comment, user: user, post: post, parent_comment_id: newest_post_comment.id, created_at: 1.minute.ago) }
    let!(:middle_comment_reply) { create(:comment, user: user, post: post, parent_comment_id: newest_post_comment.id, created_at: 2.minutes.ago) }
    let!(:oldest_comment_reply) { create(:comment, user: user, post: post, parent_comment_id: newest_post_comment.id, created_at: 3.minutes.ago) }

    context 'when owner is a Post' do
      it 'returns a post presenter' do
        with_post_owner = described_class.new(post_id: post.id)

        expect(with_post_owner.load).to be_a(PostPresenter)
      end
    end

    context 'when owner is a Comment' do
      it 'returns a comment presenter' do
        with_comment_owner = described_class.new(comment_id: newest_post_comment.id)

        expect(with_comment_owner.load).to be_a(CommentPresenter)
      end
    end

    context 'when limit param is specified' do
      it 'returns the correct amount of display comments' do
        limit = 2
        with_limit_param = described_class.new(post_id: post.id, limit: limit)
        loaded_comments = with_limit_param.load.display_comments

        expect(loaded_comments.size).to eq(limit)
      end
    end

    context 'when limit param is not specified' do
      let!(:fourth_comment) { create(:comment, user: user, post: post) }

      it 'returns the default amount of comments' do
        without_limit_param = described_class.new(post_id: post.id)
        loaded_comments = without_limit_param.load.display_comments

        expect(loaded_comments.size).to eq(described_class::DEFAULT_LIMIT)
      end
    end

    context 'when loading post comments' do
      it 'returns newest comments ordered from oldest to newest' do 
        owned_by_post = described_class.new(post_id: post.id, limit: 2)
        loaded_comments = owned_by_post.load.display_comments

        expect(loaded_comments).to eq([middle_post_comment, newest_post_comment])
      end
    end
    
    context 'when loading comment replies' do
      it 'returns newest comments from ordered from oldest to newest' do
        owned_by_comment = described_class.new(comment_id: newest_post_comment.id, limit: 2)
        loaded_comments = owned_by_comment.load.display_comments

        expect(loaded_comments).to eq([middle_comment_reply, newest_comment_reply])
      end
    end

    context 'when given older than param' do
      it 'returns older comments' do
        with_older_than = described_class.new(post_id: post.id, older_than: middle_post_comment.id)
        loaded_comments = with_older_than.load.display_comments

        expect(loaded_comments).to eq([oldest_post_comment])
      end
    end

    context 'when given a display depth' do
      it 'assigns display depth' do
        depth = 3
        with_display_depth = described_class.new(comment_id: newest_post_comment.id, limit: 2, display_depth: depth)
        loaded_comments = with_display_depth.load.display_comments

        expect(loaded_comments.first.display_depth).to eq(depth)
      end

      it 'assigns default depth for post comments' do
        with_display_depth = described_class.new(post_id: post.id, limit: 1, display_depth: 3)
        loaded_comments = with_display_depth.load.display_comments

        expect(loaded_comments.first.display_depth).to eq(described_class::DEFAULT_DISPLAY_DEPTH)
      end
    end

    context 'when not given a display_depth' do
      it 'assigns default display depth to comments' do
        without_display_depth = described_class.new(comment_id: newest_post_comment.id, limit: 1)
        loaded_comments = without_display_depth.load.display_comments

        expect(loaded_comments.first.display_depth).to eq(described_class::DEFAULT_DISPLAY_DEPTH)
      end
    end

    context 'when given a displayed count' do
      it 'assigns the owner the displayed_count' do
        with_display_count = described_class.new(post_id: post.id, displayed_count: 99)
        owner = with_display_count.load

        expect(owner.already_displayed_comments_count).to eq(99)
      end
    end

    context 'when not given a displayed count' do
      it 'assigns the owner the default displayed_count' do
        with_display_count = described_class.new(post_id: post.id)
        owner = with_display_count.load

        expect(owner.already_displayed_comments_count).to eq(described_class::DEFAULT_DISPLAYED_COUNT)
      end
    end
  end
end