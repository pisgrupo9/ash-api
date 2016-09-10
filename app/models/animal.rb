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
#
# Indexes
#
#  index_animals_on_species_id  (species_id)
#

class Animal < ActiveRecord::Base
  belongs_to :species
  validates :species, presence: true
  validates :name, uniqueness: true, presence: true
  validates :sex,  presence: true
  validates :vaccines, presence: true
  validates :castrated, presence: true
  validates :admission_date, presence: true
  validates :birthdate, presence: true
  enum sex:  [:male, :female]
end
