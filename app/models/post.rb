class Post < ApplicationRecord
  include Likeable
  include Pageable

  belongs_to :user

  has_many :comments, -> { top_level }, class_name: 'Comment', dependent: :destroy, inverse_of: :post
  has_many :all_comments, dependent: :destroy, class_name: 'Comment', inverse_of: :post

  scope :newest, -> { order(created_at: :desc) }

  validates :content, presence: true

  def update_comment_counters
    self.total_comments_count = all_comments.count
    self.comments_count = comments.count
    save
  end
end
