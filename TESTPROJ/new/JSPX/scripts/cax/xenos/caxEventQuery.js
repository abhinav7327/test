//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $


 xenos.ns.views.caxEventQuery.validateSubmit = function(){
	var alertStr = [];
	
	var exDateFromString = $('#exDateFromStr').val();
	var exDateToString = $('#exDateToStr').val();
	
	var recordDateFromSting = $('#recordDateFromStr').val();
	var recordDateToString = $('#recordDateToStr').val();
	
	var paymentDateTakeUpFromString = $('#paymentDateTakeUpFromStr').val();
	var paymentDateTakeUpToString = $('#paymentDateTakeUpToStr').val();
	
	var processStartDateFromString = $('#processStartDateFromStr').val();
	var processStartDateToString = $('#processStartDateToStr').val();
	
	var paymentDateFromString = $('#paymentDateFromStr').val();
	var paymentDateToString = $('#paymentDateToStr').val();
	
	var processEndDateFromString = $('#processEndDateFromStr').val();
	var processEndDateToString = $('#processEndDateToStr').val();
	
	var dueBillEndDateFromString = $('#dueBillEndDateFromStr').val();
	var dueBillEndDateToString = $('#dueBillEndDateToStr').val();
	
	var entryDateFromString = $('#entryDateFromStr').val();
	var entryDateToString = $('#entryDateToStr').val();
	
	var lastEntryDateFromString = $('#lastEntryDateFromStr').val();
	var lastEntryDateToString = $('#lastEntryDateToStr').val();
	
	var dateFormatValidationFails = false;
	
	//this block will validate if date is given as per enterprise default or not
	
	if(dateFormatValidationFails==false && exDateFromString.length>0 && isDateCustom(exDateFromString)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.caxEventQuery.date_format_check + exDateFromString);
	}
	
	if(dateFormatValidationFails==false && exDateToString.length>0 && isDateCustom(exDateToString)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.caxEventQuery.date_format_check + exDateToString);
	}
	
	
	if(dateFormatValidationFails==false && recordDateFromSting.length>0 && isDateCustom(recordDateFromSting)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.caxEventQuery.date_format_check + recordDateFromSting);
	}
	
	if(dateFormatValidationFails==false && recordDateToString.length>0 && isDateCustom(recordDateToString)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.caxEventQuery.date_format_check + recordDateToString);
	}
	
	if(dateFormatValidationFails==false && paymentDateTakeUpFromString.length>0 && isDateCustom(paymentDateTakeUpFromString)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.caxEventQuery.date_format_check + paymentDateTakeUpFromString);
	}
	
	if(dateFormatValidationFails==false && paymentDateTakeUpToString.length>0 && isDateCustom(paymentDateTakeUpToString)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.caxEventQuery.date_format_check + paymentDateTakeUpToString);
	}
	
	if(dateFormatValidationFails==false && processStartDateFromString.length>0 && isDateCustom(processStartDateFromString)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.caxEventQuery.date_format_check + processStartDateFromString);
	}
	
	if(dateFormatValidationFails==false && processStartDateToString.length>0 && isDateCustom(processStartDateToString)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.caxEventQuery.date_format_check + processStartDateToString);
	}
	
	if(dateFormatValidationFails==false && paymentDateFromString.length>0 && isDateCustom(paymentDateFromString)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.caxEventQuery.date_format_check + paymentDateFromString);
	}
	
	if(dateFormatValidationFails==false && paymentDateToString.length>0 && isDateCustom(paymentDateToString)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.caxEventQuery.date_format_check + paymentDateToString);
	}
	
	if(dateFormatValidationFails==false && processEndDateFromString.length>0 && isDateCustom(processEndDateFromString)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.caxEventQuery.date_format_check + processEndDateFromString);
	}
	
	if(dateFormatValidationFails==false && processEndDateToString.length>0 && isDateCustom(processEndDateToString)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.caxEventQuery.date_format_check + processEndDateToString);
	}
	
	if(dateFormatValidationFails==false && dueBillEndDateFromString.length>0 && isDateCustom(dueBillEndDateFromString)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.caxEventQuery.date_format_check + dueBillEndDateFromString);
	}
	
	if(dateFormatValidationFails==false && dueBillEndDateToString.length>0 && isDateCustom(dueBillEndDateToString)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.caxEventQuery.date_format_check + dueBillEndDateToString);
	}
	
	if(dateFormatValidationFails==false && entryDateFromString.length>0 && isDateCustom(entryDateFromString)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.caxEventQuery.date_format_check + entryDateFromString);
	}
	
	if(dateFormatValidationFails==false && entryDateToString.length>0 && isDateCustom(entryDateToString)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.caxEventQuery.date_format_check + entryDateToString);
	}
	
	if(dateFormatValidationFails==false && lastEntryDateFromString.length>0 && isDateCustom(lastEntryDateFromString)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.caxEventQuery.date_format_check + lastEntryDateFromString);
	}
	
	if(dateFormatValidationFails==false && lastEntryDateToString.length>0 && isDateCustom(lastEntryDateToString)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.caxEventQuery.date_format_check + lastEntryDateToString);
	}
	
	
	if(dateFormatValidationFails==false){
	
		if(xenos.ns.views.caxEventQuery.isValidText(exDateFromString) && xenos.ns.views.caxEventQuery.isValidText(exDateToString)){
			// Validate EX Date From - To
			if (!isValidDateRange(exDateFromString,exDateToString)) {
				alertStr.push(xenos$CAX$i18n.caxEventQuery.date_from_to_check);
			}
		}
		
		if(xenos.ns.views.caxEventQuery.isValidText(recordDateFromSting) && xenos.ns.views.caxEventQuery.isValidText(recordDateToString)){
			// Validate Record Date From - To
			if (!isValidDateRange(recordDateFromSting,recordDateToString)) {
				alertStr.push(xenos$CAX$i18n.caxEventQuery.date_from_to_check);
			}
		}
		
		if(xenos.ns.views.caxEventQuery.isValidText(paymentDateTakeUpFromString) && xenos.ns.views.caxEventQuery.isValidText(paymentDateTakeUpToString)){
			// Validate payment Date TakeUp From - To
			if (!isValidDateRange(paymentDateTakeUpFromString,paymentDateTakeUpToString)) {
				alertStr.push(xenos$CAX$i18n.caxEventQuery.date_from_to_check);
			}
		}
		
		if(xenos.ns.views.caxEventQuery.isValidText(processStartDateFromString) && xenos.ns.views.caxEventQuery.isValidText(processStartDateToString)){
			// Validate Process start Date From - To
			if (!isValidDateRange(processStartDateFromString,processStartDateToString)) {
				alertStr.push(xenos$CAX$i18n.caxEventQuery.date_from_to_check);
			}
		}
		
				
		if(xenos.ns.views.caxEventQuery.isValidText(paymentDateFromString) && xenos.ns.views.caxEventQuery.isValidText(paymentDateToString)){
			// Validate Payment Date From - To
			if (!isValidDateRange(paymentDateFromString,paymentDateToString)) {
				alertStr.push(xenos$CAX$i18n.caxEventQuery.date_from_to_check);
			}
		}
		
		if(xenos.ns.views.caxEventQuery.isValidText(processEndDateFromString) && xenos.ns.views.caxEventQuery.isValidText(processEndDateToString)){
			// Validate process end  Date From - To
			if (!isValidDateRange(processEndDateFromString,processEndDateToString)) {
				alertStr.push(xenos$CAX$i18n.caxEventQuery.date_from_to_check);
			}
		}
		
		if(xenos.ns.views.caxEventQuery.isValidText(dueBillEndDateFromString) && xenos.ns.views.caxEventQuery.isValidText(dueBillEndDateToString)){
			// Validate dule bill end date From - To
			if (!isValidDateRange(dueBillEndDateFromString,dueBillEndDateToString)) {
				alertStr.push(xenos$CAX$i18n.caxEventQuery.date_from_to_check);
			}
		}
		
		if(xenos.ns.views.caxEventQuery.isValidText(entryDateFromString) && xenos.ns.views.caxEventQuery.isValidText(entryDateToString)){
			// Validate Entry Date From - To
			if (!isValidDateRange(entryDateFromString,entryDateToString)) {
				alertStr.push(xenos$CAX$i18n.caxEventQuery.date_from_to_check);
			}
		}
		
		if(xenos.ns.views.caxEventQuery.isValidText(lastEntryDateFromString) && xenos.ns.views.caxEventQuery.isValidText(lastEntryDateToString)){
			// Validate Last Entry Date From - To
			if (!isValidDateRange(lastEntryDateFromString,lastEntryDateToString)) {
				alertStr.push(xenos$CAX$i18n.caxEventQuery.date_from_to_check);
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
 
 
 xenos.ns.views.caxEventQuery.isValidText = function(text){
	if(text!='undefined' && text!=null && $.trim(text).length > 0){
		return true;
	}
	return false;
 }
