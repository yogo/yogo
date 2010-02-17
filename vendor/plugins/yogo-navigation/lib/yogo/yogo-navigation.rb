module ActionView
  class Base
    include NavigationHelper
  end
end

module DataMapper
  module Model
    def collect_navigation_results(parameters)
      table = self
      if Yogo::Navigation::Query.valid_params?(table, parameters[table.name.to_sym])
        if parameters[table.name.to_sym] || Yogo::Navigation::Query.check_depth_params(parameters)
          conditions = Yogo::Navigation::Query.build_search_conditions(table, parameters[table.name.to_sym])
          return table.all(eval(conditions))
        else
          return table.all
        end
      end
    end
  end
end

module Yogo
  module Navigation
    class Query
  
      def self.valid_params?(table, params)   
        table_properties = []  
        table.properties.each do |property|
          table_properties << property.name.to_s
        end
        unless params.nil? || params.empty? 
          check = params.map do |k, v|
            table_properties.include?(k)
          end
          !check.include?(false)
        else
          true
        end
      end

      def self.build_search_conditions(table, parameters)
        query = "{"
        unless parameters.nil?
          parameters.each_pair do |key, value|
            if NavModel.first(:name => table.name).nav_attributes.first(:name => key).range
              min, max = parse_value_range(value)
              query += ":#{key}.lt => '#{max}', :#{key}.gt => '#{min}',"
            else
              query += ":#{key} => '#{(value)}',"
            end
          end
        end
        parameters.each_pair do |name, val|
          if name.include?("depth_query-")
            val.each_pair do |attribute, value|
              query += fetch_depth_query(name.split("^"), attribute, value, table)
            end
          end
        end
        query[-1] = "}"
        return query
      end

      def self.fetch_depth_query(history, attribute, value, table)
        query = ""
        history = history.map {|x| x.gsub("depth_query-", "")}
        history[1..-1].each do |depth|
          if depth == history[-1]
            if NavModel.first(:name => history[-1]).nav_attributes.first(:name => attribute).range
              min, max = parse_value_range(value)
              query += ":#{determine_plurality(history, depth, table)} => #{depth}.all(:#{attribute}.lt => '#{max}', :#{attribute}.gt => '#{min}'"
            else  
              query += ":#{determine_plurality(history, depth, table)} => #{depth}.all(:#{attribute} => '#{(value)}'"
            end
          else
            query += ":#{determine_plurality(history, depth, table)} => #{depth}.all("
          end
        end
        (history.length - 1).times do 
          query += ")"
        end
        query += ","
      end

      def determine_plurality(history, depth, table)
        history = history.map {|x| x.capitalize.constantize}
        history[history.index(depth.capitalize.constantize) -1].relationships.each_pair do |tble, relationship|
          if relationship.child_model_name == depth.capitalize
            if relationship.class.to_s.split("::")[-2] == "OneToOne"
              return depth.downcase
            else
              return depth.downcase + "s"
            end
          end
        end
      end

      def self.parse_value_range(value)
          min = value.split('..')[0]
          max = value.split('..')[1]
          return min, max
      end

      def self.check_depth_params(parameters)
        return false if parameters.nil?
        parameters.each_pair do |name, value|
          if name.include?('depth_query-')
            return true
          end
        end
        return false
      end

      def self.has_relationships?(table)
        !table.capitalize.constantize.relationships.empty?
      end

      # Appends table relationships to the list of attributes for each table in hash form to be
      # decoded and handled in the nav_display and nav_display prime methods.   
      # def fetch_relationships(table)
      #     table = table.capitalize.constantize
      #     relationships = {}
      #     table.relationships.each_pair do |table, relationship|
      #       if relationship.child_model != table
      #         relationships.update({relationship.child_model_name.capitalize.constantize.to_s.downcase => "relationship"})
      #       end
      #     end
      #     relationships
      #   end  

      def self.fetch_relationships(table)
        table = table.capitalize.constantize
        relationships = {}
        table.relationships.each_pair do |table, relationship|
          if relationship.child_model != table
            relationships.update({relationship.child_model => relationship.max})
          end
        end
        relationships
      end
      
      def self.create_navigation_from_model(model)
        
      end
      
    end
  end
end
