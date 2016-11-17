ActiveAdmin.register Adopter do
  permit_params :email, :first_name, :last_name, :phone, :blacklisted, :home_address,
                :ci, :house_description
  actions :all, except: [:destroy]
  member_action :remove_adopter, method: :post

  form do |f|
    f.inputs 'Datos' do
      f.input :ci
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :phone
      f.input :home_address
      f.input :house_description
      f.input :blacklisted if f.object.new_record?
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
    column :created_at
    column :updated_at
    actions defaults: true do |adopter|
      link_to(
        'Eliminar',
        remove_adopter_admin_adopter_path(adopter),
        method: :post,
        data: { confirm: 'Se eliminará el adoptante y todas sus adopciones. ¿Está seguro/a?' })
    end
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

  controller do
    def remove_adopter
      adopter = Adopter.find(params[:id])
      adopter.destroy
      redirect_to(admin_adopters_path)
    end
  end
end
