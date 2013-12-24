Rails.application.config.after_initialize do
  ActiveRecord::Base.connection_pool.disconnect!

  ActiveSupport.on_load(:active_record) do
    config = Rails.application.config.database_configuration[Rails.env]
    config['reaping_frequency'] = 10 # seconds
    config['pool']              = 15
    ActiveRecord::Base.establish_connection(config)
  end
end
