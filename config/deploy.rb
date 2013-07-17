require 'bundler/capistrano'
require 'airbrake/capistrano'
require './config/boot'

default_run_options[:pty] = true
ssh_options[:port] = 31337
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


task :staging do
  set :rails_env, 'staging'
  set :domain, '198.58.105.102'
  set :deploy_to, '/webapps/idealme'
  set :branch, 'master'
  set :keep_releases, 1
  role :app, domain
  role :web, domain
  role :db, domain, :primary => true
end

#If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do
    ;
  end
  task :stop do
    ;
  end
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end
end
        require './config/boot'
        require 'airbrake/capistrano'
