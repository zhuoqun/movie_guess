class Location < ActiveRecord::Base
  attr_accessible :id, :name

  has_many :users
end
