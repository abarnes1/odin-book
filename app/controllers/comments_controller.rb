class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @comments = CommentsLoader.load(load_comments_params)

    @depth = params[:depth].present? ? params[:depth].to_i : 0
    owner = @comments.first.owner

    @displayed_count = params[:displayed_count].to_i + @comments.size
    @remaining_count = owner.comments_count - @displayed_count

    respond_to do |format|
      format.turbo_stream
      format.html
    end
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
    params.permit(:older_than, :parent_comment)
  end

  def comment_params
    params.require(:comment).permit(:post_id, :parent_comment_id, :message)
  end
end
