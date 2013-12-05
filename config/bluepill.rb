

Bluepill.application("idealme", log_file: "/var/log/bluepill.log") do |app|
  app.process("puma") do |process|
    process.start_command    = "bundle exec puma -C config/puma/production.rb"
    process.pid_file         = "/tmp/pids/puma.idealme.pid"
    process.start_grace_time = 30.seconds
    process.daemonize        = true
  end
end
