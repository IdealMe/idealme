class RemoteIpLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    Rails.logger.info env
    remote_ip = env["HTTP_X_FORWARDED_FOR"]
    if remote_ip
      remote_ip = remote_ip.split(',').first
      Rails.logger.info "Remote IP: #{remote_ip}" if remote_ip
    end
    @app.call(env)
  end
end
