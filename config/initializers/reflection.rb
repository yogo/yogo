require 'datamapper/factory'

# Reflect Yogo data into memory
DataMapper::Reflection.reflect(:yogo) unless (ENV['NO_PERSEVERE'] || Rails.env == "test")
