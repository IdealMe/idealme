class RemoteIpLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    # remote_ip = env["HTTP_X_FORWARDED_FOR"]
    remote_ip = env['action_dispatch.remote_ip']
    if remote_ip
      # remote_ip = remote_ip.split(',').first
      Rails.logger.info "Remote IP: #{remote_ip}" if remote_ip
    end
    @app.call(env)
  end
end
