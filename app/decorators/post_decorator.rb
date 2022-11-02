class PostDecorator < SimpleDelegator
  include DisplayableComments

  def initialize(post)
    super
    @post = post
  end

  def __getobj__
    @post
  end
end