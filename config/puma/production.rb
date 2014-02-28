
threads 8,16
workers 4
bind 'unix:///home/idealme/puma.idealme.sock'
daemonize false
pidfile '/home/idealme/puma.idealme.pid'
state_path '/home/idealme/puma.idealme.state'
stdout_redirect '/home/idealme/app/log/puma.stdout.log', '/home/idealme/app/log/puma.stderr.log', true
environment 'production'
directory '/home/idealme/app'
preload_app!


