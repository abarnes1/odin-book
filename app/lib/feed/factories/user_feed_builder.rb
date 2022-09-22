module Feed
  module Factories
    class UserFeedBuilder
      def self.for(user)
        feed_cache = Feed::Factories::ModelCacheBuilder.for_user_feed(user, 5)
        posts = feed_cache.cache(Post)

        feed_posts = []

        posts.each do |post|
          post_comments = feed_cache.select_by_attribute_values(Comment, post_id: post.id, parent_comment_id: nil)
          feed_posts << Feed::Factories::FeedPostBuilder.for_post(post, post_comments, feed_cache)
        end

        UserFeed.new(user, feed_posts)
      end
    end
  end
end