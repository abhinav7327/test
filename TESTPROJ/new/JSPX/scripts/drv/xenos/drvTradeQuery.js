//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
 xenos.ns.views.drvTradeQuery.validateSubmit = function(){

	var alertStr = [];
	var tradeDateFrom = $('#trdDateFrom').val();
	var tradeDateTo = $('#trdDateTo').val();
	var valueDateFrom = $('#valueDateFrom').val();
	var valueDateTo = $('#valueDateTo').val();
	var dateFormatValidationFails = false;
	var dateRangeValidationFails = false;
	
	if(isDateCustom(tradeDateFrom)==false && tradeDateFrom.length>0) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$DRV$i18n.derivativeTrade.query.date_format_check_trdDateFrom);
	}
	
	if(dateFormatValidationFails==false && tradeDateTo.length>0 && isDateCustom(tradeDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$DRV$i18n.derivativeTrade.query.date_format_check_trdDateTo);
	}
	
	if(dateFormatValidationFails==false && valueDateFrom.length>0 && isDateCustom(valueDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$DRV$i18n.derivativeTrade.query.date_format_check_valueDateFrom);
	}
	
	if(dateFormatValidationFails==false && valueDateTo.length>0 && isDateCustom(valueDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$DRV$i18n.derivativeTrade.query.date_format_check_valueDateTo);
	}

	if(dateFormatValidationFails==false) {
		// Validate Trade Date From - To
		if(!isValidDateRange(tradeDateFrom, tradeDateTo)){
			dateRangeValidationFails = true;
			alertStr.push(xenos$DRV$i18n.derivativeTrade.query.date_from_to_check_trade);
		}
		// Validate Value Date From - To
		if(dateRangeValidationFails == false && !isValidDateRange(valueDateFrom, valueDateTo)){
			dateRangeValidationFails = true;
			alertStr.push(xenos$DRV$i18n.derivativeTrade.query.date_from_to_check_value);
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