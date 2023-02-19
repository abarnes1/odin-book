class Users::PostsController < PostsController
  def index
    @user = User.find(params[:user_id])
    posts_relation = @user.posts.newest

    pagination = Pagination::RelationPagination.new(posts_relation)

    @posts = pagination.page(page).map { |post| PostPresenter.new(post) }
    @page_ranges = pagination.page_ranges
  end

  private

  def page
    return 1 unless params[:page].present?

    params[:page].to_i
  end
end
