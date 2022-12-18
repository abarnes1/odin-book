class AddPolymorphicLikeable < ActiveRecord::Migration[7.0]
  def change
    remove_column :likes, :post_id, :bigint
    add_column :likes, :likeable_id, :bigint
    add_column :likes, :likeable_type, :string

    add_index :likes, %i[user_id likeable_id likeable_type], unique: true
    add_column :posts, :likes_count, :integer
    add_column :comments, :likes_count, :integer
  end
end
