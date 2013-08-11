require 'bundler/capistrano'
require 'airbrake/capistrano'
require 'capistrano-unicorn'
require 'capistrano/maintenance'
require './config/boot'

default_run_options[:pty] = true
#ssh_options[:port] = 31337
ssh_options[:keys] = [File.join(ENV['HOME'], '.ssh', 'id_rsa')]
ssh_options[:forward_agent] = true

set :application, 'idealme'
set :scm, :git
set :repository, 'ssh://git@bitbucket.org/billxinli/idealme.git'
set :deploy_via, :remote_cache
set :user, 'deploy'
set :use_sudo, false
set :keep_releases, 5

# Remove No such file/directory warnings.
set :normalize_asset_timestamps, false

set :maintenance_template_path, '/apps/idealme/current/app/views/maintenance.html.erb'
set :maintenance_config_warning, false
set :maintenance_dirname, '/apps/idealme/current/public/static'


task :production do
#...
end

task :staging do
  set :repository, 'ssh://git@bitbucket.org/billxinli/idealme.git'
  set :rails_env, 'staging'
  set :domain, 'idealmedev.com'
  set :deploy_to, '/apps/idealme'
  set :branch, 'master'
  set :keep_releases, 1
  set :db_destruction, true

  role :app, domain
  role :web, domain
  role :db, domain, :primary => true
end

namespace :db do
  desc 'Drop database'
  task :drop do
    if exists?(:db_destruction)
      run "cd #{current_path}; bundle exec rake db:drop RAILS_ENV=#{rails_env}"
    end
  end
  
  desc 'Seed database'
  task :seed do
    if exists?(:db_destruction)
      run "cd #{current_path}; bundle exec rake  db:seed:development:users db:seed:development:goals db:seed:development:goal_users db:seed:development:checkins db:seed:development:categories db:seed:development:jewels db:seed:development:courses db:seed:development:cms comfortable_mexican_sofa:fixtures:import FROM=idealme TO=idealme RAILS_ENV=#{rails_env}"
    end
  end
end

after 'deploy:restart', 'unicorn:restart' # app preloaded
