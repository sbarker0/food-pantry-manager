require "rvm/capistrano"
require "bundler/capistrano"
set :application, "pantry"
set :repository,  "git@github.com:tbrooke/food-pantry-manager.git"
set :user, 'deployer'
set :ssh_options, {:forward_agent => true}
set :use_sudo, false
set :rvm_type, :user
default_run_options[:pty] = true
set :scm, :git

set :deploy_to, "/var/www/pantry"
set :branch, "master"
set :deploy_via, :remote_cache
set :use_sudo, false

server "192.168.1.30", :web, :app, :db, primary: true
#set :port, 25000
ssh_options[:forward_agent] = true

role :web,    "192.168.1.30"
role :app,    "192.168.1.30"
role :db,     "192.168.1.30", :primary => true


after 'deploy:update_code', 'deploy:symlink_db'
after "deploy:symlink_db", "deploy:migrate"

namespace :deploy do
    desc "Symlinks the database.yml"
      task :symlink_db, :roles => :app do
            run "ln -nfs #{shared_path}config/database.yml #{release_path}/config/database.yml"
              end
end



require 'simple-capistrano-unicorn'
after :deploy, "unicorn:restart"



require 'simple-capistrano-unicorn'
after :deploy, "unicorn:restart"

