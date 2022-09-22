module Feed
  class FeedPost
    attr_reader :comments, :content, :created_at, :id, :user

    def initialize(post, comments, user)
      @created_at = post.created_at
      @id = post.id
      @content = post.content
      @user = user
      @comments = comments
    end
  end
end