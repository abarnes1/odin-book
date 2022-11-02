class CommentDecorator < SimpleDelegator
  include DisplayableComments

  def initialize(comment)
    super
    @comment = comment
  end

  def __getobj__
    @comment
  end
end