class ProjectMenuCell < Cell::Rails

  def display
    @current_user = @opts[:current_user]
    @projects = @current_user.projects
    render
  end

end
