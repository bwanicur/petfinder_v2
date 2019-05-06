require "bundler/setup"
require 'vcr'
require 'byebug'
require "petfinder_V2"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  if ENV['PETFINDER_V2_CLIENT_ID']
    config.filter_sensitive_data('<CLIENT_ID>') { ENV['PETFINDER_V2_CLIENT_ID'] }
  end
  if ENV['PETFINDER_V2_CLIENT_SECRET']
    config.filter_sensitive_data('<CLIENT_SECRET>') { ENV['PETFINDER_V2_CLIENT_SECRET'] }
  end
end

CLIENT_ID = ENV['PETFINDER_V2_CLIENT_ID'] || 'does-not-matter'
CLIENT_SECRET = ENV['PETFINDER_V2_CLIENT_SECRET'] || 'does-not-matter'
