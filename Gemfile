source 'https://rubygems.org'
ruby '2.2.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18.2'

gem 'annotate', '~> 2.6.5'
gem 'activeadmin', '~> 1.0.0.pre1'

gem 'devise', '~> 3.5.1'
gem 'simple_token_authentication', '~> 1.6.0'

gem 'pundit', '~>1.1.0'

gem 'rack-cors', '~> 0.4.0', require: 'rack/cors'

gem 'carrierwave', '~> 0.11.2'
gem 'carrierwave-base64', '~> 2.3.1'
gem 'rmagick', '~>2.16.0'
gem 'fog-aws', '~> 0.10.0'
gem 'kaminari', '~> 0.17.0'
gem 'prawn', '~> 2.0.2'
gem 'prawn-table', '~> 0.2.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

gem 'uglifier', '~> 2.7.2'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'rails_12factor', group: :production

# Use delayed jobs
gem 'delayed_job_active_record', '~> 4.0.3'

gem 'pg_search', '~> 1.0', '>= 1.0.6'

# upload excel to amazon
gem 'aws-sdk', '~> 2.6.6'
gem 'axlsx_rails', '~> 0.5.0'
gem 'axlsx', '~> 2.0.1'

group :development, :test do
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'faker', '~> 1.6.5'
  gem 'rspec-rails', '~> 3.5'
  gem 'spork-rails', '~> 4.0.0'
  gem 'thin', '~> 1.6.3'
end

group :development do
  # Code analysis tools
  gem 'rails_best_practices', '~> 1.16.0'
  gem 'reek', '~> 1.3.6'
  gem 'rubocop', '~> 0.32.1'
  gem 'pry-byebug', '~> 3.3.0'
  gem 'pry-rails', '~> 0.3.4'
  gem 'quiet_assets', '~> 1.1.0'
  gem 'letter_opener', '~> 1.4.1'
end

group :test do
  gem 'simplecov'
  gem 'database_cleaner', '~> 1.4.1'
  gem 'shoulda-matchers', '~> 2.8.0'
end
