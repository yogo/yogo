# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: persvr.rake
# 
#

require 'slash_path'
require 'yaml'
require 'net/http'

namespace :persvr do
  PERSVR_CMD = ENV['PERSVR'] || (ENV['PERSEVERE_HOME'] && ENV['PERSEVERE_HOME']/:bin/:persvr) || RAILS_ROOT/'vendor/bundled/bin/persvr' || 'persvr'
  
  def config(env)
    cfg = YAML.load_file(RAILS_ROOT/:config/'persvr.yml')[env]
    raise "Persevere configuration does not exist for environment: #{env}" unless cfg
    raise "Persevere configuration does not contain a port for environment: #{env}" unless cfg['port']
    raise "Persevere configuration does not contain a database path for environment: #{env}" unless cfg["database"]
    return cfg
  end
  
  task :version do
    sh "#{PERSVR_CMD} --version" do |ok,resp|
      unless ok
        fail "persvr was not found! Ensure persevere is installed and set PERSEVERE_HOME to the path of your persevere install."
      end
    end
  end
  
  desc "Download and unpack persevere for development"
  task :setup do
    persvr_zip = RAILS_ROOT/:tmp/'persvr.zip'
    vendor_dir = RAILS_ROOT/:vendor
    # Grab persevere from http://persevere-framework.googlecode.com/files/persevere1.0.1.rc2.zip
    Net::HTTP.start("persevere-framework.googlecode.com") do |http|
      resp = http.get("/files/persevere1.0.1.rc2.zip")
      open(persvr_zip, "wb") { |file| file.write(resp.body) }
    end
    
    # unpack it in vendor/persevere
    sh "unzip -o #{persvr_zip} -d #{vendor_dir} > /dev/null 2>&1"
    
    # link vendor/persevere/bin/persvr to vendor/bundled/bin/persvr
    sh "ln -f -s #{vendor_dir}/persevere/bin/persvr #{vendor_dir}/bundled/bin/persvr"
    
    # Chmod +x
    sh "chmod +x #{vendor_dir}/persevere/bin/persvr"
    
    # Clean up zip file
    sh "rm #{persvr_zip}"
  end
  
  desc "Cleanup vendor installed persevere"
  task :remove do
    vendor_dir = RAILS_ROOT/:vendor
    
    # Remove the link
    sh "rm #{vendor_dir}/bundled/bin/persvr"
    
    # Remove the installed code
    sh "rm -rf #{vendor_dir}/persevere"
  end
  
  desc "Create the persevere instance for the current environment."
  task :create => [:version] do
    cfg = config(RAILS_ENV)
    cd RAILS_ROOT do
      sh "#{PERSVR_CMD} --gen-server #{cfg['database']}" unless File.exist? RAILS_ROOT/cfg['database']
    end
    Rake::Task['persvr:drop'].reenable
  end
  
  desc "Remove the persevere instance for the current environment."
  task :drop => [:version, :stop] do
    cfg = config(RAILS_ENV)
    rm_rf RAILS_ROOT/cfg['database'] if File.exist?(RAILS_ROOT/cfg['database'])
    Rake::Task['persvr:create'].reenable
  end
  
  desc "Clear the database of the persevere instance for the current environment."
  task :clear => [:version, :stop] do
    cfg = config(RAILS_ENV)
    if File.exist?(RAILS_ROOT/cfg['database'])
      cd RAILS_ROOT/cfg['database'] do
        sh "#{PERSVR_CMD} --eraseDB" do |ok|
          puts "No database to clear." if !ok
        end
      end
    end
    Rake::Task['persvr:clear'].reenable
  end
  
  def start_persvr(interactive=false)
    cfg = config(RAILS_ENV)
    cd RAILS_ROOT/cfg['database'] do
      if File.exist? "./WEB-INF/process"
        puts "Persevere instance already running in #{RAILS_ROOT/cfg['database']}"
      else
        if defined? JRUBY_VERSION
          puts "I can't fork the persvr into a background process from JRuby."
          puts "You will need to execute `rake pesvr:start` from a separate shell if you want to run script/server."
          puts "Starting persvr #{RAILS_ENV} instance in #{RAILS_ROOT/cfg['database']}..."
          exec "#{PERSVR_CMD} --start --port #{cfg['port']}"
        else
          log = RAILS_ROOT/:log/"persvr_#{RAILS_ENV}.log"
          pid = Process.fork do
            puts "Starting background persvr #{RAILS_ENV} instance in #{RAILS_ROOT/cfg['database']}..."
            puts "...logging persvr output to #{log}."
            exec "#{PERSVR_CMD} --start --port #{cfg['port']} > #{log} 2>&1" 
          end
          Process.detach(pid)
          
          # Now we wait for the background process to come up
          times_tried = 0
          begin
            sleep 0.45
            times_tried += 1
            Net::HTTP.new('localhost', cfg['port']).send_request('GET', '/', nil, {})
          rescue Exception => e
            retry if times_tried < 20
            Rake.application['persvr:stop'].execute
            fail 'The perserver server didn\'t come up properly.'
          end
        end
      end
    end
  end
  
  desc "Start the persevere instance for the current environment."
  task :start => [:version, :stop, :create] do
    start_persvr
    Rake::Task['persvr:stop'].reenable
    Rake::Task['persvr:stop_all'].reenable
    #sh "reset" # starting persvr seems to mess up the terminal sometimes; reset to fix
  end
  
  desc "Stop the persevere instance for the current environment."
  task :stop => :version do
    cfg = config(RAILS_ENV)
    if File.exist?(RAILS_ROOT/cfg['database'])
      cd RAILS_ROOT/cfg['database'] do
        if File.exist? '.'/'WEB-INF'/'process'
          sh "#{PERSVR_CMD} --stop"
        else
          puts "Persevere instance not running in #{RAILS_ROOT/cfg['database']}"
        end
      end
    end
    Rake::Task['persvr:start'].reenable
  end
  
  task :stop_all => :version do
    FileList[RAILS_ROOT/:db/:persvr/'*'].each do |dir|
      if File.exist? dir/'WEB-INF'/'process'
        cd dir do
          puts "Stopping persevere instance in #{dir}"
          sh "#{PERSVR_CMD} --stop"
        end
      end
      Rake::Task['persvr:start'].reenable
    end
  end
  
  task :status => :version do
    puts "-"*50
    puts "Status  \t Instance"
    puts "-"*50
    FileList[RAILS_ROOT/:db/:persvr/'*'].each do |dir|
      if File.exist? dir/'WEB-INF'/'process'
        puts "RUNNING \t #{dir}"
      else
        puts "STOPPED: #{dir}"
      end
    end
    Rake::Task['persvr:status'].reenable
  end
end