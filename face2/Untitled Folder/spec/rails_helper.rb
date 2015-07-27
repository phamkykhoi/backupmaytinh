ENV["RAILS_ENV"] ||= "test"
require "spec_helper"
require File.expand_path("../../config/environment", __FILE__)
require "rspec/rails"
require "database_cleaner"

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false

  config.before :suite do
    DatabaseCleaner.strategy = :truncation
  end

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end
end
