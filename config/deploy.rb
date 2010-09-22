$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"

set :rvm_ruby_string, '1.8.7'

set :application, "voeis"
set :use_sudo,    false

set :scm, :git
set :repository,  "git://github.com/yogo/yogo.git"
set :shell, "/bin/bash"

set :branch, "apps/voeis"
set :deploy_via, :remote_cache
set :copy_exclude, [".git"]

set  :user, "voeis-demo"
role :web, "klank.msu.montana.edu"
role :app, "klank.msu.montana.edu"
set  :deploy_to, "/home/#{user}/voeis"


default_run_options[:pty] = false

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

# namespace :deploy do
#   desc "Restart Server"
#   task :restart, :roles => :app do
#    run "TZ=America/Denver #{current_path}/lib/trinidad.sh restart"
#   end
#
#   desc "Start Server"
#   task :start, :roles => :app do
#     run "TZ=America/Denver #{current_path}/lib/trinidad.sh start"
#   end
#
#   desc "Stop Server"
#   task :stop, :roles => :app do
#     run "TZ=America/Denver #{current_path}/lib/trinidad.sh stop"
#   end
# end

namespace :db do
  desc "Seed initial data"
  task :seed, :roles => :app do
    run "bash -c 'cd #{current_path} && RAILS_ENV=production rake db:seed'"
  end

  desc  "Clear out test data"
  task :clear, :roles => :app do
    run "bash -c 'cd #{current_path} && rake db:drop:all'"
  end

  task :setup do
    run "mkdir -p #{deploy_to}/#{shared_dir}/db/persvr"
    run "mkdir -p #{deploy_to}/#{shared_dir}/db/sqlite3"
    run "mkdir -p #{deploy_to}/#{shared_dir}/vendor/persevere"
  end

  task :symlink do
    run "ln -nfs #{deploy_to}/#{shared_dir}/db/persvr #{release_path}/db/persvr"
    run "rm -rf #{release_path}/db/sqlite3"
    run "ln -nfs #{deploy_to}/#{shared_dir}/db/sqlite3 #{release_path}/db/sqlite3"
    run "ln -nfs #{deploy_to}/#{shared_dir}/vendor/persevere #{release_path}/vendor/persevere"
  end
end

# These are one time setup steps
after "deploy:setup",       "db:setup"
#after "db:setup",           "persvr:setup"
#after "persvr:setup",       "persvr:start"

# This happens every deploy
after "deploy:update_code", "db:symlink"

namespace :assets do
  task :setup do
    run "mkdir -p #{deploy_to}/#{shared_dir}/assets/files"
    run "mkdir -p #{deploy_to}/#{shared_dir}/assets/images"
  end

  task :symlink do
    run "ln -nfs #{deploy_to}/#{shared_dir}/assets/files #{release_path}/public/files"
    run "ln -nfs #{deploy_to}/#{shared_dir}/assets/images #{release_path}/public/images"
  end
end
after "deploy:setup",       "assets:setup"
after "deploy:update_code", "assets:symlink"

namespace :bundle do
  desc "Run bundle install on the server"
  task :install do
    run("bash -c 'cd #{release_path} && rm Gemfile.lock && bundle install'")
  end
end
after 'deploy:update_code', 'bundle:install'

namespace :persvr do
  desc "Setup Persevere on the server"
  task :setup do
    run("bash -c 'cd #{current_path} && rake persvr:setup'")
  end

  desc "Start Persevere on the server"
  task :start do
    puts '************************* This takes me a long time sometimes *************************'
    puts '************************************* Be patient **************************************'
    run("bash -c 'cd #{current_path} && rake persvr:start PERSEVERE_HOME=#{deploy_to}/#{shared_dir}/vendor/persevere RAILS_ENV=production'")
  end

  desc "Stop Persevere on the server"
  task :stop do
    puts '************************* This takes me a long time sometimes *************************'
    puts '************************************* Be patient **************************************'
    run("bash -c 'cd #{current_path} && rake persvr:start PERSEVERE_HOME=#{deploy_to}/#{shared_dir}/vendor/persevere RAILS_ENV=production'")
  end

  task :drop do
    run("bash -c 'cd #{current_path} && rake persvr:drop PERSEVERE_HOME=#{deploy_to}/#{shared_dir}/vendor/persevere RAILS_ENV=production'")
  end

  task :version do
    run("bash -c 'cd #{current_path} && rake persvr:version PERSEVERE_HOME=#{deploy_to}/#{shared_dir}/vendor/persevere RAILS_ENV=production'")
  end
end
