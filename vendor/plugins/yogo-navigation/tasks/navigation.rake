namespace :nav do
  desc "Configure navigation settings."
  task :generate => :environment do
    persvr = Persevere.new(ENV['HOST'])
    persvr = JSON.parse(persvr.retrieve("/Class?!core").body)
    models = {}
    persvr.each do |mod|
      model_name = mod['id'][6..-1]
      models.update({model_name => []})
    end
    models.each_pair do |model, properties|
      collection = JSON.load(RestClient.get("#{ENV['HOST']}/#{model}", :accept => 'application/json'))
      collection.each do |instance|
        instance.each_pair do |attribute, value|
          update_properties(attribute, value, properties, [attribute])
        end  
      end
    end
    print_results(models)
    destroy_models
    generate(models)
    puts " ...you must be powerful..."
  end
  
  desc "Update navigation settings."
  task :update => :environment do
    models = {}
    repository(ENV['REPO'].to_sym).adapter.query("SHOW TABLES").each do |mod|
      models.update({mod => []})
    end
    models.each_pair do |model, properties|
      repository(ENV['REPO'].to_sym).adapter.query("SELECT * FROM #{model.upcase} LIMIT 1")[0].members.each do |attribute|
        properties << attribute
      end
    end
    generate(models)
  end
  
  def collect_current_state(models)
    NavModel.all.each do |nav_model|
      models.update({nav_model.name => []})
      nav_model.nav_attributes.each do |nav_attribute|
        models[nav_model.name] << nav_attribute.name
      end
    end
    return models
  end
  
  def update_properties(attribute, value, properties, path)
    if value.class == Hash
      value.each_pair do |prime_attribute, prime_value|
        update_properties(prime_attribute, prime_value, properties, path << prime_attribute)
      end
    else
      if !properties.include?(attribute)
        properties << attribute
      end
    end
  end
  
  def generate(models)
    models.each_pair do |model_name, attributes|
      temp_mod = NavModel.new(:name          => model_name,
                              :included      => true,
                              :controller    => model_name.downcase,
                              :display_name  => model_name,
                              :display_count => false
                              )
      attributes.each do |attribute|
        temp_attr = NavAttribute.new(:name          => attribute,
                                     :included      => true,
                                     :display_name  => attribute,
                                     :display_count => false,
                                     :range         => false 
                                     )
        temp_mod.nav_attributes << temp_attr
        temp_mod.save
      end
    end
    puts " You have created everything."
  end
  
  def destroy_models
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
    puts 'You have destroyed everything.'
  end
  
  def print_results(models)
    models.each_pair do |model, attributes|
      puts "Model: #{model}"
      attributes.each do |attribute|
        puts '--- ' + attribute
      end
      puts
    end
  end
  
end