class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    user_relation = filter.order(:username)

    pagination = Pagination::RelationPagination.new(user_relation)

    @users = pagination.page(page)
    @page_ranges = pagination.page_ranges
  end

  def show
    @user = User.find(params[:id])
    @post = PostPresenter.new(@user.posts.last) unless @user.posts.last.nil?
    @comment = CommentPresenter.new(@user.comments.last, { depth: 0 }) unless @user.comments.last.nil?
  end

  private

  def page
    return 1 unless params[:page].present?

    params[:page].to_i
  end

  def filter
    filter = params[:filter]

    if filter == 'sent'
      current_user.sent_friend_request_users
    elsif filter == 'received'
      current_user.received_friend_request_users
    else
      User.where.not(id: current_user.id)
    end
  end
end
