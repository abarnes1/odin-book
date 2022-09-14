require_relative 'comments_cache'

class UserFeed
  attr_reader :user, :limit

  def initialize(user, post_count: 5)
    @user = user
    @limit = post_count
  end

  def posts
    @posts ||= fetch_posts(limit: limit, offset: 0)
  end

  def comments_cache
    @comments_cache ||= CommentsCache.for(posts)
  end

  private

  def post_ids
    @post_ids ||= posts.map(&:id)
  end

  def fetch_posts(limit: 5, offset: 0)
    Post.newest
        .joins(:user)
        .where(user_id: user.friends.map(&:id) << user.id)
        .limit(limit)
        .offset(offset)
  end
end
