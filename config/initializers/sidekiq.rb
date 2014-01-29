Sidekiq.configure_server do |config|
  config.redis = { :url => 'redis://localhost:6379', :namespace => "im_#{Rails.env}" }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => 'redis://localhost:6379', :namespace => "im_#{Rails.env}" }
end
