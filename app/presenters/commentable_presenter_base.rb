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

  def container_id(label)
    "#{__getobj__.class.name.downcase}_#{id}_#{label}"
  end
end
