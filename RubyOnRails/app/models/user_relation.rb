class UserRelation < ActiveRecord::Base
  attr_accessible :contact_id, :extra1, :extra2, :extra3, :extra4, :extra5, :relation_code_id, :user_id

  validates :user_id, :contact_id, :relation_code_id, :presence => true

  belongs_to :user, :foreign_key=>"user_id", :class_name=>"User"
  belongs_to :contact, :foreign_key=>"contact_id", :class_name=>"User"

  belongs_to :relation_code

  scope :follow_ids, select(:contact_id).where(:relation_code_id => 1)
  scope :follower_ids, select(:user_id).where(:relation_code_id => 1)
end
