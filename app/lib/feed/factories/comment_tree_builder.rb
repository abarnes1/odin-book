module Feed
  module Factories
    class CommentTreeBuilder
      def self.for_comments(comments, cache, comment_levels = 3)
        remaining_depth = comment_levels - 1
        feed_comments = []

        return feed_comments unless remaining_depth.positive?

        [comments].flatten.each do |comment|
          user = cache.select_by_attribute_values(User, id: comment.user_id)
          current_comment = FeedComment.new(comment, user)
          feed_comments << current_comment

          load_replies(current_comment, cache, remaining_depth)
        end

        feed_comments
      end

      class << self
        private

        def load_replies(parent_comment, cache, remaining_depth)
          return if remaining_depth.zero?

          # actual comments
          replies = cache.select_by_attribute_values(Comment, parent_comment_id: parent_comment.id)

          replies.each do |reply|
            user = cache.select_by_attribute_values(User, id: reply.user_id)
            
            feed_comment = FeedComment.new(reply, user)
            parent_comment.add_reply(feed_comment)

            load_replies(feed_comment, cache, remaining_depth - 1)
          end
        end
      end
    end
  end
end
