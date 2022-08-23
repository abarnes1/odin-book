class CommentsController < ApplicationController
  def new
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.build(comment_params)

    if @comment.save
      flash[:alert] = 'Post Creation Success'
      redirect_to posts_path
    else
      flash[:alert] = 'Post Creation Error'
      # figure out how to render only the comment form
      # render :new, status: :unprocessable_entity

      redirect_to posts_path
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :parent_comment_id, :message)
  end
end