class Comments::LikesController < LikesController
  private

  def likeable
    @likeable ||= Comment.find(params[:likeable_id])
  end

  def like
    @like ||= Like.find_by(likeable_id: params[:likeable_id], likeable_type: Comment.name, user_id: current_user.id)
  end

  def likeable_presenter
    CommentPresenter.new(likeable)
  end
end
