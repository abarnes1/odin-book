class PostPresenter < CommentablePresenterBase
  def initialize(post, options = {})
    super(post, options)
  end

  def post_id
    id
  end

  def post
    @commentable
  end

  def comment_id
    nil
  end

  def load_comments_link_text
    "View Previous (#{not_displayed_comments_count} Remain)"
  end

  def load_comments_params
    { oldest: oldest_display_comment_id,
      post_id: id }
  end
end
