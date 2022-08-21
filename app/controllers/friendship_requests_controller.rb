class FriendshipRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.sent_friend_requests.build(recipient_id: params[:friend_id])

    current_user.save

    redirect_to users_path
  end

  def destroy
    request = find_friend_request

    FriendshipRequest.destroy(request.id)

    redirect_to users_path
  end

  def update
    request = find_friend_request

    request.update(status: 'accepted')

    redirect_to users_path
  end

  private

  def find_friend_request
    friend_request = FriendshipRequest.where(sender: current_user, recipient: params[:friend_id]).or(
      FriendshipRequest.where(sender: params[:friend_id], recipient: current_user)
    ).first
  end
end
