//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
(function($) {
	$.fn.xenos$multiSelect = function(option){
			var _option = {
				select: function(){},
				deselect:function(){},
				label: '',
				minWidth: 300,
				maxWidth: 590,	
				scroll: 80
			};
			option = $.extend(_option, option);
			$(this).multiselect({
				select: option.select,
				deselect:option.deselect,
				label: option.label,
				minWidth: option.minWidth,
				maxWidth: option.maxWidth,	
				scroll: option.scroll
		  });
			};
})(jQuery);