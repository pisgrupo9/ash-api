ActiveAdmin.register Animal do
  actions :all, except: [:new, :edit]

  index do
    selectable_column
    id_column
    column :name
    column :chip_num
    column :species_id
    column :race
    column :sex
    column :admission_date
    column :birthdate
    column :death_date
    column :weight
    column :vaccines
    column :castrated
    column :type
    column :adopted
    column :created_at
    column :updated_at

    actions
  end

  filter :name
  filter :chip_num
  filter :species_id
  filter :race
  filter :sex
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
      row :sex
      row :admission_date
      row :birthdate
      row :death_date
      row :weight
      row :type
      row :vaccines
      row :castrated
      row :adopted
      row :profile_image
      row :created_at
      row :updated_at
    end
  end
end
