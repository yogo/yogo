# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def add_menu_item(name, url = {}, html_options = {})
    css_class = ''
    css_class = 'highlighted-menu-item' if request.url.include?(h(url))
      
    "<li class='#{css_class}'>" +
      link_to(name, url, html_options) +
    "</li>"
  end
  
  def all_projects
    Project.all
  end

  def pagination_links(collection, cur_page = 1, per_page = 5)
    total_pages = collection.model.page_count(:per_page => per_page)
    current_page = cur_page.nil? ? 1 : cur_page.to_i

    output = ""

    if current_page > 1
      output += link_to(image_tag("prev.png"), "?page=#{current_page-1}")
    end
    # output += ' PAGINATION '
    if current_page < total_pages
      output += link_to(image_tag("next.png"), "?page=#{current_page+1}")
    end

    output
  end
end
