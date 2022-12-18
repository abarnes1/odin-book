class Comment < ApplicationRecord
  include Likeable

  after_create :update_counter_caches
  after_destroy :update_counter_caches

  belongs_to :user, inverse_of: :comments
  belongs_to :post, inverse_of: :comments

  has_many :comments, class_name: 'Comment', foreign_key: 'parent_comment_id'
  belongs_to :parent_comment, class_name: 'Comment', foreign_key: 'parent_comment_id', optional: true,
                              counter_cache: true

  validates :message, presence: true

  scope :newest, -> { order(created_at: :desc) }
  scope :oldest, -> { order(:created_at) }
  scope :top_level, -> { where(parent_comment_id: nil) }

  def top_level?
    parent_comment_id.nil?
  end

  def owner
    if top_level?
      post
    else
      parent_comment
    end
  end

  private

  def update_counter_caches
    post.update_comment_counters
  end
end
