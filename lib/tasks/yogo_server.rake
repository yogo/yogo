namespace :yogo do
  pid_file = File.join(Rails.root, 'tmp', 'pids', 'server.pid')

  desc "Start the Yogo System"
  task :start => ['yogo:stop', 'persvr:start'] do
    cd ::Rails.root.to_s do
      sh "script/server -d"
    end
    Rake::Task['yogo:stop'].reenable
  end

  desc "Open Yogo in a web browser"
  task :open do
    times_tried = 0
    begin
      sleep 3
      times_tried += 1
      Net::HTTP.new('localhost', '3000').send_request('GET', '/', nil, {})
    rescue Exception => e
      if times_tried == 1
        Rake::Task['yogo:start'].invoke
        retry
      end
      retry if times_tried < 20
      Rake::Task['yogo:stop'].execute
      fail "Could not connect to the yogo server on port 3000!"
    end
    sh "open http://localhost:3000" do |ok,res|
      if ok
        puts "Yogo opened in browser: http://localhost:3000"
      else
        puts "Couldn't open your browser. Goto http://localhost:3000 in your browser to open yogo!"
      end
    end
    Rake::Task['yogo:open'].reenable
  end

  desc "Stop the Yogo System"
  task :stop do
    begin
      open(pid_file) do |pf|
        pid = pf.read.to_i
        puts "Stopping Yogo Server (#{pid})"
        # Try to stop politely first, then more aggressively
        Process.kill("TERM", pid)
        puts "Waiting for server to exit"
        sleep 3
        Process.kill("TERM", pid)
        sleep 3
        Process.kill("INT", pid)
        sleep 3
        Process.kill("INT", pid)
        sleep 3
        Process.kill("KILL", pid)
        sleep 3
        Process.kill("KILL", pid)
        rm_f pid_file
      end
    rescue Errno::ENOENT
      puts "Yogo Server not running"
    rescue Errno::ESRCH => e    # catch the above Process.kills if process already exited
      puts "Server stopped"
      rm_f pid_file
    ensure
      Rake::Task['persvr:stop'].invoke
      Rake::Task['yogo:start'].reenable
    end
  end

  desc "Restart the Yogo System"
  task :restart => ['yogo:stop'] do
    Rake::Task['yogo:start'].invoke
    Rake::Task['yogo:restart'].reenable
  end

  desc "Destroy the Yogo databases and restore everything to clean state."
  task :clean => ['yogo:stop', 'persvr:stop_all'] do
    puts "Clearing all yogo data and restoring to clean state!"
    Rake::Task['persvr:drop'].invoke
    sh "git clean -X -d -f"
    Rake::Task['yogo:clean'].reenable
  end

  desc "Update and install the ruby gems required by yogo"
  task :gems do
    sh "gem bundle"
  end

  desc "Update the Yogo system from the source repository"
  task :update => ['yogo:stop'] do
    puts "Updating yogo from the git repository!"
    cd ::Rails.root.to_s do
      sh "git pull"
    end
    Rake::Task['yogo:gems'].invoke
    Rake::Task['persvr:setup'].invoke
  end
end