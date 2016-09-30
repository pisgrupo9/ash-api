# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  file       :string
#  animal_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :integer
#
# Indexes
#
#  index_images_on_animal_id  (animal_id)
#  index_images_on_event_id   (event_id)
#

class Image < ActiveRecord::Base
  belongs_to :animal
  mount_base64_uploader :file, ImageUploader
end
