class CommentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @comment = Comment.new(comment_params)
    # @comment = current_user.comments.build(comment_params)
  end

  def create
    @comment = current_user.comments.build(comment_params)

    if @comment.save
      flash[:alert] = 'Comment Creation Success'
      redirect_to posts_path
    else
      flash[:alert] = 'Comment Creation Error'
      # figure out how to render only the comment form
      # render :new, status: :unprocessable_entity

      redirect_to posts_path
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.remove_message
    comment.save

    redirect_to posts_path
  end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :parent_comment_id, :message)
  end
end
