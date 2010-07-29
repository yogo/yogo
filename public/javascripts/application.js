
$(document).ready(function(){
  
  $(".date-picker").datepicker();
  
  //$('#project_model_name').textdropdown();
  
  $('#tabs').each(function(){
    this.style.visibility = "visible";
  });
  
  $("#tabs").tabs();

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

  // Toggle elements on the project-user-groups page
  $('#project-user-groups-form :checkbox').bind('change', function(e){
    if ($(this).attr('checked')) {
      $(this).next('label').text('In Group');
    } else {
      $(this).next('label').text('Not In Group');
    };
    
  })
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

