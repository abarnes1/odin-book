class FriendshipRequest < ApplicationRecord
  enum status: { pending: 'pending', accepted: 'accepted' }

  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
end
