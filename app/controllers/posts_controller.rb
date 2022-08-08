class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = current_user.posts
  end

  def new
    # @post = current_user.posts.build
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:alert] = 'Post Creation Success'
      redirect_to posts_path
    else
      flash.now[:alert] = 'Post Creation Error'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
