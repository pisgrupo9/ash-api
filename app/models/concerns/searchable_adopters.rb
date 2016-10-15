module SearchableAdopters
  extend ActiveSupport::Concern
  included do
    include PgSearch
    default_scope { order(created_at: :desc) }

    pg_search_scope :by_name, against: [:first_name, :last_name], using: { tsearch: { prefix: true } }
    pg_search_scope :by_blacklisted, against: :blacklisted

    scope :search_by_name, lambda {|name|
      by_name(name) if name.present?
    }
    scope :search_by_blacklisted, lambda {|blacklisted|
      by_blacklisted(blacklisted) if blacklisted.present?
    }

    def self.search(params)
      search_by_name(params[:name]).search_by_blacklisted(params[:blacklisted])
    end
  end
end
