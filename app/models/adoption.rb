# == Schema Information
#
# Table name: adoptions
#
#  id         :integer          not null, primary key
#  animal_id  :integer          not null
#  adopter_id :integer          not null
#  date       :date             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_adoptions_on_adopter_id  (adopter_id)
#  index_adoptions_on_animal_id   (animal_id) UNIQUE
#

class Adoption < ActiveRecord::Base
  belongs_to :adopter
  belongs_to :animal

  validates :adopter_id, :animal_id, :date, presence: true
  validates :animal_id, uniqueness: true
  validate :adoptable_animal
  validate :adoptable_vaccines, :adoptable_castrated, if: 'animal.adoptable?'
  validate :adopter_blacklisted

  after_create :create_event, :set_adopted
  before_destroy :set_not_adopted, :event_unadopted

  private

  def adopter_blacklisted
    errors.add(:adopter_id, 'El adoptante está en la lista negra.') if adopter.blacklisted
  end

  def adoptable_animal
    errors.add(:animal_id, 'La especie del animal no es adoptable.') unless animal.adoptable?
  end

  def adoptable_vaccines
    errors.add(:animal_id, 'El animal no tiene las vacunas al día') unless animal.vaccines?
  end

  def adoptable_castrated
    errors.add(:animal_id, 'El animal no está castrado') unless animal.castrated?
  end

  def create_event
    event = Event.new(animal_id: animal_id, name: 'Adopción', description:
                      "El animal fue adoptado por #{adopter.first_name} #{adopter.last_name}.", date: date)
    event.save
  end

  def event_unadopted
    event = Event.new(animal_id: animal_id, name: 'Retiro de adopción', description:
                      "Fue retirada la adopción de #{adopter.first_name} #{adopter.last_name}.",
                      date: Time.now.strftime('%Y%m%d'))
    event.save
  end

  def set_adopted
    animal.update(adopted: true)
  end

  def set_not_adopted
    animal.update(adopted: false)
  end
end
