class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = current_user.posts.includes(
      likes: [:user],
      comments: [:user]
    )
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:alert] = 'Post Creation Success'
      redirect_to feed_path
    else
      flash.now[:alert] = 'Post Creation Error'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # todo: Maybe load *some* nested comments through service object and/or CommentsCache?
    @post = LoadComments.new(post_id: params[:id]).load
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
