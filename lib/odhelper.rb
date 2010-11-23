module Odhelper
  def self.default_repository_name
    :his
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
end