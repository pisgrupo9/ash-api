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
#  weight         :integer
#
# Indexes
#
#  index_animals_on_species_id  (species_id)
#

class Animal < ActiveRecord::Base
  belongs_to :species
  has_many :images, dependent: :destroy
  has_many :events, dependent: :destroy

  validates :species, presence: true
  validates :chip_num, uniqueness: true, allow_nil: true
  validates :name, presence: true
  validates :name, uniqueness: true, if: :chip_num_nil?
  validates_presence_of :vaccines, if: 'vaccines.nil?'
  validates_presence_of :castrated, if: 'castrated.nil?'
  validates :admission_date, presence: true
  validates :birthdate, presence: true
  validate :correct_dates

  enum sex:  [:male, :female]

  mount_base64_uploader :profile_image, ProfileUploader

  def sex_to_s
    case sex
    when 'male' then 'Macho'
    when 'female' then 'Hembra'
    end
  end

  private

  def chip_num_nil?
    chip_num.nil?
  end

  def correct_dates
    death_date ? ok = dates_compare? && death_compare? : ok = dates_compare?
    errors.add(:dates, 'Fechas inválidas.') unless ok
  end

  def dates_compare?
    Date.today >= admission_date && admission_date >= birthdate
  end

  def death_compare?
    Date.today > death_date && death_date > admission_date
  end
end
