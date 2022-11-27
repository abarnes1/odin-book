# frozen_string_literal: true

# Examine parameters and load the correct unnested comments for display.
class LoadComments
  DEFAULT_LIMIT = 3
  DEFAULT_DISPLAYED_COUNT = 0
  DEFAULT_DISPLAY_DEPTH = 0

  attr_reader :limit, :comment_id, :post_id

  def initialize(params = {})
    @post_id = params.fetch(:post_id, nil)
    @older_than = params.fetch(:older_than, nil)
    @newer_than = params.fetch(:newer_than, nil)
    @comment_id = params.fetch(:comment_id, nil)
    @limit = params.fetch(:limit, DEFAULT_LIMIT).to_i
    @displayed_count = params.fetch(:displayed_count, DEFAULT_DISPLAYED_COUNT).to_i
    @display_depth = params.fetch(:display_depth, DEFAULT_DISPLAY_DEPTH).to_i
  end

  def owner
    @owner ||= comment_owner
  end

  def oldest_comment
    return nil unless older_than

    @oldest_comment ||= Comment.find(older_than)
  end

  def newest_comment
    return nil unless newer_than

    @newest_comment ||= Comment.find(newer_than)
  end

  def load
    decorated_owner.display_comments = comments.map { |c| CommentPresenter.new(c) }
    ServiceSupport::AssignDisplayDepth.assign_depth(decorated_owner.display_comments, starting_display_depth)
    decorated_owner
  end

  private

  attr_reader :older_than, :newer_than, :display_depth, :displayed_count

  def comments
    if older_than
      load_previous
    elsif newer_than
      load_newer
    else
      load_initial
    end
  end

  def load_previous
    previous_comments
  end

  def load_newer
    later_comments
  end

  def load_initial
    owner.comments.newest.limit(limit).includes(:user).reverse
  end

  def decorated_owner
    @decorated_owner ||= if owner.is_a? Post
                           PostPresenter.new(owner, { displayed_count: displayed_count })
                         else
                           CommentPresenter.new(owner,
                                                { displayed_count: displayed_count, display_depth: display_depth })
                         end
  end

  def starting_display_depth
    if owner.is_a? Post
      DEFAULT_DISPLAY_DEPTH
    else
      display_depth
    end
  end

  def comment_owner
    if comment_id
      Comment.find(comment_id)
    else
      Post.find(post_id)
    end
  end

  def previous_comments
    owner.comments
         .where('created_at < ?', oldest_comment.created_at)
         .newest
         .limit(limit)
         .includes(:user)
         .reverse
  end

  def later_comments
    owner.comments
         .where('created_at > ?', newest_comment.created_at)
         .oldest
         .limit(limit)
         .includes(:user)
         .reverse
  end
end
