
$(document).ready(function() {

  // tabs = document.getElementById("tabs");
  $('#tabs').each(function(){
    this.style.visibility = "visible";
  })

  $("#feedback").accordion({
    collapsible: true
  });
  $("#feedback").accordion('activate', false);
  $('#feedback').bind('accordionchangestart', function(event, ui) {
    this.style.zIndex = 1 - this.style.zIndex; 
  });
  $("#graphs").accordion({
    collapsible: true
  });
  
   
  $("#graphs").accordion('activate', false);
  
  $("#publish").accordion({
    collapsible: true
  });
  $("#publish").accordion('activate', false);
  
  $("#tabs").tabs();
   
  $("#content").corner('top');
  $(".nav-items").corner('bottom');
  $("h3.nav-title").corner('top');
  $("#home-title").corner('bottom');
  // $("#tabs").bind('tabsselect', function(event, ui){
  //   var last_tab = getCookie("current_page");
  //   var new_tab = last_tab[1..last_tab.length-1];
  //   var selected = $('#tabs').tabs('option', 'selected');
  //   $.get("/yogo/feedback/edit", function(data){
  //     alert("Data Loaded: " + data);
  //   });
  // 
  // });
  
});

function getCookie(c_name)
{
if (document.cookie.length>0)
  {
  c_start=document.cookie.indexOf(c_name + "=");
  if (c_start!=-1)
    {
    c_start=c_start + c_name.length+1;
    c_end=document.cookie.indexOf(";",c_start);
    if (c_end==-1) c_end=document.cookie.length;
    return unescape(document.cookie.substring(c_start,c_end));
    }
  }
return "";
}
	
(function($){
  // This plugin could really be cleaned up.
  $.yogo_mapit = function(element, options){

    defaults = {
      locations: [{'lat': 45.6, 'long': -111.0,   'name': "Lorem ipsum."},
                  {'lat': 45.62, 'long': -111.01, 'name': "Lorem ipsum."}],
      recenter: true,
      display_links: true,
      zoom: 'auto'
    }
      var blue_icon = '/images/blue-dot.png';
      var settings = jQuery.extend(defaults, options);
    
      minLat = 360;
      maxLat = -360;
      minLng = 360; 
      maxLng = -360;
    
      $.each(settings.locations, function(i, location){
        if (minLat > location['lat']) { minLat = location['lat'] };
        if (maxLat < location['lat']) { maxLat = location['lat'] };
        if (minLng > location['long']) { minLng = location['long'] };
        if (maxLng < location['long']) { maxLng = location['long'] };
      });
    
      var latLngBounds = new google.maps.LatLngBounds(new google.maps.LatLng(minLat, minLng),
                                                      new google.maps.LatLng(maxLat, maxLng));
    
      mapOptions = {
        center: latLngBounds.getCenter(),
        mapTypeId: google.maps.MapTypeId.TERRAIN,
        navigationControl: true,
        navigationControlOptions : { style: google.maps.NavigationControlStyle.SMALL },
        mapTypeControl: true,
        mapTypeControlOptions: {style: google.maps.MapTypeControlStyle.DROPDOWN_MENU},
        
        scaleControl: true
      };
    
      var map = new google.maps.Map($(element)[0], mapOptions);
      if (settings.zoom == "auto") {
        map.fitBounds(latLngBounds);
      } else {
        map.setZoom(settings.zoom);
      };

            var curInfoWindow = null;
      $.each(settings.locations, function(i,location){
        var latlng = new google.maps.LatLng(location['lat'], location['long']);
        if (location['status'] == "Tentative")
        {
          var marker = new google.maps.Marker({
                position: latlng, 
                map: map,
                title: location['lat'] + " : " + location['long'],
                icon: blue_icon
            });
        }
        else
        {
          var marker = new google.maps.Marker({
                position: latlng, 
                map: map,
                title: location['lat'] + " : " + location['long']
            });
        }
        if (location.name) {
          var infoWindow = new google.maps.InfoWindow({
            content: location.name
          });

          google.maps.event.addListener(marker, 'click', function(){
            if(curInfoWindow!=null){
              curInfoWindow.close();
            };
            infoWindow.open(map,marker);
            curInfoWindow = infoWindow;
              $(element).siblings('.maps-info').find('div').hide();
              $("#site_"+location.id).toggle();
          });
        };
        
        if( settings.display_links == true ){
          $("<a href='#>"+location.name+"</a>").appendTo($(element).siblings('.map-links')).bind('click', function(){
            google.maps.event.trigger(marker,'click');
          });
        };
        
      });
  
      // Create a 'Recenter link' if requested.
      if( settings.recenter == true ) {
        $("<a href='#' id='#recenter-map' class='map-center-link'>Recenter</a>").appendTo($(element).siblings('.map-links')).bind("click", function(){
          if(curInfoWindow != null){ curInfoWindow.close();};
          $(element).siblings('.maps-info').find('div').hide();
          map.fitBounds(latLngBounds);
          map.panTo(latLngBounds.getCenter());
        });
      };
      
    
    return this;
  };
  
  
})(jQuery);

(function($){
  
  $.fn.yogo_graphit = function(options){

  this.each(function(i, domElement){




  // hard-code color indices to prevent them from shifting as
  // series are turned on/off
  var i = 0;
  $.each(options.plot_data, function(key, val) {
      val.color = i;
      ++i;
  });

  function fillInSeriesOptions() {
      var i;
      
      // collect what we already got of colors
      var neededColors = series.length,
          usedColors = [],
          assignedColors = [];
      for (i = 0; i < series.length; ++i) {
          var sc = series[i].color;
          if (sc != null) {
              --neededColors;
              if (typeof sc == "number")
                  assignedColors.push(sc);
              else
                  usedColors.push($.color.parse(series[i].color));
          }
      }
      
      // we might need to generate more colors if higher indices
      // are assigned
      for (i = 0; i < assignedColors.length; ++i) {
          neededColors = Math.max(neededColors, assignedColors[i] + 1);
      }

      // produce colors as needed
      var colors = [], variation = 0;
      i = 0;
      while (colors.length < neededColors) {
          var c;
          if (options.colors.length == i) // check degenerate case
              c = $.color.make(100, 100, 100);
          else
              c = $.color.parse(options.colors[i]);

          // vary color if needed
          var sign = variation % 2 == 1 ? -1 : 1;
          c.scale('rgb', 1 + sign * Math.ceil(variation / 2) * 0.2)

          // FIXME: if we're getting to close to something else,
          // we should probably skip this one
          colors.push(c);
          
          ++i;
          if (i >= options.colors.length) {
              i = 0;
              ++variation;
          }
      }


  }
  
  function rgbConvert(rgbstr) 
  {
     var str = rgbstr.replace(/rgb\(|\)/g, "").split(",");
     str[0] = parseInt(str[0], 10).toString(16).toLowerCase();
     str[1] = parseInt(str[1], 10).toString(16).toLowerCase();
     str[2] = parseInt(str[2], 10).toString(16).toLowerCase();
     str[0] = (str[0].length == 1) ? '0' + str[0] : str[0];
     str[1] = (str[1].length == 1) ? '0' + str[1] : str[1];
     str[2] = (str[2].length == 1) ? '0' + str[2] : str[2];
     return ('#' + str.join(""));
  }
  
  var colors = ["#edc240", "#afd8f8", "#cb4b4b", "#4da74d", "#9440ed"];
  function make_new_color(index)
  {
    if (index > 4)
    {
      variation = 1;
      i = 0;
      neededColors = index;
      temp_colors =  colors = ["#edc240", "#afd8f8", "#cb4b4b", "#4da74d", "#9440ed"];
      while (colors.length < neededColors) {
          var c;
          c = $.color.parse(temp_colors[i]);

          // vary color if needed
          var sign = variation % 2 == 1 ? -1 : 1;
          //c.scale('rgb', 1 + sign * Math.ceil(variation / 2) * 0.2);
          c.scale('rgb', 1 + sign * Math.ceil(variation / 2) * 0.2);
          // FIXME: if we're getting to close to something else,
          // we should probably skip this one
          colors.push(c);
          
          ++i;
          if (i >= temp_colors.length) {
              i = 0;
              ++variation;
          }
      }
      // var rgbstr = new String();
      // rgbstr = + colors[index];
      // var str = rgbstr.substring(/rgb\(|\)/g, "").split(",");
      //  str[0] = parseInt(str[0], 10).toString(16).toLowerCase();
      //  str[1] = parseInt(str[1], 10).toString(16).toLowerCase();
      //  str[2] = parseInt(str[2], 10).toString(16).toLowerCase();
      //  str[0] = (str[0].length == 1) ? '0' + str[0] : str[0];
      //  str[1] = (str[1].length == 1) ? '0' + str[1] : str[1];
      //  str[2] = (str[2].length == 1) ? '0' + str[2] : str[2];
       // return ('#' + str.join(""));
       return colors[index];
    }
    else
    {
      return colors[index];
    }
  }
  make_new_color(20);
  function jqCheckAll( pID )
  {
     $( '#' + pID + " :checkbox").attr('checked', $('#checkOn').is(':checked'));
     plotAccordingToChoices();
  }
  
  function plotAccordingToChoices() {
      var data = [];

      choiceContainer.find("input:checked").each(function () {
          var key = $(this).attr("name");
          if (key && options.plot_data[key])
              data.push(options.plot_data[key]);

          
      });
      if (data.length > 0)
      {
         var plot =    $.plot($(domElement), data, {
              series: {
                  lines: { show: true },
                  points: { show: true }
                 },
              grid:  { hoverable: true, clickable: true },
              xaxis: { mode: "time" },
              xaxis: { mode: "time" },
              pan:   { interactive: true },
              zoom:  { interactive: true },
              legend:{ show: false, container: options.leg}
          });
           // add zoom out button 
           $('<div class="zobutton" style="right:23px;top:20px">-</div>').appendTo($(domElement)).click(function (e) {
               e.preventDefault();
               plot.zoomOut();
           });
           $('<div class="zibutton" style="right:20px;top:40px">+</div>').appendTo($(domElement)).click(function (e) {
               e.preventDefault();
               plot.zoom();
           });
        
        }
  }
  
  // insert checkboxes 
  var choiceContainer = $(options.choice);
  choiceContainer.append('<table>');
  $.each(options.plot_data, function(key, val) {
      choiceContainer.append('<tr><td valign="top"><div style="border: 1px solid rgb(204, 204, 204); padding: 1px;">'+
                             '<div style="border: 5px solid ' + colors[val.color] + '; overflow: hidden; width: 4px; height: 0pt;"/></div>'+
                             '</td><td valign="top""><label for="id' + key + '" background-color = #edc240>'+ val.label + '</label>'+
                             '<input type="checkbox" name="' + key +
                             '" checked="checked" id="id' + key + '" onChange="plotAccordingToChoices()"></td></tr>');
  });
  //choiceContainer.append('<tr><td>&nbsp</td><td><input type="checkbox" name="checkOn" checked="checked" onclick="jqCheckAll(' + options.choice.substring('#', '') 
   //                     +' );"/><label>Check/Uncheck All</label></td></tr>');
   // 
  choiceContainer.append('</table>');
  choiceContainer.find("input").click(plotAccordingToChoices);
  


  

  plotAccordingToChoices();



  // var plot = $.plot($(domElement),
  //         plot_data, {
  //             series: {
  //                 lines: { show: true },
  //                 points: { show: true }
  //                },
  //             grid:  { hoverable: true, clickable: true },
  //             xaxis: { mode: "time" },
  //             xaxis: { mode: "time" },
  //             pan:   { interactive: true },
  //             zoom:  { interactive: true },
  //             legend:{ show: true, container: "#legend"}
  //            });

  function showTooltip(x, y, contents) {
      $('<div id="tooltip">' + contents + '</div>').css( {
          position: 'absolute',
          display: 'none',
          top: y + 5,
          left: x + 5,
          border: '1px solid #fdd',
          padding: '2px',
          'background-color': '#fee',
          opacity: 0.80
      }).appendTo("body").fadeIn(200);
  }

  var previousPoint = null;
  $(domElement).bind("plothover", function (event, pos, item) {
      var mEpoch = pos.x; // convert to milliseconds (Epoch is usually expressed in seconds, but Javascript uses Milliseconds)
      dDate = new Date();
      dDate.setTime(mEpoch);
      $(options.x).text(dDate.toGMTString());
      $(options.y).text(pos.y);

      //if ($("#enableTooltip:checked").length > 0) {
          if (item) {
              if (previousPoint != item.datapoint) {
                  previousPoint = item.datapoint;
                  $("#tooltip").remove();
                  var x = item.datapoint[0].toFixed(2),
                      y = item.datapoint[1].toFixed(2);
                      var mEpoch = x; // convert to milliseconds (Epoch is usually expressed in seconds, but Javascript uses Milliseconds)
                      dDate = new Date();
                      dDate.setTime(mEpoch);
                  showTooltip(item.pageX, item.pageY,
                              item.series.label + " on " + dDate.toGMTString() + " = " + y);
              }
          }
          else {
              $("#tooltip").remove();
              previousPoint = null;            
          }
      //}
  }); 
});
};
})(jQuery);

$(document).ready(function() {
  $(document).ajaxStart(function(){
    $('.spinner').show();
  });
  
  $(document).ajaxSuccess(function(){
    $('.spinner').hide();
  });
  
  $(document).ajaxError(function(event, request, settings){
    $('.spinner').hide();
    alert("There was an error with your request. Please refresh the page and try again.");
  });
  
});