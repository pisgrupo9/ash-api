module Authenticable
  extend ActiveSupport::Concern

  included do
    acts_as_token_authenticatable
    devise :database_authenticatable,  #  Password and password confirmation fields
           :recoverable,               #  Reset the password
           :registerable,
           :validatable               #  Validate the email

    validates :encrypted_password, uniqueness: false

    def invalidate_token
      self.authentication_token = ''
      self.save!
    end
  end
end
