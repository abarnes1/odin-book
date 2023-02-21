# frozen_string_literal: true

# Loads n comments per m tiers with minimal database activity.  Returns
# supplied Posts as PostPresenters, which are capable of displaying a
# subset of all post comments.
class LoadPostsTieredComments
  extend ServiceSupport::AttachDisplayCommentsFromCache

  attr_reader :posts, :comment_tiers, :comments_per_tier

  DEFAULT_POST_COUNT = 5
  DEFAULT_COMMENT_TIERS = 3
  DEFAULT_COMMENTS_PER_TIER = 3

  def initialize(posts, params = {})
    @posts = posts.is_a?(Array) ? posts : [posts]
    @comment_tiers = params.fetch(:comment_tiers, DEFAULT_COMMENT_TIERS).to_i
    @comments_per_tier = params.fetch(:comments_per_tier, DEFAULT_COMMENTS_PER_TIER).to_i
  end

  def load
    cache = CommentsCacheFactory.create_for(posts, comment_tiers, comments_per_tier)

    post_presenters = posts.map { |p| PostPresenter.new(p) }
    post_presenters.each do |post|
      ServiceSupport::AttachDisplayCommentsFromCache.attach(post, cache)
      ServiceSupport::AssignDisplayDepth.assign_depth(post.display_comments)
    end

    post_presenters
  end
end
