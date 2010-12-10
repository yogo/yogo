# SensorValues
#

class Voeis::SensorValue
  include DataMapper::Resource
  include Facet::DataMapper::Resource

  property :id, Serial
  property :value,    Float,   :required => true
  property :string_value, String, :required => true, :default => "Unknown"
  property :units,    String,  :required => true
  property :timestamp,    DateTime,  :required => true, :index => true
  property :published,  Boolean, :required => false
  property :created_at,  DateTime, :required => true,  :default => DateTime.now
  property :updated_at, DateTime, :required => true,  :default => DateTime.now

  is_versioned :on => :updated_at
  
  before(:save) {
    self.updated_at = DateTime.now
  }

  has n, :site,           :model => "Voeis::Site", :through => Resource
  has n, :sensor_type,    :model => "Voeis::SensorType", :through => Resource
  has n, :meta_tags,      :model => "Voeis::MetaTag", :through => Resource
  
  default_scope(:default).update(:order => [:timestamp]) # set default order

  def name
    self.sensor_type.name
  end

  # Returns the last updated sensor value
  def self.last_updated
    lu = first(:order => [:timestamp.desc])
    lu.timestamp unless lu.nil?
  end




  # Parses a csv file using an existing data_column template
   # column values are stored in sensor_values
   #
   # @example parse_logger_csv_header("filename")
   #
   # @param [String] csv_file
   # @param [Object] data_stream_template
   # @param [Object] site
   #
   # @return
   #
   # @author Yogo Team
   #
   # @api public
   def self.parse_logger_csv(csv_file, data_stream_template_id, site_id)
     if !Voeis::DataStream.get(data_stream_template_id).data_stream_columns.first(:name => "Timestamp").nil?
        data_timestamp_col = Voeis::DataStream.get(data_stream_template_id).data_stream_columns.first(:name => "Timestamp").column_number
        date_col=""
        time_col=""
     else
       data_timestamp_col = ""
       date_col = Voeis::DataStream.get(data_stream_template_id).data_stream_columns.first(:name => "Date").column_number
       time_col = Voeis::DataStream.get(data_stream_template_id).data_stream_columns.first(:name => "Time").column_number
     end
     start_line = Voeis::DataStream.get(data_stream_template_id).start_line
     
     site = Voeis::Site.get(site_id)
      data_col_array = Array.new
      Voeis::DataStream.get(data_stream_template_id).data_stream_columns.each do |col|
        data_col_array[col.column_number] = [col.sensor_types.first, col.unit, col.name]
      end
     CSV.open(csv_file, "r") do |csv|
       (0..start_line-2).each do
          header_row = csv.readline
       end
       csv.each do |row|
           #logger.info {row.join(', ')}
           parse_logger_row(data_timestamp_col, data_stream_template_id, date_col, time_col, row, site, data_col_array)
       end
     end
     GC.start
     return {}
   end
   
   
   
   # Parses a csv row using an existing data_column template
    # column values are stored in sensor_values
    #
    # @example parse_logger_csv_header("filename")
    #
    # @param [String] csv_file
    # @param [Object] data_stream_template
    # @param [Object] site
    #
    # @return
    #
    # @author Yogo Team
    #
    # @api public
   def self.parse_logger_row(data_timestamp_col, data_stream_id, date_col, time_col, row, site, data_col_array)
     # sensor_type_array = Array.new
     # data_stream_col_unit = Array.new
     # data_stream_col_name = Array.new
     # data_stream_template.data_stream_columns.each do |col|
     #      sensor_type_array[col.column_number] = col.sensor_types.first
     #      data_stream_col_unit[col.column_number] = col.unit
     #      data_stream_col_name[col.column_number] = col.name
     # end
     # 
     # 
     name = 2
     sensor = 0
     unit = 1
     
     Voeis::SensorValue.transaction do
       '2010-12-07T12:32:59-07:00'
       created_at = updated_at = Time.now.strftime("%Y-%m-%dT%H:%M:%S%z")
       row_values = []
       (0..row.size-1).each do |i|
         if i != data_timestamp_col && i != date_col && i != time_col
          if data_col_array[i][name] != "ignore"
            cv = /^[-]?[\d]+(\.?\d*)(e?|E?)(\-?|\+?)\d*$|^[-]?(\.\d+)(e?|E?)(\-?|\+?)\d*$/.match(row[i]) ? row[i].to_f : -9999.0
            timestamp = (data_timestamp_col == "") ? Time.parse(row[date_col].to_s + ' ' + row[time_col].to_s).strftime("%Y-%m-%dT%H:%M:%S%z") : row[data_timestamp_col.to_i]
            
            row_values << "(#{cv.to_s}, '#{data_col_array[i][unit]}', '#{timestamp}', FALSE, '#{row[i].to_s}', '#{created_at}', '#{updated_at}')"
            # 
            # sensor_value = Voeis::SensorValue.create(
            #                                :value => cv,
            #                                :units => data_col_array[i][unit],
            #                                :timestamp => timestamp,
            #                                :published => false,
            #                                 :string_value => row[i].to_s)
            # sensor_value.sensor_type << data_col_array[i][sensor]
            #sensor_value.site << site
            # sensor_value.save
          end
        end
       end
        sql = "INSERT INTO \"#{self.class.repository_name}\" (\"value\",\"units\",\"timestamp\",\"published\",\"string_value\",\"created_at\",\"updated_at\") VALUES "
        sql << row_values.join(',')
        sql << "RETURNING id"
        puts sql
        result_ids = repository.adapter.select(sql)
        
        sql = "INSERT INTO \"voeis_sensor_value_sites\" (\"sensor_value_id\", \"site_id\") VALUES "
        sql << result_ids.collect{|i| "(#{i},#{site.id})"}.join(',')
        puts sql
        repository.adapter.select(sql)
        
        sql = "INSERT INTO \"voeis_sensor_type_sensor_values\" (\"sensor_value_id\",\"sensor_type_id\" VALUES"
        sql << (0..result_ids.length-1).collect{|i| "(#{result_ids[i]},#{data_col_array[i][sensor].id})"}
        puts sql
        repository.adapter.select(sql)
      end
      GC.start
  end

  "INSERT INTO \"roles\" (\"name\",\"position\") VALUES  ('blah7',12), ('blah8',13) RETURNING \"id\""

end