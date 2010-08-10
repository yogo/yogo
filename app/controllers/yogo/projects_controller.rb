# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: projects_controller.rb
# The projects controller provides all the CRUD functionality for the project
# and additionally: upload of CSV files, an example project and rereflection
# of the yogo repository.

class Yogo::ProjectsController < Yogo::BaseController
  defaults :resource_class => Yogo::Project,
           :collection_name => 'projects',
           :instance_name => 'project'


  protected

  def resource
    @project ||= collection.get(params[:id])
  end

  def collection
    @projects ||= resource_class.all# .paginate(:page => params[:page], :per_page => 5)
  end

  def resource_class
    Yogo::Project
  end

  with_responder do
    def resource_json(project)
      hash = super(project)
      hash[:data_collections] = project.data_collections.map do |c|
        controller.send(:yogo_project_collection_path, project, c)
      end
      hash
    end
  end

  def add_site
    @project = Project.get(params[:id])

    respond_to do |format|
      format.html
    end
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
    @sites = Site.all
    if !params[:upload].nil? && datafile = params[:upload]['datafile']
      if ! ['text/csv', 'text/comma-separated-values', 'application/vnd.ms-excel',
            'application/octet-stream','application/csv'].include?(datafile.content_type)
        flash[:error] = "File type #{datafile.content_type} not allowed"
        redirect_to(:controller =>"projects", :action => "add_stream", :params => {:id => params[:project_id]})
      else

        # Read the logger file header
        @header_info = parse_logger_csv_header(datafile.path)
        if @header_info.empty?
          flash[:error] = "CSV File improperly formatted. Data not uploaded."
          #redirect_to :controller =>"projects", :action => "add_stream", :params => {:id => params[:project_id]}
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
                                 :project_id => params[:project_id])
    data_stream.save
    data_stream.errors do |e|
      puts e
    end

    data_stream.sites << Site.first(:id => params[:site])
    data_stream.save
    #create DataStreamColumns
    #
    header = parse_logger_csv_header(params[:datafile])
    puts range = params[:rows].to_i-1
    puts range
    (0..range.to_i).each do |i|
      puts i.to_s + ": i"
      #create the Timestamp column
      if i == params[:timestamp].to_i
        data_stream_column = DataStreamColumn.new(:column_number => i,
                                                  :name => "Timestamp",
                                                  :type =>"Timestamp",
                                                  :original_var => header[i]["variable"])
        data_stream_column.save
        puts data_stream_column.errors.inspect
        data_stream.data_stream_columns << data_stream_column
        data_stream.save
        puts data_stream_column.errors.inspect
      else
              data_stream_column = DataStreamColumn.new(:column_number => i,
                                                        :name => header[i]["variable"],
                                                        :original_var => header[i]["variable"],
                                                        :type => header[i]["type"])
              data_stream_column.save
              puts data_stream_column.errors.inspect
              data_stream_column.variables << Variable.first(:id => params["column"+i.to_s])
              data_stream_column.data_streams << data_stream
              data_stream_column.save
              # data_stream.data_stream_columns << data_stream_column
              # data_stream.save
      end


    end
    parse_logger_csv(params[:datafile], data_stream, 4)

    respond_to do |format|
      format.html
    end
    # process csv data and store datavalues
    #
    #
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

  def parse_logger_csv(csv_file, data_stream_template,  start_line)
    require "yogo/model/csv"
    csv_data = CSV.read(csv_file)
    path = File.dirname(csv_file)
    data_model = Project.first(:id => data_stream_template.project_id).get_model("DataValue")
    csv_data[start_line..-1].each do |row|
      (0..row.size-1).each do |i|
        if i != data_stream_template.data_stream_columns.first(:name => "Timestamp").column_number
          data_value = data_model.new
          data_value.yogo__data_value = row[i]
          data_value.yogo__local_date_time = row[data_stream_template.data_stream_columns.first(:name => "Timestamp").column_number]
          if !data_stream_template.data_stream_columns.first(:column_number => i).variables.first.nil?
            data_value.yogo__variable = data_stream_template.data_stream_columns.first(:column_number => i).variables.first.id
          end
          data_value.save
        end
      end
    end
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
  # def create
  #   if !Setting[:local_only]
  #     flash[:error] = "You need to login first" unless logged_in?
  #     flash[:error] = "You do not have permission to create the project." unless current_user.has_permission?(:create_projects)
  #   end
  #
  #   @project = Project.new(params[:project])
  #
  #   if @project.save
  #     flash[:notice] = "Project \"#{@project.name}\" has been created."
  #       #Check to be sure the default VOEIS project is loaded - create it if it doesn't exist
  #              if Project.first(:name => "VOEIS").nil?
  #                def_project = Project.new()
  #                def_project.name = "VOEIS"
  #                def_project.description = "The Default VOEIS Project and Repository"
  #                def_project.save
  #                puts odm_contents = Dir.new("dist/odm").entries
  #                odm_contents.each do |content|
  #                  puts content.to_s + "before"
  #                  if !content.to_s.index('.csv').nil?
  #                    puts content.to_s
  #                    def_project.process_csv('dist/odm/' + content.to_s, content.to_s.gsub(".csv",""))
  #                  end
  #                end
  #              end
  #              puts voeis_contents = Dir.new("dist/voeis_default").entries
  #              voeis_contents.each do |content|
  #                puts content.to_s + "before"
  #                if !content.to_s.index('.csv').nil?
  #                  puts content.to_s
  #                  @project.process_csv('dist/voeis_default/' + content.to_s, content.to_s.gsub(".csv",""))
  #                end
  #              end
  #     redirect_to projects_url
  #   else
  #     flash[:error] = "Project could not be created."
  #     redirect_to projects_url
  #   end
  # end
