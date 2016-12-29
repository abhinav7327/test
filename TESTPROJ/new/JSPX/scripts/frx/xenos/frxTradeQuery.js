//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $




 xenos.ns.views.frxTradeQuery.validateSubmit = function(){
	var alertStr = [];
	
	var tradeDateFromStr = $('#tradeDateFrom').val();
	var tradeDateToStr = $('#tradeDateTo').val();
	var valueDateFromStr = $('#valueDateFrom').val();
	var valueDateToStr = $('#valueDateTo').val();
	var appRegiDateFromStr = $('#appRegiDateFrom').val();
	var appRegiDateToStr = $('#appRegiDateTo').val();
	var appUpdDateFromStr = $('#appUpdDateFrom').val();
	var appUpdDateToStr = $('#appUpdDateTo').val();
	
	var dateFormatValidationFails = false;
	
	if(dateFormatValidationFails==false && tradeDateFromStr.length>0 && isDateCustom(tradeDateFromStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxTradeQuery.date_format_check , [tradeDateFromStr]));
	}
	
	if(dateFormatValidationFails==false && tradeDateToStr.length>0 && isDateCustom(tradeDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxTradeQuery.date_format_check , [tradeDateToStr]));
	}
	
	if(dateFormatValidationFails==false && valueDateFromStr.length>0 && isDateCustom(valueDateFromStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxTradeQuery.date_format_check , [valueDateFromStr]));
	}
	
	if(dateFormatValidationFails==false && valueDateToStr.length>0 && isDateCustom(valueDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxTradeQuery.date_format_check , [valueDateToStr]));
	}
	
	if(dateFormatValidationFails==false && appRegiDateFromStr.length>0 && isDateCustom(appRegiDateFromStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxTradeQuery.date_format_check , [appRegiDateFromStr]));
	}
	
	if(dateFormatValidationFails==false && appRegiDateToStr.length>0 && isDateCustom(appRegiDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxTradeQuery.date_format_check , [appRegiDateToStr]));
	}
	
	if(dateFormatValidationFails==false && appUpdDateFromStr.length>0 && isDateCustom(appUpdDateFromStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxTradeQuery.date_format_check , [appUpdDateFromStr]));
	}
	
	if(dateFormatValidationFails==false && appUpdDateToStr.length>0 && isDateCustom(appUpdDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxTradeQuery.date_format_check , [appUpdDateToStr]));
	}
	
	if(dateFormatValidationFails==false){
	
		if(xenos.ns.views.frxTradeQuery.isValidText(tradeDateFromStr) && xenos.ns.views.frxTradeQuery.isValidText(tradeDateToStr)){
			// Validate Trade Date From - To
			if (!isValidDateRange(tradeDateFromStr,tradeDateToStr)) {
				alertStr.push(xenos$FRX$i18n.frxTradeQuery.date_from_to_check);
			}
		}
		
		if(xenos.ns.views.frxTradeQuery.isValidText(valueDateFromStr) && xenos.ns.views.frxTradeQuery.isValidText(valueDateToStr)){
			// Validate Value Date From - To
			if (!isValidDateRange(valueDateFromStr,valueDateToStr)) {
				alertStr.push(xenos$FRX$i18n.frxTradeQuery.date_from_to_check);
			}
		}
		
		if(xenos.ns.views.frxTradeQuery.isValidText(appRegiDateFromStr) && xenos.ns.views.frxTradeQuery.isValidText(appRegiDateToStr)){
			// Validate Creation Date From - To
			if (!isValidDateRange(appRegiDateFromStr,appRegiDateToStr)) {
				alertStr.push(xenos$FRX$i18n.frxTradeQuery.date_from_to_check);
			}
		}
		
		if(xenos.ns.views.frxTradeQuery.isValidText(appUpdDateFromStr) && xenos.ns.views.frxTradeQuery.isValidText(appUpdDateToStr)){
			// Validate Update Date From - To
			if (!isValidDateRange(appUpdDateFromStr,appUpdDateToStr)) {
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
 
 
xenos.ns.views.frxTradeQuery.isValidText = function(text){
	if(text!='undefined' && text!=null && $.trim(text).length > 0){
		return true;
	}
	return false;
}

xenos.ns.views.frxTradeQuery.formatCustomDate = function(date){
	if(date.value.length == 7){
		if(date.id=="tradeDateFrom"){
			$("#tradeDateFrom").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		
		if(date.id=="tradeDateTo"){
			$("#tradeDateTo").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		
		if(date.id=="valueDateFrom"){
			$("#valueDateFrom").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		
		if(date.id=="valueDateTo"){
			$("#valueDateTo").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		
		if(date.id=="appUpdDateFrom"){
			$("#appUpdDateFrom").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		
		if(date.id=="appUpdDateTo"){
			$("#appUpdDateTo").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		
		if(date.id=="appRegiDateFrom"){
			$("#appRegiDateFrom").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		
		if(date.id=="appRegiDateTo"){
			$("#appRegiDateTo").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
	}
}
