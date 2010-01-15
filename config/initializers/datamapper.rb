# Read the configuration from the existing database.yml file
config = YAML.load(File.new(File.join(Rails.root, "config", "database.yml")))

# Setup the default datamapper repository corresponding to the current rails environment
# unnecessary: rails-datamapper handles this 
DataMapper.setup(:default, config[Rails.env])

# Setup the persevere repository for cool fun research!
DataMapper.setup(:yogo, config["yogo"]) unless ENV['NO_PERSEVERE']

# Setup the persevere repository for cool fun research!
DataMapper.setup(:example, config["example"]) unless ENV['NO_PERSEVERE']

# Setup reflections
DataMapper::Reflection.setup(:binding => binding, :database => :yogo) unless ENV['NO_PERSEVERE']

# Map the datamapper logging to rails logging
DataMapper.logger = Rails.logger
DataObjects::Postgres.logger  = Rails.logger if DataObjects.const_defined?(:Postgres)
DataObjects::Sqlserver.logger = Rails.logger if DataObjects.const_defined?(:Sqlserver)
DataObjects::Mysql.logger     = Rails.logger if DataObjects.const_defined?(:Mysql)
DataObjects::Sqlite.logger    = Rails.logger if DataObjects.const_defined?(:Sqlite)