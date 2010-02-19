
$(document).ready(function(){

  $('#add-property').bind('click', function(event){
    $('#new-properties').append("<div class=\"new-property\">" + $('#form-template').html() + "</div>")
    return false;
  });
  
  $('.remove-new-property').live('click', function(event){
    $(this).parents('div.new-property').hide().remove();
    return false;
  });
  
});

function check_navigation_element_state(element){
  // Select an array of child divs of the element
  child_element = $(element).parent('div').children('div');
  // Toggle the visibility of the div.
  child_element.toggle();
  // Return true if the child_element list is empty and the user action is passed through to the application.
  // Return false if the child_element list is not empty.
  return child_element.length < 1;
}