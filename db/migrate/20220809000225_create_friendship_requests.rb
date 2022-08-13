class CreateFriendshipRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :friendship_requests do |t|
      t.references :sender, null: false, index: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, index: false, foreign_key: { to_table: :users }
      t.index %i[sender_id recipient_id], unique: true
      t.index %i[recipient_id sender_id], unique: true
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
         CREATE TYPE friendship_request_status AS ENUM ('pending', 'accepted')
        SQL

        add_column :friendship_requests, :status, :friendship_request_status
      end

      dir.down do
        remove_column :friendship_requests, :status

        execute <<-SQL
          DROP TYPE friendship_request_status
        SQL
      end
    end

    add_index :friendship_requests, :status
  end
end
