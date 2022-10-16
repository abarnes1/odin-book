module Feed
  class UserFeedFactory
    def self.for_user(user, post_limit = 5, page = 0, comment_tiers = 3, comments_per_tier = 3)
      posts = feed_posts(user, post_limit, page)
      cache = Caching::CommentsCacheFactory.create_for(posts, comment_tiers, comments_per_tier)

      display_posts = posts.map do |post|
        Display::DisplayPostFactory.create_for(post, cache) do |display_post| 
          Caching::AttachesDisplayCommentsFromCache.attach(display_post, cache)
        end
      end

      UserFeed.new(user, display_posts)
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
