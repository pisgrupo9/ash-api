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

class Animal < ActiveRecord::Base
  include Searchable
  belongs_to :species
  has_one :adoption
  has_one :adopter, through: :adoption
  delegate :name, to: :species, prefix: true

  has_many :images, dependent: :destroy
  has_many :events, dependent: :destroy

  validates :species, presence: true
  validates :chip_num, uniqueness: true, allow_nil: true
  validates :name, presence: true, length: { maximum: 30 }
  validates :name, uniqueness: true, if: :chip_num_nil?
  validates :admission_date, presence: true
  validates :birthdate, presence: true
  validate :correct_death_date, unless: 'death_date.nil?'
  validate :correct_birthdate
  validate :correct_admission_date
  validates :weight, numericality: { greater_than: 0 }

  enum sex:  [:male, :female]

  mount_base64_uploader :profile_image, ProfileUploader

  def sex_to_s
    case sex
    when 'male' then 'Macho'
    when 'female' then 'Hembra'
    end
  end

  def vaccines_to_s
    vaccines ? 'Si' : 'No'
  end

  def castrated_to_s
    castrated ? 'Si' : 'No'
  end

  def adoptable?
    type == 'Adoptable'
  end

  private

  def chip_num_nil?
    chip_num.nil?
  end

  def correct_death_date
    errors.add(:death_date, 'La fecha de muerte es inválida.') if validate_death_date?
  end

  def validate_death_date?
    Date.today < death_date || death_date < admission_date || death_date < birthdate
  end

  def correct_admission_date
    errors.add(:admission_date, 'La fecha de ingreso es inválida.') if validate_admission_date?
  end

  def validate_admission_date?
    Date.today < admission_date || admission_date < birthdate || (death_date < admission_date if death_date)
  end

  def correct_birthdate
    errors.add(:birthdate, 'La fecha de nacimiento es inválida.') if validate_birthdate?
  end

  def validate_birthdate?
    admission_date < birthdate || Date.today < birthdate || (death_date < birthdate if death_date)
  end
end
