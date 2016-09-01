#encoding: utf-8

include Warden::Test::Helpers

module RequestHelpers
  def login(user)
    login_as user, scope: :user
    user
  end
end