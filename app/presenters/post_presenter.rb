class PostPresenter < SimpleDelegator
  attr_accessor :display_depth

  def initialize(post)
    super
    @post = post
  end
end
