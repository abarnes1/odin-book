class Notification < ApplicationRecord
  include Pageable

  belongs_to :user, inverse_of: :notifications
  belongs_to :notifiable, polymorphic: true

  scope :newest, -> { order(created_at: :desc) }
  scope :unacknowledged, -> { where(acknowledged: false) }
end
