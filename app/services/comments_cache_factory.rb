# frozen_string_literal: true

# Preloads a limited section of a comments thread in a way that reduces database
# activity by selecting an entire level of comments across multiple posts or
# comments in a single query.  This gets around both n+1 queries and ActiveRecord's
# limitations where:
#   1) eager loading an association with a limit will ignore the limit:
#      https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html
#      quote: "If you eager load an association with a specified :limit option, it will
#              be ignored, returning all the associated objects"
#   2) eager loading with post.includes(:comments) will preload every single
#      comment, which can potentially be very high when a limited number is desired
class CommentsCacheFactory
  def self.create_for(models, comment_tiers = 3, comments_per_tier = 3)
    models = [models].flatten
    cache = CommentsCache.new

    comments =
      if models.first.is_a?(Post)
        post_comments(models, comments_per_tier)
      else
        comments_replies(models, comments_per_tier)
      end

    cache.store_comments(comments)
    load_comments_tiers(comments, cache, comment_tiers - 1, comments_per_tier)
  end

  class << self
    private

    def load_comments_tiers(comments, cache, comment_tiers, comments_per_tier)
      until comment_tiers.zero?
        replies = comments_replies(comments, comments_per_tier)
        cache.store_comments(replies)
        comment_tiers -= 1
        comments = replies
      end

      cache
    end

    # rubocop:disable Metrics/MethodLength
    def post_comments(posts, comments_per_post = 5)
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
             .reverse
    end
    # rubocop:enable Metrics/MethodLength

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
             .order(:post_id, :created_at)
             .includes(:user)
    end
  end
end
