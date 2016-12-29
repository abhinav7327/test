//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
$(document).ready(function () {
	
	//Converting Date Type input fields to Date Fields.
	xenos.loadScript([{path: xenos.context.path + '/scripts/xenos-datepicker.js'}], {
	    success: function() {
			$('.dateinput').xenosdatepicker();
        }
    });
	
	$('#popInstrumentType').treeview({
		                    contentName: 'instrumentJson',
							type: "Instrument Type",
							isPopUp: true
	});
	
	$('#popMarket').treeview({
		                    contentName: 'marketJson',
							type: "market",
							isPopUp: true
	});
	
});
