class CommentPresenter < CommentablePresenterBase
  MAX_DISPLAY_DEPTH = 2
  DEFAULT_DISPLAY_DEPTH = 0

  def initialize(comment, options = {})
    super(comment, options)
    @display_depth = options.fetch(:display_depth, DEFAULT_DISPLAY_DEPTH).to_i
  end

  attr_accessor :display_depth

  def comment_id
    id
  end

  def display_comments_turbo_method
    :append
  end

  def max_display_depth?
    display_depth >= MAX_DISPLAY_DEPTH
  end

  def load_comments_link_text
    if max_display_depth?
      "\u2937 Continue Conversation"
    else
      "\u2937 #{not_displayed_comments_count} More Replies"
    end
  end

  def comment_form_id
    # If comment has an id it should interact with its own form.
    # Otherwise, it is a new comment and the form belongs to
    # the parent commentable.
    if id?
      super
    elsif parent_comment_id?
      "#{__getobj__.class.name.downcase}_#{parent_comment_id}_comment_form"
    else
      "post_#{post.id}_comment_form"
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
end
