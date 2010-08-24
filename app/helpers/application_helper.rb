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
  def pagination_links(collection, cur_page = 1, per_page = 5)
    total_pages = collection.page_count(:per_page => per_page)
    current_page = cur_page.nil? ? 1 : cur_page.to_i

    output = ""

    output += link_to("&lt;&lt; First&nbsp;", params.merge(:page => 1), :class => 'button-link')  if current_page > 2
    output += link_to("&lt;&nbsp;Previous&nbsp;", params.merge(:page => current_page-1), :class => 'button-link') if current_page > 1

    if total_pages > 1
      # Looking for a range of 5 pages centered around the current page.
      min_page = [current_page - 2, 1].max
      max_page = [current_page + 2, total_pages].min

      # This makes sure the range of 5 is ther even if the curren page isn't in the middle.
      min_page = max_page - 5 if max_page.eql?(total_pages) && total_pages > 5
      max_page = min_page + 4 if min_page.eql?(1) && total_pages > 5

      (min_page...max_page+1).each do |p|
        output += link_to("&nbsp;"+((current_page==p) ? "<strong>"+p.to_s+"</strong>" : p.to_s + "")+"&nbsp;",params.merge(:page=>p), :class => 'button-link')
      end
    end

    output += link_to("&nbsp;Next&nbsp;&gt;", params.merge(:page => current_page+1), :class => 'button-link') if current_page < total_pages
    output << link_to("&nbsp;Last &gt;&gt;",params.merge(:page => total_pages), :class => 'button-link') if current_page < total_pages-1

    # calculate the row range for this page
    from = ((current_page - 1) * per_page.to_i) + 1
    to = (collection.count < per_page.to_i) ? collection.count : from + per_page.to_i - 1

    if (from == 1 and to == collection.count)
      output = ""
    else
      output += " <span style='font-style: italic'>Showing #{from}&hellip;#{to} #{collection.name} (#{collection.count} total)</span>"
    end
  end


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
    "<br clear='all' style='clear: both;'/>"
  end

  def page_title
    if ["pages", "dashboards"].include?(controller_name)
      "#{controller_name.titleize} >> #{params[:id].humanize}"
    elsif (not resource.nil?) && resource.respond_to?(:name)
      "#{link_to(controller_name.titleize, :controller => params[:controller], :action => :index)} >> #{resource.name}"
    else
      controller_name.capitalize
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
      <<-TT
      <div id='#{id}' class='tooltip' title='#{title || "Click to see full text."}'>#{body}</div>
      <span class='tooltip-snippet' onClick="$('##{id}').dialog('open')">
        #{body[0..length]}<span class='more'>&#8230; more</span>
      </span>
      TT
    else
      body
    end
  end

  # Renders the project quick-jump box
  def render_dashboard_jump_box
    return unless logged_in?
    roles = Role.all
    if roles.any?
      s = '<select onchange="if (this.value != \'\') { window.location = this.value; }">' +
            "<option value=''>Jump to Dashboard...</option>" +
            '<option value="" disabled="disabled">---</option>'
      s << options_for_select(roles, :selected => @role) do |role|
        dashboard = role.name.gsub(' ', '').underscore
        z = { :value => dashboard_url(dashboard.to_sym) }
        z[:disabled] = 'disabled' unless current_user.roles.include?(role)
        z
      end
      s << '</select>'
      s
    end
  end

  # Renders the project quick-jump box
  def render_project_jump_box
    if logged_in?
      projects = Project.all
    else
      projects = Project.select {|p| not p.is_private? }
    end
    if projects.any?
      s = '<select onchange="if (this.value != \'\') { window.location = this.value; }">' +
            "<option value=''>Jump to Project...</option>" +
            '<option value="" disabled="disabled">---</option>'
      s << options_for_select(projects, :selected => @project ) do |project|
        z = { :value => project_url(project) }
        if logged_in?
          z[:disabled] = 'disabled' unless current_user.projects.include?(project)
        end
        z
      end
      s << '</select>'
      s
    end
  end

  def options_for_select(items, options = {})
    s = ''
    items.each do |item|
      tag_options = {:value => item.id}
      if item == options[:selected] || (options[:selected].respond_to?(:include?) && options[:selected].include?(item))
        tag_options[:selected] = 'selected'
      else
        tag_options[:selected] = nil
      end
      tag_options.merge!(yield(item)) if block_given?
      s << content_tag('option', h(item.name), tag_options)
    end
    s
  end

  def yogo_button(image, text, link)
    link_to(image_tag(image), link)
  end

  # Creates the appropriate HTML for attributes on a model
  #
  # For attributes that are files or images it makes a download link work for them
  #
  # @example
  #   <%- @model.usable_properties.each do |p| %>
  #     <%= yogo_show_helper(d, p, @project, @model) %>
  #   <%- end %>
  #
  # @return [HTML Fragment] the HTML is either a string or a link to the file/image.
  #
  # @api public
  def yogo_show_helper(item, property, project, model)
    case property
    when DataMapper::Property::YogoImage
      file = item[property.name]
      file = file[0..15] + '...' if file.length > 15
      img = image_tag(show_asset_project_yogo_data_path(project, model, item, :attribute_name => property.name), :width => '100px')
      link_target = detailed ? img : file
      link_to(link_target, show_asset_project_yogo_data_path(project, model, item, :attribute_name => property.name, :ext => '.png'),
        :class => 'fancybox', :title => model.name)
    when DataMapper::Property::YogoFile
      file = item[property.name]
      file = file[0..15] + '...' if file.length > 15
      link_to(file, download_asset_project_yogo_data_path(project, model, item, :attribute_name => property.name))
    when DataMapper::Property::Text
      if !detailed && (item[property.name] && item[property.name].length > 15)
        tooltip(item[property.name])
      else
        item[property.name]
      end
    else
      item[property.name]
    end
  end
end
