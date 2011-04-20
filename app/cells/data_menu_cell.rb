class DataMenuCell < Cell::Rails

  def display
    @current_user = @opts[:current_user]
    @queries = []
    render
  end
end
