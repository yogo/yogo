module Odhelper
  def self.default_repository_name
    :his
  end
  
  def upgrade_projects
    DataMapper::Model.descendants.each do |model|
      begin
        model::Version
      rescue
      end
    end
    Project.all.each do |project|
      project.managed_repository do
        # 
        puts project.name
        DataMapper.auto_upgrade!
        Voeis::SensorTypeSensorValue.auto_upgrade!
        Voeis::SensorValue.auto_upgrade!
        Voeis::SensorType.auto_upgrade!
        Voeis::Site.auto_upgrade!
        Voeis::Sample.auto_upgrade!
        Voeis::DataValue.auto_upgrade!
        Voeis::Variable.auto_upgrade!
        Voeis::DataStream.auto_upgrade!
        # Voeis::SensorType.all.each do |sensor|
        #   if !sensor.sensor_values.nil?
        #     sensor.sensor_values.all.update!(:sensor_id => sensor.id)
        #   end
        # end
      end
    end
  end
  
  def fix_scientific_data(project)
    project.managed_repository do
      Voeis::SensorValue.all(:value => -9999.0).each do |val|
        if /^[-]?[\d]+(\.?\d*)(e?|E?)(\-?|\+?)\d*$|^[-]?(\.\d+)(e?|E?)(\-?|\+?)\d*$/.match(val.string_value)
          val.value = val.string_value.to_f
          val.save
        end
      end
    end
  end
  
  def load_his_site_data (project, site, his_site, site_variables)
    #create a new data_stream
      #his_site = His::Site.first(:site_code => site.code)
      puts his_site
      if !his_site.nil?
        @site_data_stream = project.managed_repository{Voeis::DataStream.first_or_create(:name => site.code+'_HIS_legacy', :start_line => -9999, :filename => "NA")}
        #site_variables = His::DataValue.all(:site_id => his_site.id).all(:fields => [:variable_id], :unique => true)
        #site_variables = His::Variable.all
        site_variables.each do |var|
          #create a variable
          #puts @his_var = His::Variable.get(var.id)
          @project_var = project.managed_repository{Voeis::Variable.store_from_his(var)}
          #create a data_column
          @data_column =""
          puts "before First"
          first_val = His::DataValue.first(:site_id => his_site.id, :variable_id => var.id)
          if first_val.nil?
            #do nothing
          else
            puts "inside"
            project.managed_repository do
              puts @data_column = Voeis::DataStreamColumn.create(
                :column_number => -9999,
                :name => @project_var.variable_code,
                :type => "Legacy",
                :unit => "NA",
                :original_var => "Legacy")
              @data_column.data_streams << @site_data_stream
              @data_column.variables << @project_var
              @data_column.save!
            end
            #create a sensor_type
            @sensor_type =""
            project.managed_repository do
              puts @sensor_type = Voeis::SensorType.create(
                            :name => @project_var.variable_name + @site.name,
                            :min => 0.0,
                            :max => 0.0,
                            :difference => 0.0)
              #Add sites and variable associations to senor_type
              @sensor_type.sites << site
              @sensor_type.variables <<  @project_var
              @sensor_type.data_stream_columns << @data_column
              @sensor_type.save!
              site.variables << project_var
              site.save!
            end
            #create all the sensor_values
            # 
            @his_unit = His::Unit.get(@project_var.variable_units_id)
            @unit = ""
            parent.managed_repository do
              @unit = Voeis::Unit.first_or_create(
                :units_name => @his_unit.units_name, 
                :units_type => @his_unit.units_type, 
                :units_abbreviation =>@his_unit.units_abbreviation)
              @unit.variables << @project_var
              @unit.save!
            end
            end_time = His::DataValue.last(:site_id => site.id, :variable_id => var.id, :order => [:local_date_time.asc]).local_date_time
            start_time = Time.now - 2000.year
            while start_time != end_time
              His::DataValue.all(:site_id => site.id, :variable_id => var.id, :local_date_time.gte => start_time, :limit => 10).each do |val|
                #create sensor value
                #associate with site
                #associate with sensor_type
                #associate with data_columns
                #associate with variable
                parent.managed_repository do
                  puts sensor_value = Voeis::SensorValue.new(
                    :value => val.data_value,
                    :units => @unit.units_name,
                    :timestamp => val.local_date_time,
                    :published => true,
                    :string_value => val.data_value.to_s)
                  logger.info {sensor_value.valid?}
                  logger.info{sensor_value.errors.inspect()}
                  sensor_value.save!
                  logger.info{sensor_type_array[i].id}
                  sensor_value.sensor_type << @sensor_type
                  sensor_value.site << site
                  sensor_value.variables << @project_var
                  sensor_value.save!
                  start_time = val.local_date_time
                end #end manged_repo
              end #each |val|
            end #while
          end #end if first_val
        end #each |var|
      end #if
  end #def
  
  
  
  def search_to_ruport
    p = Project.first
    r = Array.new
    p.managed_repository{Voeis::SensorValue.properties.map{|k| r << k.name}}
    csv = r.to_csv + p.managed_repository{Voeis::SensorValue.all(:id.gt => 130100).to_csv}
    File.open("my_temp.csv", 'w'){|f| f.write(csv)}
    csv_data = CSV.read "my_temp.csv"
    headers = csv_data.shift.map{|i| i.to_s}
    string_data = csv_data.map{|row| row.map{|cell| cell.to_s} }
    table = Ruport::Data::Table.new :data=> string_data, :column_names => headers
    table.pivot 'sensor_id', :group_by => "timestamp", :values => "string_value"
    
    
    
    
  end
end