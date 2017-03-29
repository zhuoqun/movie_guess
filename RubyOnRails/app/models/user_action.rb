class UserAction < ActiveRecord::Base
  attr_accessible :action_type, :extra1, :extra2, :extra3, :extra4, :extra5, :puzzle_id, :user_id

  validates :user_id, :puzzle_id, :action_type, :presence => true

  belongs_to :user
  belongs_to :puzzle, :foreign_key => 'puzzle_id'
end
