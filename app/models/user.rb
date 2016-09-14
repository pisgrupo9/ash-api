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
  before_update :send_mail_accepted_user, if: :account_active_changed?
  before_destroy :send_mail_rejected_user

  enum permissions:  [:default_user, :animals_edit, :adopters_edit, :super_user]

  def account_active?
    account_active
  end

  def send_mail_accepted_user
    UserMailer.accepted_user_email(self).deliver_now
  end

  def send_mail_rejected_user
    UserMailer.rejected_user_email(self).deliver_now
  end
end
