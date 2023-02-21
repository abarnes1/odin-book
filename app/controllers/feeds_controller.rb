class FeedsController < ApplicationController
  before_action :authenticate_user!

  def show
    posts_relation = current_user.feed_posts
    pagination = Pagination::RelationPagination.new(posts_relation)

    @posts = LoadPostsTieredComments.new(pagination.page(page).to_a).load
    @page_ranges = pagination.page_ranges
  end

  private

  def page
    return 1 unless params[:page].present?

    params[:page].to_i
  end
end
