module Feed
  module Factories
    class ModelCacheBuilder
      def self.for_user_feed(user, post_count = 5, comment_levels = 3, comments_per_level = 3)
        cache = Feed::ModelCache.new

        posts = FeedQueries.feed_posts(user, post_count)
        cache.add(Post, posts)

        add_top_level_comments(cache, comment_levels, comments_per_level)
        add_users(cache)

        cache
      end

      def self.for_post(post, comment_levels = 3, comments_per_level = 3)
        cache = Feed::ModelCache.new
        cache.add(Post, post)

        add_top_level_comments(cache, comment_levels, comments_per_level)
        add_users(cache)

        cache
      end

      def self.for_comment(comment, comment_levels = 3, comments_per_level = 3)
        cache = Feed::ModelCache.new
        cache.add(Comment, comment)

        add_comment_replies(cache, comment_levels, comments_per_level)
        add_users(cache)

        cache
      end

      class << self
        private

        def add_top_level_comments(cache, comment_levels = 3, comments_per_level = 3)
          posts = cache.cache(Post)

          if comment_levels.positive?
            comments = FeedQueries.post_comments(posts, comments_per_level)
            cache.add(Comment, comments)
          end

          add_comment_replies(cache, comment_levels, comments_per_level)
        end

        def add_comment_replies(cache, comment_levels = 3, comments_per_level = 3)
          comments = cache.cache(Comment)
          remaining_levels = comment_levels - 1

          until remaining_levels.zero?
            comments = FeedQueries.comment_replies(comments, comments_per_level)
            cache.add(Comment, comments)
            remaining_levels -= 1
          end
        end

        def add_users(cache)
          user_ids_across_all_caches = cache.select_attribute_values(:user_id)
          users = User.where(id: user_ids_across_all_caches).to_a
          cache.add(User, users)
        end
      end
    end
  end
end
