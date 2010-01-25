namespace :yogo do
  namespace :db do
    namespace :example do
      desc "Copies the example database into persevere."
      task :load => :environment do
        require 'ruby-debug'
        # Iterate through each model and make it in persevere, then copy instances
        DataMapper::Reflection.reflect(:example).each do |model|
          mphash = Hash.new
          model.properties.each do |prop| 
            mphash[prop.name] = { :type => prop.type, :key => prop.key?, :serial => prop.serial? } 
            mphash[prop.name].merge!({:default => prop.default}) if prop.default? 
          end

          model_hash = { :name       => model.name.camelcase, 
                         :modules    => ["Yogo", "ExampleProject"], 
                         :properties => mphash }


          yogo_model = DataMapper::Factory.build(model_hash, :yogo)

          yogo_model.auto_migrate!

          # Create each instance of the class
          model.all.each{ |item| yogo_model.create!(item.attributes) }
        end

       Project.create(:name => "Example Project")
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