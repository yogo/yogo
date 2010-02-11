class YogoDataFormBuilder < ActionView::Helpers::FormBuilder
  
  # Analysis (Analyze?) a DataMapper parameter to create the correct form element type.
  #
  def field_for_param(param, *args)
    if param.type == DataMapper::Types::YogoFile
      file_field(param.name, *args)
    else
      text_field(param.name, *args)
    end
  end
  
end