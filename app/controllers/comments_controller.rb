class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    #place holder, may use for user comments
  end

  def load
    @commentable = LoadComments.new(load_comments_params).load
  end

  def new
    @comment = Comment.new(comment_params)
  end

  def create
    @comment = current_user.comments.build(comment_params)

    if @comment.save
      flash[:alert] = 'Comment Creation Success'
      redirect_to feed_path
    else
      flash.now[:alert] = 'Comment Creation Error'
      render :new, status: :unprocessable_entity
    end
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

  def show
    @comment = Comment.find(params[:id])
  end

  private

  def load_comments_params
    params.permit(:post_id, :comment_id, :older_than, :displayed_count, :display_depth)
  end

  def comment_params
    params.require(:comment).permit(:post_id, :parent_comment_id, :message)
  end
end
