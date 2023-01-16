class FriendshipRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_authorization, only: %i[destroy]

  def create
    request = current_user.sent_friend_requests.build(recipient_id: params[:friend_id])

    if request.save
      flash[:notice] = 'Friend Request Sent'
      # send notification to recipient here
    else
      flash[:alert] = 'Request Failed'
    end

    redirect_back(fallback_location: users_path)
  end

  def destroy
    if friend_request.destroy
      flash[:notice] = friend_request.status == 'pending' ? 'Request Cancelled' : 'Friend Removed'
      # delete sent notification if it exists?
    else
      flash[:alert] = 'Request Failed'
    end

    redirect_back(fallback_location: users_path)
  end

  def update
    if friend_request.update(status: 'accepted')
      flash[:notice] = 'Request Accepted'
    else
      flash[:alert] = 'Request Failed'
    end

    redirect_back(fallback_location: users_path)
  end

  private

  def friend_request
    @friend_request ||= FriendshipRequest.where(sender: current_user, recipient: params[:friend_id]).or(
      FriendshipRequest.where(sender: params[:friend_id], recipient: current_user)
    ).first
  end

  def check_authorization
    head :unauthorized unless friend_request.sender == current_user || friend_request.recipient == current_user
  end
end
