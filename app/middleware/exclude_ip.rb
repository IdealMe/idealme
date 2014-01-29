class ExcludeIp
  def initialize(app)
    @app = app
  end

  def call(env)
    path = env['ORIGINAL_FULLPATH']
    if path == '/__exclude_ip?list'
      ips = $redis.smembers("im_excluded_ips").join("\n")
      [200, {"Content-Type" => "text/plain"}, [ips]]
    elsif path == '/__exclude_ip?clear'
      $redis.del('im_excluded_ips')
      [200, {"Content-Type" => "text/plain"}, ["Exclude list cleared"]]
    elsif path == '/__exclude_ip'
      ip = env['X-Real-IP']
      Rails.logger.info "Exclude #{ip} from analytics"
      $redis.sadd("im_excluded_ips", ip) unless ip.blank?
      [200, {"Content-Type" => "text/plain"}, ["Your IP has been added to the analytics exclude list"]]
    else
      # forward the request
      @app.call(env)
    end
  end
end
