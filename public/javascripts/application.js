
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