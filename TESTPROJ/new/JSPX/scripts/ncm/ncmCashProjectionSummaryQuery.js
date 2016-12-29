//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos.ns.views.ncmCashProjectionSummaryQuery.formatDate = function(date){
		if(date.value.length == 7){
			if(date.id=="dateTo"){
				$("#dateTo").val(date.value.substr(0,6)+"0"+date.value.substr(6));
			}
		}
};