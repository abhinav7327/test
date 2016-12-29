//$Id$
//$Author: Saravanan $
//$Date: 2016-12-24 15:37:59 $

xenos.ns.views.namFundConfigQuery.validateSubmit = function(){
	var alertStr = [];	
	
	var openDateFrom  = $('#openDateFrom').val(); 
	var openDateTo    = $('#openDateTo').val(); 
	var closeDateFrom    = $('#closeDateFrom').val(); 
	var closeDateTo    = $('#closeDateTo').val(); 
	var entryDateFrom    = $('#entryDateFrom').val(); 
	var entryDateTo    = $('#entryDateTo').val(); 
	var lastEntryDateFrom    = $('#lastEntryDateFrom').val(); 
	var lastEntryDateTo    = $('#lastEntryDateTo').val();
 
	
	var dateFormatValidationFails = false;
	
	if(dateFormatValidationFails==false && openDateFrom.length > 0 && isDateCustom(openDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$NAM$i18n.fundConfigQuery.date_format_check, [openDateFrom]));
	}
	if(!dateFormatValidationFails){	
		xenos.ns.views.namFundConfigQuery.formatDate(openDateFrom,$('#openDateFrom'));
	}
	
	if(dateFormatValidationFails==false && openDateTo.length > 0 && isDateCustom(openDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$NAM$i18n.fundConfigQuery.date_format_check, [openDateTo]));
	}
	if(!dateFormatValidationFails){	
		xenos.ns.views.namFundConfigQuery.formatDate(openDateTo,$('#openDateTo'));
	}
	
	if(dateFormatValidationFails==false && closeDateFrom.length>0 && isDateCustom(closeDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$NAM$i18n.fundConfigQuery.date_format_check, [closeDateFrom]));
	}
	if(!dateFormatValidationFails){	
		xenos.ns.views.namFundConfigQuery.formatDate(closeDateFrom,$('#closeDateFrom'));
	}
	
	if(dateFormatValidationFails==false && closeDateTo.length>0 && isDateCustom(closeDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$NAM$i18n.fundConfigQuery.date_format_check, [closeDateTo]));
	}
	if(!dateFormatValidationFails){	
		xenos.ns.views.namFundConfigQuery.formatDate(closeDateTo,$('#closeDateTo'));
	}
	
	if(dateFormatValidationFails==false && entryDateFrom.length > 0 && isDateCustom(entryDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$NAM$i18n.fundConfigQuery.date_format_check, [entryDateFrom]));
	}
	if(!dateFormatValidationFails){	
		xenos.ns.views.namFundConfigQuery.formatDate(entryDateFrom,$('#entryDateFrom'));
	}
	
	if(dateFormatValidationFails==false && entryDateTo.length > 0 && isDateCustom(entryDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$NAM$i18n.fundConfigQuery.date_format_check, [entryDateTo]));
	}
	if(!dateFormatValidationFails){	
		xenos.ns.views.namFundConfigQuery.formatDate(entryDateTo,$('#entryDateTo'));
	}
	
	if(dateFormatValidationFails==false && lastEntryDateFrom.length>0 && isDateCustom(lastEntryDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$NAM$i18n.fundConfigQuery.date_format_check, [lastEntryDateFrom]));
	}
	if(!dateFormatValidationFails){	
		xenos.ns.views.namFundConfigQuery.formatDate(lastEntryDateFrom,$('#lastEntryDateFrom'));
	}
	
	if(dateFormatValidationFails==false && lastEntryDateTo.length>0 && isDateCustom(lastEntryDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$NAM$i18n.fundConfigQuery.date_format_check, [lastEntryDateTo]));
	}
	if(!dateFormatValidationFails){	
		xenos.ns.views.namFundConfigQuery.formatDate(lastEntryDateTo,$('#lastEntryDateTo'));
	}
	
	if(dateFormatValidationFails==false){
	
		if(namFundConfigQueryisValidText(openDateFrom) && namFundConfigQueryisValidText(openDateTo)) {
			// Validate Open Date From - To
			if (!isValidDateRange(openDateFrom, openDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(namFundConfigQueryisValidText(closeDateFrom) && namFundConfigQueryisValidText(closeDateTo)) {
			// Validate Close Date From - To
			if (!isValidDateRange(closeDateFrom, closeDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(namFundConfigQueryisValidText(entryDateFrom) && namFundConfigQueryisValidText(entryDateTo)) {
			// Validate Entry Date From - To
			if (!isValidDateRange(entryDateFrom, entryDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(namFundConfigQueryisValidText(lastEntryDateFrom) && namFundConfigQueryisValidText(lastEntryDateTo)) {
			// Validate Last Entry Date From - To
			if (!isValidDateRange(lastEntryDateFrom, lastEntryDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		if(dateFormatValidationFails) {
			alertStr.push(xenos$NAM$i18n.fundConfigQuery.date_from_to_check);
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
 
function namFundConfigQueryisValidText(text) {
	if(text!='undefined' && text!=null && $.trim(text).length > 0){
		return true;
	}
	return false;
}
 
xenos.ns.views.namFundConfigQuery.formatDate = function (date,id){
	if(date.length == 7){
		id.val(date.substr(0,6)+"0"+date.substr(6));
	}
}