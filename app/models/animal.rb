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

class Animal < ActiveRecord::Base
  belongs_to :species
  has_many :images, dependent: :destroy

  validates :species, presence: true
  validates :chip_num, uniqueness: true, allow_nil: true
  validates :name, presence: true
  validates :name, uniqueness: true, if: :chip_num_nil?
  validates_presence_of :vaccines, if: 'vaccines.nil?'
  validates_presence_of :castrated, if: 'castrated.nil?'
  validates :admission_date, presence: true
  validates :birthdate, presence: true

  enum sex:  [:male, :female]

  mount_base64_uploader :profile_image, ProfileUploader

  private

  def chip_num_nil?
    chip_num.nil?
  end
end
