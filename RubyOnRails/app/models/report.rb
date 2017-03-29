class Report < ActiveRecord::Base
  attr_accessible :close, :content, :content_type, :extra1, :extra2, :extra3, :extra4, :extra5, :handler, :reason, :user_id

  validates :user_id, :content_type, :content, :reason, :presence => true

  belongs_to :user
end
