class AddSiteCell < Cell::Rails

  def display_form
    @site = @opts[:site]
    @project = @opts[:project]
    render
  end
  
  def display_list
    @sites = @opts[:sites]
    render
  end
end
