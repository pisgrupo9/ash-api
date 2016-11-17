ActiveAdmin.register Species do
  permit_params :name, :adoptable
  actions :all, except: [:destroy]
  member_action :remove_specie, method: :post

  form do |f|
    f.inputs 'Datos' do
      f.input :name
      f.input :adoptable
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :name
    column :adoptable
    actions defaults: true do |specie|
      link_to(
        'Eliminar',
        remove_specie_admin_species_path(specie),
        method: :post,
        data: { confirm: 'Se eliminará la especie y todos los animales pertenecientes a la misma. ¿Está seguro/a?'
          }) unless specie.adoptable?
    end
  end

  filter :id
  show do
    attributes_table do
      row :id, sortable: true
      row :name
      row :adoptable
    end
  end

  controller do
    def remove_specie
      specie = Species.find(params[:id])
      specie.destroy
      redirect_to(admin_species_index_path)
    end
  end
end
