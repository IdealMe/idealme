Idealme::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = true

  # Compress JavaScripts and CSS
  config.assets.compress = true
  config.assets.js_compressor = :uglifier

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"
  #config.action_controller.asset_host = "//#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com"
  config.action_controller.asset_host = "//d1oi23ayjzl9lh.cloudfront.net"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  #config.assets.precompile += %w( ckeditor/skins/moono/editor.css ckeditor/skins/moono/editor.css ckeditor/lang/en.js )
  config.assets.precompile += %w( ckeditor/skins/moono/editor.css ckeditor/skins/moono/editor.css ckeditor/lang/en.js admin.js /ckeditor/plugins/image/dialogs/image.js /ckeditor/skins/moono/dialog.css )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = {host: 'idealme.com'}

  Paperclip::Attachment.default_options[:storage] = :s3
  Paperclip::Attachment.default_options[:s3_credentials] = {
    bucket: ENV['AWS_S3_BUCKET'],
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  }
  Paperclip::Attachment.default_options[:s3_protocol] = :https
  #Paperclip::Attachment.default_options[:url] = ':s3_alias_url'
  #Paperclip::Attachment.default_options[:s3_host_alias] = 'd13lmyn0z90wuo.cloudfront.net'
  #Paperclip::Attachment.default_options[:path] = ":class/:id/:style.:extension"

  ActionMailer::Base.smtp_settings = {
    address: 'smtp.sendgrid.net',
    port: '587',
    authentication: :plain,
    user_name: ENV['SENDGRID_API_USERNAME'],
    password: ENV['SENDGRID_API_PASSWORD'],
    domain: 'idealme.com',
    enable_starttls_auto: true
  }
end
TEST_STRIPE_GATEWAY = ActiveMerchant::Billing::StripeGateway.new(login: ENV['TEST_STRIPE_SECRET_KEY'])
STRIPE_GATEWAY      = ActiveMerchant::Billing::StripeGateway.new(login: ENV['STRIPE_SECRET_KEY'])
