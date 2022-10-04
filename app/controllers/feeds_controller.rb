class FeedsController < ApplicationController
  def show
    @posts = Feed::UserFeedFactory.for_user(current_user).posts
  end
end