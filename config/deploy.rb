require 'bundler/capistrano'
require "delayed/recipes"

default_run_options[:pty] = true
default_environment['LD_LIBRARY_PATH'] = '/opt/IBM/informix/lib:/opt/IBM/informix/lib/esql:/opt/IBM/informix/lib/cli:/usr/lib/sqlapi' 
default_environment['INFORMIXSERVER'] = 'cpcecf_desar'
default_environment['RAILS_RELATIVE_URL_ROOT'] = '/methodology_app'

set :application, 'methodology_app'
set :rails_env, "production" #added for delayed job 

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

desc "Symlink the config.local.yml file from shared
      directory to current release directory."
task :symlink_config_local_yml, :roles => :app do
  run "ln -nsf #{shared_path}/config/config.local.yml
       #{release_path}/config/config.local.yml"
end
after 'deploy:update_code', 'symlink_config_local_yml'

desc "Symlink the public/images directory
      to nginx's html directory."
task :symlink_images_dir, :roles => :app do
  sudo "ln -nsf #{current_path}/public/images
       /opt/nginx/html/images"
end
after 'deploy:update_code', 'symlink_images_dir'

# Delayed Job  
before "deploy:restart", "delayed_job:stop"
after  "deploy:restart", "delayed_job:start"

after "deploy:stop",  "delayed_job:stop"
after "deploy:start", "delayed_job:start"

namespace(:deploy) do
  desc 'Restart the app server'
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
after 'deploy', 'deploy:cleanup'