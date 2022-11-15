class FeedsController < ApplicationController
  before_action :authenticate_user!

  def show
    @posts = LoadFeedPosts.new(current_user).load
  end
end