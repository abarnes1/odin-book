class CommentPresenter < CommentablePresenterBase
  MAX_DISPLAY_DEPTH = 2

  def initialize(comment, options = {})
    super(comment, options)
    @display_depth = Integer(options.fetch(:depth, nil), exception: false)
  end

  attr_accessor :display_depth

  def comment_id
    id
  end

  def child_display_depth
    display_depth + 1
  end

  def max_display_depth?
    return false if display_depth.nil?

    display_depth >= MAX_DISPLAY_DEPTH
  end

  def displayable?
    return true if display_depth.nil?

    display_depth <= MAX_DISPLAY_DEPTH
  end

  def load_comments_link_text
    if max_display_depth?
      "\u2937 Continue Conversation"
    else
      "\u2937 View Previous Replies (#{not_displayed_comments_count} Remain)"
    end
  end

  def container_id(label)
    return super(label) unless label == :comment_form

    # If comment has an id it should interact with its own form.
    # Otherwise, it is a new comment and the form belongs to
    # the parent commentable.
    if id?
      super(label)
    elsif parent_comment_id?
      "#{__getobj__.class.name.downcase}_#{parent_comment_id}_#{label}"
    else
      "post_#{post.id}_#{label}"
    end
  end

  def load_comments_link_indent_pixels
    indent_pixels + 32
  end

  def indent_pixels
    if display_depth.positive?
      display_depth * 32
    else
      0
    end
  end

  def avatar_size
    24
  end

  def load_comments_params
    { comment_id: id,
      depth: display_depth,
      oldest: oldest_display_comment_id }
  end
end
