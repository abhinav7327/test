//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $




 xenos.ns.views.trdQuery.validateSubmit = function(){
	var alertStr = [];	
	
	var tradeDateFrom  = $('#tradeDateFrom').val();
	var tradeDateTo    = $('#tradeDateTo').val();
	var valueDateFrom  = $('#valueDateFrom').val();
	var valueDateTo    = $('#valueDateTo').val();
	var entryDateFrom  = $('#entryDateFrom').val();
	var entryDateTo    = $('#entryDateTo').val();
	var updateDateFrom = $('#updateDateFrom').val();
	var updateDateTo   = $('#updateDateTo').val();
	
	
	var dateFormatValidationFails = false;
	
	if(dateFormatValidationFails==false && tradeDateFrom.length > 0 && isDateCustom(tradeDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeQuery.date_format_check, [tradeDateFrom]));
	}
	
	if(dateFormatValidationFails==false && tradeDateTo.length > 0 && isDateCustom(tradeDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeQuery.date_format_check, [tradeDateTo]));
	}
	
	if(dateFormatValidationFails==false && valueDateFrom.length>0 && isDateCustom(valueDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeQuery.date_format_check, [valueDateFrom]));
	}
	
	if(dateFormatValidationFails==false && valueDateTo.length>0 && isDateCustom(valueDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeQuery.date_format_check, [valueDateTo]));
	}
	
	if(dateFormatValidationFails==false && entryDateFrom.length > 0 && isDateCustom(entryDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeQuery.date_format_check, [entryDateFrom]));
	}
	
	if(dateFormatValidationFails==false && entryDateTo.length > 0 && isDateCustom(entryDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeQuery.date_format_check, [entryDateTo]));
	}
	
	if(dateFormatValidationFails==false && updateDateFrom.length>0 && isDateCustom(updateDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeQuery.date_format_check, [updateDateFrom]));
	}
	
	if(dateFormatValidationFails==false && updateDateTo.length>0 && isDateCustom(updateDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeQuery.date_format_check, [updateDateTo]));
	}
	
	if(dateFormatValidationFails==false){
	
		if(xenos.ns.views.trdQuery.isValidText(tradeDateFrom) && xenos.ns.views.trdQuery.isValidText(tradeDateTo)) {
			// Validate Trade Date From - To
			if (!isValidDateRange(tradeDateFrom, tradeDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(xenos.ns.views.trdQuery.isValidText(valueDateFrom) && xenos.ns.views.trdQuery.isValidText(valueDateTo)) {
			// Validate Value Date From - To
			if (!isValidDateRange(valueDateFrom, valueDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(xenos.ns.views.trdQuery.isValidText(entryDateFrom) && xenos.ns.views.trdQuery.isValidText(entryDateTo)) {
			// Validate Entry Date From - To
			if (!isValidDateRange(entryDateFrom, entryDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(xenos.ns.views.trdQuery.isValidText(updateDateFrom) && xenos.ns.views.trdQuery.isValidText(updateDateTo)) {
			// Validate LAst Entry Date From - To
			if (!isValidDateRange(updateDateFrom, updateDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		if(dateFormatValidationFails) {
			alertStr.push(xenos$TRD$i18n.tradeQuery.date_from_to_check);
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

 xenos.ns.views.trdQuery.formatDateValues = function(date,id){
		if(date.length == 7){
			id.val(date.substr(0,6)+"0"+date.substr(6));
		}
 }
 
 xenos.ns.views.trdQuery.isValidText = function (text){
	if(text!='undefined' && text!=null && $.trim(text).length > 0){
		return true;
	}
	return false;
 }