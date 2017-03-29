class Comment < ActiveRecord::Base
  attr_accessible :answer_id, :content, :disable, :extra1, :extra2, :extra3, :extra4, :extra5, :user_id

  default_scope where('disable = ?', false).order('created_at DESC')

  validates :user_id, :answer_id, :content, :presence => true

  belongs_to :answer
  belongs_to :user
end
