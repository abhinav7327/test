//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
 xenos.ns.views.secQuery.validateSubmit = function(){
	 
	var alertStr = [];
	var secDateFrom = $('#dateFrom').val();
	var secDateTo = $('#dateTo').val();
	var entDateFrom = $('#entDateFrom').val();
	var entDateTo = $('#entDateTo').val();
	var updateDateFrom = $('#updateDateFrom').val();
	var updateDateTo = $('#updateDateTo').val();
	var dateFormatValidationFails = false;
	var dateRangeValidationFails = false;

	if(secDateFrom.length==0 || secDateTo.length==0) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAM$i18n.securityQuery.daterange_empty);
	}
	
	if(dateFormatValidationFails==false && secDateFrom.length>0 && isDateCustom(secDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$CAM$i18n.securityQuery.date_format_check, [secDateFrom]));
	}
	
	if(dateFormatValidationFails==false && secDateTo.length>0 && isDateCustom(secDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$CAM$i18n.securityQuery.date_format_check, [secDateTo]));
	}
	
	if(dateFormatValidationFails==false && entDateFrom.length>0 && isDateCustom(entDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$CAM$i18n.securityQuery.date_format_check, [entDateFrom]));
	}
	
	if(dateFormatValidationFails==false && entDateTo.length>0 && isDateCustom(entDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$CAM$i18n.securityQuery.date_format_check, [entDateTo]));
	}
	
	if(dateFormatValidationFails==false && updateDateFrom.length>0 && isDateCustom(updateDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$CAM$i18n.securityQuery.date_format_check, [updateDateFrom]));
	}
	
	if(dateFormatValidationFails==false && updateDateTo.length>0 && isDateCustom(updateDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$CAM$i18n.securityQuery.date_format_check, [updateDateTo]));
	}

	if(dateFormatValidationFails==false) {
		
		if(!isValidDateRange(secDateFrom, secDateTo)){
			dateRangeValidationFails = true;
		}
		
		if(dateRangeValidationFails == false && !isValidDateRange(entDateFrom, entDateTo)){
			dateRangeValidationFails = true;
		}
		
		if(dateRangeValidationFails == false && !isValidDateRange(updateDateFrom, updateDateTo)){
			dateRangeValidationFails = true;
		}
		
		if(dateRangeValidationFails) {
			alertStr.push(xenos$CAM$i18n.securityQuery.date_from_to_check);
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