# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def add_menu_item(name, url = {}, html_options = {})
    css_class = ''
    css_class = 'highlighted-menu-item' if request.url.include?(h(url))
      
    "<li class='#{css_class}'>" +
      link_to(name, url, html_options) +
    "</li>"
  end
end
