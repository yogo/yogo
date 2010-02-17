module Yogo
  module Navigation
    class Breadcrumbs
  
      def crumb_name(req)
        req.split('&').reverse[0].split(']')[0].split('[')[1]
      end

      def crumb_value(req)
        req.split('&').reverse[0].split('=')[1]
      end

      def breadcrumbs(req, name = nil)
        validate_breadcrumbs
        show_name = NavModel.first(:model_id => request.parameters[:model_id]).display_name
        show_name += " : #{name}" unless name.nil?
        # if the condition has been breadcrumb'ed pop back to it.
        if session[:breadcrumbs].map{ |c| c[:name] }.include?(crumb_name(req))
          begin
            temp_crumb = session[:breadcrumbs].pop
          end while temp_crumb[:name] != crumb_name(req)
        # if 'cells' or 'browse' were clicked on, dump the crumbs
        elsif (req.split('&').length == 1) and name.nil?
          session[:breadcrumbs] = []
        end
        #add the current req to the crumbs
        session[:breadcrumbs] << {:name => crumb_name(req), :link => req, :value => crumb_value(req)} unless crumb_name(req) == show_name

        #if we are at a cell and looking at it, add the cell to the crumbs
        unless name.nil?
          session[:breadcrumbs] << {:name => show_name, :link => req, :value => name} unless session[:breadcrumbs].include?({:name => show_name, :link => req, :value => name})
        end
      end 

      def validate_breadcrumbs
        # if the breadcrumbs are nil or not an array, initialize them to an empty
        # array
        if session[:breadcrumbs].nil? or session[:breadcrumbs].class != Array
          session[:breadcrumbs] = []
        end
        # if any of the crumbs are not a hash or have empty or nil names or links, delete them
        session[:breadcrumbs].each do |crumb|
          if crumb.class != Hash or crumb[:name].nil? or crumb[:link].nil? or crumb[:value].nil? or crumb[:name].blank? or crumb[:link].blank? or crumb[:value].blank?
            session[:breadcrumbs].delete(crumb)
          end
        end
      end

      def print_breadcrumbs
        validate_breadcrumbs
        out = [ link_to("Home", :controller => NavSetting.first.root_name, :action => "index"), link_to("#{request.parameters[:controller].capitalize}", :controller => "#{request.parameters[:controller]}", :action => "index") ]
        unless session[:breadcrumbs].empty?
          out << session[:breadcrumbs].map {|crumb|
            if session[:breadcrumbs][-1] == crumb
              "#{fetch_crumb_display_value(crumb[:name], crumb[:value])}"
            else
              link_to("#{fetch_crumb_display_value(crumb[:name], crumb[:value])}", crumb[:link])
            end
          }
        end
        out.join(" &gt; ")
      end

      def fetch_crumb_display_value(attribute_name, database_value)
        value_display = ""
        result = ""
        controller = request.parameters[:controller]
        model = NavModel.first(:model_id => request.parameters[:model_id])
        return attribute_name if attribute_display = model.nav_attributes.first(:name => attribute_name).nil?
        attribute_display = model.nav_attributes.first(:name => attribute_name).display_name
        display_values = model.nav_attributes.first(:name => attribute_name).nav_display_values
        display_values.each do |display|
          if display.nav_database_value.value == database_value
            value_display = display.value
          end
        end
        return attribute_display + " : " + value_display
      end
  
    end
  end
end