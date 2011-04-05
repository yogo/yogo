# Ensure our 'print' statments are displayed when we expect them
# to be.
STDOUT.sync = true

namespace :yogo do
  namespace :destructive do


    def model_has_field?(model, field)
      model.properties.map(&:name).include?(field.to_sym)
    end
    
    def model_has_created_at?(model)
      #      model.properties.map(&:name).include?(:created_at)
      model_has_field?(model, :created_at)
    end

    def table_has_field?(model, field, repo_name = :default)
      table_name = model.storage_name(repo_name)
      schema_name = repository(repo_name).adapter.schema_name

      query = DataMapper::Ext::String.compress_lines(<<-SQL)
            SELECT "column_name"
                 , "data_type"
                 , "column_default"
                 , "is_nullable"
                 , "character_maximum_length"
                 , "numeric_precision"
              FROM "information_schema"."columns"
             WHERE "table_schema" = ?
               AND "table_name" = ?
          ORDER BY "ordinal_position"
        SQL
      
      columns = repository(repo_name).adapter.select(query, schema_name, table_name)
      
      return columns.collect{ |i| i.column_name }.include?(field.to_s)
    end
    
    def table_has_created_at?(model, repo_name = :default)
      return table_has_field?(model, "created_at", repo_name)
    end

    def fix_timestamp_column(model, repo_name)
      if model.storage_exists?(repo_name) && model_has_field?(model, :sensor_value_timestamp) && table_has_field?(model, "sensor_value_timsestamp", repo_name)
        puts "Fixing Column in #{model.name}"
        repository(repo_name).adapter.execute("ALTER TABLE #{model.storage_name} RENAME sensor_value_timsestamp TO sensor_value_timestamp")
      end
    end

    def add_missing_fields(model, repo_name = :default)
      return if model.name.match(/^His/) || !model.storage_exists?(repo_name)
      model.properties.each do |prop|
        if !table_has_field?(model, prop.name, repo_name)
          puts "Adding a #{prop.name} to #{model.name}"
          repository(repo_name).adapter.execute("ALTER TABLE #{model.storage_name} ADD COLUMN #{prop.name} integer")
        end
      end
    end
    
    desc "Remove all 'voeis_*' datababses (might not work)"
    task :remove_all, :needs => :environment do
     databases = repository(:default).adapter.select("SELECT datname FROM pg_database WHERE datname like 'voeis_%'")

      puts 'Deleting those tables'

      databases.each do |database|
        repository(:default).adapter.execute("DROP DATABASE \"#{database}\"")
      end
      
    end
    
    desc "Destroy and reacreate the database from ashes."
    task :firebird, :needs => :environment do
      puts 'Reworking master database'
      DataMapper.finalize

      puts 'Finding empty VOEIS tables to destroy!'
      tables = repository(:default).adapter.select("select relname from pg_stat_user_tables WHERE schemaname='public' and relname like 'voeis_%'")

      puts 'Deleting those tables'
      repository(:default).adapter.execute("DROP TABLE #{tables.join(', ')}") unless tables.empty?

      voeis_models = DataMapper::Model.descendants.select{|d| d.name.match(/^Voeis::/) }

      # storage_names = voeis_models.inject([]){|memo,vm| memo << [vm.storage_name.match(/^voeis_(\w+)/)[1], vm]}

      puts 'Moving old tables into the voeis namespace'
      voeis_models.each do |model|
        old_storage_name = model.storage_name.match(/^voeis_(\w+)/)[1]

        old_existance = repository(:default).adapter.select("select relname from pg_stat_user_tables WHERE schemaname='public' and relname='#{old_storage_name}'")

        unless old_existance.empty?
          # Rename the table to the new name.
          repository(:default).adapter.execute("ALTER TABLE #{old_storage_name} RENAME TO #{model.storage_name}")
          # Rename relationship rows if need be
        end

      end
      
      puts 'Manually renaming some columns'
      repository(:default).adapter.execute("ALTER TABLE voeis_sites RENAME site_name TO name")
      repository(:default).adapter.execute("ALTER TABLE voeis_sites RENAME site_code TO code")

      # Change this DatMapper Set into an array
      models = DataMapper::Model.descendants.collect{ |i| i }

      models.each do |model|
        if model.storage_exists? && model_has_created_at?(model) && !table_has_created_at?(model)
          # Make stupid column in the table
          puts "Add Column in #{model.name}"
          repository(:default).adapter.execute("ALTER TABLE #{model.storage_name} ADD COLUMN created_at timestamp without time zone")
#          model.all.update_attri
          # Seed it with something interesting
          # Fix column to make it non nullable
        end
      end

      puts 'Running auto_upgrade! on the master repository'
      
      DataMapper.auto_upgrade!
      
      Project.all.each do |p| 
        puts "Running auto_upgrade! on #{p.managed_repository_name}"
        p.managed_repository do
          models = DataMapper::Model.descendants.collect{ |i| i }
          puts "There are supposidly #{models.count} models"
          models.each do |model|
            next if !model.storage_exists?(p.managed_repository_name)
            fix_timestamp_column(model, p.managed_repository_name)
            if model.storage_exists?(p.managed_repository_name) && model_has_created_at?(model) && !table_has_created_at?(model, p.managed_repository_name)
                puts "Add Column in #{model.name}"
                repository(p.managed_repository_name).adapter.execute("ALTER TABLE #{model.storage_name} ADD COLUMN created_at timestamp without time zone")
            end
            add_missing_fields(model, p.managed_repository_name)
            
            if model_has_created_at?(model)
#              puts "UPDATE #{model.storage_name} SET created_at = '#{DateTime.now.strftime("%Y-%m-%d %T")}' WHERE created_at IS NULL"
              repository(p.managed_repository_name).adapter.execute("UPDATE #{model.storage_name} SET created_at = '#{DateTime.now.strftime("%Y-%m-%d %T")}' WHERE created_at IS NULL" )
            end
          end
          # Threading issue?

#          models.each{|m| puts "Auto Upgrading #{m.name}"; m.auto_upgrade!(p.managed_repository_name) }
          DataMapper.auto_upgrade!(p.managed_repository_name)
        end
      end
    end
    
  end
end



