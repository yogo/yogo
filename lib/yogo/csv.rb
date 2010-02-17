module Yogo
  class CSV
    def self.load_data(model, csv_data)
      csv_data.each do |line|
        line_data = Hash.new
        csv_data[0].each_index do |i| 
          attr_name = csv_data[0][i].tableize.singularize.gsub(' ', '_')
          prop = model.properties[attr_name]
          line_data[attr_name] = prop.typecast(line[i]) unless line[i].nil? || prop.nil?
        end
        model.create(line_data)
      end
    end
    
    def self.validate_csv(model, csv_data)
      prop_hash = Hash.new
      csv_data[0].each_index do |idx|
        prop_hash[csv_data[0][idx].tableize.singularize.gsub(' ', '_')] = csv_data[1][idx]
      end

      valid = true
      model.properties.each do |prop|
        valid = false unless (prop_hash.has_key?(prop.name.to_s) && 
                              prop_hash[prop.name.to_s] == Yogo::Types.dm_to_human(prop.type))
      end
      valid
    end
    
    def self.make_csv(model, include_data=false)
      csv_output = FasterCSV.generate do |csv|
        csv << model.properties.map{|prop| prop.name.to_s.humanize}
        csv << model.properties.map{|prop| Yogo::Types.dm_to_human(prop.type)}
        csv << "Units will go here when supported"
      end

      model.all.each { |m| csv_output << m.to_csv } if include_data
      
      csv_output
    end
  end # class CSV
end # module Yogo