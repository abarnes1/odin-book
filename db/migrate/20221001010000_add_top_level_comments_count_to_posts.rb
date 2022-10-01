class AddTopLevelCommentsCountToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :top_level_comments_count, :integer
  end
end
