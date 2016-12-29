//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
 xenos.ns.views.balanceQuery.validateSubmit = function(){
	 
	var alertStr = [];
	var baseDate = $('#baseDt').val();
	var balncBasis = $('#blncBasis').val();
	var dateFormatValidationFails = false;

	if(baseDate.length==0) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAM$i18n.balanceQuery.basedate_empty);
	}
	
	if(dateFormatValidationFails==false && baseDate.length>0 && isDateCustom(baseDate)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAM$i18n.balanceQuery.basedate_format_check);
	}
	
	if(dateFormatValidationFails==false && balncBasis.length==0) {
		alertStr.push(xenos$CAM$i18n.balanceQuery.empty_balance_basis);
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