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

class Adoptable < Animal
  validates_presence_of :vaccines, if: 'vaccines.nil?'
  validates_presence_of :castrated, if: 'castrated.nil?'

  after_create :set_adopted

  private

  def set_adopted
    update(adopted: false)
  end
end
