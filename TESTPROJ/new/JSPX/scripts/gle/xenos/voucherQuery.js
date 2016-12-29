//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos.ns.views.gleVoucherQuery.validateSubmit = function(){
	var alertStr = [];
	var transactionDate = $.trim($('#transactionDate').val());
	var bookDate = $.trim($('#bookDate').val());
	var appiDateFrom = $.trim($('#appiDateFrom').val());
	var appiDateTo = $.trim($('#appiDateTo').val());
	var updateDateFrom = $.trim($('#updateDateFrom').val());
	var updateDateTo = $.trim($('#updateDateTo').val());
	
	var dateFormatValidationFails = false;
	var dateRangeValidationFails = false;
	
	if(isDateCustom(transactionDate)==false && transactionDate.length>0) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$GLE$i18n.voucher.query.invalid_transaction_date);
	}
	
	if(dateFormatValidationFails==false && bookDate.length>0 && isDateCustom(bookDate)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$GLE$i18n.voucher.query.invalid_book_date);
	}
	
	if(dateFormatValidationFails==false && appiDateFrom.length>0 && isDateCustom(appiDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$GLE$i18n.voucher.query.date_format_check + appiDateFrom);
	}
	
	if(dateFormatValidationFails==false && appiDateTo.length>0 && isDateCustom(appiDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$GLE$i18n.voucher.query.date_format_check + appiDateTo);
	}
	
	if(dateFormatValidationFails==false && updateDateFrom.length>0 && isDateCustom(updateDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$GLE$i18n.voucher.query.date_format_check + updateDateFrom);
	}
	
	if(dateFormatValidationFails==false && updateDateTo.length>0 && isDateCustom(updateDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$GLE$i18n.voucher.query.date_format_check + updateDateTo);
	}

	if(dateFormatValidationFails==false) {
		// Validate Entry Date From - To
		if(!isValidDateRange(appiDateFrom, appiDateTo)){
			dateRangeValidationFails = true;
		}
		// Validate Update Date From - To
		if(dateRangeValidationFails == false && !isValidDateRange(updateDateFrom, updateDateTo)){
			dateRangeValidationFails = true;
		}
		if(dateRangeValidationFails) {
			alertStr.push(xenos$GLE$i18n.voucher.query.date_from_to_check);
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
		formatDate(transactionDate,$('#transactionDate'));
		formatDate(bookDate,$('#bookDate'));
		formatDate(appiDateFrom,$('#appiDateFrom'));
		formatDate(appiDateTo,$('#appiDateTo'));
		formatDate(updateDateFrom,$('#updateDateFrom'));
		formatDate(updateDateTo,$('#updateDateTo'));
	}
	return true;
}
	