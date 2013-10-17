set :application, 'idealme'
set :repo_url, 'git@bitbucket.org:idealmeinc/ideal.me.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :branch, 'mvp'

set :deploy_to, '~/apps/idealme'
# set :scm, :git

set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

SSHKit.config.command_map[:rake] = "~/.rvm/bin/idealme_bundle exec rake"

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      execute :bluepill, "restart idealme"
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

