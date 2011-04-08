class AddMetaDataCell < Cell::Rails

  def display_general_category_cv
    render
  end
  
  def display_variable
    render
  end
  
  def display_list
    @sites = @opts[:sites]
    render
  end
end
