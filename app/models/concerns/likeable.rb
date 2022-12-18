module Likeable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :likeable, dependent: :destroy, inverse_of: :likeable

    def liked_by?(user)
      likes.find { |like| like.user_id == user.id }
    end
  end
end