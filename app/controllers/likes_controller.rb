class LikesController < ApplicationController
  before_action :authenticate_user! 

  def like
    post = Post.find(params[:post_id])

    post.likes.create(user: current_user)

    redirect_to posts_path(post)
  end

  def unlike
    like = Like.find_by(user: current_user, post: params[:post_id])
    like.destroy

    redirect_to posts_path
  end
end