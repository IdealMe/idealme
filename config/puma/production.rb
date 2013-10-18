
threads 8,64
workers 3
bind 'unix:///tmp/puma.idealme.sock'
daemonize true
pidfile '/tmp/pids/puma.idealme.pid'
state_path '/tmp/pids/puma.idealme.state'
stdout_redirect '/home/idealme/apps/idealme/shared/log/puma.stdout.log', '/home/idealme/apps/idealme/shared/log/puma.stderr.log', true
environment 'production'
directory '/home/idealme/apps/idealme/current'
preload_app!
