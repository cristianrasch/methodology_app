require 'bundler/capistrano'

set :user, 'cristian'
default_run_options[:pty] = true

set :application, "methodology_app"
set :repository,  "ssh://git@git-server:14725/~/repos/#{application}.git"

set :scm, :git
# set :user, 'git'
set :deploy_via, :remote_cache
set :deploy_to, "/home/#{user}/public_html/#{application}"

role :app, 'dev'
# set :user, 'cristian'
role :db,  "uruguay", :primary => true

desc "Symlink the database config file from shared
      directory to current release directory."
task :symlink_database_yml do
  run "ln -nsf #{shared_path}/config/database.yml
       #{release_path}/config/database.yml"
end
after 'deploy:update_code', 'symlink_database_yml'

after 'deploy', 'deploy:cleanup'

namespace(:deploy) do
  desc 'Restart the app server'
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end