class CreateUserActions < ActiveRecord::Migration
  def change
    create_table :user_actions do |t|
      t.string :user_id
      t.string :puzzle_id
      t.string :action_type
      t.string :extra1
      t.string :extra2
      t.string :extra3
      t.string :extra4
      t.string :extra5

      t.timestamps
    end
  end
end
