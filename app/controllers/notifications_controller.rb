class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_authorization, only: %i[update destroy]

  def index
    @notifications = filter(index_base_relation, filter_params)

    respond_to do |format|
      format.turbo_stream
      format.html { unsupported_format }
    end
  end

  def update
    if notification.update(notification_params)
      respond_to do |format|
        format.html { unsupported_format }

        format.turbo_stream do
          flash.now[:notice] = 'Notification Updated'
          render :update
        end
      end
    end
  end

  def destroy
    if notification.destroy
      respond_to do |format|
        format.html { unsupported_format }

        format.turbo_stream do
          flash.now[:notice] = 'Notification Removed'
          render :destroy
        end
      end
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:acknowledged)
  end

  def check_authorization
    head :unauthorized unless notification.user == current_user
  end

  def notification
    @notification ||= Notification.find(params[:id])
  end

  def unsupported_format
    flash[:alert] = 'Not Supported'
    redirect_back(fallback_location: feed_path)
  end

  def index_base_relation
    current_user.notifications.newest.limit(10).includes(
      [
        notifiable:
        [
          :user,                    # user being notified
          :sender,                  # friendship request
          {
            post: [:user],          # posts
            parent_comment: [:user] # comments
          }
        ]
      ]
    )
  end

  def filter_params
    params.permit(filters: [:unread])
  end

  def filter(relation, filter_params)
    return relation if filter_params.empty?

    if filter_params[:filters][:unread] == 'true'
      relation.unacknowledged
    else
      relation
    end
  end
end
