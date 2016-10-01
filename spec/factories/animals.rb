# == Schema Information
#
# Table name: animals
#
#  id             :integer          not null, primary key
#  chip_num       :string
#  name           :string           not null
#  race           :string
#  sex            :integer          not null
#  vaccines       :boolean          not null
#  castrated      :boolean          not null
#  admission_date :date             not null
#  birthdate      :date             not null
#  death_date     :date
#  species_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  profile_image  :string
#
# Indexes
#
#  index_animals_on_species_id  (species_id)
#


FactoryGirl.define do
  factory :animal, class: 'Animal' do
    name { Faker::Name.first_name }
    chip_num { Faker::Code.isbn }
    race { Faker::Name.first_name }
    sex "female"
    vaccines { Faker::Boolean.boolean }
    castrated { Faker::Boolean.boolean }
    admission_date { Faker::Time.between(3.days.ago, Date.today, :all) }
    birthdate { Faker::Time.between(5.days.ago, Date.today, :all) }
    species
  end
end
