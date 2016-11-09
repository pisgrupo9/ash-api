ActiveAdmin.register User do
  permit_params :email, :first_name, :last_name,
                :phone, :account_active, :permissions

  member_action :update_account, method: :post

  form do |f|
    f.inputs 'Details' do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :phone
      f.input :permissions, include_blank: false
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
      user.account_active ? text_link = 'Desactivar Cuenta' : text_link = 'Activar Cuenta'
      link_to "#{text_link}", update_account_admin_user_path(user.id),
              method: :post, data: { no_turbolink: true }, class: 'member_link'
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
    before_action :load_user, only: [:update_account]

    def update_account
      @user.account_active ? @user.destroy : @user.update(account_active: true)
      redirect_to(admin_users_path)
    end

    private

    def load_user
      @user = User.find(params[:id])
    end
  end
end
