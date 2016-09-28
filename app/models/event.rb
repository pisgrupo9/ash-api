# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :string           not null
#  date        :date             not null
#  animal_id   :integer          not null
#
# Indexes
#
#  index_events_on_animal_id  (animal_id)
#

class Event < ActiveRecord::Base
  belongs_to :animal

  validates :name, :description, :date, :animal_id, presence: true
  validates :name, length: { maximum: 50 }
end
