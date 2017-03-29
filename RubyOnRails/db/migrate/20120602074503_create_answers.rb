class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :puzzle_id
      t.string :user_id
      t.string :content
      t.string :comment_cnt, :default => '0'
      t.boolean :is_best, :default => false
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
