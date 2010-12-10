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
  end
rescue Exception => e
  puts 'Delayed Job not loaded'
end