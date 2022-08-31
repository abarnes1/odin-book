class LikesController < ApplicationController
  before_action :authenticate_user! 

  def create
    flash[:alert] = if post.likes.create(user: current_user)
                      'Liked!'
                    else
                      'Like Failed'
                    end

    redirect_to feed_path
  end

  def destroy
    flash[:alert] = if like.destroy
                      'Unliked!'
                    else
                      'Unlike Failed'
                    end

    redirect_to feed_path
  end

  private

  def post
    @post ||= Post.find(params[:post_id])
  end

  def like
    @like = Like.find_by(user: current_user, post: params[:post_id])
  end
end
