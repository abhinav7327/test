//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
 xenos.ns.views.unrealizedPLQuery.validateSubmit = function(){

	var validationMessages = [];
	var baseDateStr = $('#baseDateStr').val();
	
	if(isDateCustom(baseDateStr)==false && baseDateStr.length>0) {
		dateFormatValidationFails = true;
		validationMessages.push(xenos.utils.evaluateMessage(xenos$DRV$i18n.unrealizedPLQuery.validation.date_format_check));
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