class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_authorization, only: %i[update destroy]

  def index
    notifications_relation = filter(index_base_relation, filter_params)

    @pagination = Pagination::RelationPagination.new(notifications_relation)
    @notifications = @pagination.page(1)
    @filters = filter_params

    respond_to do |format|
      format.turbo_stream
      format.html { unsupported_format }
    end
  end

  def update
    if notification&.update(notification_params)
      respond_to do |format|
        format.html { unsupported_format }

        format.turbo_stream do
          flash.now[:notice] = 'Notification Updated'
          render :update
        end
      end
    else
      flash[:alert] = 'Mysterious Error'
      redirect_back(fallback_location: feed_path)
    end
  end

  def destroy
    if notification&.destroy
      respond_to do |format|
        format.html { unsupported_format }

        format.turbo_stream do
          flash.now[:notice] = 'Notification Removed'
          render :destroy
        end
      end
    else
      flash[:alert] = 'Mysterious Error'
      redirect_back(fallback_location: feed_path)
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:acknowledged)
  end

  def check_authorization
    head :unauthorized if notification && notification.user != current_user
  end

  def notification
    @notification ||= Notification.find_by_id(params[:id])
  end

  def unsupported_format
    flash[:alert] = 'Not Supported'
    redirect_back(fallback_location: feed_path)
  end

  def index_base_relation
    current_user.notifications.newest.includes(
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
    @filter_params ||= params.permit(:page, filters: %i[unread oldest])
  end

  def filter(relation, filter_params)
    return relation unless filter_params[:filters].present?

    filter_params[:filters].each_pair do |key, value|
      case key.to_sym
      when :unread
        relation = relation.unacknowledged if value == 'true'
      when :oldest
        relation = relation.where('id < ?', value)
      end
    end

    relation
  end
end
