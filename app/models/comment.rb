# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  adopter_id :integer
#  text       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_comments_on_adopter_id  (adopter_id)
#  index_comments_on_user_id     (user_id)
#

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :adopter

  default_scope { order(created_at: :desc) }

  validates :text, length: { maximum: 500 }, presence: true
end
