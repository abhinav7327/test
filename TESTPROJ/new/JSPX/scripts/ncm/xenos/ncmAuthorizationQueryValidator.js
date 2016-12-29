//$Id$
//$Author: sumitag $
//$Date: 2016-12-23 14:24:30 $
xenos.ns.views.ncmAuthorizationQueryValidator.validateSubmit = function(){
	
	
	var alertStr = [];
	
	//Call to individual date field validation for invalid input.
	var dateFormatValidationFails = customDateValidation(alertStr);
	
	//Call to date range validation.
	if(dateFormatValidationFails == false){
		dateRangeValidation(alertStr);
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
function customDateValidation(alertStr){
	
	var dateFormatValidationFails = false;	
	
	//Validation If From or To Date empty
	if($.trim($('#dateTo').val()).length==0 || $.trim($('#dateFrom').val()).length==0){
		dateFormatValidationFails = true;
		alertStr.push(xenos$NCM$i18n.authorizationAdjustment.validation.date_empty);
		return dateFormatValidationFails;
		
	}
	
	//Validation Value Date From format
	if($.trim($('#dateFrom').val()).length>0 && isDateCustom($.trim($('#dateFrom').val()))==false){
		dateFormatValidationFails=true;
		alertStr.push(xenos$NCM$i18n.authorizationAdjustment.validation.datefrom_invalid);
	}
	
	//Validation Value Date To format
	if($.trim($('#dateTo').val()).length>0 && isDateCustom($.trim($('#dateTo').val()))==false){
		dateFormatValidationFails=true;
		alertStr.push(xenos$NCM$i18n.authorizationAdjustment.validation.dateto_invalid);
	}
	
	return dateFormatValidationFails;
}

//This method does date range validation.
function dateRangeValidation(alertStr){

	if(!isValidDateRange($.trim($('#dateFrom').val()), $.trim($('#dateTo').val()))){
		alertStr.push(xenos$NCM$i18n.authorizationAdjustment.validation.datefrom_less);
	}
	
	// Validate that Security and Currency have not been specified together
	if($.trim($('#securityCode').val()).length != 0 && $.trim($('#currency').val()).length != 0){
		alertStr.push(xenos$NCM$i18n.authorizationAdjustment.validation.securitycurrency_validation);
	}	
}

xenos.ns.views.ncmAuthorizationQueryValidator.formatDate = function(date,id){
	if(date.length == 7){
		id.val(date.substr(0,6)+"0"+date.substr(6));
	}
 }




