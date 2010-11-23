namespace :yogo do
  namespace :destructive do
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

      puts 'Running auto_upgrade! on the master repository'
      DataMapper.auto_upgrade!
      
      Project.all.each do |p| 
        puts "Running auto_upgrade! on #{p.managed_repository_name}"
        p.managed_repository{ DataMapper.auto_upgrade!(p.managed_repository_name)}
      end
    end
    
  end
end