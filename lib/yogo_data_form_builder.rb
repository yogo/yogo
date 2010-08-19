class YogoDataFormBuilder < ActionView::Helpers::FormBuilder

  # Creates the correct form field element for a DataMapper Type
  #
  # @example field_for_param(DM_Object_Boolean, {:checked => "checked"})
  #
  # @param [Property] param a DataMapper Property Object
  # @param [Array] *args array of options to be passed to the corresponding rails form builder method.
  #
  # @return [String] A formatted html form element for the DataMapper type
  #
  # @author Robbie Lamb robbie.lamb@gmail.com
  # @author PPooll Lllloovvvettt pol.llovet@gmail.com
  #
  # @api public
  def field_for_param(param, *args)
    if param.kind_of?(DataMapper::Property::YogoFile) || param.kind_of?(DataMapper::Property::YogoImage)
      options = args.last.is_a?(Hash) ? args.pop : {}
      options.merge!(:size => 15)
      args << options
      file_field(param.name, *args)
    elsif param.kind_of?(DataMapper::Property::Boolean)
      radio_button(param.name, true, *args) + " " + label(param.name, "True", :value => true) << ActiveSupport::SafeBuffer.new('<br>') <<
      radio_button(param.name, false, *args) + " " + label(param.name, "False", :value => false)
    elsif param.type == Date
      options = args.last.is_a?(Hash) ? args.pop : {}
      options.merge!(:size => 15)
      args << (options.has_key?(:class) ? options.merge(:class => options[:class]+",date-picker") : options.merge(:class => 'date-picker'))
      text_field(param.name, *args)
    else
      options = args.last.is_a?(Hash) ? args.pop : {}
      options.merge!(:size => 15)
      args << options
      text_field(param.name, *args)
    end
  end
  
end