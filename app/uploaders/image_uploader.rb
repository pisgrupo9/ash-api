# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  def store_dir
    "uploads/animal/#{model.animal_id}/images/#{model.id}"
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
