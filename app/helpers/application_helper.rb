# Yogo Data Management Toolkit
# Copyright (c) 2010 Montana State University
#
# License -> see license.txt
#
# FILE: application_helper.rb
# Methods added to this helper will be available to all templates in the application.
#
module ApplicationHelper

  # include Google Vis tools
  include GoogleVisualization

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

  # Helper method for making a float breaking block level element
  #
  # @example
  #   <%= clear_break %>
  #   renders:
  #   <br clear='all' style='clear: both;'/>
  #
  # @return [HTML Fragment]
  #
  # @api public
  def clear_break
    "<br clear='all' style='clear: both;'/>".html_safe
  end

  def page_title
    if ["pages", "dashboards"].include?(controller_name)
      "#{controller_name.titleize} >> #{params[:id].humanize}"
    elsif defined?(resource) && (!resource.nil?) && resource.respond_to?(:name)
      "#{link_to(controller_name.titleize, :controller => params[:controller], :action => :index)} >> #{resource.name}"
    else
      controller_name.titleize
    end
  end

  ##
  # Helper for creating a tooltip
  #
  # @example
  #   Here is an example
  #
  # @param [String] body
  # @param [String] title
  # @param [Integer] length
  #
  # @return [HTML Fragment]
  #
  # @author yogo
  # @api public
  def tooltip(body, title = nil, length = 10)
    id = UUIDTools::UUID.random_create
    if body.length > length
      output= <<-TT
      <div id='#{id}' class='tooltip' title='#{title || "Click to see full text."}'>#{body}</div>
      <span class='tooltip-snippet' onClick="$('##{id}').dialog('open')">
        #{body[0..length]}<span class='more'>&#8230; more</span>
      </span>
      TT
      output.html_safe
    else
      body.html_safe
    end
  end


  # Renders the project quick-jump box
  def render_project_jump_box
    projects = Project.all(:is_private => false)
    if logged_in?
      projects = projects | current_user.projects
    end
    if projects.count > 0 
      s = '<select onchange="if (this.value != \'\') { window.location = this.value; }">' +
            "<option value=''>Jump to Project...</option>" +
            '<option value="" disabled="disabled">---</option>'
      
      options = projects.collect{|p| [p.name, "/projects/#{p.id}"]}
      s << options_for_select(options, @project.nil? ? '' : "/projects/#{@project.id}")
      
      s << '</select>'
      s.html_safe
    end
  end

  def yogo_button(image, text, link)
    link_to(image_tag(image), link)
  end
  
end
