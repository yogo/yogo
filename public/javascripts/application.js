
$(document).ready(function(){

  // TODO: Scope into model editor better.
  $('#add-property').bind('click', function(event){
    $('#sortable').append("<li class=\"new-property\">" + $('#form-template').html() + "</li>")
    return false;
  });

  // TODO: Scope into model editor better.  
  $('.remove-new-property').live('click', function(event){
    $(this).parents('li.new-property').hide().remove();
    return false;
  });
  
    // TODO: Scope into model editor better.
  $("#sortable").sortable({
    stop: function(event, ui) {
      $("#sortable li input:hidden").each(function(index){ this.value = index+1 })
    }
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


