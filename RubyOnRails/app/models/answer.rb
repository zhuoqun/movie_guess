class Answer < ActiveRecord::Base
  attr_accessible :comment_cnt, :content, :disable, :extra1, :extra2, :extra3, :extra4, :extra5, :is_best, :puzzle_id, :user_id

  acts_as_votable

  default_scope where('disable = ?', false)
  scope :correct, where('is_best = ?', true)

  validates :user_id, :puzzle_id, :content, :presence => true

  belongs_to :puzzle, :foreign_key => 'puzzle_id'
  belongs_to :user
  has_many   :comments
end
