//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos.ns.views.txnReportQuery.validateSubmit = function(){
				var alertStr = [];
				var fundCode = $.trim($('#fundCode').val());
				var tradeDateFromStr = $.trim($('#dateForm').val());
				var tradeDateToStr = $.trim($('#dateTo').val());
					
				var dateFormatValidationFails = false;
	
	//check empty fields			
	if(VALIDATOR.isNullValue(fundCode)){
	alertStr.push(xenos$TRD$i18n.txnReportQuery.fund_code_check);
	}
	
		//date format validation [YYYYMMDD]
	if(dateFormatValidationFails==false && tradeDateFromStr.length>0 && isDateCustom(tradeDateFromStr)==false) {
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.txnReportQuery.date_format_check, [tradeDateFromStr]));
	}
	
	if(dateFormatValidationFails==false && tradeDateToStr.length>0 && isDateCustom(tradeDateToStr)==false) {
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.txnReportQuery.date_format_check, [tradeDateToStr]));
	}
	
	//date range validation	
	if(dateFormatValidationFails==false){
		if(isValidText(tradeDateFromStr) && isValidText(tradeDateToStr)){
			if (!isValidDateRange(tradeDateFromStr,tradeDateToStr)) {
				alertStr.push(xenos$TRD$i18n.txnReportQuery.date_from_to_check);
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
 
  function isValidText(text){
	if(text!='undefined' && text!=null && $.trim(text).length > 0){
		return true;
	}
	return false;
 }
 
 
  xenos.ns.views.txnReportQuery.formatDate = function formatCnfDate(date,id){
	if(date.length == 7){
		id.val(date.substr(0,6)+"0"+date.substr(6));
	}
 }