class CreateUserRelations < ActiveRecord::Migration
  def change
    create_table :user_relations do |t|
      t.string :user_id
      t.string :contact_id
      t.integer :relation_code_id
      t.string :extra1
      t.string :extra2
      t.string :extra3
      t.string :extra4
      t.string :extra5

      t.timestamps
    end
  end
end
