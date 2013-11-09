unless ENV['CI']
  Honeybadger.configure do |config|
    config.api_key = '2a573130'
  end
end
