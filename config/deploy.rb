require 'bundler/capistrano'

default_run_options[:pty] = true

set :application, 'methodology_app'

set :scm, :git
set :repository,  "ssh://git@git-server:14725/~/repos/#{application}.git"

role :app, 'dev'
set :user, 'cristian'
set :deploy_via, :remote_cache
set :deploy_to, "/home/#{user}/public_html/#{application}"

role :db,  'uruguay', :primary => true, :no_release => true

desc "Symlink the database config file from shared
      directory to current release directory."
task :symlink_database_yml, :roles => :app do
  run "ln -nsf #{shared_path}/config/database.yml
       #{release_path}/config/database.yml"
end
after 'deploy:update_code', 'symlink_database_yml'

after 'deploy', 'deploy:cleanup'

namespace(:deploy) do
  desc 'Restart the app server'
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end