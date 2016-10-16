# == Schema Information
#
# Table name: species
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Species < ActiveRecord::Base
  has_many :animals

  validates :name, presence: true, allow_nil: false, uniqueness: true

  def not_deleteable?
    [1, 2, 3].include? id
  end
end
