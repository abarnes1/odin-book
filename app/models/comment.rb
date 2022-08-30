class Comment < ApplicationRecord
  belongs_to :user, inverse_of: :comments
  belongs_to :post, inverse_of: :comments

  has_many :comments, class_name: 'Comment', foreign_key: 'parent_comment_id'
  belongs_to :parent_comment, class_name: 'Comment', foreign_key: 'parent_comment_id', optional: true

  validates :message, presence: true

  def top_level?
    parent_comment_id.nil?
  end
end