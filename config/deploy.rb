
set :application, 'idealme'
set :repo_url, 'git@github.com:flingbob/idealme.git'

set :branch, 'origin/mvp'

set_default_env :RAILS_ENV, 'production'

# set :scm, :git

#set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }


# hipchat config
set :hipchat_token, ENV['HIPCHAT_AUTH_TOKEN']
set :hipchat_room_name, "Notifications" # If you pass an array such as ["room_a", "room_b"] you can send announcements to multiple rooms.
set :hipchat_announce, false # notify users
set :hipchat_color, 'gray' #normal message color
set :hipchat_success_color, 'green' #finished deployment message color
set :hipchat_failed_color, 'red' #cancelled deployment message color
set :hipchat_message_format, 'text' # Sets the deployment message format, see https://www.hipchat.com/docs/api/method/rooms/message

namespace :deploy do
  desc "Restart the application following a deploy"
  task :restart do
  end
end




