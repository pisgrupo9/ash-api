# == Schema Information
#
# Table name: species
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  adoptable  :boolean          not null
#

FactoryGirl.define do
  factory :species, class: 'Species' do
    name  { Faker::Name.first_name }
 end
end
