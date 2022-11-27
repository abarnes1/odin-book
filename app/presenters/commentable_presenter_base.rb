class CommentablePresenterBase < SimpleDelegator
  include DisplayableComments

  def initialize(commentable, options = {})
    super(commentable)
    @commentable = commentable
    @already_displayed_comments_count = options.fetch(:displayed_count, 0).to_i
  end

  attr_reader :commentable

  def __getobj__
    commentable
  end

  def display_depth
    nil
  end

  def comments_container_id
    "#{__getobj__.class.name.downcase}_#{id}_comments"
  end

  def new_comments_container_id
    "#{__getobj__.class.name.downcase}_#{id}_new_comments"
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
end
