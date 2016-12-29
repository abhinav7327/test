//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
 xenos.ns.views.bkgQuery.validateSubmit = function(){

	var alertStr = [];
	var tradeDateFrom = $('#tradeDateFrom').val();
	var tradeDateTo = $('#tradeDateTo').val();
	var startDateFrom = $('#startDateFrom').val();
	var startDateTo = $('#startDateTo').val();
	var maturityDateFrom = $('#maturityDateFrom').val();
	var maturityDateTo = $('#maturityDateTo').val();
	var dateFormatValidationFails = false;
	var dateRangeValidationFails = false;
	
	if(isDateCustom(tradeDateFrom)==false && tradeDateFrom.length>0) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$BKG$i18n.bankingTrade.query.date_format_check + tradeDateFrom);
	}
	
	if(dateFormatValidationFails==false && tradeDateTo.length>0 && isDateCustom(tradeDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$BKG$i18n.bankingTrade.query.date_format_check + tradeDateTo);
	}
	
	if(dateFormatValidationFails==false && startDateFrom.length>0 && isDateCustom(startDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$BKG$i18n.bankingTrade.query.date_format_check + startDateFrom);
	}
	
	if(dateFormatValidationFails==false && startDateTo.length>0 && isDateCustom(startDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$BKG$i18n.bankingTrade.query.date_format_check + startDateTo);
	}
	
	if(dateFormatValidationFails==false && maturityDateFrom.length>0 && isDateCustom(maturityDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$BKG$i18n.bankingTrade.query.date_format_check + maturityDateFrom);
	}
	
	if(dateFormatValidationFails==false && maturityDateTo.length>0 && isDateCustom(maturityDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$BKG$i18n.bankingTrade.query.date_format_check + maturityDateTo);
	}

	if(dateFormatValidationFails==false) {
		// Validate Trade Date From - To
		if(!isValidDateRange(tradeDateFrom, tradeDateTo)){
			dateRangeValidationFails = true;
		}
		// Validate Start Date From - To
		if(dateRangeValidationFails == false && !isValidDateRange(startDateFrom, startDateTo)){
			dateRangeValidationFails = true;
		}
		// Validate Maturity Date From - To
		if(dateRangeValidationFails == false && !isValidDateRange(maturityDateFrom, maturityDateTo)){
			dateRangeValidationFails = true;
		}
		
		// Validate Trade Date From - Start Date From
		if(dateRangeValidationFails == false && !isValidDateRange(tradeDateFrom, startDateFrom)){
			dateRangeValidationFails = true;
		}
		// Validate Trade Date From - Start Date To
		if(dateRangeValidationFails == false && !isValidDateRange(tradeDateFrom, startDateTo)){
			dateRangeValidationFails = true;
		}
		// Validate Trade Date From - Maturity Date From
		if(dateRangeValidationFails == false && !isValidDateRange(tradeDateFrom, maturityDateFrom)){
			dateRangeValidationFails = true;
		}
		// Validate Trade Date From - Maturity Date To
		if(dateRangeValidationFails == false && !isValidDateRange(tradeDateFrom, maturityDateTo)){
			dateRangeValidationFails = true;
		}
		
		// Validate Trade Date To - Start Date From
		if(dateRangeValidationFails == false && !isValidDateRange(tradeDateTo, startDateFrom)){
			dateRangeValidationFails = true;
		}
		// Validate Trade Date To - Start Date To
		if(dateRangeValidationFails == false && !isValidDateRange(tradeDateTo, startDateTo)){
			dateRangeValidationFails = true;
		}
		// Validate Trade Date To - Maturity Date From
		if(dateRangeValidationFails == false && !isValidDateRange(tradeDateTo, maturityDateFrom)){
			dateRangeValidationFails = true;
		}
		// Validate Trade Date To - Maturity Date To
		if(dateRangeValidationFails == false && !isValidDateRange(tradeDateTo, maturityDateTo)){
			dateRangeValidationFails = true;
		}
		
		// Validate Start Date From - Maturity Date From
		if(dateRangeValidationFails == false && !isValidDateRange(startDateFrom, maturityDateFrom)){
			dateRangeValidationFails = true;
		}
		// Validate Start Date From - Maturity Date To
		if(dateRangeValidationFails == false && !isValidDateRange(startDateFrom, maturityDateTo)){
			dateRangeValidationFails = true;
		}
		
		// Validate Start Date To - Maturity Date From
		if(dateRangeValidationFails == false && !isValidDateRange(startDateTo, maturityDateFrom)){
			dateRangeValidationFails = true;
		}
		// Validate Start Date To - Maturity Date To
		if(dateRangeValidationFails == false && !isValidDateRange(startDateTo, maturityDateTo)){
			dateRangeValidationFails = true;
		}
		
		if(dateRangeValidationFails) {
			alertStr.push(xenos$BKG$i18n.bankingTrade.query.date_from_to_check);
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
		formatDate(tradeDateFrom,$('#tradeDateFrom'));
		formatDate(tradeDateTo,$('#tradeDateTo'));
		formatDate(startDateFrom,$('#startDateFrom'));
		formatDate(startDateTo,$('#startDateTo'));
		formatDate(maturityDateFrom,$('#maturityDateFrom'));
		formatDate(maturityDateTo,$('#maturityDateTo'));
	}
	return true;
}