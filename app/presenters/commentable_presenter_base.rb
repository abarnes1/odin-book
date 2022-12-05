class CommentablePresenterBase < SimpleDelegator
  include DisplayableComments

  def initialize(commentable, options = {})
    super(commentable)
    @commentable = commentable

    # interact with DisplayableComments module
    @displayed_count_override = Integer(options.fetch(:displayed_count, nil), exception: false)
    @not_displayed_count_override = Integer(options.fetch(:not_displayed_count, nil), exception: false)
    @oldest_display_comment_id_override = options[:oldest_comment_id]
  end

  attr_reader :commentable

  def __getobj__
    commentable
  end

  def display_depth
    nil
  end

  def child_display_depth
    0
  end

  def comments_container_id
    "#{__getobj__.class.name.downcase}_#{id}_comments"
  end

  def comments_counter_container_id
    "#{__getobj__.class.name.downcase}_#{id}_comments_counter"
  end

  def load_comments_link_id
    "#{__getobj__.class.name.downcase}_#{id}_load_comments"
  end

  def comment_form_id
    "#{__getobj__.class.name.downcase}_#{id}_comment_form"
  end

  def comment_link_id
    "#{__getobj__.class.name.downcase}_#{id}_comment_link"
  end
end
