//$Id$
//$Author: nehab $
//$Date: 2016-12-26 18:00:47 $
 xenos.ns.views.entitlementGenerationQuery.validateSubmit = function(){

	var alertStr = [];
	var exDateFrom = $('#exDateFromStr').val();
	var exDateTo = $('#exDateToStr').val();
	var recordDateFrom = $('#recordDateFromStr').val();
	var recordDateTo = $('#recordDateToStr').val();
	var paymentDateTakeUpFrom = $('#paymentDateTakeUpFromStr').val();
	var paymentDateTakeUpTo = $('#paymentDateTakeUpToStr').val();	
	var processStartDateFrom = $('#processStartDateFromStr').val();
	var processStartDateTo = $('#processStartDateToStr').val();
	var paymentDateFrom = $('#paymentDateFromStr').val();
	var paymentDateTo = $('#paymentDateToStr').val();
	var processEndDateFrom = $('#processEndDateFromStr').val();
	var processEndDateTo = $('#processEndDateToStr').val();
	var dueBillEndDateFrom = $('#dueBillEndDateFromStr').val();
	var dueBillEndDateTo = $('#dueBillEndDateToStr').val();
	var entryDateFrom = $('#entryDateFromStr').val();
	var entryDateTo = $('#entryDateToStr').val();
	var lastEntryDateFrom = $('#lastEntryDateFromStr').val();
	var lastEntryDateTo = $('#lastEntryDateToStr').val();
	
	
	var dateFormatValidationFails = false;
	var dateRangeValidationFails = false;
	
	if(isDateCustom(exDateFrom)==false && exDateFrom.length>0) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.entitlementGenerationTrade.query.date_format_check + exDateFrom);
	}
	
	if(dateFormatValidationFails==false && exDateTo.length>0 && isDateCustom(exDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.entitlementGenerationTrade.query.date_format_check + exDateTo);
	}
	
	if(dateFormatValidationFails==false && recordDateFrom.length>0 && isDateCustom(recordDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.entitlementGenerationTrade.query.date_format_check + recordDateFrom);
	}
	
	if(dateFormatValidationFails==false && recordDateTo.length>0 && isDateCustom(recordDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.entitlementGenerationTrade.query.date_format_check + recordDateTo);
	}
	
	if(dateFormatValidationFails==false && paymentDateTakeUpFrom.length>0 && isDateCustom(paymentDateTakeUpFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.entitlementGenerationTrade.query.date_format_check + paymentDateTakeUpFrom);
	}
	
	if(dateFormatValidationFails==false && processStartDateTo.length>0 && isDateCustom(processStartDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.entitlementGenerationTrade.query.date_format_check + processStartDateTo);
	}
	
	if(dateFormatValidationFails==false && paymentDateFrom.length>0 && isDateCustom(paymentDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.entitlementGenerationTrade.query.date_format_check + paymentDateFrom);
	}
	
	if(dateFormatValidationFails==false && paymentDateTo.length>0 && isDateCustom(paymentDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.entitlementGenerationTrade.query.date_format_check + paymentDateTo);
	}
	
	if(dateFormatValidationFails==false && processEndDateFrom.length>0 && isDateCustom(processEndDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.entitlementGenerationTrade.query.date_format_check + processEndDateFrom);
	}
	
	if(dateFormatValidationFails==false && processEndDateTo.length>0 && isDateCustom(processEndDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.entitlementGenerationTrade.query.date_format_check + processEndDateTo);
	}
	
	if(dateFormatValidationFails==false && dueBillEndDateFrom.length>0 && isDateCustom(dueBillEndDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.entitlementGenerationTrade.query.date_format_check + dueBillEndDateFrom);
	}
	
	if(dateFormatValidationFails==false && dueBillEndDateTo.length>0 && isDateCustom(dueBillEndDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.entitlementGenerationTrade.query.date_format_check + dueBillEndDateTo);
	}
	
	if(dateFormatValidationFails==false && entryDateFrom.length>0 && isDateCustom(entryDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.entitlementGenerationTrade.query.date_format_check + entryDateFrom);
	}
	
	if(dateFormatValidationFails==false && entryDateTo.length>0 && isDateCustom(entryDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.entitlementGenerationTrade.query.date_format_check + entryDateTo);
	}
	
	if(dateFormatValidationFails==false && lastEntryDateFrom.length>0 && isDateCustom(lastEntryDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.entitlementGenerationTrade.query.date_format_check + lastEntryDateFrom);
	}
	
	if(dateFormatValidationFails==false && lastEntryDateTo.length>0 && isDateCustom(lastEntryDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.entitlementGenerationTrade.query.date_format_check + lastEntryDateTo);
	}

	if(dateFormatValidationFails==false) {
		
		// Validate Ex Date From - To
		if(!isValidDateRange(exDateFrom, exDateTo)){
			dateRangeValidationFails = true;
		}
		
		// Validate Record Date From - To
		if(dateRangeValidationFails == false && !isValidDateRange(recordDateFrom, recordDateTo)){
			dateRangeValidationFails = true;
		}
		
		// Validate Payment Date Take Up Cost From - To
		if(dateRangeValidationFails == false && !isValidDateRange(paymentDateTakeUpFrom, paymentDateTakeUpTo)){
			dateRangeValidationFails = true;
		}
		
		// Validate Process Start Date From - To
		if(dateRangeValidationFails == false && !isValidDateRange(processStartDateFrom, processStartDateTo)){
			dateRangeValidationFails = true;
		}
		
		// Validate Payment Date From -To
		if(dateRangeValidationFails == false && !isValidDateRange(paymentDateFrom, paymentDateTo)){
			dateRangeValidationFails = true;
		}
		
		// Validate Process End Date From - To
		if(dateRangeValidationFails == false && !isValidDateRange(processEndDateFrom, processEndDateTo)){
			dateRangeValidationFails = true;
		}
		
		// Validate Due Bill End Date From - To
		if(dateRangeValidationFails == false && !isValidDateRange(dueBillEndDateFrom, dueBillEndDateTo)){
			dateRangeValidationFails = true;
		}
		
		// Validate Entry Date From - To
		if(dateRangeValidationFails == false && !isValidDateRange(entryDateFrom, entryDateTo)){
			dateRangeValidationFails = true;
		}
		
		// Validate Last Entry Date From - To
		if(dateRangeValidationFails == false && !isValidDateRange(lastEntryDateFrom, lastEntryDateTo)){
			dateRangeValidationFails = true;
		}
		
		if(dateRangeValidationFails) {
			alertStr.push(xenos$CAX$i18n.entitlementGenerationTrade.query.date_from_to_check);
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
		
		xenos.ns.views.entitlementGenerationQuery.formatDate($('#exDateFromStr'));
		xenos.ns.views.entitlementGenerationQuery.formatDate($('#exDateToStr'));
		
		xenos.ns.views.entitlementGenerationQuery.formatDate($('#recordDateFromStr'));
		xenos.ns.views.entitlementGenerationQuery.formatDate($('#recordDateToStr'));
		
		xenos.ns.views.entitlementGenerationQuery.formatDate($('#paymentDateTakeUpFromStr'));
		xenos.ns.views.entitlementGenerationQuery.formatDate($('#paymentDateTakeUpToStr'));
		
		xenos.ns.views.entitlementGenerationQuery.formatDate($('#paymentDateFromStr'));
		xenos.ns.views.entitlementGenerationQuery.formatDate($('#paymentDateToStr'));
		
		xenos.ns.views.entitlementGenerationQuery.formatDate($('#processStartDateFromStr'));
		xenos.ns.views.entitlementGenerationQuery.formatDate($('#processStartDateToStr'));
		
		xenos.ns.views.entitlementGenerationQuery.formatDate($('#processEndDateFromStr'));
		xenos.ns.views.entitlementGenerationQuery.formatDate($('#processEndDateToStr'));
		
		xenos.ns.views.entitlementGenerationQuery.formatDate($('#dueBillEndDateFromStr'));
		xenos.ns.views.entitlementGenerationQuery.formatDate($('#dueBillEndDateToStr'));
		
		xenos.ns.views.entitlementGenerationQuery.formatDate($('#entryDateFromStr'));
		xenos.ns.views.entitlementGenerationQuery.formatDate($('#entryDateToStr'));
		
		xenos.ns.views.entitlementGenerationQuery.formatDate($('#lastEntryDateFromStr'));
		xenos.ns.views.entitlementGenerationQuery.formatDate($('#lastEntryDateToStr'));		
	}
	return true;
}
 
 xenos.ns.views.entitlementGenerationQuery.formatDateOnchange = function(date) {
		var dateVal = date.value;
		if(checkDate(date)){	
			if(dateVal.length == 7){
				$("#" + date.id).val(dateVal.substr(0,6)+"0"+dateVal.substr(6));
				}
			}else{
			xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos$CAX$i18n.entitlementGenerationTrade.query.date_format_check + "" + date.value));
			}

		  }
	xenos.ns.views.entitlementGenerationQuery.formatDate = function(date) {
		var dateVal = date.val();
			if(dateVal.length == 7){
				$(date.selector).val(dateVal.substr(0,6)+"0"+dateVal.substr(6));
				}
		  }	   