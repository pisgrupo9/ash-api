# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :string           not null
#  date        :date             not null
#  animal_id   :integer          not null
#
# Indexes
#
#  index_events_on_animal_id  (animal_id)
#

class Event < ActiveRecord::Base
  include PgSearch
  belongs_to :animal
  has_many :images, dependent: :destroy

  validates :name, :description, :date, :animal_id, presence: true
  validates :name, length: { maximum: 50 }
  validate :correct_date

  default_scope { order(date: :desc) }

  def self.search(params)
    text = '%' + I18n.transliterate(params[:text]) + '%'
    where('unaccent(name) ilike ? or unaccent(description) ilike ?', text, text)
  end

  private

  def correct_date
    errors.add(:date, 'La fecha del evento no es válida.') if date < animal.birthdate
  end
end
