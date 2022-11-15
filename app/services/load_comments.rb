# frozen_string_literal: true

# Examine parameters and load the correct unnested comments for display.
class LoadComments
  include AssignDisplayDepth

  attr_reader :limit, :comment_id, :post_id

  def initialize(params = {})
    @post_id = params.fetch(:post_id, nil)
    @older_than = params.fetch(:older_than, nil)
    @comment_id = params.fetch(:comment_id, nil)
    @limit = params.fetch(:limit, 2)
    @displayed_count = params.fetch(:displayed_count, 0).to_i
    @display_depth = params.fetch(:display_depth, 0).to_i
  end

  def owner
    @owner ||= comment_owner
  end

  def oldest_comment
    @oldest_comment ||= Comment.find(older_than)
  end

  def load
    decorated_owner.display_comments = comments.map { |c| CommentPresenter.new(c) }
    decorated_owner.display_comments.each { |c| c.display_depth = starting_display_depth }
    decorated_owner
  end

  def comments
    if older_than
      load_previous
    else
      load_initial
    end
  end

  def load_previous
    previous_comments
  end

  def load_initial
    owner.comments.newest.limit(limit).includes(:user).reverse
  end

  private

  attr_reader :older_than, :display_depth, :displayed_count

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
      0
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
end
