class Provider < ActiveRecord::Base
  attr_accessible :extra1, :extra2, :extra3, :extra4, :extra5, :oauth_token, :provider, :user_id, :uid, :url

  validates :user_id, :provider, :uid, :presence => true

  belongs_to :user
end
