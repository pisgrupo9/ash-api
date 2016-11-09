# == Schema Information
#
# Table name: reports
#
#  id         :integer          not null, primary key
#  name       :string
#  url        :string
#  type_file  :integer
#  state      :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_reports_on_user_id  (user_id)
#

class Report < ActiveRecord::Base
  belongs_to :user

  validates :name, :type_file, :state, :user_id, presence: true

  default_scope { order(created_at: :desc) }

  enum type_file:  [:pdf, :excel]
  enum state:  [:processing, :done]

  after_create :update_list

  def state_to_s
    case state
    when 'processing' then 'procesando'
    when 'done' then 'completado'
    end
  end

  private

  def update_list
    reports = User.find(user_id).reports
    reports.last.destroy if reports.count > 20
  end
end
