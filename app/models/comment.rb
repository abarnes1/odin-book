class Comment < ApplicationRecord
  include DisplayComments

  after_create :update_counter_caches
  after_destroy :update_counter_caches

  belongs_to :user, inverse_of: :comments
  belongs_to :post, inverse_of: :comments
  # belongs_to :post, counter_cache: :top_level_comments_count, inverse_of: :top_level_comments

  has_many :comments, class_name: 'Comment', foreign_key: 'parent_comment_id'
  belongs_to :parent_comment, class_name: 'Comment', foreign_key: 'parent_comment_id', optional: true,
                              counter_cache: true

  validates :message, presence: true

  scope :newest, -> { order(created_at: :desc) }
  scope :top_level, -> { where(parent_comment_id: nil) }

  def top_level?
    parent_comment_id.nil?
  end

  def self.previous(comment, limit = 3)
    Comment.where(post_id: comment.post_id, parent_comment_id: comment.parent_comment_id)
           .where('created_at < ?', comment.created_at)
           .limit(limit)
           .order(:created_at)
  end

  private

  def update_counter_caches
    post.update_counters
  end
end
