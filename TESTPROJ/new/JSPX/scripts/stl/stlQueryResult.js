//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $

// Toggle handler
$('span.handler').die();
$('span.handler').live('click',function (e) {
	var container = $(this).parent().parent().next().next();
	if ($(this).hasClass('collapse')) {
		$(this).removeClass('collapse');
		$(this).attr('title', 'Collapse');		
	} else {
		$(this).addClass('collapse');
		$(this).attr('title', 'Expand');
	}	
	container.slideToggle('normal');
});
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 