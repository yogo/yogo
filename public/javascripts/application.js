
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