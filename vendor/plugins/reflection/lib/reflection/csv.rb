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
      
      def self.import_data(csv='/tmp/data/test.csv')
        #instance = []
        model_name = "Ref" + csv.gsub(/.*\//,'').gsub('.csv','')
        Object::const_get(model_name).auto_migrate!
        csv = clean_csv(csv)
        puts attributes = csv[0].split(',').map{|attribute| attribute.gsub(" ", "_").downcase}
        count =0
        csv[3..-1].each do |line|
          count +=1
          parameters = {:id => count.to_s}
          # @instance = Object::const_get(model_name).new
          line.split(',').each_with_index do |attribute, index|
            parameters = parameters.update( {attributes[index].to_sym => attribute} )
            # @instance.attribute_set(attributes[index].to_sym, attribute)
            #            puts attributes[index].to_sym
            #            puts @instance.attributes
            #            puts @instance.save
            #            puts @instance.errors.inspect
          end unless line.nil?
          puts parameters
          
          puts @r = Object::const_get(model_name).create!(parameters)
          puts @r.inspect
          puts @r.valid?
          puts @r.errors.inspect
          # @instance = Object::const_get(model_name).new(parameters)
          #          puts @instance.save
          #          puts @instance.errors
        end 
      end

    end
  end
end
