//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos.ns.views.drvMarginQueryCriteria.validateSubmit = function(){
	var alertStr = [];
	var tradeDateFromStr = $('#tradeDateFrom').val();
	var tradeDateToStr = $('#tradeDateTo').val();
	
	var dateFormatValidationFails = false;
	
	if(dateFormatValidationFails==false && tradeDateFromStr.length>0 && isDateCustom(tradeDateFromStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$DRV$i18n.drvMarginQuery.fromdate_format_check , [tradeDateFromStr]));
	}
	
	if(dateFormatValidationFails==false && tradeDateToStr.length>0 && isDateCustom(tradeDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$DRV$i18n.drvMarginQuery.todate_format_check , [tradeDateToStr]));
	}
	
	if(dateFormatValidationFails==false){
	
		if(isValidText(tradeDateFromStr) && isValidText(tradeDateToStr)){
			// Validate Trade Date From - To
			if (!isValidDateRange(tradeDateFromStr,tradeDateToStr)) {
				alertStr.push(xenos$DRV$i18n.drvMarginQuery.date_from_to_check);
			}
		}
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
