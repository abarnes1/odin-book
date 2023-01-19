class Users::PostsController < PostsController
  def index
    @user = User.find(params[:user_id])
    @posts = @user.posts.map { |post| PostPresenter.new(post) }
  end
end