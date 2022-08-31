class CommentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @comment = Comment.new(comment_params)
  end

  def create
    @comment = current_user.comments.build(comment_params)

    flash[:alert] = if @comment.save
                      'Comment Creation Success'
                    else
                      'Comment Creation Error'
                    end

    redirect_to feed_path
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])

    if @comment.update(comment_params)
      flash[:alert] = 'Comment Update Success'
      redirect_to feed_path
    else
      flash[:alert] = 'Comment Update Error'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :parent_comment_id, :message)
  end
end
