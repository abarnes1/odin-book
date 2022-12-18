class LikesController < ApplicationController
  before_action :authenticate_user!
  
  def create
    flash[:alert] = if likeable.likes.create(user: current_user)
                      'Liked!'
                    else
                      'Like Failed'
                    end

    redirect_to feed_path
  end

  def destroy
    flash[:alert] = if like.destroy
                      'Unliked!'
                    else
                      'Unlike Failed'
                    end

    redirect_to feed_path
  end
end
