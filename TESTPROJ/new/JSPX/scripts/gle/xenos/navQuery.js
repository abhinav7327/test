//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos.ns.views.gleNavQuery.validateSubmit = function(){
	var alertStr = [];
	var valuationDate = $.trim($('#valuationDate').val());
	var dateFormatValidationFails = false;
	
	if(isDateCustom(valuationDate)==false && valuationDate.length>0) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$GLE$i18n.nav.query.date_format_check);
	}
	//Show the error message
	if(alertStr.length > 0){
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, alertStr, true));
		return false;
	}else{
		$('.formHeader').find('.formTabErrorIco').css('display', 'none');
		formatDate(valuationDate,$('#valuationDate'));
	}
	return true;
}