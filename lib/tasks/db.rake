# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: db.rake
# 
#
namespace :yogo do
  namespace :db do
    desc "Import legacy database into Yogo."
    task :import, :db, :name, :needs => :environment do |task, args|
      # FIXME - we need to make this rake task work at some point
      return 

      # # Connect to the legacy database
      # DataMapper.setup(:import, args[:db])
      #  # We'll create a new project with the name of the imported database
      #  project = Project.create(:name => args[:name])
      #  # Iterate through each model and make it in persevere, then copy instances
      #  models = DataMapper::Reflection.reflect(:import)
      #  puts "There are #{models.length} models to process. They are:"
      #  puts "\t#{models.join("\n\t")}"
      #  models.each do |model|
      #    mphash = Hash.new
      #    model.properties.each do |prop| 
      #      mphash[prop.name] = { :type => prop.type, :key => prop.key?, :serial => prop.serial? } 
      #      mphash[prop.name].merge!({:default => prop.default}) if prop.default? 
      #    end
      #    model_hash = { :name       => model.name.camelcase, 
      #                   :modules    => ["Yogo", args[:name].camelcase], 
      #                   :properties => mphash }
      #    yogo_model =factory.build(model_hash, :yogo, { :attribute_prefix => "yogo" })
      #    yogo_model.auto_migrate!
      #    print "Created #{yogo_model}, importing data..."
      #    # Create each instance of the class
      #    model.all.each do |item| 
      #      yogo_model.create!(item.attributes) 
      #    end
      #    print "done!\n"
      #  end
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
  
    desc "Backup all databases"
    task :backup, :needs => [:backup_master, :backup_projects]
  
    desc "Backup the databases with pg_backup"
    task :backup_master, :needs => :environment do
      current_db = repository(:default).adapter.options
      host          = current_db[:host] || 'localhost'
      port          = current_db[:port] || 5432
      username      = current_db[:username]
      database      = current_db[:path]
      output_path   = "#{::Rails.root.to_s}/db/backup"
      command =<<-CMD
        pg_dump -h #{host}          \
                -p #{port}          \
                -U #{username}  \
                -F plain   \
                --no-owner --clean --no-privileges --verbose \
                -f "#{output_path}/#{database}" \
                "#{database}"
      CMD
      # puts command
      system(command)
    end
    
    desc "Backup project databases with pg_backup"
    task :backup_projects, :needs => [:environment] do
      project_config = Rails::DataMapper.configuration.repositories["yogo-db"]["default"]
      host         = project_config["host"] || localhost
      port         = project_config["port"] || 5432
      username     = project_config["username"]
      output_path  = "#{::Rails.root.to_s}/db/backup"
      command = []
      command << 'pg_dump'
      command << "-h #{host}"
      command << "-p #{port} "
      command << "-U #{username} " unless username.blank?
      command << "--format plain"
      command << "--no-owner"
      command << "--clean"
      command << "--no-privileges"
      command << "--verbose"
      Project.all.each do |project|
        project_opts = project.managed_repository.adapter.options
        database = project_opts["database"]
        current_commands = command.dup
        current_commands << "-f \"#{output_path}/#{database}\""
        current_commands <<  "\"#{database}\""
        # puts current_commands.join(' ')
        system(*current_commands)
      end
    end
  end
end