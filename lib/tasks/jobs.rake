begin
  require 'delayed_job'
  # Re-definitions are appended to existing tasks
  task :environment

  namespace :jobs do
    desc "Clear the delayed_job queue."
    task :clear => [:environment] do
      Delayed::Job.destroy
    end

    desc "Start a delayed_job worker."
    task :work => [:environment] do
      Delayed::Worker.new(:min_priority => ENV['MIN_PRIORITY'], :max_priority => ENV['MAX_PRIORITY']).start
    end
    
    desc "Stop the delayed_job worker."
    task :stop => [:environment] do
      Dir.glob(File.join(::Rails.root.to_s, 'tmp', 'pids', 'delayed_job*')).each do |pid_file|
        File.open(pid_file, 'r') do |file|
          cur_pid = file.read
          puts "Stopping Delayed Job Process #{cur_pid}"
          system('kill', '-INT', cur_pid)
        end
      end
    end
  end
rescue Exception => e
  puts 'Delayed Job not loaded'
end