require 'pry'
require 'hipchat/capistrano'
require 'recap/recipes/rails'
require './config/boot'

set :application, 'idealme'
set :repository, 'git@github.com:flingbob/idealme.git'

server 'mvp', :app

set :application, 'idealme'
set :repo_url, 'git@github.com:flingbob/idealme.git'

#set :branch, 'mvp'

set_default_env :RAILS_ENV, 'production'

# hipchat config
set :hipchat_token, '2876c736673caf9c04fd310cdb2e47'
set :hipchat_room_name, "Notifications" # If you pass an array such as ["room_a", "room_b"] you can send announcements to multiple rooms.
set :hipchat_announce, false # notify users
set :hipchat_color, 'gray' #normal message color
set :hipchat_success_color, 'green' #finished deployment message color
set :hipchat_failed_color, 'red' #cancelled deployment message color
set :hipchat_message_format, 'text' # Sets the deployment message format, see https://www.hipchat.com/docs/api/method/rooms/message

real_revision = `git rev-parse HEAD`
set :real_revision, real_revision
set :current_revision, real_revision

set(:asset_precompilation_triggers, %w(app/assets vendor/assets Gemfile.lock))

namespace :deploy do
  desc "Restart the application following a deploy"
  task :restart do
    as_app "kill -s TERM $(cat /home/idealme/sidekiq.pid)"
    as_app "bundle exec pumactl -P /home/idealme/puma.idealme.pid restart"
  end

  desc "Notifies Honeybadger locally using curl"
  task :notify_honeybadger do
    require 'json'
    require 'honeybadger'

    begin
      require './config/initializers/honeybadger'
    rescue LoadError
      logger.info 'Honeybadger initializer not found'
    else
      honeybadger_api_key = Honeybadger.configuration.api_key
      local_user          = ENV['USER'] || ENV['USERNAME']
      honeybadger_env     = fetch(:rails_env, "production")
      notify_command      = "curl -sd 'deploy[repository]=#{repository}&deploy[revision]=#{current_revision}&deploy[local_username]=#{local_user}&deploy[environment]=#{honeybadger_env}&api_key=#{honeybadger_api_key}' https://api.honeybadger.io/v1/deploys"
      logger.info "Notifying Honeybadger of Deploy (`#{notify_command}`)"
      result = JSON.parse `#{notify_command}` rescue nil
      result ||= { 'error' => 'Invalid response' }
      if result.include?('error')
        logger.info "Honeybadger Notification Failed: #{result['error']}"
      else
        logger.info "Honeybadger Notification Complete."
      end
    end
  end
end

after 'deploy', 'deploy:notify_honeybadger'
after 'deploy:migrations', 'deploy:notify_honeybadger'


desc 'copy ckeditor nondigest assets'
task :copy_nondigest_assets, roles: :app do
  as_app "cd /home/idealme/app && bundle exec rake RAILS_ENV=production ckeditor:copy_nondigest_assets"
end
after 'rails:assets:precompile', 'copy_nondigest_assets'

