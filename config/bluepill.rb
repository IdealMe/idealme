

Bluepill.application("idealme", :log_file => "/path/to/bluepill.log") do |app|
  app.process("unicorn") do |process|
    process.start_command = "/home/idealme/.rvm/bin/idealme_bundle exec unicorn -c config/unicorn/production.rb"
    process.pid_file = "/home/idealme/apps/idealme/shared/tmp/pids/unicorn.pid"
  end
end