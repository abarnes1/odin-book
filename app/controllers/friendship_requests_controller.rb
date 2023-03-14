class FriendshipRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_destroy_request, only: %i[destroy]
  before_action :validate_create_request, only: %i[create]

  def create
    request = current_user.sent_friend_requests.build(recipient_id: params[:friend_id])

    if request.save
      flash[:notice] = 'Friend Request Sent'
      Notification.create(user: request.recipient, notifiable: request)
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
      # send notification of new friend here
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

  def validate_destroy_request
    if friend_request.nil?
      flash[:alert] = 'Invalid Request'
      redirect_back(fallback_location: users_path)
    end

    check_authorization unless performed?
  end

  def validate_create_request
    return unless friend_request

    flash[:alert] = 'Invalid Request'
    redirect_back(fallback_location: users_path)
  end

  def check_authorization
    head :unauthorized unless friend_request.sender == current_user || friend_request.recipient == current_user
  end
end
