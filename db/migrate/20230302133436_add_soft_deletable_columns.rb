class AddSoftDeletableColumns < ActiveRecord::Migration[7.0]
  def change
    add_column(:posts, :soft_deleted, :boolean, null: false, default: false)
    add_column(:comments, :soft_deleted, :boolean, null: false, default: false)
  end
end
