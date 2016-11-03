# == Schema Information
#
# Table name: adoptions
#
#  id         :integer          not null, primary key
#  animal_id  :integer          not null
#  adopter_id :integer          not null
#  date       :date             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_adoptions_on_adopter_id  (adopter_id)
#  index_adoptions_on_animal_id   (animal_id) UNIQUE

FactoryGirl.define do
  factory :adoption, class: 'Adoption' do
    animal
    adopter
    date { '2016-11-01' }
  end
end
