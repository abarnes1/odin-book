class Posts::LikesController < LikesController
  private

  def likeable
    @likeable ||= Post.find(params[:likeable_id])
  end

  def like
    @like ||= Like.find_by(likeable_id: params[:likeable_id], likeable_type: Post.name, user_id: current_user.id)
  end
end