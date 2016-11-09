# == Schema Information
#
# Table name: animals
#
#  id             :integer          not null, primary key
#  chip_num       :string
#  name           :string           not null
#  race           :string
#  sex            :integer          not null
#  vaccines       :boolean          
#  castrated      :boolean          
#  admission_date :date             not null
#  birthdate      :date             not null
#  death_date     :date
#  species_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  profile_image  :string
#  weight         :integer
#  type           :string
#  adopted        :boolean
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
    sex { Faker::Number.between(0, 1) }
    vaccines { Faker::Boolean.boolean }
    castrated { Faker::Boolean.boolean }
    admission_date { Faker::Date.between(7.days.ago, 5.days.ago) }
    birthdate { Faker::Date.between(1.year.ago, 8.days.ago) }
    death_date { Faker::Date.between(3.days.ago, Date.today) }
    profile_image { Faker::Internet.url }
    weight { Faker::Number.number(2) }
    species

    factory :animal_con_evento do
      after(:create) do |animal|
        create(:events, animal: animal)
      end
    end
  end
end
