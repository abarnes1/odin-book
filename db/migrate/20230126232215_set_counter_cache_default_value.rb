class SetCounterCacheDefaultValue < ActiveRecord::Migration[7.0]
  def change
    change_column_default(:comments, :comments_count, from: nil, to: 0)
    change_column_default(:comments, :likes_count, from: nil, to: 0)

    change_column_default(:posts, :comments_count, from: nil, to: 0)
    change_column_default(:posts, :total_comments_count, from: nil, to: 0)
    change_column_default(:posts, :likes_count, from: nil, to: 0)
  end
end
