class AdminMailer < ApplicationMailer
  def new_user_mail(admin_user)
    @user = admin_user
    @url  = admin_users_url
    mail(to: @user.email, subject: 'Nuevo usuario en el sistema')
  end
end
