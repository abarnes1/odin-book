class Like < ApplicationRecord
  belongs_to :user, inverse_of: :likes
  belongs_to :likeable, polymorphic: true, counter_cache: :likes_count
end
