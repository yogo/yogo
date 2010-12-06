begin
  require 'dm-visualizer/rake/rails/graphviz_task'
  DataMapper::Visualizer::Rake::Rails::GraphVizTask.new
rescue
  puts "dm-visualizer not loaded"
end