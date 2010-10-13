
$(document).ready(function(){
  // show_loader = function(){
  // $('#loader').attr("display", "visible");
  // };
  
  $(".date-picker").datepicker();
  
  //$('#project_model_name').textdropdown();
  
  $('#tabs').each(function(){
    this.style.visibility = "visible";
  });
  
  $("#tabs").tabs();
  
  $( "#feedback" ).draggable();

  //Hide (Collapse) the toggle containers on load
  $(".toggle-container").hide();

  //Slide up and down & toggle the Class on click
  $('h2.trigger').click(function(){
  $(this).toggleClass('active').next('.toggle-container').slideToggle('slow');
  });
  
  //Initialization for the lightbox-style image popups
  $("a.fancybox").fancybox();
  
  $("a[rel=gallery]").fancybox({
    'transitionIn'  : 'none',
    'transitionOut' : 'none',
    'titlePosition' : 'over',
    'titleFormat'   : function(title, currentArray, currentIndex, currentOpts) {
      return '<span id="fancybox-title-over">Image ' + (currentIndex + 1) + ' / ' + currentArray.length + (title.length ? ' &nbsp; ' + title : '') + '</span>';
    }
  });
  
  // Dataset tab behavior (for the project show page)
  $(".action-tabs").tabs();
  
  // Tooltip dialogs
  $('.tooltip').dialog({autoOpen:false, width:600});

  $("#graphs").accordion({collapsible: true});
  $("#graphs").accordion('activate', false);

  $("#about-accordion").accordion({collapsible: true});
  $("#about-accordion").accordion('activate', true);
  
  $("#graph-accordion").accordion({collapsible: true});
  $("#graph-accordion").accordion('activate', false);
  
  // Toggle elements on the project-user-roles page
  $('#project-user-roles-form :checkbox').bind('change', function(e){
    if ($(this).attr('checked')) {
      $(this).next('label').text('Has Role');
    } else {
      $(this).next('label').text('Does Not Have Role');
    };
  });
    
  // collapsible
  $(".site-name").show();
  $(".site-name").click(function()
    {
      $(this).toggleClass('icon-collapsed');
      //$(this).toggleClass('icon-expanded');
      $(this).next(".sensors").slideToggle(300);
    });
});

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


function check_navigation_element_state(element){
  // Select an array of child divs of the element
  child_element = $(element).parent('div').children('div');
  // Toggle the visibility of the div.
  child_element.toggle();
  // Return true if the child_element list is empty and the user action is passed through to the application.
  // Return false if the child_element list is not empty.
  return child_element.length < 1;
}

(function($) {
	
	var defaults = {
		perPage : 5, // number of items per page
		startPage : 1, // page to begin on - NOT zero indexed
		atEnd : 'stop' // loop / stop
	};
	
	$.fn.evtpaginate = function( options )
	{
		return this.each(function(){
		
			var opts = $.extend(true, {}, defaults, options); // set options
			var wrap = opts.wrapper = $(this);
			
			wrap.bind( 'show.evtpaginate', function( e, pageNum ){ show( opts, pageNum-1 ); });
			wrap.bind( 'next.evtpaginate', function(){ next( opts ); });
			wrap.bind( 'prev.evtpaginate', function(){ prev( opts ); });
			wrap.bind( 'first.evtpaginate', function(){ show( opts, 0 ); });
			wrap.bind( 'last.evtpaginate', function(){ show( opts, opts.totalPages-1 ); });
			wrap.bind( 'refresh.evtpaginate', function( e, newopts ){ refresh( opts, newopts ); });
			
			setUp( opts );
		});
	};
	
	function setUp( opts )
	{
		opts.perPage		=	parseInt(opts.perPage);
		opts.items 			=	opts.wrapper.children();
		opts.totalItems		=	opts.items.size();
		opts.totalPages		=	Math.ceil( opts.totalItems / opts.perPage );
		opts.currentPage	=	parseInt(opts.startPage) - 1;
		opts.first 			=	isFirstPage( opts, opts.currentPage );
		opts.last 			=	isLastPage( opts, opts.currentPage );
		opts.pages			=	[];
		
		if ( opts.currentPage > opts.totalPages-1 ) opts.currentPage = opts.totalPages-1;

		opts.items.hide();	
			
		for ( var i = 0; i < opts.totalPages; i++ )
		{
			var startItem = i*opts.perPage;
			opts.pages[i] = opts.items.slice( startItem, (startItem + opts.perPage) );
		}
		
		show( opts, opts.currentPage );
		
		opts.wrapper.trigger( 'initialized.evtpaginate', [opts.currentPage+1, opts.totalPages] );
	}
	
	function refresh( opts, newopts )
	{
		if ( newopts !== undefined ) $.extend(true, opts, newopts); // update options
		opts.startPage = parseInt(opts.currentPage)+1;
		setUp( opts );
	}
	
	function next( opts )
	{
		switch( opts.atEnd )
		{
			case 'loop': show( opts, (opts.last ? 0 : opts.currentPage + 1) ); break;
			default: show( opts, (opts.last ? opts.totalPages - 1 : opts.currentPage + 1) ); break; // stop when getting to last page 
		}
	}
	
	function prev( opts )
	{
		switch( opts.atEnd )
		{
			case 'loop': show( opts, (opts.first ? opts.totalPages - 1 : opts.currentPage - 1) ); break;
			default: show( opts, (opts.first ? 0 : opts.currentPage - 1) ); break; // stop when getting to first page 
		}
	}
	
	function show( opts, pageNum )
	{	
		if ( pageNum > opts.totalPages-1 ) pageNum = opts.totalPages-1;
				
		if ( ! opts.pages[opts.currentPage].is(':animated') )
		{
			opts.wrapper.trigger( 'started.evtpaginate', opts.currentPage+1 );
			
			$.fn.evtpaginate.swapPages( opts, pageNum, function(){
				
				opts.currentPage = pageNum;
				opts.first = isFirstPage( opts, opts.currentPage ) ? true : false;
				opts.last = isLastPage( opts, opts.currentPage ) ? true : false;
				
				opts.wrapper.trigger( 'finished.evtpaginate', [opts.currentPage+1, opts.first, opts.last] );
						
			});
		}
	}
	
	// public, can override this if neccessary
	$.fn.evtpaginate.swapPages = function( opts, pageNum, onFinish )
	{
		opts.pages[opts.currentPage].hide();
		opts.pages[pageNum].show();
		onFinish();
	};
	
	// utility functions
	function isFirstPage( opts, internalPageNum ) { return ( internalPageNum === 0 ); }
	function isLastPage( opts, internalPageNum ) { return ( internalPageNum === opts.totalPages-1 ); };
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

jQuery.fn.textdropdown = function() {
  with ($(this)) {
    with (next('ul:first')) {
      find('li').click(function() {
        $(this).parent().prev('.textdropdown-outer').find('input:first').attr('value', $(this).html());
        $(this).parent().hide();
      });
      hide();
    } 

    keypress(function() { 
      $(this).parent().next('ul:first').hide();
    });

    change(function() { 
      $(this).parent().next('ul:first').hide();
    });

    wrap('<div class="textdropdown-outer" style="width: ' + width() + 'px; height: ' + (height() + 5) + 'px"></div>');
    var btn = parent().prepend('<div class="textdropdown-btn">&nbsp;</div>').find('.textdropdown-btn');
    width(width() - btn.width() - 5);
    css("border", "0");

    btn.click(function() {
      var p = parent();
      with (p.next('ul:first')) {
        css('position', 'absolute');
        css('width',    p.width());
        css('left',     p.position().left);
        css('top',      p.position().top + p.height() + 1);
        toggle();
      }
    });
  }
};

