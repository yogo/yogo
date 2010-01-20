require 'datamapper/factory'

# Reflect Yogo data into memory
DataMapper::Reflection.reflect(:yogo) unless Rails.env == "test"