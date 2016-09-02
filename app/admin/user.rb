ActiveAdmin.register User do
  permit_params :email, :first_name, :last_name, :access_level, :account_active

  form do |f|
    f.inputs 'Details' do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :account_active
      f.input :access_level
    end

    f.actions
  end

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :created_at
    column :updated_at
    column :account_active
    column :access_level

    actions
  end

  filter :id
  filter :email
  filter :first_name
  filter :last_name
  filter :created_at
  filter :updated_at

  show do
    attributes_table do
      row :id
      row :email
      row :first_name
      row :last_name
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
