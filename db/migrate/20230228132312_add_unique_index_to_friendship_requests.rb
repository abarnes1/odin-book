class AddUniqueIndexToFriendshipRequests < ActiveRecord::Migration[7.0]
  def up
    remove_index :friendship_requests, %i[sender_id recipient_id]
    remove_index :friendship_requests, %i[recipient_id sender_id]

    execute <<-SQL
      CREATE UNIQUE INDEX friendship_requests_sender_id_recipient_id_pair
        ON friendship_requests (LEAST(sender_id, recipient_id), GREATEST(sender_id, recipient_id))
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX IF EXISTS friendship_requests_sender_id_recipient_id_pair
    SQL

    add_index :friendship_requests, %i[sender_id recipient_id], unique: true
    add_index :friendship_requests, %i[recipient_id sender_id], unique: true
  end
end
