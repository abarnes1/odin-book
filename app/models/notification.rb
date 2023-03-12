class Notification < ApplicationRecord
  belongs_to :user, inverse_of: :notifications
  belongs_to :participant, class_name: 'User'
  belongs_to :notifiable, polymorphic: true
end
