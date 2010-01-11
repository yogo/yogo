require 'csv'
module DataMapper
  class Reflection
    class CSV
      
      def self.describe_model(csv='tmp/data/test.csv')
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
      
      def self.import_data(csv, repo_name)
        model_name = "Ref" + csv.gsub(/.*\//,'').gsub('.csv','')
        if repository(:"#{repo_name}").adapter.options[:adapter] == "persevere"
           repository(:"#{repo_name}").adapter.put_schema(Object::const_get(model_name).send(:to_json_schema_compatable_hash))
        else
          puts Object::const_get(model_name).auto_migrate!
        end
        
        csv = clean_csv(csv)
        puts attributes = csv[0].split(',').map{|attribute| attribute.gsub(" ", "_").downcase}
        count =0
        csv[3..-1].each do |line|
          count +=1
          parameters = {:id => count.to_s}

          line.split(',').each_with_index do |attribute, index|
            parameters = parameters.update( {attributes[index].to_sym => attribute} )

          end unless line.nil?
          puts parameters
          repository(:"#{repo_name}") do
            puts Object::const_get(model_name).create!(parameters)
          end
        end 
      end

    end
  end
end

