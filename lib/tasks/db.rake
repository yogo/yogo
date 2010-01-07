namespace :db do
  namespace :example do
  desc "Copies the example database into persevere."
  task :load => :environment do
    DataMapper::Reflection.setup(:binding => binding, :database => :example)
    DataMapper::Reflection.create_models_from_database

    [Warehouse, Customer, OrderLine, Order, Item, History, NewOrder, Stock, District].each do |model|
      collection = model.all
      repository(:yogo).adapter.put_schema(model.send(:to_json_schema_compatable_hash))
      repository(:yogo) do
        collection.each{|item| model.create!(item.attributes) }
      end
    end
  end
  desc "Clears the example database from persevere."
  task :clear => :environment do
  end
end