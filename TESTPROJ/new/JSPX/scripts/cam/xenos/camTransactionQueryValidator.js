//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $

xenos.ns.views.camTranQry.validateSubmit = function(){
	var validationMessages = [];		
	var fundCode = $.trim($('#fundCode').val());
	var fromDate = $.trim($('#fromDate').val());	
	var toDate = $.trim($('#toDate').val());		
	var isValidDate = true;	

	
	if(VALIDATOR.isNullValue($.trim(fundCode))){		
		validationMessages.push(xenos$CAM$i18n.transQ.enter_fundCode);
	}	
	
	if(fromDate.length>0 && isDateCustom(fromDate) == false) {
		isValidDate = false;
		validationMessages.push(xenos$CAM$i18n.transQ.invalid_fromdate);
	}
	
	if(toDate.length>0 && isDateCustom(toDate) == false) {
		isValidDate = false;
		validationMessages.push(xenos$CAM$i18n.transQ.invalid_todate);
	}
	
	if(fromDate.length == 0 || toDate.length == 0) {		
		validationMessages.push(xenos$CAM$i18n.transQ.daterange_empty);
	}else{
		if(isValidDate == true && !isValidDateRange(fromDate, toDate)){
			validationMessages.push(xenos$CAM$i18n.transQ.daterange_invalid);
		}
	}	
	
	//Show the error message
	if(validationMessages.length > 0){
		xenos.utils.displayGrowlMessage(xenos.notice.type.error, validationMessages);
		return false;
	}else{
		xenos.utils.clearGrowlMessage();
	}
	return true;
					
}