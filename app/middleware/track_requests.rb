class TrackRequests
  def initialize(app)
    @app = app
  end

  def call(env)
    path = env['PATH_INFO']
    if path == '/__request_counts'
      [200, { 'Content-Type' => 'text/plain' }, [build_report]]
    elsif path == '/__reset_request_counts'
      reset_counts
      [200, { 'Content-Type' => 'text/plain' }, [build_report]]
    else
      # forward the request
      $redis.incr("request_counts:#{env['REQUEST_PATH']}") unless path =~ /^(\/assets|\/__)/
      @app.call(env)
    end
  end

  def reset_counts
    keys = $redis.keys('request_counts:*')
    keys.each { |key| $redis.del key }
  end

  def build_report
    keys = $redis.keys('request_counts:*')
    keys.sort.map { |key| "#{sprintf("%15d", $redis.get(key))}: #{key.sub("request_counts:", '')}" }.join("\n")
  end
end
