#CsvHelper

    # parse the header of a logger file
    # assumes Campbell scientific header style at the moment
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

      header_data << csv_data[4]
    end
    
    # Returns the specified row of a csv
    #
    # @example get_row("filename",4)
    #
    # @param [String] csv_file
    # @param [Integer] row
    #
    # @return [Array] an array whose elements are a csv-row columns
    #
    # @author Yogo Team
    #
    # @api public
    def get_row(csv_file, row)
      csv_data = CSV.read(csv_file)
      path = File.dirname(csv_file)

      csv_data[row-1]
    end
