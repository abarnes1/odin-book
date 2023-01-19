class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_authorization, only: %i[edit update destroy]

  def load
    @commentable = LoadComments.new(load_comments_params).load

    respond_to do |format|
      format.turbo_stream { render 'commentable/load' }
      format.html { redirect_to feed_path }
    end
  end

  def new
    @comment = CommentPresenter.new(Comment.new(comment_params), display_params)
    respond_to do |format|
      format.html { render :new }
      format.turbo_stream { render :new }
    end
  end

  def create
    comment = CommentPresenter.new(current_user.comments.build(comment_params), display_params)
    if comment.save
      # LoadCommnents works but probably does too much, maybe can do something like
      # CommentablePresenterFactory.build(comment.owner, presenter_params) instead
      @commentable = LoadComments.new(comment_id: comment.parent_comment_id, post_id: comment.post_id,
                                      limit: 0, depth: comment.display_depth - 1).load

      @commentable.display_comments = comment

      flash[:notice] = 'Comment Created'

      respond_to do |format|
        format.html { redirect_to comment_path(comment.parent_comment_id) }
        format.turbo_stream { render 'commentable/add_comment' }
      end
    else
      flash.now[:alert] = 'Comment Creation Failed'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @comment = CommentPresenter.new(Comment.find(params[:id]))
  end

  def update
    @comment = CommentPresenter.new(Comment.find(params[:id]))

    if @comment.update(comment_params)
      flash[:notice] = 'Comment Updated'

      respond_to do |format|
        format.html { redirect_to comment_path(@comment) }
        format.turbo_stream { render :update }
      end
    else
      flash.now[:alert] = 'Comment Update Failed'
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    comment = Comment.find(params[:id])
    @post = PostPresenter.new(comment.post)
    @post.display_comments = LoadComments.new(comment_id: comment.id).load

    render 'show', locals: { post: @post }
  end

  private

  def load_comments_params
    params.permit(:post_id, :comment_id, :oldest, :depth)
  end

  def comment_params
    params.require(:comment).permit(:post_id, :parent_comment_id, :message)
  end

  def display_params
    params.require(:display).permit(:depth)
  end

  def comment
    @comment ||= Comment.find(params[:id])
  end

  def check_authorization
    head :unauthorized unless comment.user == current_user
  end
end
