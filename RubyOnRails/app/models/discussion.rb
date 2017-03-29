class Discussion < ActiveRecord::Base
  attr_accessible :content, :disable, :extra1, :extra2, :extra3, :extra4, :puzzle_id, :user_id

  acts_as_votable

  default_scope where('disable = ?', false)

  validates :user_id, :puzzle_id, :content, :presence => true

  belongs_to :puzzle
  belongs_to :user
end
