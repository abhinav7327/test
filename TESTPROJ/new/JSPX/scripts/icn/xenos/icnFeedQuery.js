//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos.ns.views.icnFeedQuery.validateSubmit = function(){
	
	var alertStr = [];	
	
	var applicationDate  = $('#applicationDate').val();
	
	var dateFormatValidationFails = false;
	
	if(dateFormatValidationFails==false && applicationDate.length > 0 && isDateCustom(applicationDate)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$ICN$i18n.icnFeedQuery.date_format_check, [applicationDate]));
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

xenos.ns.views.icnFeedQuery.formatDate = function(date,id){
	if(date.length == 7){
		id.val(date.substr(0,6)+"0"+date.substr(6));
	}
}