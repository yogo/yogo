module NavigationHelper
  
  def generate_navigation_display(models)
    display = []
    models.map! {|mod| NavModel.first(:name => mod.name)}
    models.delete_if {|x| x.nil?}
    table = models.select {|x| x.model_id == request.parameters[:model_id]}[0]
    if display_conditions(request.parameters, table)
      display = construct_display(table, table, [table], [])
    end
    return display.join("\n")
  end
  
  def display_conditions(parameters, table)
    if table \
     && parameters[:controller] == 'yogo_data' \
     && parameters[:action]     == 'index' \
     #&& table.display 
      return true
    end
  end
  
  def fetch_path(table, attribute, range, history)
    #if hist > 1 then prime
    controller = table.model_id
    database_value = attribute.fetch_db_value(range) unless range.eql?('+')
    if params[table.name.to_sym] == nil
       return link_to("#{range}", "#{controller}?#{request.url.split("?")[1]}&#{table.name}[#{attribute.name}]=#{database_value}")# + fetch_count(table, attribute, database_value)
    else
      if params[table.name.to_sym][attribute.name] == database_value
        return range
      else
        navlink = "#{controller}?#{request.url.split("?")[1]}&#{table.name}[#{attribute.name}]=#{range}"
        navlink.gsub!(Regexp.new("#{table.name}\\[#{attribute.name}\\]=.*"), "#{table.name}[#{attribute.name}]=#{database_value}")
        return link_to("#{range}", navlink) #+ fetch_count(table, attribute, database_value)
      end
    end
  end
  
  def parse_value_range(value)
       min = value.split('..')[0]
       max = value.split('..')[1]
       return min, max
   end

  def fetch_attribute_name(table, attribute)
    NavModel.first(:name => table).nav_attributes.first(:name => attribute).display_name
  end
  
  def construct_display(table, current, history, display, level=1)
    display << "<div id='nav_bar'>" if display.empty?
    display << "<a href='#' onclick=\"toggle_visibility('#{table.name + level.to_s}');\">" + 
               "#{table.display_name}</a><br>"
    display << "<div id='#{table.name + level.to_s}' style='display:show'>"
    display << "<ul>"
    table.fetch_attributes.each do |attribute|
      #level += 1
      if attribute.class == Hash
        attribute.each_pair do |related_table, relationship|
          unless relative_table == current || relative_table == table
            history << related_table
            display = construct_display(related_table, table, history, display, level + 1) #or level += 1 if above
          end
        end 
      else
        display << "<a href='#' onclick=\"toggle_visibility" +
                   "('#{table.name + level.to_s + attribute.name}');\">" + 
                   "#{attribute.display_name}</a><br>"
        display << "<div id='#{table.name + level.to_s + attribute.name}', style='display:none'>"
        display << "<ul>"
        attribute.fetch_range_display.each do |range|
          display << "<li>#{fetch_path(table, attribute, range, history)}</li>"
        end
        display << "</ul>"
        display << "</div>"
      end
    end
    display << "</ul>"
    display << "</div>"
    display << "</div>" if level == 1
    return display
  end

end