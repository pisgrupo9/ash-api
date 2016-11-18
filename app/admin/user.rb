ActiveAdmin.register User do
  permit_params :email, :first_name, :last_name,
                :phone, :account_active, :permissions, :password, :password_confirmation
  actions :all, except: [:destroy]
  member_action :activate_account, method: :post
  member_action :delete_account, method: :post

  form do |f|
    f.inputs 'Datos' do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :phone
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
      f.input :permissions, include_blank: false
      f.input :account_active if f.object.new_record? || !User.find(params[:id]).account_active?
    end

    f.actions
  end

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :phone
    column :account_active
    column :permissions
    column :created_at
    column :updated_at

    actions defaults: true do |user|
      if user.account_active
        text_link = 'Desactivar'
        message = 'Se eliminará el usuario y todos sus comentarios sobre los adoptantes. ¿Está seguro/a?'
      else
        item 'Activar', activate_account_admin_user_path(user.id), method: :post, data: { no_turbolink: true, confirm:
          'Se activará la cuenta del usuario. ¿Está seguro/a?' }, class: 'member_link'
        text_link = 'Eliminar'
        message = 'Se eliminará el usuario. ¿Está seguro/a?'
      end
      item text_link, delete_account_admin_user_path(user.id),
           method: :post, data: { no_turbolink: true, confirm: message }, class: 'member_link'
    end
  end

  filter :id
  filter :email
  filter :first_name
  filter :last_name
  filter :phone
  filter :account_active
  filter :permissions, as: :select, collection: User.permissions
  filter :created_at
  filter :updated_at

  show do
    attributes_table do
      row :id
      row :email
      row :first_name
      row :last_name
      row :phone
      row :account_active
      row :permissions
      row :created_at
      row :updated_at
    end
  end

  controller do
    before_action :load_user, only: [:activate_account, :delete_account]

    def activate_account
      @user.update(account_active: true)
      redirect_to(admin_users_path)
    end

    def delete_account
      @user.destroy
      redirect_to(admin_users_path)
    end

    private

    def load_user
      @user = User.find(params[:id])
    end
  end
end
