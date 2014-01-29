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
      remote_ip = env["HTTP_X_FORWARDED_FOR"]
      if remote_ip
        remote_ip = split(',').first
        Rails.logger.info "Exclude #{remote_ip} from analytics"
        $redis.sadd("im_excluded_ips", remote_ip) unless remote_ip.blank?
      end
      Rails.logger.info env
      [200, {"Content-Type" => "text/plain"}, ["Your IP has been added to the analytics exclude list"]]
    else
      # forward the request
      @app.call(env)
    end
  end
end
