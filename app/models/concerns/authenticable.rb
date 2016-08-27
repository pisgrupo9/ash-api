module Authenticable
  extend ActiveSupport::Concern

  included do
    acts_as_token_authenticatable
    devise :database_authenticatable,  #  Password and password confirmation fields
           :recoverable,               #  Reset the password
           :registerable,
           :validatable               #  Validate the email

    validates :email, uniqueness: true
    validates :encrypted_password, uniqueness: false

    def invalidate_token
      self.authentication_token = ''
      self.save!
    end

    # protected

    # def password_required?
    #   !password.nil? || !password_confirmation.nil?
    # end

    # def email_required?
    #   false
    # end
  end
end
