class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :user_id
      t.string :content_type
      t.string :content
      t.string :reason
      t.boolean :close, :default => false
      t.string :handler
      t.string :extra1
      t.string :extra2
      t.string :extra3
      t.string :extra4
      t.string :extra5

      t.timestamps
    end
  end
end
