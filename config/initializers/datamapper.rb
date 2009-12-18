# Read the configuration from the existing database.yml file
config = YAML.load(File.new(File.join(Rails.root, "config", "database.yml")))

# Setup the default datamapper repository corresponding to the current rails environment
# unnecessary: rails-datamapper handles this 
DataMapper.setup(:default, config[Rails.env])

# Setup the persevere repository for cool fun research!
DataMapper.setup(:yogo, config["yogo"])

# Map the datamapper logging to rails logging
DataMapper.logger = Rails.logger
