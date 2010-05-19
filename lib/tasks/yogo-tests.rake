namespace :yogo do
  
  # Ensure a normalized RAILS_ENV before anything else starts
  task :test_env do
    puts "Setting RAILS_ENV = 'test'"
    ENV['RAILS_ENV'] = 'test'
    RAILS_ENV = 'test'
    Rake::Task['yogo:test_env'].reenable #reenable so that we can always reset if something stomps on the env
  end
  
  desc "Bring up a clean persvr instance for testing"
  task :persvr_test => ['yogo:test_env', 'persvr:drop', 'persvr:start'] do
    Rake::Task['yogo:persvr_test_cleanup'].reenable
  end
  
  desc "Shutdown and drop the persvr testing instance"
  task :persvr_test_cleanup do
    Rake::Task['persvr:drop'].invoke
    Rake::Task['yogo:persvr_test'].reenable
  end
  
  desc "Run cucumber tests. Sets up, starts, and cleans up the required persvr instance."
  task :cucumber => 'yogo:cucumber:ok'
  namespace :cucumber do
    task 'ok' => ['yogo:persvr_test'] do
      begin
        Rake::Task['cucumber:ok'].invoke
        Rake::Task['yogo:persvr_test_cleanup'].invoke
      rescue Exception => e
        Rake::Task['yogo:persvr_test_cleanup'].invoke
        raise e
      end
    end
    
    task 'wip' => ['yogo:persvr_test'] do
      begin
        Rake::Task['cucumber:wip'].invoke
        Rake::Task['yogo:persvr_test_cleanup'].invoke
      rescue Exception => e
        Rake::Task['yogo:persvr_test_cleanup'].invoke
        raise e
      end
    end
  end
  
  
  desc "Run spec tests. Sets up, starts, and cleans up the required persvr instance."
  task :spec => ['yogo:persvr_test'] do
    begin
      Rake::Task['spec'].invoke
      Rake::Task['yogo:persvr_test_cleanup'].invoke
    rescue Exception => e
      Rake::Task['yogo:persvr_test_cleanup'].invoke
      raise e
    end
  end
  
  desc "Run metrics. Sets up, starts, and cleans up the required persvr instance."
  task :metrics => ['yogo:persvr_test'] do
    begin
      Rake::Task['metrics:all'].invoke
      Rake::Task['yogo:persvr_test_cleanup'].invoke
    rescue Exception => e
      Rake::Task['yogo:persvr_test_cleanup'].invoke
      raise e
    end
  end
end