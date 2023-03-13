class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.limit(10)

    # works but can't reach beyond notifiable
    # preloader = ActiveRecord::Associations::Preloader.new(
    #   records: [@notifications].flatten,
    #   associations: :notifiable
    # ).call
    
    preloader = ActiveRecord::Associations::Preloader.new(
      records: [@notifications].flatten,
      # associations: [notifiable: [:user]]
      associations: [notifiable: [:user, owner: [:user]]]
    ).call
  end
end