class SiteBrowserCell < Cell::Rails

  def display
    @project = @opts[:project]
    @sites = @project.managed_repository{ Voeis::Site.all }
    render
  end

end
