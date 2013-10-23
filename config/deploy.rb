
set :application, 'idealme'
set :repo_url, 'git@github.com:flingbob/idealme.git'

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

#set :branch, 'origin/mvp'

set :deploy_to, '~/apps/idealme'


# set :scm, :git

#set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5


# hipchat config
binding.pry
set :hipchat_token, ENV['HIPCHAT_AUTH_TOKEN']
set :hipchat_room_name, "Notifications" # If you pass an array such as ["room_a", "room_b"] you can send announcements to multiple rooms.
set :hipchat_announce, false # notify users
set :hipchat_color, 'gray' #normal message color
set :hipchat_success_color, 'green' #finished deployment message color
set :hipchat_failed_color, 'red' #cancelled deployment message color
set :hipchat_message_format, 'text' # Sets the deployment message format, see https://www.hipchat.com/docs/api/method/rooms/message

SSHKit.config.command_map[:rake] = "~/.rvm/bin/idealme_bundle exec rake"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute("kill -s USR2 $(cat /tmp/pids/puma.idealme.pid)")
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  before "deploy:migrate", "copy_application_yaml"
  after :finishing, 'deploy:cleanup'

end

