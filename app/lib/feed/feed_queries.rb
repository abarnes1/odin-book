module Feed
  class FeedQueries
    def self.feed_posts(user, post_count = 5)
      Post.joins(:user)
          .where(user_id: user.friends.map(&:id) << user.id)
          .newest
          .limit(post_count).to_a
    end

    def self.post_comments(posts, comments_per_post = 5)
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
             .to_a
    end

    def self.comment_replies(comments, replies_per_comment)
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
             .to_a
    end
  end
end
