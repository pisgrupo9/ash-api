ActiveAdmin.register Animal do
  actions :all, except: [:new, :edit]

  index do
    selectable_column
    id_column
    column :name
    column :chip_num
    column :species_id
    column :race
    column :sex_to_s, sortable: :sex
    column :admission_date
    column :birthdate
    column :death_date
    column :weight
    column :vaccines_to_s, sortable: :vaccines
    column :castrated_to_s, sortable: :castrated
    column :type_to_s, sortable: :type
    column :adopted_to_s, sortable: :adopted
    column :created_at
    column :updated_at

    actions
  end

  filter :name
  filter :chip_num
  filter :species
  filter :race
  filter :sex, as: :select, collection: Animal.sexes
  filter :admission_date
  filter :birthdate
  filter :death_date
  filter :weight
  filter :vaccines
  filter :castrated
  filter :type
  filter :adopted
  filter :created_at
  filter :updated_at

  show do
    attributes_table do
      row :name
      row :chip_num
      row :species_id
      row :race
      row :sex_to_s
      row :admission_date
      row :birthdate
      row :death_date
      row :weight
      row :type_to_s
      row :vaccines_to_s
      row :castrated_to_s
      row :adopted_to_s
      row :profile_image
      row :created_at
      row :updated_at
    end
  end
end
