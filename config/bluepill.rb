

Bluepill.application("idealme", log_file: "/var/log/bluepill.log") do |app|
  app.process("puma") do |process|
    process.start_command = "/home/idealme/.rvm/bin/idealme_bundle exec puma -c config/puma/production.rb"
    process.pid_file = "/tmp/pids/puma.idealme.pid"
  end
end
