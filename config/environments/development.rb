Idealme::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  config.eager_load = false

  config.preload_app = true

  # Show full error reports and disable caching
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.after_initialize do
    Bullet.enable        = true
    Bullet.bullet_logger = true
    Bullet.console       = true
    Bullet.rails_logger  = true
    #Bullet.growl         = true
    Bullet.unused_eager_loading_enable = false
  end

  config.middleware.use(Rack::LiveReload,
                        :min_delay        => 500,    # default 1000
                        :max_delay        => 10_000, # default 60_000
                        :live_reload_port => 35721,  # default 35729
                        :host             => 'localhost',
                        :ignore           => [ %r{dont/modify\.html$} ],
                        #:source           => :vendored,
                       )


  #Paperclip::Attachment.default_options[:storage] = :s3
  #Paperclip::Attachment.default_options[:s3_credentials] = {
  #bucket: ENV['AWS_S3_BUCKET'],
  #access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  #secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  #}
  #Paperclip::Attachment.default_options[:s3_protocol] = :https

  config.action_mailer.default_url_options = {host: 'idealme.com'}
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    user_name: 'idealme-391cd542169169ce',
    password: 'aacad647af45183f',
    address: 'mailtrap.io',
    port: '2525',
    authentication: :plain
  }

end

