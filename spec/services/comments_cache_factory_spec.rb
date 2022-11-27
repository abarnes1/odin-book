require 'rails_helper'

RSpec.describe CommentsCacheFactory do
  subject(:comments_cache_factory) { described_class }

  describe '#create_for' do
    it 'can create a cache from a single post' do
      post = build_stubbed(:post)
      expect(comments_cache_factory.create_for(post)).to be_a CommentsCache
    end

    it 'can create a cache from an array of posts' do
      posts = [build_stubbed(:post), build_stubbed(:post)]
      expect(comments_cache_factory.create_for(posts)).to be_a CommentsCache
    end

    it 'can create a cache from a single comment' do
      comment = build_stubbed(:comment)
      expect(comments_cache_factory.create_for(comment)).to be_a CommentsCache
    end

    it 'can create a cache from an array of comments' do
      comments = [build_stubbed(:comment), build_stubbed(:comment)]
      expect(comments_cache_factory.create_for(comments)).to be_a CommentsCache
    end

    let!(:user) { create(:user) }
    let!(:post) { create(:post, user: user) }
    let!(:top_level_comment1) { create(:comment, post: post, user: user, created_at: 1.minute.ago) }
    let!(:top_level_comment2) { create(:comment, post: post, user: user, created_at: 2.minutes.ago) }
    let!(:top_level_comment3) { create(:comment, post: post, user: user, created_at: 3.minutes.ago) }
    let!(:comment_outside_of_per_tier_limit) { create(:comment, post: post, user: user, created_at: 4.minutes.ago) }

    let!(:reply1_at_depth1) { create(:comment, post: post, user: user, parent_comment: top_level_comment1, created_at: 1.minutes.ago) }
    let!(:reply2_at_depth1) { create(:comment, post: post, user: user, parent_comment: top_level_comment1, created_at: 2.minutes.ago) }
    let!(:reply3_at_depth1) { create(:comment, post: post, user: user, parent_comment: top_level_comment1, created_at: 3.minutes.ago) }

    let!(:reply1_at_depth2) { create(:comment, post: post, user: user, parent_comment: reply1_at_depth1) }
    let!(:reply1_at_depth3) { create(:comment, post: post, user: user, parent_comment: reply1_at_depth2) }
    let!(:comment_outside_of_depth_limit) { create(:comment, post: post, user: user, parent_comment: reply1_at_depth3) }

    let(:cache_starting_at_post) { comments_cache_factory.create_for(post) }

    it 'orders post comments from oldest to newest' do
      expected_comments = [top_level_comment3, top_level_comment2, top_level_comment1]
      actual_comments = cache_starting_at_post.retrieve_comments_for(post)
      expect(expected_comments).to eq(actual_comments)
    end

    it 'orders comment replies from oldest to newest' do
      expected_comments = [reply3_at_depth1, reply2_at_depth1, reply1_at_depth1]
      actual_comments = cache_starting_at_post.retrieve_comments_for(top_level_comment1)
      expect(expected_comments).to eq(actual_comments)
    end

    it 'correctly limits the comments per tier' do
      comments = cache_starting_at_post.retrieve_comments_for(post)
      expect(comments.size).to eq(3)
    end

    it 'correctly limits comment depth' do
      comments = cache_starting_at_post.retrieve_comments_for(reply1_at_depth3)
      expect(comments).to be_empty
    end
  end
end
