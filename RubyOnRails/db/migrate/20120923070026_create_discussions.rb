class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.string :puzzle_id
      t.string :user_id
      t.text :content
      t.boolean :disable, :default => false
      t.string :extra1
      t.string :extra2
      t.string :extra3
      t.string :extra4

      t.timestamps
    end
  end
end
