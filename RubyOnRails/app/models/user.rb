class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors.add(attribute, options[:message], options)
    end
  end
end

class DomainValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /^[a-zA-Z][a-zA-Z0-9_]*$/i
      record.errors.add(attribute, options[:message], options)
    end
  end
end

require 'file_size_validator'
class User < ActiveRecord::Base
  attr_accessible :gender, :captcha, :domain, :email, :location_id, :current_password, :password, :password_confirmation, :user_name, :avatar, :brief, :from_provider, :disable, :extra1, :extra2, :extra3, :extra4, :extra5, :crop_x,  :crop_y, :crop_w, :crop_h, :password_reset_token, :password_reset_sent_at, :douban_link, :weibo_name, :name_filter

  mount_uploader :avatar, AvatarUploader
  acts_as_voter

  attr_accessor :current_password, :crop_x,  :crop_y, :crop_w, :crop_h
  before_save :encrypt_password
  before_update :crop_image, :if => :cropping?

  #validates :location_id, :presence => true
  validates :user_name, :presence => true
  validates :gender, :presence => true
  validates :password, :presence => true, :confirmation => { :message => :pwd_confirmation}, :length => { :minimum => 6 }, :unless => "from_provider == true && self.provider.nil?"
  validates :email, :presence => true, :uniqueness => { :case_sensitive => false }, :email => { :message => :invalid_email}, :unless => "from_provider == true && self.provider.nil?"
  validates :domain, :allow_blank => true, :uniqueness => { :case_sensitive => false }, :length => { :in => 5..16 }, :domain => { :message => :invalid_domain}
  validates :brief, :allow_blank => true, :length => { :maximum => 140 }

  reserved_ids = %w(yahoo google puzzle puzzles account accounts logout login twitter password avatar provider screenshot lines fast index setting settings profile caidianying notification notifications)
  validates :domain, :exclusion => {:in => reserved_ids}

  validates :avatar, :allow_blank => true, :file_size => { :maximum => 2.megabytes.to_i } 

  has_one :user_stat
  has_one :provider

  has_many :user_action
  has_many :puzzles
  has_many :answers
  has_many :comments
  has_many :discussions

  has_many :follow_user_relations, :class_name => 'UserRelation'
  has_many :follower_user_relations, :foreign_key => 'contact_id', :class_name => 'UserRelation'

  has_many :reports
  has_many :notifications

  #belongs_to :location

  #For thumbnail
  def avatar_small
    avatar.url + '!small'
  end

  def avatar_medium
    avatar.url + '!medium'
  end

  def avatar_large
    avatar.url + '!large'
  end

  def path
    if self.domain.blank?
      self.id
    else
      self.domain
    end
  end

  def email_hash
    Digest::SHA1.hexdigest(self.email)[4,18]
  end

  def send_password_reset
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def encrypt_password
    if current_password.present?
      # for password update
      user = User.find(id)
      if user && user.password == BCrypt::Engine.hash_secret(current_password, user.password_salt)
        self.password_salt = BCrypt::Engine.generate_salt
        self.password = BCrypt::Engine.hash_secret(password, password_salt)
      else
        errors.add(:current_password, :invalid_current_password)
        false
      end
    else
      if password.present?
        self.password_salt = BCrypt::Engine.generate_salt
        self.password = BCrypt::Engine.hash_secret(password, password_salt)
      end
    end
  end

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def has_followed(contact)
    self.follow_user_relations.where(:contact_id => contact.id, :relation_code_id => 1).present?
  end

  def follower_cnt
    UserRelation.where(:contact_id => self.id, :relation_code_id => 1).count
  end

  def follow_cnt
    self.follow_user_relations.where(:relation_code_id => 1).count
  end

  def follows
    follow_ids = self.follow_user_relations.follow_ids
    follows = Array.new

    follow_ids.each do |item|
      follows.push User.find(item.contact_id)
    end

    follows
  end

  def followers
    follower_ids = self.follower_user_relations.follower_ids
    followers = Array.new

    follower_ids.each do |item|
      followers.push User.find(item.user_id)
    end

    followers
  end

  def cropping?
    crop_x.present? && crop_y.present? && crop_w.present? && crop_h.present?
  end

  def crop_image
    avatar.crop_image!
  end


end
