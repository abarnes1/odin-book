module Feed
  class UserFeed
    attr_reader :posts, :user

    def initialize(user, posts)
      @posts = posts
      @user = user
    end
  end
end
