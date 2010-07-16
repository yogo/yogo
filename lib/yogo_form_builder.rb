class YogoFormBuilder < ActionView::Helpers::FormBuilder
  helpers = field_helpers +
  %w(date_select datetime_select time_select collection_select calendar_date_select) +
  %w(collection_select select country_select time_zone_select) -
  %w(hidden_field label fields_for text_area check_box)

  # Creates the correct form field element for a DataMapper Type
  #
  # @author Robbie Lamb robbie.lamb@gmail.com
  #
  # @api private
  helpers.each do |name|
    define_method(name) do |field, *args|
      options = args.last.is_a?(Hash) ? args.pop : {}
      args << options.except(:label, :sub_label)
      locals = { :element => super(field, *args), :label => label(field, options[:label]), :sub_label => options[:sub_label]}
      @template.capture do
        @template.render(:partial => 'forms/field', :locals => locals)
      end
    end
  end
  
  # Set the default rows/cols for a text_area to look prettier
  #
  # @return [String]
  #   The applicable HTML for the text area element.
  # 
  # @author Pol Llovet pol.llovet@gmail.com
  #
  # @api private
  def text_area(field, *args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    options[:rows] ||= 7
    options[:cols] ||= 50
    args << options.except(:label, :sub_label)
    locals = { :element => super(field, *args), :label => label(field, options[:label]), :sub_label => options[:sub_label]}
    @template.capture do
      @template.render(:partial => 'forms/field', :locals => locals)
    end
  end
  
  # Use a different form partial for check_boxes so that they look prettier
  #
  # @return [String]
  #   The applicable HTML for the text area element.
  # 
  # @author Pol Llovet pol.llovet@gmail.com
  #
  # @api private
  def check_box(field, *args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    args << options.except(:label, :sub_label)
    locals = { :element => super(field, *args), :label => label(field, options[:label]), :sub_label => options[:sub_label]}
    @template.capture do
      @template.render(:partial => 'forms/inline_inverted_field', :locals => locals)
    end
  end
end
