class RelationCode < ActiveRecord::Base
  attr_accessible :extra1, :extra2, :extra3, :extra4, :extra5, :name

  validates :name, :presence => true

  has_many :user_relations
end
