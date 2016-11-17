ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation
  actions :all, except: [:destroy]
  member_action :remove_admin_user, method: :post

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions defaults: true do |admin_user|
      if AdminUser.count == 1
        text = 'Se eliminará el usuario administrador. El sistema quedará sin usuarios administradores. ¿Está seguro/a?'
      else
        text = 'Se eliminará el usuario administrador. ¿Está seguro/a?'
      end
      link_to(
        'Eliminar',
        remove_admin_user_admin_admin_user_path(admin_user),
        method: :post,
        data: { confirm: text })
    end
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs 'Datos Admin' do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def remove_admin_user
      admin_user = AdminUser.find(params[:id])
      admin_user.destroy
      redirect_to(admin_admin_users_path)
    end
  end
end
