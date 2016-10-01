# encoding: utf-8
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  authentication_token   :string           default("")
#  first_name             :string           not null
#  last_name              :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  phone                  :string
#  account_active         :boolean          default("false")
#  permissions            :integer          default("0")
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, class: 'User' do
    email     { Faker::Internet.email }
    password  { Faker::Internet.password }
    first_name  { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone "099234567"
  end
end
