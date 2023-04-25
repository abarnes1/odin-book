class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_authorization, only: %i[destroy]

  def create
    if likeable.likes.create(user: current_user)
      flash.now[:notice] = 'Liked!'
      render :create, locals: { likeable: likeable_presenter }
    else
      flash.now[:alert] = 'Like Failed'
      render_flash_turbo
    end
  end

  def destroy
    if like.destroy
      flash.now[:notice] = 'Unliked!'
      render :destroy, locals: { likeable: likeable_presenter }
    else
      flash[:alert].now = 'Unlike Failed'
      render_flash_turbo
    end
  end

  private

  def check_authorization
    head :unauthorized unless like.user == current_user
  end
end
