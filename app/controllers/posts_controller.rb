class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_authorization, only: %i[edit update]

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
    @post = Post.find(params[:id])
  end

  def update
    @post = PostPresenter.new(post)

    if @post.update(post_params)
      respond_to do |format|
        format.html do
          flash[:notice] = 'Post Updated'
          redirect_to @post
        end

        format.turbo_stream do
          flash.now[:notice] = 'Post Updated'
          render :update
        end
      end
    else
      flash.now[:alert] = 'Post Update Failed'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:content, :soft_deleted)
  end

  def check_authorization
    head :unauthorized unless post.user == current_user
  end

  def post
    @post ||= Post.find(params[:id])
  end
end
