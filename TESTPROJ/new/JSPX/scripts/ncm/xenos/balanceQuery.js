//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
 xenos.ns.views.balanceQuery.validateSubmit = function(){

	var validationMessages = [];
	var baseDate = $('#baseDate').val();
	var currencyCode    = $('#currencyCode').val();
	var securityCode  = $('#securityCode').val();
	
	var dateFormatValidationFails = false;
	
	if(isDateCustom(baseDate)==false && baseDate.length>0) {
		dateFormatValidationFails = true;
		validationMessages.push(xenos.utils.evaluateMessage(xenos$NCM$i18n.balanceQuery.validation.date_format_check));
	}
	
	// Validate that Security and Currency have not been specifed together
	if(securityCode.length != 0 && currencyCode.length != 0 && !dateFormatValidationFails){
		validationMessages.push(xenos.utils.evaluateMessage(xenos$NCM$i18n.balanceQuery.validation.securityandcurrency_validation));
	}
	
	//Show the error message
	if ( validationMessages.length >0){
		 xenos.utils.displayGrowlMessage(xenos.notice.type.error, validationMessages);
		 return false;
	}else{
		$('.formHeader').find('.formTabErrorIco').css('display', 'none');
	}
	return true;
}