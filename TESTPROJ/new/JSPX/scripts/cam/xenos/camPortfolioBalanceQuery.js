//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
 xenos.ns.views.portBalanceQuery.validateSubmit = function(){
	 
	var alertStr = [];
	var baseDate = $('#baseDate').val();	
	var dateFormatValidationFails = false;
	var dateRangeValidationFails = false;

	if(VALIDATOR.isNullValue(baseDate)) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAM$i18n.portfolioBalanceQuery.date_empty);
	}
	
	if(dateFormatValidationFails==false && !VALIDATOR.isNullValue(baseDate) && isDateCustom(baseDate)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAM$i18n.portfolioBalanceQuery.invalid_date);
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