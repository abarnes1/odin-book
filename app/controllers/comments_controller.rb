class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @comments = load_previous
    puts "#{params[:displayed_count]} COMMENTS ALREADY DISPLAYED"
    puts "#{@comments.size} COMMENTS LOADED"
    post = @comments.first.post
    @displayed_count = params[:displayed_count].to_i + @comments.size
    @remaining_count = post.comments_count - @displayed_count
    puts "#{@remaining_count} COMMENTS REMAIN"

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
end
