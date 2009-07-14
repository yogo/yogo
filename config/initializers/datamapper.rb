# Read the configuration from the existing database.yml file
config = YAML.load(File.new(File.join(Rails.root, "config", "database.yml")))

# Setup the default datamapper repository corresponding to the current rails environment
DataMapper.setup(:default, config[Rails.env])

# Map the datamapper logging to rails logging
DataMapper.logger = Rails.logger
