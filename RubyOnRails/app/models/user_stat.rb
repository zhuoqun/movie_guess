class UserStat < ActiveRecord::Base
  attr_accessible :retweet_cnt, :answer_cnt, :correct_answer_cnt, :create_cnt, :experience, :extra1, :extra2, :extra3, :extra4, :extra5, :fav_cnt, :follow_cnt, :follower_cnt, :last_login, :login_cnt, :medal, :recommender, :reported_cnt, :user_id, :viewed_cnt, :wealth

  validates :retweet_cnt, :answer_cnt, :correct_answer_cnt, :create_cnt, :experience, :fav_cnt, :follow_cnt, :follower_cnt, :login_cnt, :medal, :reported_cnt, :viewed_cnt, :wealth, :numericality => { :only_integer => true }

  belongs_to :user
end
