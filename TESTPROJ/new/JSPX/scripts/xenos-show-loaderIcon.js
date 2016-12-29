//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
(function ($) {
	$.fn.xenosloader = function(options){
		return this.each( function() {
				var $self = $(this);
				var markup = ""
					+ "<div class='detail-loader' ><div class='detail-loader-ico'>"
					+ "<img class='loading' src='" + xenos.context.path + "/images/xenos/xenosLoader.gif' alt='' />"
					+ "</div></div>";
				$self.append(markup);
			});
		}
}(jQuery));
