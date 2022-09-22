module Feed
  module Factories
    class FeedPostBuilder
      def self.for_post(post, comments, cache)
        feed_comments = CommentTreeBuilder.for_comments(comments, cache)
        user = cache.select_by_attribute_values(User, id: post.user_id)

        feed_post = FeedPost.new(post, feed_comments, user)
      end
    end
  end
end