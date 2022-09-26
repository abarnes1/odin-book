module Feed
  class AssignsDisplayComments
    def self.for_posts(posts, comment_tiers = 3, comments_per_tier = 3)
      posts = [posts].flatten
      comments = posts_comments(posts, comments_per_tier)
      assign_comments_to_posts(posts, comments)

      load_comments_tiers(comments, comment_tiers - 1, comments_per_tier)

      posts
    end

    def self.load_comments_tiers(comments, comment_tiers, comments_per_tier)
      until comment_tiers.zero?
        replies = comments_replies(comments, comments_per_tier)
        assign_replies_to_comments(comments, replies)

        comment_tiers -= 1

        comments = replies
      end
    end

    def self.for_comments(comments, comment_tiers = 3, comments_per_tier = 3)
      comments = [comments].flatten

      load_comments_tiers(comments, comment_tiers - 1, comments_per_tier)

      comments
    end

    def self.assign_comments_to_posts(posts, comments)
      posts.each do |post|
        post.display_comments = comments.select { |comment| comment.post_id == post.id }
      end
    end

    def self.assign_replies_to_comments(comments, replies)
      comments.each do |comment|
        comment.display_comments = replies.select { |reply| reply.parent_comment_id == comment.id }
      end
    end

    class << self
      private

      def posts_comments(posts, comments_per_post = 5)
        Comment.joins(
          "INNER JOIN (
          #{Comment.top_level.select('id, row_number() OVER (PARTITION BY post_id
          ORDER BY created_at DESC) as date_order').to_sql}
          ) by_date
          ON by_date.id = comments.id"
        )
               .where(post_id: posts)
               .where("by_date.date_order <= #{comments_per_post}")
               .order(created_at: :desc)
               .includes(:user)
               .to_a
      end

      def comments_replies(comments, replies_per_comment)
        Comment.joins(
          "INNER JOIN (
          #{Comment.select('id, row_number() OVER (PARTITION BY parent_comment_id
          ORDER BY created_at DESC) as date_order').to_sql}
          ) by_date
          ON by_date.id = comments.id"
        )
               .where(parent_comment_id: comments)
               .where("by_date.date_order <= #{replies_per_comment}")
               .order(:post_id, created_at: :desc)
               .includes(:user)
               .to_a
      end
    end
  end
end
