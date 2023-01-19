class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.where.not(id: current_user.id).order(:username)
  end

  def show
    @user = User.find(params[:id])
    @post = PostPresenter.new(@user.posts.last)
    @comment = CommentPresenter.new(@user.comments.last, { depth: 0 })
  end
end
