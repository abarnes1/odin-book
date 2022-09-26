module Feed
  class UserFeed
    attr_reader :posts, :user

    def initialize(user, posts)
      @user = user
      @posts = posts
    end
  end
end
