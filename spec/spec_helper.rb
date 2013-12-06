#require 'simplecov'
#SimpleCov.start

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'

require 'capybara/rspec'
require 'capybara/poltergeist'
require 'vcr'

#poltergeist_log = File.open(Rails.root.join("log","poltergeist.log"), "a")
#Capybara.register_driver :poltergeist do |app|
#  Capybara::Poltergeist::Driver.new(app, {
#    #logger: poltergeist_log,
#    phantomjs_logger: poltergeist_log,
#    debug: false
#  })
#end

# https://gist.github.com/ericboehs/7125105
module Capybara::Poltergeist
  class Client
    private
    def redirect_stdout
      prev = STDOUT.dup
      prev.autoclose = false
      $stdout = @write_io
      STDOUT.reopen(@write_io)

      prev = STDERR.dup
      prev.autoclose = false
      $stderr = @write_io
      STDERR.reopen(@write_io)
      yield
    ensure
      STDOUT.reopen(prev)
      $stdout = STDOUT
      STDERR.reopen(prev)
      $stderr = STDERR
    end
  end
end

class WarningSuppressor
  class << self
    def write(message)
      if message =~ /client\/compiled\/main\.js/ || message =~ /userSpaceScaleFactor/ || message =~ /QFont::setPixelSize: Pixel size <= 0/ || message =~/CoreText performance note:/ then 0 else puts(message);1;end
    end
  end
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, phantomjs_logger: WarningSuppressor, timeout: 1.minutes)
end

Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 5

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock, :faraday
  c.allow_http_connections_when_no_cassette = false
  c.configure_rspec_metadata!
  c.ignore_localhost = true
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.include Capybara::DSL, type: :request

  config.include FactoryGirl::Syntax::Methods


  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.include TestHelpers

  #config.formatter = 'Growl::RSpec::Formatter'

  DatabaseCleaner.strategy = :truncation

  config.before :each do
    DatabaseCleaner.clean
    ActionMailer::Base.deliveries = []
    Capybara.reset_sessions!
    Warden.test_mode!
  end

  config.after :each do
    Warden.test_reset!
    Capybara.reset_sessions!    # Forget the (simulated) browser state
    Capybara.use_default_driver # Revert Capybara.current_driver to Capybara.default_driver
  end

  config.before(:suite) do
    `rm -rf public/screenshots/*`
  end

end
