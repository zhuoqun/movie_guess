class CreatePuzzles < ActiveRecord::Migration
  def change
    create_table :puzzles do |t|
      t.string :puzzle_type
      t.string :image
      t.string :lines
      t.string :user_id
      t.string :answer_cnt, :default => '0'
      t.string :fav_cnt, :default => '0'
      t.string :retweet_cnt, :default => '0'
      t.string :reference
      t.string :price
      t.string :desc
      t.boolean :has_best_answer, :default => false
      t.boolean :disable, :default => false
      t.boolean :saved, :default => false
      t.string :extra1
      t.string :extra2
      t.string :extra3
      t.string :extra4
      t.string :extra5

      t.timestamps
    end
  end
end
