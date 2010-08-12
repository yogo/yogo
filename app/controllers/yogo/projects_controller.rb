# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: projects_controller.rb
# The projects controller provides all the CRUD functionality for the project
# and additionally: upload of CSV files, an example project and rereflection
# of the yogo repository.

class Yogo::ProjectsController < ApplicationController

  # Show all the projects
  #
  # @example
  #   get /projects
  #
  # @return [Array] Retrives all project and passes them to the view
  #
  # @author Yogo Team
  #
  # @api public
  def index
    @projects = Project.available.paginate(:page => params[:page], :per_page => 5)
    @project_sites_array = Array.new
    @projects.each do |project|
      sites_array = Array.new
      project.sites.each do |site|
        sites_temp_hash = Hash.new
        sites_temp_hash['lat'] = site.lat.to_f
        sites_temp_hash['long'] = site.long.to_f
        sites_temp_hash['name'] = site.name
        sites_array << sites_temp_hash
      end
      @project_sites_array[project.id] = sites_array
    end
     respond_to do |format|
        format.html
      end
  end

  # Find a project or projects and show the result
  #
  # @example
  #   get /projects/search?q=search-term
  #
  # @return [Model] searches for data across all project all models all content of models
  #
  # @author Yogo Team
  #
  # @api public
  def search
    @search_scope = params[:search_scope]
    @search_term = params[:search_term]

    raise AuthorizationError unless current_user.has_permission?(:search_project)

    if @search_scope == 'everywhere' || params[:model_name].blank?
      @projects = Project.available.search(@search_term)

      @proj_models = []
      Project.available.each do |project|
        @proj_models << [project, project.search_models(@search_term).flatten ]
      end

      @proj_models_data = []
      Project.available.each do |project|
        project.models.each do |model|
          count = model.search(@search_term).count
          @proj_models_data << [project, model, count] if count > 0
        end
      end

      respond_to do |format|
        format.html {
          if @proj_models_data.length == 1
            redirect_to(search_project_yogo_data_url(@proj_models_data[0][0],
                                                     @proj_models_data[0][1],
                                                     :search_term => @search_term))
          end
        }
      end

    else
      project = Project.get(params[:project_id])
      model = project.get_model(params[:model_name])
      respond_to do |format|
        format.html {
          redirect_to search_project_yogo_data_url(project, model, :search_term => @search_term)
        }
      end
    end

  end

  ##
  # Shows a project
  #
  # @example
  #   get /projects/1 # Returnes project with an id of 1
  #
  # @return [Object] returns a web page displaying a project
  #
  # @author Yogo Team
  #
  # @api public
  def show
    @project = Project.get(params[:id])

    if !Setting[:local_only] && @project.is_private?
      raise AuthenticationError if !logged_in?
      raise AuthorizationError  if !current_user.has_permission?(:retrieve_project, @project)
    end

    @models = @project.models
    @sidebar = true
    @sites_array = Array.new
    @project.sites.each do |site|
      sites_temp_hash = Hash.new
      sites_temp_hash['lat'] = site.lat.to_f
      sites_temp_hash['long'] = site.long.to_f
      sites_temp_hash['name'] = site.name
      @sites_array << sites_temp_hash
    end
    respond_to do |format|
      format.html
    end
  end

  ##
  # Returns a form for creating a new project
  #
  # @example
  #   get /projects/new
  #
  # @return [Object] returns an empty project
  #
  # @author Yogo Team
  #
  # @api public
  def new
    @project = Project.new

    respond_to do |format|
      format.html
    end

  end

  ##
  # Creates a new project based on the attributes
  #
  # @example
  #   post /projects
  #
  # @param [Hash] params
  # @option params [Hash] :project this is the attributes of a project
  #
  # @return if the project saves correctly it redirects to show project
  #  else it redirects to new project page
  #
  # @author Yogo Team
  #
  # @api public
  def create
    if !Setting[:local_only]
      flash[:error] = "You need to login first" unless logged_in?
      flash[:error] = "You do not have permission to create the project." unless current_user.has_permission?(:create_projects)
    end

    @project = Project.new(params[:project])

    if @project.save
      flash[:notice] = "Project \"#{@project.name}\" has been created."
        #Check to be sure the default VOEIS project is loaded - create it if it doesn't exist
               if Project.first(:name => "VOEIS").nil?
                 def_project = Project.new()
                 def_project.name = "VOEIS"
                 def_project.description = "The Default VOEIS Project and Repository"
                 def_project.save
                 puts odm_contents = Dir.new("dist/odm").entries
                 odm_contents.each do |content|
                   puts content.to_s + "before"
                   if !content.to_s.index('.csv').nil?
                     puts content.to_s
                     def_project.process_csv('dist/odm/' + content.to_s, content.to_s.gsub(".csv",""))
                   end
                 end
               end
               puts voeis_contents = Dir.new("dist/voeis_default").entries
               voeis_contents.each do |content|
                 puts content.to_s + "before"
                 if !content.to_s.index('.csv').nil?
                   puts content.to_s
                   @project.process_csv('dist/voeis_default/' + content.to_s, content.to_s.gsub(".csv",""))
                 end
               end
      redirect_to projects_url
    else
      flash[:error] = "Project could not be created."
      redirect_to projects_url
    end
  end

  ##
  # load project for editing
  #
  # @example
  #  get /projects/1/edit # edits project with an id of 1
  #
  # @param [Hash] params
  # @option params [String]:id
  #
  # @return [Object] returns a project
  #
  # @author Yogo Team
  #
  # @api public
  def edit
    @project = Project.get(params[:id])

    if !Setting[:local_only]
      raise AuthenticationError unless logged_in?
      raise AuthorizationError  unless @project.roles.users.empty? || current_user.has_permission?(:edit_project,@project)
    end

    respond_to do |format|
      format.html
    end
  end

  ##
  # Updates project with new values
  #
  # @example
  #   put /projects/1
  #
  # @param [Hash] params
  # @option params [String]:id
  # @option params [Hash] :project
  #
  # @return if the project saves correctly it redirects to show project
  #  else it redirects to edit project page
  #
  # @author Yogo Team
  #
  # @api public
  def update
    @project = Project.get(params[:id])

    if !Setting[:local_only]
      raise AuthenticationError unless logged_in?
      raise AuthorizationError  unless current_user.has_permission?(:edit_project,@project)
    end

    params[:project].delete(:name) if params.has_key?(:project)
    @project.attributes = params[:project]
    if @project.save
      flash[:notice] = "Project \"#{@project.name}\" has been updated."
      redirect_to projects_url
    else
      flash[:error] = "Project could not be updated."
      render( :action => :edit )
    end
  end

  ##
  # deletes a project
  #
  # @example
  #   destroy /projects/1
  #
  # @param [Hash] params
  # @option params [String]:id
  #
  # @return no matter what it redirects to
  #  project index page
  #
  # @author Yogo Team
  #
  # @api public
  def destroy
    @project = Project.get(params[:id])

    if !Setting[:local_only]
      flash[:error] = "You need to login first" unless logged_in?
      # We don't know how to check for this permission yet.
      #flash[:error] = "You do not have permission to delete the project." unless current_user.has_permission?(:delete_project, @project)
    end

    if @project.destroy
      flash[:notice] = "Project \"#{@project.name}\" has been destroyed."
    else
      flash[:error] = "Project \"#{@project.name}\" could not be destroyed."
    end
    redirect_to projects_url
  end

  # Create a new dataset on the project with a CSV file
  #
  # @example
  #  post /projects/upload/1 # with a CSV file
  #
  # @param [Hash] params
  # @option params [String]:id
  # @option params [Hash] :upload
  #
  # @return [] always redirects to showproject
  #
  # @author Yogo Team
  #
  # @api public
  def upload
    @project = Project.get(params[:id])

    if !Setting[:local_only]
      raise AuthenticationError unless logged_in?
      raise AuthorizationError  unless current_user.has_permission?(:edit_project,@project)
    end

    if !params[:upload].nil?
      datafile = params[:upload]['datafile']

      if !['text/csv', 'text/comma-separated-values', 'application/vnd.ms-excel',
            'application/octet-stream','application/csv'].include?(datafile.content_type)
        flash[:error] = "File type #{datafile.content_type} not allowed"
        #redirect_to project_url(@project)
      else
        class_name = File.basename(datafile.original_filename, ".csv").singularize.camelcase

        errors =  @project.process_csv(datafile.path, class_name)

        if errors.empty?
          flash[:notice]  = "Spreadsheet imported succesfully."
        else
          flash[:error] = errors.join("\n")
        end
      end

    else
       flash[:error] = "Spreadsheet import error, please try the upload again."
    end

    redirect_to project_url(@project)
  end

  # loads example project and models in Yogo
  #
  # @example
  #   get /projects/loadexample
  #
  # @return redirects to project index page
  #
  # @todo Figure out how this should act when in server mode.
  #
  # @author Yogo Team
  #
  # @api public
  def loadexample
    # Load the cercal db from CSV

    if !Setting[:local_only] && (!logged_in?)
      raise AuthenticationError
    end

    @project = Project.create(:name => "Cricket Cercal System DB")
    if @project.valid?
      errors = @project.process_csv(Rails.root.join("dist", "example_data", "cercaldb", "cells.csv"), "Cell")
      if errors.empty?
        flash[:notice]  = "Example Project imported succesfully."
      else
        flash[:error] = errors.join("\n")
      end
      Setting[:example_project_loaded] = true
      redirect_to project_url(@project)
    else
      flash[:error] = "Example Project could not be created, so was not loaded."
      redirect_to root_url
    end
  end

  def add_site
    @project = Project.get(params[:id])
    puts @sites = Site.all
    respond_to do |format|
      format.html
    end
  end

  def create_site
    site = Site.new(:code => params[:site_code],
             :name => params[:site_name],
             :lat => params[:latitude],
             :long => params[:longitude],
             :state => params[:state])
    if site.save
      site.projects << Project.first(:id => params[:project_id])
      site.save
      flash[:notice]  = "Site created succesfully."
      redirect_to project_path(params[:project_id])
    else
      flash[:error]  = "Site not created. Error!"
      redirect_to project_path(params[:project_id])
    end

  end

  def add_site_to_project
    project = Project.first(:id => params[:project_id])
    project.sites << Site.first(:id => params[:site])
    project.save
    flash[:notice] = "Site added succesfully."
    redirect_to project_path(params[:project_id])

  end

  def add_stream
    @project = Project.get(params[:id])

    respond_to do |format|
      format.html
    end
  end

  # alows us to upload csv file to be processed into data
  #
  # @example http://localhost:3000/project/upload_stream/1/
  #
  # @param [Hash] params
  # @option params [Hash] :upload
  #
  # @return [String] Accepts the upload of a CSV file
  #
  # @author Yogo Team
  #
  # @api public
  def upload_stream
    @project = Project.first(:id => params[:project_id])
    @variables = Variable.all
    @sites = @project.sites
    
    if !params[:upload].nil? && datafile = params[:upload]['datafile']
      if ! ['text/csv', 'text/comma-separated-values', 'application/vnd.ms-excel',
            'application/octet-stream','application/csv'].include?(datafile.content_type)
        flash[:error] = "File type #{datafile.content_type} not allowed"
        redirect_to(:controller =>"projects", :action => "add_stream", :params => {:id => params[:project_id]})
      else

        # Read the logger file header
        if params[:header_box] == "Campbell"
          @start_line = 4
          @header_info = parse_logger_csv_header(datafile.path)
          @row_size = @header_info.size
          @row_size = @row_size - 1 
          if @header_info.empty?
            flash[:error] = "CSV File improperly formatted. Data not uploaded."
            #redirect_to :controller =>"projects", :action => "add_stream", :params => {:id => params[:project_id]}
          end
        else
          @start_line = params[:start_line].to_i
          @row_size = get_row_size(datafile.path, params[:start_line].to_i)-1
        end
      end
      respond_to do |format|
        format.html
      end
    end
  end

  def create_stream
    #create and save new DataStream
    data_stream = DataStream.new(:name => params[:data_stream_name],
                                 :description => params[:data_stream_description],
                                 :filename => params[:datafile],
                                 :project_id => params[:project_id],
                                 :start_line => params[:start_line].to_i)
    data_stream.save

    data_stream.sites << Site.first(:id => params[:site])
    data_stream.save
    #create DataStreamColumns
    site = Site.first(:id => params[:site])
    #header = parse_logger_csv_header(params[:datafile])
    # 
    range = params[:rows].to_i
    (0..range).each do |i|
      puts i.to_s + ": i"
      #create the Timestamp column
      if i == params[:timestamp].to_i
        data_stream_column = DataStreamColumn.new(:column_number => i,
                                                  :name => "Timestamp",
                                                  :type =>"Timestamp",
                                                  :unit => "NA",
                                                  :original_var => params["variable"+i.to_s])                   

        data_stream_column.save
        puts data_stream_column.errors.inspect
        data_stream.data_stream_columns << data_stream_column
        data_stream.save
        puts data_stream_column.errors.inspect
      else
              data_stream_column = DataStreamColumn.new(:column_number => i, 
                                                        :name => params["variable"+i.to_s],
                                                        :original_var => params["variable"+i.to_s],
                                                        :unit => params["unit"+i.to_s],
                                                        :type => params["type"+i.to_s])
              data_stream_column.save
              puts data_stream_column.errors.inspect
              data_stream_column.variables << Variable.first(:id => params["column"+i.to_s])
              data_stream_column.data_streams << data_stream
              data_stream_column.save
              # data_stream.data_stream_columns << data_stream_column
              # data_stream.save 
              # 
              sensor_type = SensorType.first_or_create(:name => params["variable"+i.to_s] + Site.first(:id => params[:site]).name)
              site.sensor_types << sensor_type
              site.save
      end


    end
    parse_logger_csv(params[:datafile], data_stream, site)
    flash[:notice] = "File parsed and stored successfully."
    redirect_to project_path(params[:project_id])
  end

  # parse the header of a logger file
  #
  # @example parse_logger_csv_header("filename")
  #
  # @param [String] csv_file
  #
  # @return [Array] an array whose elements are a hash
  #
  # @author Yogo Team
  #
  # @api public
  def parse_logger_csv_header(csv_file)
    require "yogo/model/csv"
    csv_data = CSV.read(csv_file)
    path = File.dirname(csv_file)

    #look at the first hour lines -
    #line 0 is a description -so skip that one
    #line 1 is the variable names
    #line 2 is the units
    #line 3 is the type
    #store the variable,unit and type for a column as a hash in an array
    header_data=Array.new
    (0..csv_data[1].size-1).each do |i|
      item_hash = Hash.new
      item_hash["variable"] = csv_data[1][i].to_s
      item_hash["unit"] = csv_data[2][i].to_s
      item_hash["type"] = csv_data[3][i].to_s
      header_data << item_hash
    end

    header_data
  end

  def get_row_size(csv_file, row)
    require "yogo/model/csv"
    csv_data = CSV.read(csv_file)
    path = File.dirname(csv_file)

    csv_data[row-1].size
  end
  
  
  
  def parse_logger_csv(csv_file, data_stream_template, site)
    require "yogo/model/csv"
    csv_data = CSV.read(csv_file)
    path = File.dirname(csv_file)
    data_model = Project.first(:id => data_stream_template.project_id).get_model("DataValue")
    sensor_type_array = Array.new
    data_stream_col = Array.new
    data_stream_template.data_stream_columns.each do |col|
      puts col.name
      sensor_type_array[col.column_number] = SensorType.first(:name => col.original_var + site.name)
      data_stream_col[col.column_number] = col
    end
    data_timestamp_col = data_stream_template.data_stream_columns.first(:name => "Timestamp").column_number
    csv_data[data_stream_template.start_line..-1].each do |row|
      (0..row.size-1).each do |i|
        puts i
        if i != data_timestamp_col
          puts row[i]
          data_value = data_model.new
          data_value.yogo__data_value = row[i]
          data_value.yogo__local_date_time = row[data_timestamp_col]
          #if !data_stream_col.variables.first.nil?
          #  data_value.yogo__variable = data_stream_col.variables.first.id 
          #end   
          data_value.save
          #save to sensor_value and sensor_type
          sensor_value = SensorValue.new(:value => row[i],
                                        :units => data_stream_col[i].unit,
                                        :timestamp => row[data_timestamp_col])
                                          
          sensor_value.save
          puts sensor_type_array[i].name
          sensor_value.sensor_type << sensor_type_array[i]
          sensor_value.site << site
          sensor_value.save
        end
      end
    end
  end

  def data_view
    @project = Project.first(:id => params[:id])
    @project_array = Array.new
    temp_hash = Hash.new
    @project_hash = Hash.new
    @site_data = Hash.new
    num_hash = Hash.new
    site_count=-1
    #do we need all the sites or just one? for api access
    if params[:sitecode].nil? # get all sites
      @site_info= @project.sites
    else
      @site_info= Array.new
      @site_info[0]= Site.first(:code => params[:sitecode])
    end

    @site_info.each do |site| # do something for each existing site in a project
       site_count += 1
       if site.status == "Active"
       @plot_data = "{"
        senscount = 0
        @site_hash = Hash.new
        if !site.sensor_types.empty?
          #do we need only a few sensors
          #
          if params[:sensors].nil? #api grab sensors
            @sensor_types = site.sensor_types
          else
            @sensor_types= Array.new
            params[:sensors].each do |type_name|
              begin
                if SensorType.first(:name => type_name)
                  @sensor_types << SensorType.first(:name => type_name)
                end
              rescue

              end
            end
          end

          @sensor_types.each do |s_type| 
            if !s_type.sensor_values.last.nil?
              if senscount != 0 && 
                @plot_data +=  ","
              end
              senscount+=1
              count = 0
          
              @plot_data += '"' + s_type.name + "-" + site.code + '"' + ": {data:["
              # last_time = Time.now
              # tmp_data = site.sensor_values.all(:sensor_type => s_type, :fields => [:timestamp, :value], :limit => 20, :offset => 0 ).collect{|val| "[#{val.timestamp.to_time.to_i*1000}, #{val.value}]"}.join(',')
              @sensor_hash = Hash.new
              if params[:hours].nil?#api grab values for time period
                num = 12

              else
                 num = params[:hours].to_i 
              end
              if params[:begin_date].nil? # get the last ?hrs of data, calc from the last timestamp
                #cur_date = DateTime.now #strptime("2009-11-17T08:45:00+00:00")
                cur_date = site.sensor_values.first(:order => [:timestamp.desc]).timestamp
                begin_date = (cur_date.to_time - num.hours).to_datetime
              else
                            cur_date = DateTime.now #strptime("2009-11-17T08:45:00+00:00")
                            begin_date = params[:begin_date].to_datetime #(cur_date.to_time - num.hours).to_datetime
              end
              if !params[:end_date].nil?
                            cur_date = params[:end_date].to_datetime
                          end
              tmp_data = ""
              sense_data = site.sensor_types.first(:name => s_type.name).sensor_values(:timestamp.gt => begin_date, :timestamp.lt => cur_date)
              sense_data.each do |val|
                #temp_array = Array.new
                #temp_array << val.timestamp.to_time.to_i*1000
                #temp_array << val.value
                tmp_data = tmp_data + ",[" + (val.timestamp.to_time.to_i*1000).to_s + "," + val.value.to_s + "]"
              end
              tmp_data = tmp_data.slice(1..tmp_data.length)
              #tmp_data = repository(:default).adapter.select('SELECT "timestamp","value","site_id" FROM "sensor_values" WHERE site_id = ? and sensor_type_id = ? and timestamp >= ? and timestamp <= ? ORDER BY "timestamp"', site.id, s_type.id, begin_date, cur_date).collect{|val| "[#{val.timestamp.to_time.to_i*1000}, #{val.value}]"}.join(',')
            
              array_data = Array.new()
              value_results = site.sensor_types.first(:name => s_type.name).sensor_values(:timestamp.gt => begin_date, :timestamp.lt => cur_date).collect{
                |val| 
              #value_results = repository(:default).adapter.select('SELECT "timestamp","value","site_id" FROM "sensor_values" WHERE site_id = ? and sensor_type_id = ? and timestamp >= ? and timestamp <= ? ORDER BY "timestamp"', site.id, s_type.id, begin_date, cur_date).collect{|val| 
                temp_array= Array.new() 
                if params[:hourly].nil?
                  temp_array.push(val.timestamp.to_time.localtime.to_i*1000, val.value)
                  array_data.push(temp_array)
                else
                  if val.timestamp.min == 0
                    temp_array.push(val.timestamp.to_time.localtime.to_i*1000, val.value)
                    array_data.push(temp_array)
                  end
                end

              }
              # logger.debug{ "#{tmp_data}" }
              # logger.debug { "end of query: #{Time.now - last_time}" }
              if !tmp_data.nil?
                @plot_data += tmp_data
              end
              #array_data = tmp_data.to_a#{}"["  + tmp_data.to_a.to_s + "]"
              @sensor_hash["data"] = array_data
            
              # if !@sensor_labels[s_type.name.to_s].nil?
              #                @sensor_hash["label"] = @sensor_labels[s_type.name.to_s]
              #             
              #                @thelabel = @sensor_labels[s_type.name]
              # 
              #            else
          
                   @sensor_hash["label"] = s_type.name
                   @thelabel = s_type.name
             #end
              if !s_type.sensor_values.last.units.nil?              
                @sensor_hash["units"] = s_type.sensor_values.last.units
              else
                @sensor_hash["units"] = "nil"
              end
              @site_hash[s_type.name] = @sensor_hash
          
              @plot_data += "] , label: \"#{@thelabel}\" }"
            end
          end #if
      end  #for

        @plot_data += "}"
        # @json_data += ","
        temp_hash = Hash.new
        temp_hash["sitecode"]=site.code
        temp_hash["sitename"]=site.name
        temp_hash["sensors"]=@site_hash
        @project_array.push(temp_hash)
        num_hash[site.code] = site_count
      #@project_hash["sites"].push(@site_hash)
        @site_data[site.code] = @plot_data
      end
    end
    @project_hash["sites"] = @project_array
    respond_to do |format|
      if not @project.nil?
        format.html
        format.json{
          if params[:sitecode]
                      puts "YEAH+++++++++++++++++++++++++++++++++++"+ num_hash[params[:sitecode]].to_s + params[:sitecode].to_s

                      render :json => @project_hash["sites"][num_hash[params[:sitecode]]], :callback => params[:jsoncallback]
                    else
            puts "NO+++++++++++++++++++++++++++++++++++" + params[:sitecode].to_s
            render :json=> @project_hash, :callback => params[:jsoncallback]
          end
        }
      else
        flash[:warning] = "Unable to find a project with the identifier #{params[:id]}."
        format.html { redirect_to( yogo_projects_path )}
      end
    end
  end

end
