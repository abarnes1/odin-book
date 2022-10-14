module Feed
  class UserFeedFactory
    def self.for_user(user, post_limit = 5, page = 0, comment_tiers = 3, comments_per_tier = 3)
      # posts = feed_posts(user, post_limit, page)
      posts = feed_posts(user, post_limit, page).map { |post| Display::DisplayPost.new(post) }

      AssignsDisplayComments.for_posts(posts, comment_tiers, comments_per_tier)

      UserFeed.new(user, posts)
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
end
