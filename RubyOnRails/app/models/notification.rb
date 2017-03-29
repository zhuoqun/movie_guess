class Notification < ActiveRecord::Base
  attr_accessible :action, :contact_id, :extra1, :extra2, :extra3, :extra4, :extra5, :is_viewed, :target_id, :target_type, :user_id

  validates :user_id, :contact_id, :target_type, :target_id, :action, :presence => true

  belongs_to :user, :foreign_key=>'user_id', :class_name=>'User'
  belongs_to :contact, :foreign_key=>'contact_id', :class_name=>'User'

  scope :unread, where('is_viewed = ?', false)

  def self.all(user_id, limit, offset)
    if offset.nil?
      where(:contact_id => user_id).order('created_at DESC').limit(limit)
    else
      where(:contact_id => user_id).order('created_at DESC').limit(limit).offset(offset)
    end
  end
end
