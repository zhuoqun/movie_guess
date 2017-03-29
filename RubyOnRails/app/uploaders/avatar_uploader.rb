# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :upyun
  self.upyun_bucket = 'caidianying-avatar'
  self.upyun_bucket_domain = 'caidianying-avatar.b0.upaiyun.com'
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/avatar"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
 
    #"/images/fallback/" + [version_name, "default.png"].compact.join('_')
    "/assets/" + [version_name, "default_avatar.jpg"].compact.join('_')
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  process :resize_to_fit => [256, 256]
  #
  # def scale(width, height)
  #   # do something
  # end

  def crop_image!
    manipulate! do |img|
      img.crop("#{model.crop_w}x#{model.crop_h}+#{model.crop_x}+#{model.crop_y}")
      img
    end
    resize_to_limit(128, 128)
  end


  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png bmp) if model.from_provider == false
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    if model.from_provider
      if original_filename
        ext = file.extension.blank? ? '' : ".#{file.extension}"
        "u-#{model.extra2}#{ext}"
      end
    else
      "u-#{model.id}.#{file.extension}" if original_filename
    end
  end

end
