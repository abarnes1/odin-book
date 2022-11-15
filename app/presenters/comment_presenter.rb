class CommentPresenter < SimpleDelegator
  include DisplayableComments

  attr_accessor :display_depth

  def initialize(comment, options = {})
    super(comment)
    @comment = comment
    @display_depth = options.fetch(:display_depth, 0).to_i
    @already_displayed_comments_count = options.fetch(:displayed_count, 0).to_i
  end

  def __getobj__
    @comment
  end

  def comment_id
    id
  end

  def display_comments_turbo_method
    :append
  end

  def max_display_depth?
    display_depth >= 2
  end

  def load_comments_link_text
    if max_display_depth?
      "\u2937 Continue Conversation"
    else
      "\u2937 #{not_displayed_comments_count} More Replies"
    end
  end

  def comments_container_id
    "#{__getobj__.class.name.downcase}_#{id}_comments"
  end

  def load_comments_link_id
    "#{__getobj__.class.name.downcase}_#{id}_load_comments"
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
