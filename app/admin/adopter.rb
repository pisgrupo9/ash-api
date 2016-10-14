ActiveAdmin.register Adopter do
  permit_params :email, :first_name, :last_name, :phone, :blacklisted, :home_address,
                :ci, :house_description

  form do |f|
    f.inputs 'Details' do
      f.input :ci
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :phone
      f.input :blacklisted, include_blank: false
    end

    f.actions
  end

  index do
    selectable_column
    id_column
    column :ci
    column :first_name
    column :last_name
    column :email
    column :phone
    column :blacklisted
    column :home_address
    column :house_description
    column :created_at
    column :updated_at

    actions
  end

  filter :ci
  filter :email
  filter :first_name
  filter :last_name
  filter :phone
  filter :blacklisted
  filter :home_address
  filter :created_at
  filter :updated_at

  show do
    attributes_table do
      row :ci
      row :email
      row :first_name
      row :last_name
      row :phone
      row :blacklisted
      row :home_address
      row :house_description
      row :created_at
      row :updated_at
    end
  end
end
