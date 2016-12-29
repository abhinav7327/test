//$Id$
//$Author: projand $
//$Date: 2016-12-23 17:26:39 $


 xenos.ns.views.ndfExchangeRateQuery.validateSubmit = function(){
	var alertStr = [];
	
	var baseDateFromStr = $('#baseDateFromStr').val();
	var baseDateToStr = $('#baseDateToStr').val();
	var entryDateFromStr = $('#entryDateFromStr').val();
	var entryDateToStr = $('#entryDateToStr').val();
	var updateDateFromStr = $('#updateDateFromStr').val();
	var updateDateToStr = $('#updateDateToStr').val();
	
	
	var dateFormatValidationFails = false;
	
	if(dateFormatValidationFails==false && baseDateFromStr.length>0 && isDateCustom(baseDateFromStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxTradeQuery.date_format_check , [baseDateFromStr]));
	}
	
	if(dateFormatValidationFails==false && baseDateToStr.length>0 && isDateCustom(baseDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxTradeQuery.date_format_check , [baseDateToStr]));
	}
	
	if(dateFormatValidationFails==false && entryDateFromStr.length>0 && isDateCustom(entryDateFromStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxTradeQuery.date_format_check , [entryDateFromStr]));
	}
	
	if(dateFormatValidationFails==false && entryDateToStr.length>0 && isDateCustom(entryDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxTradeQuery.date_format_check , [entryDateToStr]));
	}
	
	if(dateFormatValidationFails==false && updateDateFromStr.length>0 && isDateCustom(updateDateFromStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxTradeQuery.date_format_check , [updateDateFromStr]));
	}
	
	if(dateFormatValidationFails==false && updateDateToStr.length>0 && isDateCustom(updateDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxTradeQuery.date_format_check , [updateDateToStr]));
	}
	
	
	if(dateFormatValidationFails==false){
	
		if(xenos.ns.views.ndfExchangeRateQuery.isValidText(baseDateFromStr) &&  xenos.ns.views.ndfExchangeRateQuery.isValidText(baseDateToStr)){
			// Validate Trade Date From - To
			if (!isValidDateRange(baseDateFromStr,baseDateToStr)) {
				alertStr.push(xenos$FRX$i18n.frxTradeQuery.date_from_to_check);
			}
		}
		
		if(xenos.ns.views.ndfExchangeRateQuery.isValidText(entryDateFromStr) &&  xenos.ns.views.ndfExchangeRateQuery.isValidText(entryDateToStr)){
			// Validate Value Date From - To
			if (!isValidDateRange(entryDateFromStr,entryDateToStr)) {
				alertStr.push(xenos$FRX$i18n.frxTradeQuery.date_from_to_check);
			}
		}
		
		if(xenos.ns.views.ndfExchangeRateQuery.isValidText(updateDateFromStr) && xenos.ns.views.ndfExchangeRateQuery.isValidText(updateDateToStr)){
			// Validate Creation Date From - To
			if (!isValidDateRange(updateDateFromStr,updateDateToStr)) {
				alertStr.push(xenos$FRX$i18n.frxTradeQuery.date_from_to_check);
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
 
 xenos.ns.views.ndfExchangeRateQuery.formatDate = function(date,id){
		if(date.length == 7){
			id.val(date.substr(0,6)+"0"+date.substr(6));
		}
 } 
 
 xenos.ns.views.ndfExchangeRateQuery.isValidText = function(text){
	if(text!='undefined' && text!=null && $.trim(text).length > 0){
		return true;
	}
	return false;
 }
