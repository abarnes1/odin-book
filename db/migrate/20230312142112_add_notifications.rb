class AddNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :participant, null: false, foreign_key: { to_table: :users }
      t.references :notifiable, polymorphic: true, null: false
      t.boolean :acknowledged, null: false, default: false

      t.timestamps
    end
  end
end
