require 'test_helper'

class FeedbackWidgetTest < Apotomo::TestCase
  has_widgets do |root|
    root << widget(:feedback_widget, 'me')
  end
  
  test "display" do
    render_widget 'me'
    assert_select "h1"
  end
end
