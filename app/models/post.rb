class Post < ApplicationRecord
  include DisplayComments

  belongs_to :user
  has_many :likes, dependent: :destroy, inverse_of: :post
  has_many :comments, -> { order('created_at DESC') }, dependent: :destroy, inverse_of: :post

  scope :newest, -> { order(created_at: :desc) }

  validates :content, presence: true

  def user_like(user)
    likes.find { |like| like.user_id == user.id }
  end

  def liked_by?(user)
    !!user_like(user)
  end
end
