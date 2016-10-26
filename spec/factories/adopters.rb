# == Schema Information
#
# Table name: adopters
#
#  id                :integer          not null, primary key
#  first_name        :string           not null
#  last_name         :string           not null
#  ci                :string           not null
#  email             :string           default("")
#  phone             :string           not null
#  house_description :string           default("")
#  blacklisted       :boolean          default("false"), not null
#  home_address      :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryGirl.define do
  factory :adopter, class: 'Adopter' do
    ci { CiUY.random }
    first_name  { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    home_address  { Faker::Address.street_address}
    blacklisted { Faker::Boolean.boolean }
    phone {Faker::Number.number(9)}
    house_description {Faker::Lorem.sentence}
  end
end
