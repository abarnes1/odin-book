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

  def comments_container_id
    "#{__getobj__.class.name.downcase}_#{id}_comments"
  end

  def load_comments_link_id
    "#{__getobj__.class.name.downcase}_#{id}_load_comments"
  end
end