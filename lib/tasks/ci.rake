
# Make the cucumber and spec tasks dependent on a running, clean persvr instance


namespace :ci do
  desc "Testing/Build hook for continous integration"
  task :build => ['yogo:spec', 'yogo:cucumber']
end