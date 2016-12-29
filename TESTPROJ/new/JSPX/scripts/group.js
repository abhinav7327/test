//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
OAction("group", {

	action: ONew,
	
	all: function(selector) {
		
		if (ODebug) {
			if (!selector) {
				OError(".group requires a selector.  If you passed a function(){} selector, remember the behaviour modifier as the second argument.  Try .group(function(){}, ONew)");
			}
		}
				
		var grouped = {};
		
		this.each(function(o){
			selected = OGet(o, selector);
			grouped[selected] = grouped[selected] || [];
			grouped[selected].push(o);
		});
		
		return grouped;
		
	}

});

OProvides("objx.group");