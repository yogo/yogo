function toggle_visibility(id) {
   var e = document.getElementById(id);
   if(e.style.display == 'block')
      e.style.display = 'none';
   else
      e.style.display = 'block';
}

function hide_element(element_name)
{
  element = document.getElementById(element_name);

  element.style.display = 'none';
}
