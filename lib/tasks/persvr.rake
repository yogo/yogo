require 'slash_path'
require 'yaml'
namespace :persvr do
  persvr_cmd = ENV['PERSVR'] || (ENV['PERSEVERE_HOME'] && ENV['PERSEVERE_HOME']/:bin/:persvr) || 'persvr'
  
  def config(env)
    cfg = YAML.load_file(RAILS_ROOT/:config/'persvr.yml')[env]
    raise "Persevere configuration does not exist for environment: #{env}" unless cfg
    raise "Persevere configuration does not contain a port for environment: #{env}" unless cfg['port']
    raise "Persevere configuration does not contain a database path for environment: #{env}" unless cfg["database"]
    return cfg
  end
  
  task :version do
    sh "#{persvr_cmd} --version" do |ok,resp|
      unless ok
        raise "persvr was not found! Ensure persevere is installed and set PERSEVERE_HOME to the path of your persevere install."
      end
    end
  end
  
  desc "Create the persevere instance for the current environment."
  task :create => [:version] do
    cfg = config(RAILS_ENV)
    cd RAILS_ROOT do
      sh "#{persvr_cmd} --gen-server #{cfg['database']}" unless File.exist? RAILS_ROOT/cfg['database']
    end
  end
  
  desc "Remove the persevere instance for the current environment."
  task :drop => [:version, :stop] do
    cfg = config(RAILS_ENV)
    rm_rf RAILS_ROOT/cfg['database']
  end
  
  desc "Clear the database of the persevere instance for the current environment."
  task :clear => [:version, :stop] do
    cfg = config(RAILS_ENV)
    cd RAILS_ROOT/cfg['database'] do
      sh "#{persvr_cmd} --eraseDB"
    end
  end
  
  desc "Start the persevere instance for the current environment."
  task :start => [:version, :create] do
    cfg = config(RAILS_ENV)
    cd RAILS_ROOT/cfg['database'] do
      if File.exist? "./WEB-INF/process"
        puts "Persevere instance already running in #{RAILS_ROOT/cfg['database']}"
      else
        log = RAILS_ROOT/:log/"persvr_#{RAILS_ENV}.log"
        pid = Process.fork do
          Process.fork do
            puts "Starting persvr #{RAILS_ENV} instance in #{RAILS_ROOT/cfg['database']}..."
            puts "...logging persvr output to #{log}."
            exec "#{persvr_cmd} --start --port #{cfg['port']} &> #{log}" 
          end
        end
        Process.detach(pid)
      end
    end
  end
  
  desc "Stop the persevere instance for the current environment."
  task :stop => :version do
    cfg = config(RAILS_ENV)
    cd RAILS_ROOT/cfg['database'] do
      if File.exist? '.'/'WEB-INF'/'process'
        sh "#{persvr_cmd} --stop"
      else
        puts "Persevere instance not running in #{RAILS_ROOT/cfg['database']}"
      end
    end
  end
  
  task :stop_all => :version do
    FileList[RAILS_ROOT/:db/:persvr/'*'].each do |dir|
      if File.exist? dir/'WEB-INF'/'process'
        cd dir do
          puts "Stopping persevere instance in #{dir}"
          sh "#{persvr_cmd} --stop"
        end
      end
    end
  end
end