class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy, inverse_of: :post
  has_many :comments, dependent: :destroy, inverse_of: :post

  scope :newest, -> { order(created_at: :desc) }

  validates :content, presence: true

  def user_like(user)
    likes.find { |like| like.user_id == user.id }
  end

  def liked_by?(user)
    !!user_like(user)
  end

  # temporary, may remove after benchmarking
  has_many :feed_comments, -> { Comment.top_level.newest.limit(5) }, class_name: 'Comment', inverse_of: :post
end
