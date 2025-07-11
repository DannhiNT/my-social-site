# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

# server def
server "18.143.172.153", port: 22, roles: [ :web, :app, :db ], primary: true

# basic prj info
set :application, "mysocialsite"
set :repo_url, "git@github.com:DannhiNT/my-social-site.git"

# git info
set :branch, "main"

# ssh server user
set :user, "deploy"

# where to deploy
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}" # /home/deploy/apps/mysocialsite

# puma settings
set :puma_threads, [ 4, 16 ]
set :puma_workers, 2

# capistrano deploy behavior
set :pty, true
set :use_sudo, false
set :stage, :production
set :deploy_via, :remote_cache

# puma binds path
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log, "#{release_path}/log/puma.error.log"

# Point to correct systemd unit:
set :puma_service_unit_name, "puma_mysocialsite_production"

# ssh options
set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w[~/.ssh/id_ed25519] }

# puma advanced settings
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

# link dirs and files
append :linked_files, "config/master.key", ".env", "config/database.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor", "storage"

# lang

set :default_env, { LANG: "C.UTF-8", LC_ALL: "C.UTF-8" }


namespace :puma do
  desc "Restart Puma"
  task :restart do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, "puma_mysocialsite_production.service"
    end
  end
end

# after "deploy:publishing", "puma:restart"

set :puma_systemctl_user, :system
