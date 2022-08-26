class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy, inverse_of: :post
  has_many :comments, dependent: :destroy, inverse_of: :post
  has_many :top_level_comments, -> { top_level }, class_name: 'Comment', dependent: :destroy

  validates :content, presence: true

  def user_like(user)
    likes.find { |like| like.user_id == user.id }
  end

  def liked_by?(user)
    !!user_like(user)
  end
end
