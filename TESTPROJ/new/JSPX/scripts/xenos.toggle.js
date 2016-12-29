//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
(function ($) {
	$.fn.xenostoggle = function(){
		this.click(function(){
			if($(this).attr('title') == "Expand") {
						$(this).removeClass("expand");
						$(this).addClass("collapse");
						$(this).attr('title', 'Collapse');
					} else {
						$(this).removeClass("collapse");
						$(this).addClass('expand');
						$(this).attr('title', 'Expand');
					}
					//class div.exmMoreHandle is explicitly for EXM Detail View (Edit Popup View/Comment Popup View/HTML View)
					//For all other screens, class div.moreHandle is used -->
					$(this).parents('div').nextAll('div:first').slideToggle("slow");
		});
	}
}(jQuery));