# config/deploy.rb
require "rvm/capistrano"
require "bundler/capistrano"
#require 'sidekiq/capistrano'

set :scm,             :git
set :repository,      "git@bitbucket.org:idealmeinc/ideal.me.git"
set :branch,          "origin/mvp"
set :migrate_target,  :current
set :ssh_options,     { :forward_agent => true }
set :rails_env,       "production"
set :deploy_to,       "/home/idealme/apps/idealme"
set :normalize_asset_timestamps, false

set :user,            "idealme"
# set :group,           "staff"
set :use_sudo,        false

# set :sidekiq_role,    :sidekiq
# set :sidekiq_pid,     "/tmp/sidekiq.pid"

server "mvp", :app, :web, :sidekiq, :db, :primary => true

set(:latest_release)  { fetch(:current_path) }
set(:release_path)    { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }

set(:current_revision)  { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:latest_revision)   { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:previous_revision) { capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip }

default_environment["RAILS_ENV"] = 'production'

rvm_ruby = "ruby-2.0.0-p247"

default_environment["PATH"]         = "/home/idealme/.rvm/gems/#{rvm_ruby}@idealme/bin:/home/idealme/.rvm/gems/#{rvm_ruby}@global/bin:/home/idealme/.rvm/rubies/#{rvm_ruby}/bin:/home/idealme/.rvm/bin:/Users/idealme/.rvm/gems/#{rvm_ruby}/bin:/Users/idealme/.rvm/gems/#{rvm_ruby}@global/bin:/Users/idealme/.rvm/rubies/#{rvm_ruby}/bin:/Users/idealme/.rvm/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/Users/idealme"
default_environment["GEM_HOME"]     = "/home/idealme/.rvm/gems/#{rvm_ruby}@idealme"
default_environment["RUBY_HOME"]     = "/home/idealme/.rvm/rubies/#{rvm_ruby}"
default_environment["GEM_PATH"]     = "/home/idealme/.rvm/gems/#{rvm_ruby}@idealme:/home/idealme/.rvm/gems/#{rvm_ruby}@global:/home/idealme/apps/idealme/current/forked"
default_environment["RUBY_VERSION"] = "#{rvm_ruby}@idealme"
set :bundle_cmd,      "/home/idealme/.rvm/gems/#{rvm_ruby}@global/bin/bundle" # e.g. "/opt/ruby/bin/bundle"


default_run_options[:shell] = 'zsh'
set :rvm_install_shell, :zsh

#before 'deploy:setup', 'rvm:install_rvm'
#before 'deploy', 'halt_sidekiq'
before 'deploy:assets:precompile', 'deploy:assets:touch_manifest'

# after 'deploy:restart', 'deploy:restart_god'

namespace :deploy do
  desc "Deploy your application"
  task :default do
    update
    restart
  end

  desc "Setup your git-based deployment app"
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d) }
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
    run "git clone #{repository} #{current_path}"
  end

  task :cold do
    update
    migrate
  end

  task :update do
    transaction do
      update_code
    end
  end

  desc "Update the deployed code."
  task :update_code, :except => { :no_release => true } do
    run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
    finalize_update
  end

  desc "Update the database (overwritten to avoid symlink)"
  task :migrations do
    transaction do
      update_code
    end
    migrate
    restart
  end

  task :finalize_update, :except => { :no_release => true } do
    #run "sudo chmod -R g+w #{latest_release}" if fetch(:group_writable, true)

    # mkdir -p is making sure that the directories are there for some SCM's that don't
    # save empty folders
    run <<-CMD
      rm -rf #{latest_release}/log #{latest_release}/public/system #{latest_release}/tmp/pids &&
      mkdir -p #{latest_release}/public &&
      mkdir -p #{latest_release}/tmp &&
      ln -s #{shared_path}/log #{latest_release}/log &&
      ln -s #{shared_path}/system #{latest_release}/public/system &&
      ln -s #{shared_path}/pids #{latest_release}/tmp/pids
    CMD

    if fetch(:normalize_asset_timestamps, true)
      stamp = Time.now.utc.strftime("%Y%m%d%H%M.%S")
      asset_paths = fetch(:public_children, %w(images stylesheets javascripts)).map { |p| "#{latest_release}/public/#{p}" }.join(" ")
      run "find #{asset_paths} -exec touch -t #{stamp} {} ';'; true", :env => { "TZ" => "UTC" }
    end
  end

  desc "Zero-downtime restart of Unicorn"
  task :restart, :except => { :no_release => true }, :roles => :app do
    #run "kill -s HUP `cat /tmp/unicorn.idealme.pid`"

    run "kill -s QUIT `cat /tmp/unicorn.idealme.pid`"
    run "cd #{current_path} ; bundle exec unicorn -c config/unicorn.rb -D"
  end

  # desc "Restart god"
  # task :restart_god, :except => { :no_release => true }, :roles => [:app, :db] do
  #   run "cd #{current_path} ; bundle exec god stop idealme"
  #   run "cd #{current_path} ; bundle exec god terminate"
  #   run "cd #{current_path} ; bundle exec god -c config/idealme.god"
  # end

  desc "Start unicorn"
  task :start, :except => { :no_release => true }, :roles => :app do
    run <<-CMD
      rm -rf #{current_path}/tmp/pids
    CMD
    run "cd #{current_path} ; bundle exec unicorn -c config/unicorn.rb -D"
  end

  desc "Stop unicorn"
  task :stop, :except => { :no_release => true }, :roles => :app do
    run "kill -s QUIT `cat /tmp/unicorn.idealme.pid`"
  end

  namespace :assets do
    task :touch_manifest do
      run "touch #{shared_path}/assets/manifest.yml"
    end
  end

  namespace :rollback do
    desc "Moves the repo back to the previous version of HEAD"
    task :repo, :except => { :no_release => true } do
      set :branch, "HEAD@{1}"
      deploy.default
    end

    desc "Rewrite reflog so HEAD@{1} will continue to point to at the next previous release."
    task :cleanup, :except => { :no_release => true } do
      run "cd #{current_path}; git reflog delete --rewrite HEAD@{1}; git reflog delete --rewrite HEAD@{1}"
    end

    desc "Rolls back to the previously deployed version."
    task :default do
      rollback.repo
      rollback.cleanup
    end
  end
end

def run_rake(cmd)
  run "cd #{current_path}; #{rake} #{cmd}"
end
