class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @comments = 
      if params[:id].present?
        load_previous
      else
        load_initial
      end

    @depth = params[:depth].present? ? params[:depth].to_i : 0
    commentable =
      if @comments.first.top_level?
        @comments.first.post
      else
        @comments.first.parent_comment
      end

    @displayed_count = params[:displayed_count].to_i + @comments.size
    @remaining_count = commentable.comments_count - @displayed_count

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

  def show
    @comment = Comment.find(params[:id])
  end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :parent_comment_id, :message)
  end

  def load_previous_params
    params.permit(:post_id, :comment_id)
  end

  def load_previous
    current_oldest_visible_comment = Comment.find(params[:id])

    Comment.previous(current_oldest_visible_comment)
  end

  def load_initial
    parent_comment = Comment.find(params[:parent_comment_id])
    parent_comment.comments.newest.limit(5).reverse
  end
end
