class TagnamesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    flag = true
    value.each do |name|
      flag = false if name.present?
    end

    record.errors.add(attribute, :empty, options) if flag == true

  end
end

class ImageOrLinesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.image.blank? && record.lines.blank?
      record.errors.add(:image_or_lines, :empty, options)
    end
  end
end

class Puzzle < ActiveRecord::Base
  attr_accessible :answer_cnt, :user_id, :disable, :saved, :desc, :extra1, :extra2, :extra3, :extra4, :extra5, :fav_cnt, :has_best_answer, :image, :lines, :price, :reference, :retweet_cnt, :puzzle_type, :tag_names, :image_url

  mount_uploader :image, PuzzleUploader
  acts_as_votable

  attr_accessor :tag_names, :image_or_lines, :image_url
  after_save :assign_tags

  default_scope where('disable = ?', false)
  scope :saved, where('saved = ?', true)

  validates :puzzle_type, :user_id, :presence => true
  validates :answer_cnt, :retweet_cnt, :fav_cnt, :numericality => { :only_integer => true }
  validates :image, :imageOrLines => true
  validates :lines, :imageOrLines => true
  validates :lines, :allow_blank => true, :length => { :maximum => 500 }
  validates :desc, :allow_blank => true, :length => { :maximum => 200 }

  validates :tag_names, :tagnames => true, :unless => Proc.new { |obj| obj.image.present? || obj.taggings.present? }

  belongs_to :user
  has_many :user_actions
  has_many :answers
  has_many :discussions

  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings

  #For thumbnail
  def image_wall
    image.url + '!wall'
  end

  def image_detail
    image.url + '!detail'
  end

  def get_tag_names
    tags = Array.new
    self.tags.each do |tag|
      tags.push tag.name
    end
    tags
  end

  def self.all(limit, offset)
    if offset.nil?
      saved.limit(limit).order('created_at desc')
    else
      saved.limit(limit).offset(offset).order('created_at desc')
    end
  end

  def self.by_type(puzzle_type, limit, offset)
    if offset.nil?
      saved.where(:puzzle_type => puzzle_type).limit(limit).order('created_at desc')
    else
      saved.where(:puzzle_type => puzzle_type).limit(limit).offset(offset).order('created_at desc')
    end
  end

  def self.by_tag(tag, limit, offset)
    if offset.nil?
      saved.joins(:tags).where('tags.name' => tag).limit(limit).order('created_at desc')
    else
      saved.joins(:tags).where('tags.name' => tag).limit(limit).offset(offset).order('created_at desc')
    end
  end

  private

  def assign_tags
    if @tag_names
      @tag_names.each do |name|
        @tag_names.delete name if name.blank?
      end
      self.tags = @tag_names.map do |name|
        Tag.find_or_create_by_name(name)
      end
    end
  end

end
