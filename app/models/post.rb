class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy, inverse_of: :post

  has_many :comments, -> { top_level }, class_name: 'Comment', dependent: :destroy, inverse_of: :post
  has_many :all_comments, dependent: :destroy, class_name: 'Comment', inverse_of: :post

  scope :newest, -> { order(created_at: :desc) }

  validates :content, presence: true

  def user_like(user)
    likes.find { |like| like.user_id == user.id }
  end

  def liked_by?(user)
    !!user_like(user)
  end

  def update_counters
    self.total_comments_count = all_comments.count
    self.comments_count = comments.count
    save
  end
end
