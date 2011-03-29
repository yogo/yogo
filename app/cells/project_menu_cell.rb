class ProjectMenuCell < Cell::Rails

  def display
    current_user = @opts[:current_user]
    @projects = Project.all(:is_private => false)
    if @opts[:logged_in]
      @projects = @projects | current_user.projects
    end
    render
  end

end
