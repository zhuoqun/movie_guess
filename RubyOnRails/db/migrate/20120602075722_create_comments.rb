class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :answer_id
      t.string :user_id
      t.string :content
      t.boolean :disable, :default => false
      t.string :extra1
      t.string :extra2
      t.string :extra3
      t.string :extra4
      t.string :extra5

      t.timestamps
    end
  end
end
