# encoding: utf-8

require 'rubygems'
require 'spork'
# uncomment the following line to use spork with the debugger
# require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV['RAILS_ENV'] ||= 'test'
  ENV['SKIP_RAILS_ADMIN_INITIALIZER'] = 'false'

  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
  require 'factory_girl_rails'
  require 'helpers'


  FactoryGirl.factories.clear
  FactoryGirl.reload

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join('spec/support/**/*.rb')].each { |file| require file }

  # Checks for pending migrations before tests are run.
  # If you are not using ActiveRecord, you can remove this line.
  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

  # Change rails logger level to reduce IO during tests
  Rails.logger.level = 4

  RSpec.configure do |config|
    config.include Helpers
    config.use_transactional_fixtures = false
    config.infer_base_class_for_anonymous_controllers = false
    config.order = 'random'
    config.infer_spec_type_from_file_location!

    config.include FactoryGirl::Syntax::Methods

    # Uncomment if you want to include Devise. Add devise to your gemfile
    config.include Devise::TestHelpers, type: :controller

    config.before :each do |example_group|
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.start
    end

    config.after do
      DatabaseCleaner.clean
    end

    # Uncomment if you want to include Devise. Add devise to your gemfile
    # config.include Devise::TestHelpers, type: :controller

  end
end

Spork.each_run do
  # This code will be run each time you run your specs.

end
