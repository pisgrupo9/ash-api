ActiveAdmin.register Species do
  permit_params :name
  form do |f|
    f.inputs 'Details' do
      f.input :name
    end

    f.actions
  end
  index do
    selectable_column
    id_column
    column :name

    actions
  end
  filter :id
  show do
    attributes_table do
      row :id, sortable: true
      row :name
    end
  end
end
