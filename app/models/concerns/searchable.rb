module Searchable
  extend ActiveSupport::Concern
  included do
    include PgSearch
    default_scope { order(created_at: :desc) }

    pg_search_scope :by_name, against: :name, using: { tsearch: { prefix: true } }
    pg_search_scope :by_chip_num, against: :chip_num, using: { tsearch: { prefix: true } }
    pg_search_scope :by_race, against: :race, using: { tsearch: { prefix: true } }
    pg_search_scope :by_sex, against: :sex
    pg_search_scope :by_species_id, against: :species_id
    pg_search_scope :by_weight, against: :weight
    pg_search_scope :by_vaccines, against: :vaccines
    pg_search_scope :by_castrated, against: :castrated
    pg_search_scope :by_type, against: :type
    pg_search_scope :by_adopted, against: :adopted

    scope :search_by_name, lambda {|name|
      by_name(name) if name.present?
    }
    scope :search_by_chip_num, lambda {|chip_num|
      by_chip_num(chip_num) if chip_num.present?
    }
    scope :search_by_race, lambda {|race|
      by_race(race) if race.present?
    }
    scope :search_by_sex, lambda {|sex|
      by_sex(sex) if sex.present?
    }
    scope :search_by_species_id, lambda {|species_id|
      by_species_id(species_id) if species_id.present?
    }
    scope :search_by_weight, lambda {|weight|
      by_weight(weight) if weight.present?
    }
    scope :search_by_vaccines, lambda {|vaccines|
      by_vaccines(vaccines) if vaccines.present?
    }
    scope :search_by_castrated, lambda {|castrated|
      by_castrated(castrated) if castrated.present?
    }
    scope :search_by_admission_date_from, lambda {|admission_date_from|
      where('admission_date >= ?', admission_date_from) if admission_date_from.present? &&
                                                           !(admission_date_from =~ /\A\d{4}-\d{1,2}-\d{1,2}\z/).nil? &&
                                                           Date.valid_date?(*admission_date_from.split('-').map(&:to_i))
    }
    scope :search_by_admission_date_to, lambda {|admission_date_to|
      where('admission_date <= ?', admission_date_to) if admission_date_to.present? &&
                                                         !(admission_date_to =~ /\A\d{4}-\d{1,2}-\d{1,2}\z/).nil? &&
                                                         Date.valid_date?(*admission_date_to.split('-').map(&:to_i))
    }
    scope :search_by_type, lambda {|type|
      if type == 'Adoptable'
        by_type(type)
      elsif type == '!Adoptable'
        where(type: nil)
      end
    }
    scope :search_by_adopted, lambda {|adopted|
      by_adopted(adopted) if adopted.present?
    }

    def self.search(params)
      search_by_type(params[:type]).search_by_adopted(params[:adopted]).search_by_name(params[:name])
        .search_by_chip_num(params[:chip_num]).search_by_race(params[:race]).search_by_sex(params[:sex])
        .search_by_vaccines(params[:vaccines]).search_by_weight(params[:weight]).search_by_species_id(params[:species_id])
        .search_by_castrated(params[:castrated]).search_by_admission_date_from(params[:admission_date_from])
        .search_by_admission_date_to(params[:admission_date_to])
    end
  end
end
