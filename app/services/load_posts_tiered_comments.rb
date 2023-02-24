# frozen_string_literal: true

# Loads n comments per m tiers with minimal database activity.  Returns
# supplied Posts as PostPresenters, which are capable of displaying a
# subset of each post's own #comments as #display_comments.
#
# ex: Normally this tree would run a query for the posts, again for each post's
#  comments, then yet again for each comment's comments in an n+1 fashion, with the
#  number in parenthesis denoting the query number:
# Post (1)
#  Comment (2)
#    Comment (3)
#  Comment (2)
#    Comment (4)
# Post (1)
#  Comment (5)
#    Comment (6)
#  Comment (5)
#    Comment (7)
#
# This class loads each tier in one query:
# Post (1)
#  Comment (2)
#    Comment (3)
#  Comment (2)
#    Comment (3)
# Post (1)
#  Comment (2)
#    Comment (3)
#  Comment (2)
#    Comment (3)
class LoadPostsTieredComments
  extend ServiceSupport::AttachDisplayCommentsFromCache

  attr_reader :posts, :comment_tiers, :comments_per_tier

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
