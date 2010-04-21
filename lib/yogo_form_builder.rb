class YogoFormBuilder < ActionView::Helpers::FormBuilder
  helpers = field_helpers +
  %w(date_select datetime_select time_select collection_select calendar_date_select) +
  %w(collection_select select country_select time_zone_select) -
  %w(hidden_field label fields_for)

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
end
