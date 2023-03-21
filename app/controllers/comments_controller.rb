class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_authorization, only: %i[edit update]
  after_action :broadcast_notification, only: 

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
      @commentable = LoadComments.new(comment_id: comment.parent_comment_id, post_id: comment.post_id,
                                      limit: 0, depth: comment.display_depth - 1).load

      @commentable.display_comments = comment

      Notification.create(user: @commentable.user, notifiable_id: comment.id, notifiable_type: 'Comment')
      NotificationChannel.broadcast_to(@commentable.user, count: 1)

      respond_to do |format|
        format.html do
          flash[:notice] = 'Comment Created'
          redirect_to comment_path(comment.parent_comment_id)
        end
        format.turbo_stream do
          flash.now[:notice] = 'Comment Created'
          render 'commentable/add_comment'
        end
      end
    else
      flash.now[:alert] = 'Comment Creation Failed'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    respond_to do |format|
      format.html do
        redirect_to comment_path(comment)
      end

      format.turbo_stream do
        @comment = CommentPresenter.new(Comment.find(params[:id]), display_params)
      end
    end
  end

  def update
    @comment = CommentPresenter.new(Comment.find(params[:id]), display_params)

    if @comment.update(comment_params)
      respond_to do |format|
        format.html do
          flash[:notice] = 'Comment Updated'
          redirect_to comment_path(@comment)
        end

        format.turbo_stream do
          flash.now[:notice] = 'Comment Updated'
          render :update
        end
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
    params.require(:comment).permit(:post_id, :parent_comment_id, :message, :soft_deleted)
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
