require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Idealme
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.autoload_paths += Dir["#{config.root}/app/models/**/", "#{config.root}/lib/**/"]
    config.autoload_paths += %W(#{config.root}/app/models/ckeditor)

    #config.middleware.insert_after ActionDispatch::RemoteIp, "RemoteIpLogger"
    #config.middleware.insert_after ActionDispatch::RemoteIp, "ExcludeIp"
    #config.middleware.insert_after ActionDispatch::RemoteIp, "TrackRequests"
    #if Rails.env == 'test'
      #require_relative '../app/middleware/diagnostic'
      #config.middleware.use(Idealme::DiagnosticMiddleware)
    #end

    config.filter_parameters += [:password, :card_number, :card_cvv, :card_type, :card_exp_year, :card_exp_month]
  end
end

# Log SQL separately
ActiveRecord::Base.logger = ActiveSupport::Logger.new("log/#{Rails.env}.sql.log")

I18n.enforce_available_locales = false
OmniAuth.config.full_host = 'https://idealme.com'

