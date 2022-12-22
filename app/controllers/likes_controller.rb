class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    if likeable.likes.create(user: current_user)
      respond_to do |format|
        format.turbo_stream do
          likeable_presenter =
            if likeable.is_a? Post
              PostPresenter.new(likeable)
            else
              CommentPresenter.new(likeable)
            end

          render :update_counters, locals: { likeable: likeable_presenter }
        end
        format.html { redirect_to feed_path, alert: 'Liked!' }
      end
    else
      flash[:alert] = 'Like Failed'
    end
  end

  def destroy
    if like.destroy
      respond_to do |format|
        format.turbo_stream do
          likeable_presenter =
            if likeable.is_a? Post
              PostPresenter.new(likeable)
            else
              CommentPresenter.new(likeable)
            end

          render :update_counters, locals: { likeable: likeable_presenter }
        end
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
