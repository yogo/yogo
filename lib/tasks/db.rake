require 'ruby-debug'
namespace :yogo do
  namespace :db do
    desc "Import legacy database into Yogo."
    task :import, :db, :name, :needs => :environment do |task, args|
      # Connect to the legacy database
      return 
      DataMapper.setup(:import, args[:db])
       # We'll create a new project with the name of the imported database
       project = Project.create(:name => args[:name])
       # Iterate through each model and make it in persevere, then copy instances
       models = DataMapper::Reflection.reflect(:import)
       puts "There are #{models.length} models to process. They are:"
       puts "\t#{models.join("\n\t")}"
       models.each do |model|
         mphash = Hash.new
         model.properties.each do |prop| 
           mphash[prop.name] = { :type => prop.type, :key => prop.key?, :serial => prop.serial? } 
           mphash[prop.name].merge!({:default => prop.default}) if prop.default? 
         end
         model_hash = { :name       => model.name.camelcase, 
                        :modules    => ["Yogo", args[:name].camelcase], 
                        :properties => mphash }
         yogo_model = DataMapper::Factory.build(model_hash, :yogo)
         yogo_model.auto_migrate!
         print "Created #{yogo_model}, importing data..."
         # Create each instance of the class
         model.all.each do |item| 
           yogo_model.create!(item.attributes) 
         end
         print "done!\n"
       end
    end

    namespace :example do
      desc "Copies the example database into persevere."
      task :load => :environment do
        Yogo::Loader.load(:example, "Example Project")
        DataMapper::Reflection.reflect(:yogo)
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
        Project.first(:name => "Example Project").destroy!
      end
    end
  end
end