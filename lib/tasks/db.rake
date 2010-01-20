namespace :db do
  namespace :example do

    desc "Copies the example database into persevere."
    task :load => :environment do
      # Creates in memory models from the example database
      models = DataMapper::Reflection.reflect(:example)

      # Iterate through each model and make it in persevere, then copy instances
      models.each do |model|
        # Extract and modify model description from source, to be persevere compliant
        json_schema = model.to_json_schema_compatible_hash(:yogo)
        json_schema["id"] = "yogo/example_project/#{json_schema["id"]}"
        class_def = DataMapper::Factory.describe_model_from_json_schema(json_schema, :yogo)
        
        # Create the new model that is persevere specific
        eval(class_def)
        yogo_model = eval("Yogo::ExampleProject::#{model.name}")
        yogo_model.auto_migrate!
        
        # Create each instance of the class
        model.all.each{ |item| yogo_model.create!(item.attributes) }
      end
    end
    
    desc "Clears the example database from persevere."
    task :clear => :environment do
      # This should work when reflection is more sane.
      models = DataMapper::Reflection.reflect(:yogo)
      models.each do |model|
        model.auto_migrate_down!
        name_array = model.name.split("::")
        if name_array.length == 1
          Object.send(:remove_const, model.name.to_sym)
        else
          ns = eval(name_array[0..-2].join("::"))
          ns.send(:remove_const, name_array[-1].to_sym)
        end
        DataMapper::Model.descendants.delete(model)
      end
    end
  end
end
