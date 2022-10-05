class RenamePostCommentCounters < ActiveRecord::Migration[7.0]
  def change
    rename_column(:posts, :comments_count, :total_comments_count)
    rename_column(:posts, :top_level_comments_count, :comments_count)
  end
end
