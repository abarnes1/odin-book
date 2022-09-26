class Comment < ApplicationRecord
  include DisplayComments

  belongs_to :user, inverse_of: :comments
  belongs_to :post, inverse_of: :comments

  has_many :comments, -> { order('created_at DESC') }, class_name: 'Comment', foreign_key: 'parent_comment_id'
  belongs_to :parent_comment, class_name: 'Comment', foreign_key: 'parent_comment_id', optional: true

  # temporary, may remove after benchmarking
  has_many :feed_comments, -> { newest.limit(5) }, class_name: 'Comment', foreign_key: 'parent_comment_id'

  validates :message, presence: true

  scope :newest, -> { order(created_at: :desc) }
  scope :top_level, -> { where(parent_comment_id: nil) }

  def top_level?
    parent_comment_id.nil?
  end
end
