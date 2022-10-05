class Post < ApplicationRecord
  include DisplayComments

  belongs_to :user
  has_many :likes, dependent: :destroy, inverse_of: :post
  has_many :top_level_comments, -> { top_level }, class_name: 'Comment', dependent: :destroy, inverse_of: :post
  has_many :comments, dependent: :destroy, inverse_of: :post

  scope :newest, -> { order(created_at: :desc) }

  validates :content, presence: true

  def user_like(user)
    likes.find { |like| like.user_id == user.id }
  end

  def liked_by?(user)
    !!user_like(user)
  end

  def update_counters
    self.total_comments_count = comments.count
    self.comments_count = top_level_comments.count
    save
  end
end
