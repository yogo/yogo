require 'datamapper/factory'

# Setup reflections
DataMapper::Reflection.setup(:database => :yogo)
DataMapper::Reflection.create_all_models_from_database
