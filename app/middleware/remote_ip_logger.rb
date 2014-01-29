class RemoteIpLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    remote_ip = env["action_dispatch.remote_ip"]
    Rails.logger.info "Remote IP: #{remote_ip}" if remote_ip
    @app.call(env)
  end
end
