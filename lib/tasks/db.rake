namespace :db do
  namespace :example do

    desc "Copies the example database into persevere."
    task :load => :environment do
      DataMapper::Reflection.setup(:binding => binding, :database => :example)
      DataMapper::Reflection.create_all_models_from_database
      
      # DataMapper::Reflection.setup(:binding => binding, :database => :yogo)

      [Warehouse, Customer, OrderLine, Order, Item, History, NewOrder, Stock, District].each do |model|
        json_schema = model.send(:to_json_schema_compatible_hash)
        json_schema["id"] = "yogo/example_project/#{json_schema["id"]}"
        
        class_def = DataMapper::Factory.describe_model_from_json_schema(json_schema, :yogo)
        # puts class_def
        eval(class_def)
        
        collection = model.all

        yogo_model = eval("Yogo::ExampleProject::#{model.name}")
        yogo_model.auto_migrate!

        collection.each{|item| yogo_model.create!(item.attributes) }

      end
    end
    
    desc "Clears the example database from persevere."
    task :clear => :environment do
    end

  end
end
