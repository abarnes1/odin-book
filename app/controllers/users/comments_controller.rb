class Users::CommentsController < CommentsController
  def index
    @user = User.find(params[:user_id])
    @comments = @user.comments.map { |comment| CommentPresenter.new(comment, { depth: 0 }) }
  end
end
