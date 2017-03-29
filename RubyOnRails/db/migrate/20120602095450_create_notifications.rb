class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :user_id
      t.string :action
      t.string :target_type
      t.string :target_id
      t.string :contact_id
      t.boolean :is_viewed, :default => false
      t.string :extra1
      t.string :extra2
      t.string :extra3
      t.string :extra4
      t.string :extra5

      t.timestamps
    end
  end
end
