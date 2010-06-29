set :application, "crux"
set :use_sudo,    false

set :scm, :git
set :repository,  "git://github.com/pol/crux.git"

set :branch, "master"
set :deploy_via, :remote_cache
set :copy_exclude, [".git"]

# set :user, "yogo"
# 
# role :web, "yogo.cns.montana.edu"                          # Your HTTP server, Apache/etc
# role :app, "yogo.cns.montana.edu"                          # This may be the same as your `Web` server

set :ran_user_settings, false

task :user_settings do
  if !ran_user_settings
    set :user, "crux"
    set :deploy_to, "/home/crux/"
    server "crux.msu.montana.edu", :app, :web, :db, :primary => true
    server_prompt = "What server are you deploying to?"
    set :temp_server, Proc.new { Capistrano::CLI.ui.ask(server_prompt)}
    role :web, "#{temp_server}"
    role :app, "#{temp_server}"
    user_prompt = "What user are you deploying to the server under? (defaults to 'yogo')"
    set :temp_user, Proc.new { Capistrano::CLI.ui.ask(user_prompt)}
    if temp_user.empty?
      set :user, "yogo"
      set :deploy_to, "/home/yogo/rails/yogo/"
    else
      set :user, "#{temp_user}"
      set :deploy_to, "/home/#{temp_user}/rails/yogo/"
    end
    set :ran_user_settings, true
  end
end

[ "bundle:install", "deploy", "deploy:check", "deploy:cleanup", "deploy:cold", "deploy:migrate",
  "deploy:migrations", "deploy:pending", "deploy:pending:diff", "deploy:rollback", "deploy:rollback:code",
  "deploy:setup", "deploy:symlink", "deploy:update", "deploy:update_code", "deploy:upload", "deploy:web:disable",
  "deploy:web:enable", "invoke", "persvr:setup", "persvr:start", "persvr:stop", "persvr:drop",
  "persvr:version", "shell" ].each do |task|
  before task, :user_settings
end

# before deploy, :user_settings

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :db do
  task :setup do
    run "mkdir -p #{deploy_to}#{shared_dir}/database/persvr"
    run "mkdir -p #{deploy_to}#{shared_dir}/database/persevere"
  end
  
  task :symlink do
    run "ln -nfs #{deploy_to}#{shared_dir}/database/persvr #{release_path}/db/persvr"
    run "ln -nfs #{deploy_to}#{shared_dir}/database/persevere #{release_path}/vendor/persevere"
  end
end
after "deploy:setup",       "db:setup"
after "deploy:update_code", "db:symlink"

namespace :tomcat do
  task :setup do
    run "mkdir -p #{deploy_to}#{shared_dir}/vendor/blazeds"
  end
  
  task :symlink do
    run "ln -nfs #{deploy_to}#{shared_dir}/vendor/blazeds #{release_path}/vendor/blazeds"
  end
end
after "deploy:setup",       "tomcat:setup"
after "deploy:update_code", "tomcat:symlink"

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

task :setup_for_server do
  run("rm #{release_path}/config/settings.yml && cp #{release_path}/config/server_settings.yml #{release_path}/config/settings.yml")
end
after "deploy:update_code", "setup_for_server"

namespace :bundle do
  desc "Run bundle install on the server"
  task :install do
    run("bash -c 'cd #{release_path} && bundle install'")
  end
end
after 'setup_for_server', 'bundle:install'

namespace :tomcat do
  desc "Start the Tomcat Instance on the server (blazeds and persevere)"
  task :start do
    puts '************************* This takes me a long time sometimes *************************'
    puts '************************************* Be patient **************************************'
    run("bash -c 'cd #{current_path} && rake blazeds:start RAILS_ENV=production'")
  end
  
  desc "Stop the Tomcat Instance on the server (blazeds and persevere)"
  task :stop do
    puts '************************* This takes me a long time sometimes *************************'
    puts '************************************* Be patient **************************************'
    run("bash -c 'cd #{current_path} && rake blazeds:stop RAILS_ENV=production'")
  end
end

namespace :persvr do
  desc "Setup Persevere on the server"
  task :setup do
    run("bash -c 'cd #{current_path} && rake persvr:setup'")
  end
  
  desc "Start Persevere on the server"
  task :start do
    puts '************************* This takes me a long time sometimes *************************'
    puts '************************************* Be patient **************************************'
    run("bash -c 'cd #{current_path} && rake persvr:start PERSEVERE_HOME=#{deploy_to}#{shared_dir}/database/persevere RAILS_ENV=production'")
  end
  
  desc "Stop Persevere on the server"
  task :stop do
    puts '************************* This takes me a long time sometimes *************************'
    puts '************************************* Be patient **************************************'
    run("bash -c 'cd #{current_path} && rake persvr:start PERSEVERE_HOME=#{deploy_to}#{shared_dir}/database/persevere RAILS_ENV=production'")
  end
  
  task :drop do
    run("bash -c 'cd #{current_path} && rake persvr:drop PERSEVERE_HOME=#{deploy_to}#{shared_dir}/database/persevere RAILS_ENV=production'")
  end
  
  task :version do
    run("bash -c 'cd #{current_path} && rake persvr:version PERSEVERE_HOME=#{deploy_to}#{shared_dir}/database/persevere RAILS_ENV=production'")
  end
end
