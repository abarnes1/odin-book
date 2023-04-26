# frozen_string_literal: true

# Adds the ability to "like" a model.
module Likeable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :likeable, dependent: :destroy, inverse_of: :likeable

    def liked_by?(user)
      likes.any? { |like| like.user_id == user.id }
    end
  end
end
