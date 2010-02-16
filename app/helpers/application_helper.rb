# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: application_helper.rb
# Methods added to this helper will be available to all templates in the application.
# 
module ApplicationHelper
  
  # Returns a link formatted for a menu as a list item
  #
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

  # Returns navigation for links to paginated collection items
  # 
  def pagination_links(collection, cur_page = 1, per_page = 5)
    total_pages = collection.model.page_count(:per_page => per_page)
    current_page = cur_page.nil? ? 1 : cur_page.to_i

    output = ""

    if current_page > 1
      output += link_to("&lt;&nbsp;Previous&nbsp;", "?page=#{current_page-1}")
    end
  
    if total_pages > 2
        (1...total_pages+1).each do |p|
          output += link_to("&nbsp;"+((current_page==p) ? "<strong>"+p.to_s+"</strong>" : p.to_s + "")+"&nbsp;","?page=#{p}")
      end
    end

    if current_page < total_pages
      output += link_to("&nbsp;Next&nbsp;&gt;", "?page=#{current_page+1}")
    end
    
    output = (link_to("<< First&nbsp;","?page=1") + output)
    output << link_to("&nbsp;Last >>","?page=#{total_pages}")

    output
  end
end
