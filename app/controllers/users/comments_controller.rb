class Users::CommentsController < CommentsController
  def index
    @user = User.find(params[:user_id])
    comments_relation = @user.comments
                             .newest
                             .includes(post: :user, parent_comment: :user)

    pagination = Pagination::RelationPagination.new(comments_relation)

    @comments = pagination.page(page)
    @page_ranges = pagination.page_ranges
  end

  private

  def page
    return 1 unless params[:page].present?

    params[:page].to_i
  end
end
