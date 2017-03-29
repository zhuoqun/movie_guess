class CreateUserStats < ActiveRecord::Migration
  def change
    create_table :user_stats do |t|
      t.string :user_id
      t.datetime :last_login
      t.integer :login_cnt, :default => 0
      t.string :wealth, :default => '0'
      t.string :experience, :default => '0'
      t.string :medal, :default => '0'
      t.string :recommender, :default => '0'
      t.string :create_cnt, :default => '0'
      t.string :fav_cnt, :default => '0'
      t.string :retweet_cnt, :default => '0'
      t.string :follower_cnt, :default => '0'
      t.string :follow_cnt, :default => '0'
      t.string :reported_cnt, :default => '0'
      t.string :answer_cnt, :default => '0'
      t.string :correct_answer_cnt, :default => '0'
      t.string :viewed_cnt, :default => '0'
      t.string :extra1
      t.string :extra2
      t.string :extra3
      t.string :extra4
      t.string :extra5

      t.timestamps
    end
  end
end
