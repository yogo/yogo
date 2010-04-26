# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: application_helper.rb
# Methods added to this helper will be available to all templates in the application.
# 
module ApplicationHelper
  #
  # Google Vis API
  # 
  include GoogleVisualization
  
  ##
  # Adds items to the menu in the view
  #
  # @example
  #  add_menu_item(Bacon, bacon)
  #
  # @param [String] name
  #  The name of the item to link to
  # @param [String] url
  #  The url of the item to link to, default value is {}
  # @param [String] html_options
  #  The html options for the link, default value is {}
  #
  # @return [String] a link formatted for a menu as a list item
  #
  # @author Yogo Team
  #
  # @api public
  #
  def add_menu_item(name, url = {}, html_options = {})
    css_class = ''
    css_class = 'highlighted-menu-item' if request.url.include?(h(url))
      
    "<li class='#{css_class}'>" +
      link_to(name, url, html_options) +
    "</li>"
  end
  
  ##
  # Returns all projects
  # 
  # @example
  #  all_projects
  #
  # @return [Array <Objects>] returns an array of projects
  #
  # @author Yogo Team
  #
  # @api public
  #
  def all_projects
    Project.all
  end

  ##
  # Generates the links needed for pagination
  #
  # @example
  #  pagiation_links(yogo_collection, 1, 20)
  #
  # @param [object] collection
  #  Yogo collection object
  # @param [Integer] cur_page
  #  The current pagination page, by default it is 1
  # @param [Integer] per_page
  #  The number of items to display per page, by default this 5
  #
  # @return [String] navigation for links to paginated collection items
  #
  # @author Robbie Lamb
  #
  # @api public
  #
  def pagination_links(collection, cur_page = 1, per_page = 5)
    total_pages = collection.page_count(:per_page => per_page)
    current_page = cur_page.nil? ? 1 : cur_page.to_i

    output = ""

    if current_page > 1
      output += link_to("&lt;&nbsp;Previous&nbsp;", "?page=#{current_page-1}")
    end
  
    if total_pages > 1
      # Looking for a range of 5 pages centered around the current page.
      min_page = [current_page - 2, 1].max
      max_page = [current_page + 2, total_pages].min
      
      # This makes sure the range of 5 is ther even if the curren page isn't in the middle.
      min_page = max_page - 5 if max_page.eql?(total_pages) && total_pages > 5
      max_page = min_page + 4 if min_page.eql?(1) && total_pages > 5

      (min_page...max_page+1).each do |p|
        output += link_to("&nbsp;"+((current_page==p) ? "<strong>"+p.to_s+"</strong>" : p.to_s + "")+"&nbsp;","?page=#{p}")
      end
    end

    if current_page < total_pages
      output += link_to("&nbsp;Next&nbsp;&gt;", "?page=#{current_page+1}")
    end
    
    output = (link_to("&lt;&lt First&nbsp;","?page=1") + output) if current_page > 2
    output << link_to("&nbsp;Last &gt;&gt;","?page=#{total_pages}") if current_page < total_pages-1

    output
  end

  ##
  # Creates breadcrumbs based on the request query_string
  #
  # @example
  #   query_params
  #
  # @return [String] a string of links of breadcrumbs based on the request query_string
  #
  # @author Yogo Team
  #
  # @api public
  #
  def query_params
    ref_path = request.path_info;
    ref_query = URI.decode(request.query_string)
    query_options = ref_query.split('&').select{|r| !r.blank?}
    res = []
    query_path = []
    
    query_options[0..-2].each do |qo|
      qo.match(/q\[(\w+)\]\[\]=(.+)/)
      attribute = $1
      condition = $2
      found = false
      res << link_to("#{attribute.humanize}: #{condition}", ref_path+"?"+query_path.join("&"))
      query_path << qo
      
    end
    
    query_options[-1].match(/q\[(\w+)\]\[\]=(.+)/)
    attribute = $1
    condition = $2
     res << "#{attribute.humanize}: #{condition}"
     
    return res.join(' > ')
  end
  
  def yogo_show_helper(item, property, project, model)
    if property.type == DataMapper::Types::YogoFile || property.type == DataMapper::Types::YogoImage
      file = item[property.name]
      link_to(file, download_asset_project_yogo_data_path(project, model.name.demodulize, item.yogo_id, :attribute_name => property.name))
    else 
      item[property.name]
    end
  end
end
