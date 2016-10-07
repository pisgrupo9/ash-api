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

FactoryGirl.define do
  factory :events, class: 'Event' do
    name { Faker::Name.last_name }
    description { Faker::ChuckNorris.fact }
    date { Faker::Date.between(1.days.ago, Date.today) }
    animal 
  end
end
