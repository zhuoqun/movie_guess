class Tag < ActiveRecord::Base
  attr_accessible :extra1, :extra2, :extra3, :extra4, :extra5, :name

  validates :name, :uniqueness => true

  has_many :taggings, :dependent => :destroy
  has_many :puzzles, :through => :taggings
end
