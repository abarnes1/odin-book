class LoadFeedPosts
  attr_reader :user, :post_count, :page, :comment_tiers, :comments_per_tier

  DEFAULT_POST_COUNT = 5
  DEFAULT_COMMENT_TIERS = 3
  DEFAULT_COMMENTS_PER_TIER = 3

  def initialize(user, params = {})
    @user = user
    @post_count = params.fetch(:post_count, DEFAULT_POST_COUNT).to_i
    @page = params.fetch(:page, 1).to_i - 1
    @comment_tiers = params.fetch(:comment_tiers, DEFAULT_COMMENT_TIERS).to_i
    @comments_per_tier = params.fetch(:comments_per_tier, DEFAULT_COMMENTS_PER_TIER).to_i
  end

  def load
    posts = feed_posts.to_a
    cache = CommentsCacheFactory.create_for(posts, comment_tiers, comments_per_tier)

    posts = posts.map { |p| PostPresenter.new(p) }
    posts.each do |post|
      AttachDisplayCommentsFromCache.attach(post, cache)
      assign_depth(post.display_comments)
    end

    posts
  end

  private

  def assign_depth(comments, depth = 0)
    comments.each do |comment|
      comment.display_depth = depth
      assign_depth(comment.display_comments, depth + 1)
    end

    comments
  end

  def feed_posts
    Post.includes(:user, likes: [:user])
        .joins(:user)
        .where(user_id: user.friends.map(&:id) << user.id)
        .newest
        .limit(post_count)
        .offset(page * post_count)
  end
end