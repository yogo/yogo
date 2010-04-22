require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'
require 'rubygems'
require 'rubygems/gem_runner'

desc 'Default: run specs.'
task :default => :spec

desc 'Run the specs for yogo_'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--colour --format progress --loadby mtime --reverse']
  t.spec_files = FileList['spec/**/*_spec.rb']
end


desc 'Generate documentation for the yogo_ plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Yogo'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('app/**/*.rb')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name    = "yogo_"
    gem.summary = "Autorization and Authenication for the yogo toolkit."
    gem.email   = "yogo@montana.edu"
    gem.homepage = "http://neurosys.msu.montana.edu/Yogo/index.html"
    gem.authors = "Team Yogo"
    gem.add_dependency "authlogic"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available."
end