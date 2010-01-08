require 'csv'
module DataMapper
  class Reflection
    class CSV
      
      def self.describe_model(csv='/tmp/data/test.csv')
        desc = {}
        desc.update( {'id' => "Ref" + csv.gsub(/.*\//,'').gsub('.csv', '')} )
        desc.update( {'properties' => {}} )
        csv = clean_csv(csv)
        attributes = csv[0].split(',')
        data_types = csv[1].split(',')
        unit_types = csv[2].split(',')
        attributes.each_with_index do |property, index|
          prop = property.gsub(' ', '_')
          prop = prop.downcase
          desc['properties'].update( {prop => {'type' => data_types[index]}} )
        end
        desc.to_json
      end

      def self.clean_csv(csv=nil)
        clean_lines = []
        File.new(csv, 'r').each_line do |line|
          if line.chomp != ""
           clean_lines << line.chomp
          end
        end
        clean_lines
      end
      
      def self.import_data(csv='/tmp/data/test.csv')
        instance = []
        model_name = "Ref" + csv.csv.gsub(/.*\//,'').gsub('.csv','')
        csv = clean_csv(csv)
        attributes = csv[0].split(',').map{|attribute| attribute.gsub(" ", "_").downcase}
        csv[3..-1].each do |line|
          parameters = {}
          line.split(',').each_with_index do |attribute, index|
            parameters.update( {attributes[index].to_sym => attribute} )
          end unless line.nil?
          instance << Object::const_get(model_name).new(parameters)
        end 
        instance
      end

    end
  end
end
