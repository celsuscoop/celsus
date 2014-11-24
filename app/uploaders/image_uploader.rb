# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:

  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fit => [240, 135]
  end

  version :middle do
    process :resize_to_fit => [575, 381]
  end

  version :large do
    process :resize_to_fit => [1006, 400]
  end

  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

end
