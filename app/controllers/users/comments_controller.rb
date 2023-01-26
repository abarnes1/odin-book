class Users::CommentsController < CommentsController
  def index
    @user = User.find(params[:user_id])
    @comments = @user.comments
                     .includes(post: :user, parent_comment: :user)
                     .map { |comment| CommentPresenter.new(comment, { depth: 0 }) }
  end
end
