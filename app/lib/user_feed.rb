# frozen_string_literal: true

# Represents a user's feed, which is a collection of recent
# posts by the user or the user's friends.
class UserFeed
  attr_reader :posts, :user

  def initialize(user, posts)
    @user = user
    @posts = posts
  end
end
