class FriendsController < ApplicationController
  before_action :authenticate_user!

  def index
    friends_relation = current_user.friends.order(:username)
    pagination = Pagination::RelationPagination.new(friends_relation)

    @friends = pagination.page(page)
    @page_ranges = pagination.page_ranges
  end

  private

  def page
    return 1 unless params[:page].present?

    params[:page].to_i
  end
end
