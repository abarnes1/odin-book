class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    if likeable.likes.create(user: current_user)
      respond_to do |format|
        format.turbo_stream { render :update, locals: { likeable: likeable_presenter } }
        format.html { redirect_to feed_path, alert: 'Liked!' }
      end
    else
      flash[:alert] = 'Like Failed'
    end
  end

  def destroy
    if like.destroy
      respond_to do |format|
        format.turbo_stream { render :update, locals: { likeable: likeable_presenter } }
        format.html { redirect_to feed_path, alert: 'Unliked!' }
      end
    else
      flash[:alert] = 'Unlike Failed'
    end
  end

  private

  def user_owns_like?
    like.user == current_user
  end
end
