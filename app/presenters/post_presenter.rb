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
    if display_comments?
      "View Previous (#{not_displayed_comments_count} Remain)"
    else
      "View Comments (#{not_displayed_comments_count})"
    end
  end

  def load_comments_params
    { oldest: oldest_display_comment_id,
      post_id: id }
  end
end
