require 'rubygems'
require 'pathname'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = %q{dm-persevere-adapter}
    gemspec.summary = %q{A DataMapper Adapter for persevere}
    gemspec.description = %q{A DataMapper Adapter for persevere}
    gemspec.email = ["irjudson [a] gmail [d] com"]
    gemspec.homepage = %q{http://github.com/yogo/dm-persevere-adapter}
    gemspec.authors = ["Ivan R. Judson", "The Yogo Data Management Development Team" ]
    gemspec.rdoc_options = ["--main", "README.txt"]
    gemspec.add_dependency(%q<dm-core>, [">= 0.10.1"])
    gemspec.add_dependency(%q<persevere>, [">= 1.1"])
    gemspec.add_dependency(%q<extlib>)
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

ROOT    = Pathname(__FILE__).dirname.expand_path
JRUBY   = RUBY_PLATFORM =~ /java/
WINDOWS = Gem.win_platform?
SUDO    = (WINDOWS || JRUBY) ? '' : ('sudo' unless ENV['SUDOLESS'])

require ROOT + 'lib/persevere_adapter'

Pathname.glob(ROOT.join('tasks/**/*.rb').to_s).each { |f| require f }