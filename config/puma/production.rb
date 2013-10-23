
threads 8,64
workers 3
bind 'unix:///tmp/puma.idealme.sock'
daemonize true
pidfile '/tmp/pids/puma.idealme.pid'
state_path '/tmp/pids/puma.idealme.state'
stdout_redirect '/home/idealme/app/log/puma.stdout.log', '/home/idealme/app/log/puma.stderr.log', true
environment 'production'
directory '/home/idealme/app'
preload_app!
