namespace :navigation do
  namespace :fixtures do
    desc "Configure navigation settings."
    task :generate => :environment do
      ['alpha', 'beta', 'omega'].each do |model|
        nav_model = NavModel.new(:name          => model.capitalize,
                                 :display       => true,
                                 :model_id    => model.downcase + 's',
                                 :display_name  => model.capitalize,
                                 :display_count => false
                                 )
        ['stringattr', 'integerattr', 'dateattr', 'booleanattr'].each do |attribute|
          nav_attribute = NavAttribute.new(:name          => attribute,
                                           :display       => true,
                                           :display_name  => attribute,
                                           :display_count => false,
                                           :range         => is_range?(attribute) 
                                           )
          nav_display_value = NavDisplayValue.new(:value => determine_display_value(attribute))
          nav_database_value = NavDatabaseValue.new(:value => determine_database_value(attribute))
          nav_display_value.nav_database_value = nav_database_value
          nav_attribute.nav_display_values << nav_display_value
          nav_model.nav_attributes << nav_attribute
          nav_model.save
        end
      end  
      puts 'Fixtures have been created successfully.'
    end
    
    task :destroy => :environment do
      NavModel.all.each do |i|
        i.destroy
      end
      NavAttribute.all.each do |i|
        i.destroy
      end
      NavDisplayValue.all.each do |i|
        i.destroy
      end
      NavDatabaseValue.all.each do |i|
        i.destroy
      end
      puts 'Fixtures have been destroyed successfully.'
    end
    
    def is_range?(attribute)
      case attribute
      when 'integerattr'
        then return false
      when 'dateattr'
        then  return false
      else
        return true
      end
    end
  
    def determine_display_value(attribute)
      case attribute
      when 'stringattr'
        then 'String 1'
      when 'integerattr'
        then '1..50'
      when 'dateattr'
        then (Date.today + rand(100)).to_s
      when 'booleanattr'
        then 'True'
      end
    end
  
    def determine_database_value(attribute)
      case attribute
      when 'stringattr'
        then 'string1'
      when 'integerattr'
        then '1..50'
      when 'dateattr'
        then (Date.today + rand(100)).to_s
      when 'booleanattr'
        then true
      end
    end
    
  end
end