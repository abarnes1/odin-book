class CommentPresenter < SimpleDelegator
  attr_reader :already_displayed_count
  attr_accessor :display_depth

  def initialize(comment, options = {})
    super(comment)
    @comment = comment
    @display_depth = options[:depth].present? ? options[:depth].to_i : 0
    @already_displayed_count = options[:displayed_count].present? ? options[:displayed_count].to_i : 0
  end

  def not_displayed_comments_count
    super - already_displayed_count
  end

  def __getobj__
    @comment
  end
end
