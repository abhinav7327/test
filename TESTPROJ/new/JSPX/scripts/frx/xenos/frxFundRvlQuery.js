//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $




 xenos.ns.views.frxFundRvlQuery.validateSubmit = function(){
	var alertStr = [];
	
	var bookingDate = $('#bookingDate').val();
	var dateFormatValidationFails = false;
	
	if (VALIDATOR.isNullValue(bookingDate)) {
			alertStr.push(xenos$FRX$i18n.frxFundRvlQuery.validation.base_date_empty);
		}
	
	if(dateFormatValidationFails==false && bookingDate.length>0 && isDateCustom(bookingDate)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxFundRvlQuery.validation.date_invalid, [bookingDate]));
		console.log(bookingDate);
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
 
 
 function isValidText(text){
	if(text!='undefined' && text!=null && $.trim(text).length > 0){
		return true;
	}
	return false;
 }
