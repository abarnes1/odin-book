class PostPresenter < SimpleDelegator
  include DisplayableComments

  attr_accessor :display_depth

  def initialize(post, options = {})
    super(post)
    @post = post
    @already_displayed_comments_count = options.fetch(:displayed_count, 0).to_i
  end

  def __getobj__
    @post
  end

  def post_id
    id
  end

  def comment_id
    nil
  end

  def display_comments_turbo_method
    :prepend
  end

  def comments_container_id
    "#{__getobj__.class.name.downcase}_#{id}_comments"
  end

  def load_comments_link_text
    "View Previous (#{not_displayed_comments_count} Remain)"
  end

  def load_comments_link_id
    "#{__getobj__.class.name.downcase}_#{id}_load_comments"
  end
end