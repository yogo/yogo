begin 
  gem 'metric_fu' 
  require 'metric_fu' 

  MetricFu::Configuration.run do |config| 
    config.metrics        = [ :stats, :churn, :saikuro, :flay, :flog, :reek, :roodi, :rcov ] 
    config.graphs         = [ :flog, :flay, :reek, :roodi, :rcov ] 
    config.flay           = { :dirs_to_flay        => ['app', 'lib'] } 
    config.flog           = { :dirs_to_flog        => ['app', 'lib'] } 
    config.reek           = { :dirs_to_reek        => ['app', 'lib'] } 
    config.roodi          = { :dirs_to_roodi       => ['app', 'lib'] } 
    config.saikuro        = { :input_directory     => ['app', 'lib'], 
                              :cyclo               => "", 
                              :filter_cyclo        => "0", 
                              :warn_cyclo          => "5", 
                              :error_cyclo         => "7", 
                              :formater            => "text" } 
    config.churn          = { :start_date          => "1 year ago", 
                              :minimum_churn_count => 10 }
    config.rcov           = { :environment         => 'test',
                              :test_files          => [ "spec/**/*_spec.rb" ],
                              :rcov_opts           => [ "--sort coverage", 
                                                        "--no-html", 
                                                        "--text-coverage",
                                                        "--no-color",
                                                        "--profile",
                                                        "--rails",
                                                        "--exclude /gems/,/Library/,spec" ] }
    config.graph_engine = :bluff
#    config.graph_engine = :gchart
  end 
rescue LoadError 
end
