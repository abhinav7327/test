//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
 xenos.ns.views.accruedCouponQuery.validateSubmit = function(){
	 
	var alertStr = [];
	var baseDate = $('#baseDate').val();
	var dateFormatValidationFails = false;
	
	if(baseDate.length>0 && isDateCustom(baseDate)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$CAM$i18n.accruedCouponQuery.date_format_check, [baseDate]));
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