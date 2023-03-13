class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.limit(10)
  end
end