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
  
  # FIXME @return [] a link formatted for a menu as a list item
  # FIXME @api private, semipublic, or public
  def add_menu_item(name, url = {}, html_options = {})
    css_class = ''
    css_class = 'highlighted-menu-item' if request.url.include?(h(url))
      
    "<li class='#{css_class}'>" +
      link_to(name, url, html_options) +
    "</li>"
  end
  
  # Returns all projects
  # 
  def all_projects
    Project.all
  end

  # @return [String, Array] navigation for links to paginated collection items
  # FIXME @api private, semipublic, or public
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

  # @return [String] creates breadcrumbs based on the request query_string
  # FIXME @api private, semipublic, or pubic
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
end
