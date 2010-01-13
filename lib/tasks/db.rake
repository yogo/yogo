namespace :db do
  namespace :example do

    desc "Copies the example database into persevere."
    task :load => :environment do
      DataMapper::Reflection.setup(:binding => binding, :database => :example)
      DataMapper::Reflection.create_all_models_from_database
      
      DataMapper::Reflection.setup(:binding => binding, :database => :yogo)

      [Warehouse, Customer, OrderLine, Order, Item, History, NewOrder, Stock, District].each do |model|
        json_schema = model.send(:to_json_schema_compatible_hash)
        json_schema["id"] = "example_project/#{json_schema["id"]}"
        puts json_schema.to_json
        
        collection = model.all

        repository(:yogo).adapter.put_schema(json_schema)
        DataMapper::Reflection.create_model_from_db(json_schema["id"])
        yogo_model = eval("ExampleProject::#{model.name}")

        collection.each{|item| yogo_model.create!(item.attributes) }

      end
    end
    
    desc "Clears the example database from persevere."
    task :clear => :environment do
    end

  end
end
