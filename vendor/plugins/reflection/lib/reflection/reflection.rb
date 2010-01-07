require 'reflection/requirements'
module DataMapper
  
  module Model
    
    def is_reflected?
      false
    end
    
  end
  
  class Reflection
    
    include Databases
    
    @@adapter=nil, @@options=nil, @@database=nil, @@bind=nil, @@descriptions=[]
    
    def self.setup(options)
      defaults = {:overwrite_models => false,
                  :database      => :default,
                  :binding       => binding,
                  :ignore        => []
                  }
                         
      @@options  = defaults.merge(options)
      @@database = DataMapper.repository(@@options[:database])
      @@adapter  = @@database.adapter
      @@bind     = options[:binding]
      
      case @@adapter.class.to_s
        when /Sqlite3/ 
          then @@adapter.extend(Databases::Sqlite3)
        when /Mysql/
          then @@adapter.extend(Databases::MySQL)
        when /Persevere/
          then @@adapter.extend(Databases::Persevere)
        when /Postgres/
          then @@adapter.extend(Databases::Postgres)
        else 
          raise "#{@@adapter.class} is not supported." 
      end
    end
    
    def self.descriptions
      @@descriptions
    end
    
     def self.add_description(description)
        @@descriptions << description
      end
    
    def self.options
      @@options
    end
    
    def self.adapter
      @@adapter
    end
    
    def self.append_reflected
      ["def self.is_reflected?", "true", "end"]
    end
    
    def self.append_default_repo_name
      ["def self.default_repository_name", ":#{@@options[:database]}", "end"]
    end
    
    def self.create_models_from_database
      @@adapter.fetch_models.each do |model_name|
        self.create_model_from_db(model_name)
      end
    end
    
    def self.create_model_from_json(json)
      describe_class(json)
      generate_descriptions
    end
    
    def self.create_model_from_db(model_name)
      describe_class(describe_model(model_name))
      generate_descriptions
    end
    
    def self.create_model_from_csv(csv)
      describe_class(self::CSV.describe_model())
      generate_descriptions
    end
    
    def self.generate_descriptions
      @@descriptions.each do |desc|
        puts desc
        puts "========"
        eval(desc, @@bind)
      end
      @@descriptions.clear
    end
    
    def self.handle_id(desc)
      case @@adapter.class.to_s 
        when /Persevere/
          return ["property :id, String"] 
      else
        return ["property :id, Serial"] 
      end unless desc['properties']['id'] #this unless may be removed if exists in describe class
    end
    
    def self.describe_model(model_name)
      desc = {}
      @@adapter.fetch_models.select{|model| model == model_name}.each do |model|
        attributes = @@adapter.fetch_attributes(model)
        desc.update( {'id' => "#{model}"} )
        desc.update( {'properties' => {}} )
        attributes.each do |attribute|
          if attribute.name == 'id'
            desc['properties'].update( {attribute.name => {'type' => 'string'}} )
          else
            desc['properties'].update( {attribute.name => {'type' => attribute.type}} )
          end
        end
      end
      desc.to_json
    end
    
    def self.describe_class(desc, id=nil, history=[])
      model_description = []
      desc = JSON.parse(desc) if desc.class != Hash
      history << desc['id']   if desc['id']
      history << id           if id
      model_description << "class #{history.join('_').singularize.camel_case}"
      model_description << "include DataMapper::Resource"
      model_description << DataMapper::Reflection.append_default_repo_name
      model_description << DataMapper::Reflection.append_reflected
      model_description << handle_id(desc) unless desc['properties']['id']
      desc['properties'].each_pair do |key, value|
        if value.has_key?('properties')
          model_description << "property :#{history.join('_')}_#{key}, String"
          describe_class( value, key, history)
        else
          prop = value['type'] ? "property :#{key}, #{value['type'].capitalize}" : "property :#{key}, String"
          model_description << prop
        end
      end
      model_description << 'end'
      @@descriptions << (model_description.join("\n"))
      return model_description.join("\n")
    end
     
  end
end