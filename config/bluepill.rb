

Bluepill.application("idealme", :log_file => "/home/idealme/apps/idealme/shared/log/bluepill.log") do |app|
  app.process("unicorn") do |process|
    process.start_command = "/home/idealme/.rvm/bin/idealme_bundle exec unicorn -c config/unicorn/production.rb -D"
    process.pid_file = "/home/idealme/apps/idealme/shared/tmp/pids/unicorn.pid"
  end
end