class FeedsController < ApplicationController
  before_action :authenticate_user!

  def show
    @posts = UserFeedFactory.for_user(current_user).posts
  end
end