require 'rails_helper'

RSpec.describe LoadPostsTieredComments do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:second_post) { create(:post, user: user) }

  describe '#load' do
    context 'when give a single post' do
      it 'returns an array of post presenters' do
        feed_posts = described_class.new(post).load
        expect(feed_posts).to all(be_a(PostPresenter))
      end
    end

    context 'when given an array of posts' do
      it 'returns an array of post presenters' do
        feed_posts = described_class.new([post, second_post]).load
        expect(feed_posts).to all(be_a(PostPresenter))
      end
    end

    context 'when given a number of comment tiers' do
      let!(:post_comment) { create(:comment, user: user, post: post) }
      let!(:comment_reply) { create(:comment, user: user, post: post, parent_comment: post_comment) }

      it 'returns the correct number of tiers' do
        post_with_tiered_comments = described_class.new(post, comment_tiers: 1).load.find { |feed_post| feed_post == post }
        second_tier_comments = post_with_tiered_comments.display_comments.first.display_comments
        expect(second_tier_comments).to be_empty
      end
    end

    context 'when not given a number of comment tiers' do
      let!(:post_comment) { create(:comment, user: user, post: post) }
      let!(:comment_reply) { create(:comment, user: user, post: post, parent_comment: post_comment) }
      let!(:third_level_comment) { create(:comment, user: user, post: post, parent_comment: comment_reply) }
      let!(:fourth_level_comment) { create(:comment, user: user, post: post, parent_comment: third_level_comment) }

      it 'returns the default number of tiers' do
        commentable = described_class.new(post).load.first
        tiers = 0

        until commentable.display_comments.empty?
          tiers += 1
          commentable = commentable.display_comments.first
        end

        expect(tiers).to eq(described_class::DEFAULT_COMMENT_TIERS)
      end
    end

    context 'when given a number of comments per tier' do
      let!(:post_comment1) { create(:comment, user: user, post: post, created_at: 1.minute.ago) }
      let!(:post_comment2) { create(:comment, user: user, post: post, created_at: 2.minutes.ago) }
      let!(:post_comment3) { create(:comment, user: user, post: post, created_at: 3.minutes.ago) }

      let!(:post1_reply1) { create(:comment, user: user, post: post, parent_comment: post_comment1) }
      let!(:post1_reply2) { create(:comment, user: user, post: post, parent_comment: post_comment1) }
      let!(:post1_reply3) { create(:comment, user: user, post: post, parent_comment: post_comment1) }

      it 'returns the correct number of comments per tier' do
        comments_per_tier = 2
        post_with_tiered_comments = described_class.new(post, comment_tiers: 2, comments_per_tier: comments_per_tier)
                                                   .load.find { |feed_post| feed_post == post }
        first_tier_comments = post_with_tiered_comments.display_comments
        second_tier_comments = first_tier_comments.find { |display_comment| display_comment == post_comment1 }.display_comments

        expect([first_tier_comments.size, second_tier_comments.size]).to all(eq(comments_per_tier))
      end
    end

    context 'when not given a number of comments per tier' do
      let!(:post_comment1) { create(:comment, user: user, post: post, created_at: 1.minute.ago) }
      let!(:post_comment2) { create(:comment, user: user, post: post, created_at: 2.minutes.ago) }
      let!(:post_comment3) { create(:comment, user: user, post: post, created_at: 3.minutes.ago) }
      let!(:post_comment4) { create(:comment, user: user, post: post, created_at: 4.minutes.ago) }

      it 'returns the default number of comments per tier' do
        post_with_tiered_comments = described_class.new(post).load.find { |feed_post| feed_post == post }
        expect(post_with_tiered_comments.display_comments.size).to eq(described_class::DEFAULT_COMMENTS_PER_TIER)
      end
    end
  end
end