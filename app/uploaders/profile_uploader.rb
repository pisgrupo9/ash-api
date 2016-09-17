# encoding: utf-8

class ProfileUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
  end

  version :thumb do
    process resize_to_fill: [150, 150]
  end

  version :medium do
    process resize_to_fill: [500, 500]
  end

  version :maximun do
    process resize_to_fill: [800, 800]
  end

  def extension_white_list
    %w(jpg jpeg png)
  end
end
