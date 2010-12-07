begin
  require 'dm-visualizer/rake/rails/graphviz_task'
  DataMapper::Visualizer::Rake::Rails::GraphVizTask.new
rescue Exception => e
  puts "dm-visualizer not loaded"
end