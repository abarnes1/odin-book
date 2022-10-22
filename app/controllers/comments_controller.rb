class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @comments =
      if params[:older_than].present?
        load_previous
      else
        load_initial
      end.map { |c| c.extend DisplayableComments }

    @depth = params[:depth].present? ? params[:depth].to_i : 0
    owner = comment_owner(@comments.first)

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

  def comment_owner(comment)
    if comment.top_level?
      comment.post
    else
      comment.parent_comment
    end
  end

  def comment_params
    params.require(:comment).permit(:post_id, :parent_comment_id, :message)
  end

  def load_previous
    current_oldest_visible_comment = Comment.find(params[:older_than])

    Comment.previous(current_oldest_visible_comment)
  end

  def load_initial
    parent_comment = Comment.find(params[:parent_comment])
    parent_comment.comments.newest.limit(5).reverse
  end
end
