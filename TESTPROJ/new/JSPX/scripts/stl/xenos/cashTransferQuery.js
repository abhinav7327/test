//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos.ns.views.cashTransferQuery.validateSubmit = function(){
	
	var alertStr = [];
	
	//Call to individual date field validation for invalid input.
	var dateFormatValidationFails = xenos.ns.views.cashTransferQuery.customDateValidation(alertStr);
	
	//Call to date range validation.
	if(dateFormatValidationFails == false){
		xenos.ns.views.cashTransferQuery.dateRangeValidation(alertStr);
	}
	
	
	//Show the error message
	if(alertStr.length > 0){
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, alertStr, true));
		return false;
	}else{
		$('.formHeader').find('.formTabErrorIco').css('display', 'none');
	}	
	return true;
}
 //This method does individual date field validation for invalid input.
xenos.ns.views.cashTransferQuery.customDateValidation = function(alertStr){
	
	var valueDateFrom = $('#valueDateFrom').val();
	var valueDateTo = $('#valueDateTo').val();	
	
	var dateFormatValidationFails = false;	
	
	
	
	//Validation Value Date From
	if(dateFormatValidationFails==false && valueDateFrom.length>0 && isDateCustom(valueDateFrom)==false) {
		dateFormatValidationFails = true;	
		alertStr.push(xenos$STL$i18n.cashTransferQuery.date_format_check + valueDateFrom);
	}
		if(!dateFormatValidationFails){	
		formatDate(valueDateFrom,$('#valueDateFrom'));
	}
	//Validation Value Date To
	if(dateFormatValidationFails==false && valueDateTo.length>0 && isDateCustom(valueDateTo)==false) {
		dateFormatValidationFails = true;	
		alertStr.push(xenos$STL$i18n.cashTransferQuery.date_format_check + valueDateTo);
	}
		if(!dateFormatValidationFails){	
		formatDate(valueDateTo,$('#valueDateTo'));
	}
	
	return dateFormatValidationFails;
}

//This method does date range validation.
xenos.ns.views.cashTransferQuery.dateRangeValidation=function(alertStr){
	
	var valueDateFrom = $('#valueDateFrom').val();
	var valueDateTo = $('#valueDateTo').val();	
	
	var dateRangeValidationFails = false;
	
	// Validate Value Date From - To
	if(dateRangeValidationFails == false && !isValidDateRange(valueDateFrom, valueDateTo)){
		dateRangeValidationFails = true;
	}
	
	
	if(dateRangeValidationFails) {
		alertStr.push(xenos$STL$i18n.cashTransferQuery.date_from_to_check);
	}
}
