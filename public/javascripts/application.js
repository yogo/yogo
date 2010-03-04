
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
    handle: '.grippie',
    stop: function(event, ui) {
      $("#sortable li input:hidden").each(function(index){ this.value = index+1 })
    }
  });
  
  $(".date-picker").datepicker();
  
  $('#tabs').each(function(){
    this.style.visibility = "visible";
  });
  
  $("#tabs").tabs();
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
	function isLastPage( opts, internalPageNum ) { return ( internalPageNum === opts.totalPages-1 ); }
	
})(jQuery);
