
threads 8,64
workers 3
bind 'unix:///home/idealme/puma.idealme.sock'
daemonize false
#pidfile '/tmp/pids/puma.idealme.pid'
state_path '/home/idealme/puma.idealme.state'
stdout_redirect '/home/idealme/app/log/puma.stdout.log', '/home/idealme/app/log/puma.stderr.log', true
environment 'production'
directory '/home/idealme/app'
preload_app!


