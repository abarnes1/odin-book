class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_authorization, only: %i[edit update]

  def index
    posts = current_user.posts.includes(
      likes: [:user],
      comments: [:user]
    )

    # not great but won't error - should load some comments similar to a feed
    # otherwise n+1 problems OR make smaller posts view with limited info that
    # links to post#show
    @posts = posts.map { |p| PostPresenter.new(p) }
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      flash[:notice] = 'Post Created'
      redirect_to @post
    else
      flash.now[:alert] = 'Post Creation Failed'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = LoadComments.new(post_id: params[:id]).load
  end

  def edit
    # @post = Post.find(params[:id])
    post
  end

  def update
    if post.update(post_params)
      flash[:notice] = 'Post Updated'
      redirect_to @post
    else
      flash[:alert] = 'Post Update Failed'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

  def check_authorization
    return if post.user == current_user

    flash[:alert] = 'Not Authorized'
    redirect_to post_path(post)
  end

  def post
    @post ||= Post.find(params[:id])
  end
end
