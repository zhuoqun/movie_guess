class Tagging < ActiveRecord::Base
  attr_accessible :puzzle_id, :tag_id

  belongs_to :puzzle
  belongs_to :tag
end
