# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  authentication_token   :string           default("")
#  first_name             :string           not null
#  last_name              :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  phone                  :string
#  account_active         :boolean          default("false")
#  permissions            :integer          default("0")
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  include Authenticable
  has_many :reports, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :first_name, :last_name, :encrypted_password, presence: true
  validates :first_name, :last_name, length: { maximum: 30 }
  validates :phone, presence: true, format: { with: /\A[0-9]{8}[0-9]?\z/ }
  before_update :send_mail_accepted_user, if: :account_active_changed?
  before_update :send_mail_permissions_changed, if: :permissions_changed_and_is_active?
  before_destroy :send_mail_deleted_user

  enum permissions:  [:default_user, :animals_edit, :adopters_edit, :super_user]

  def account_active?
    account_active
  end

  def send_mail_accepted_user
    UserMailer.accepted_user_email(self).deliver_now
  end

  def send_mail_deleted_user
    if account_active
      UserMailer.deactivated_user_email(self).deliver_now
    else
      UserMailer.rejected_user_email(self).deliver_now
    end
  end

  def send_mail_permissions_changed
    UserMailer.permissions_changed_email(self).deliver_now
  end

  def permissions_changed_and_is_active?
    account_active && permissions_changed?
  end

  def permissions_to_s
    case permissions
    when 'default_user'
      'Tienes permiso para listar y buscar animales.'
    when 'animals_edit'
      'Tienes permiso para crear y editar animales.'
    when 'adopters_edit'
      'Tienes permiso para crear y editar adoptantes, y crear adopciones.'
    end
  end
end
