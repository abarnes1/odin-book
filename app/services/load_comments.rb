# frozen_string_literal: true

# Examine parameters and load the correct unnested comments for display.
class LoadComments
  DEFAULT_LIMIT = 3
  DEFAULT_DISPLAY_DEPTH = 0

  attr_reader :limit, :comment_id, :post_id

  def initialize(params = {})
    @post_id = Integer(params.fetch(:post_id, nil), exception: false)
    @oldest_comment_id = Integer(params.fetch(:oldest, nil), exception: false)
    @comment_id = Integer(params.fetch(:comment_id, nil), exception: false)
    @limit = params.fetch(:limit, DEFAULT_LIMIT).to_i
    @display_depth = params.fetch(:depth, DEFAULT_DISPLAY_DEPTH).to_i
  end

  def owner
    @owner ||= comment_owner
  end

  def oldest_comment
    return nil unless oldest_comment_id

    @oldest_comment ||= Comment.find(oldest_comment_id)
  end

  def load
    comments_relation = comments
    decorated_owner(not_displayed_count: comments.size, depth: display_depth).display_comments =
      comments_relation.limit(limit).reverse.map { |c| CommentPresenter.new(c) }
    ServiceSupport::AssignDisplayDepth.assign_depth(decorated_owner.display_comments, starting_display_depth)
    decorated_owner
  end

  private

  attr_reader :oldest_comment_id, :display_depth, :not_displayed_count, :displayed_count

  def comments
    @comments ||= if oldest_comment_id
                    load_older_comments
                  else
                    load_initial_comments
                  end
  end

  def load_older_comments
    owner.comments
         .where('created_at < ?', oldest_comment.created_at)
         .newest
         .includes(:user)
  end

  def load_initial_comments
    owner.comments.newest.includes(:user)
  end

  def decorated_owner(params = {})
    @decorated_owner ||= if owner.is_a? Post
                           PostPresenter.new(owner, params)
                         else
                           CommentPresenter.new(owner, params)
                         end
  end

  def starting_display_depth
    if owner.is_a? Post
      DEFAULT_DISPLAY_DEPTH
    else
      display_depth + 1
    end
  end

  def comment_owner
    if comment_id
      Comment.find(comment_id)
    else
      Post.find(post_id)
    end
  end
end
