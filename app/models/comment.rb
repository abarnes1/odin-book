class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  has_many :comments, class_name: 'Comment', foreign_key: 'parent_comment_id'
  belongs_to :parent_comment, class_name: 'Comment', foreign_key: 'parent_comment_id', optional: true

  scope :top_level, -> { where(parent_comment_id: nil) }

  def remove_message
    self.message = '(deleted comment)'
  end
end
