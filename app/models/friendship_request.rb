class FriendshipRequest < ApplicationRecord
  enum status: { pending: 'pending', accepted: 'accepted' }

  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  scope :sent_by, ->(user) { where(sender_id: user.id) }
  scope :received_by, ->(user) { where(recipient_id: user.id) }
end
