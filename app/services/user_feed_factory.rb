# frozen_string_literal: true

# Creates a UserFeed object, consisting of posts with a limited number of
# displayed comment levels and displayed comments per level.
class UserFeedFactory
  def self.for_user(user, post_limit = 5, page = 0, comment_tiers = 3, comments_per_tier = 3)
    posts = feed_posts(user, post_limit, page).map { |post| post.extend DisplayableComments }
    cache = CommentsCacheFactory.create_for(posts, comment_tiers, comments_per_tier)

    posts_with_display_comments = posts.map do |post|
      AttachDisplayCommentsFromCache.attach(post, cache)
    end

    UserFeed.new(user, posts_with_display_comments)
  end

  class << self
    private

    def feed_posts(user, post_count = 5, page = 0)
      Post.includes(:user, likes: [:user])
          .joins(:user)
          .where(user_id: user.friends.map(&:id) << user.id)
          .newest
          .limit(post_count)
          .offset(page * post_count)
          .to_a
    end
  end
end
