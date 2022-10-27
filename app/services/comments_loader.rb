# frozen_string_literal: true

# Examine parameters and load the correct comments for display.
class CommentsLoader
  def self.load(params)
    if params[:older_than].present?
      load_previous(params[:older_than])
    else
      load_initial(params[:parent_comment])
    end.map { |c| c.extend DisplayableComments }
  end

  def self.load_previous(oldest_comment_id)
    current_oldest_visible_comment = Comment.find(oldest_comment_id)

    previous_comments(current_oldest_visible_comment, 3)
  end

  def self.load_initial(parent_comment_id)
    parent_comment = Comment.find(parent_comment_id)
    parent_comment.comments.newest.limit(5).reverse
  end

  class << self
    private

    def previous_comments(comment, limit = 3)
      Comment.where(post_id: comment.post_id, parent_comment_id: comment.parent_comment_id)
             .where('created_at < ?', comment.created_at)
             .limit(limit)
             .order(created_at: :desc)
             .reverse
    end
  end
end
