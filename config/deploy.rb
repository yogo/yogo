set :application, "voeis"
set :use_sudo,    false

set :scm, :git
set :repository,  "git://github.com/yogo/yogo.git"

set :branch, "apps/voeis"
set :deploy_via, :remote_cache
set :copy_exclude, [".git"]

set  :user, "voeis-demo"
role :web, "klank.msu.montana.edu"                          # Your HTTP server, Apache/etc
role :app, "klank.msu.montana.edu"                          # This may be the same as your `Web` server
set :deploy_to, "/home/#{user}/voeis/"

namespace :deploy do
  desc "Restart Glassfish"
  task :restart, :roles => :app do
   run "TZ=America/Denver #{current_path}/lib/glassfish.sh restart"
  end

  desc "Start Glassfish"
  task :start, :roles => :app do
    run "TZ=America/Denver #{current_path}/lib/glassfish.sh start"
  end

  desc "Stop Glassfish"
  task :stop, :roles => :app do
    run "TZ=America/Denver #{current_path}/lib/glassfish.sh stop"
  end
end

namespace :db do
  task :setup do
    run "mkdir -p #{deploy_to}#{shared_dir}/db/persvr"
    run "mkdir -p #{deploy_to}#{shared_dir}/db/sqlite3"
    run "mkdir -p #{deploy_to}#{shared_dir}/vendor/persevere"
  end

  task :symlink do
    run "ln -nfs #{deploy_to}#{shared_dir}/db/persvr #{release_path}/db/persvr"
    run "ln -nfs #{deploy_to}#{shared_dir}/db/sqlite3 #{release_path}/db/sqlite3"
    run "ln -nfs #{deploy_to}#{shared_dir}/vendor/persevere #{release_path}/vendor/persevere"
  end
end
after "deploy:setup",       "db:setup"
after "deploy:update_code", "db:symlink"

namespace :assets do
  task :setup do
    run "mkdir -p #{deploy_to}#{shared_dir}/assets/files"
    run "mkdir -p #{deploy_to}#{shared_dir}/assets/images"
  end

  task :symlink do
    run "ln -nfs #{deploy_to}#{shared_dir}/assets/files #{release_path}/public/files"
    run "ln -nfs #{deploy_to}#{shared_dir}/assets/images #{release_path}/public/images"
  end
end
after "deploy:setup",       "assets:setup"
after "deploy:update_code", "assets:symlink"

namespace :bundle do
  desc "Run bundle install on the server"
  task :install do
    run("bash -c 'cd #{release_path} && bundle install'")
  end
end
after 'setup_for_server', 'bundle:install'

namespace :persvr do
  desc "Setup Persevere on the server"
  task :setup do
    run("bash -c 'cd #{current_path} && rake persvr:setup'")
  end

  desc "Start Persevere on the server"
  task :start do
    puts '************************* This takes me a long time sometimes *************************'
    puts '************************************* Be patient **************************************'
    run("bash -c 'cd #{current_path} && rake persvr:start PERSEVERE_HOME=#{deploy_to}#{shared_dir}/vendor/persevere RAILS_ENV=production'")
  end

  desc "Stop Persevere on the server"
  task :stop do
    puts '************************* This takes me a long time sometimes *************************'
    puts '************************************* Be patient **************************************'
    run("bash -c 'cd #{current_path} && rake persvr:start PERSEVERE_HOME=#{deploy_to}#{shared_dir}/vendor/persevere RAILS_ENV=production'")
  end

  task :drop do
    run("bash -c 'cd #{current_path} && rake persvr:drop PERSEVERE_HOME=#{deploy_to}#{shared_dir}/vendor/persevere RAILS_ENV=production'")
  end

  task :version do
    run("bash -c 'cd #{current_path} && rake persvr:version PERSEVERE_HOME=#{deploy_to}#{shared_dir}/vendor/persevere RAILS_ENV=production'")
  end
end
