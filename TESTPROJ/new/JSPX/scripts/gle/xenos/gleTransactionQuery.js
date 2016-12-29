//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos.ns.views.gleTranQry.validateSubmit = function(){

	var alertStr = [];
	var appregDateFrom = $.trim($('#appregDateFrom').val());
	var appregDateTo = $.trim($('#appregDateTo').val());
	var dateFormatValidationFails = false;
	var dateEmpty = false;
	function isBlank(str) {
		return ($.trim(str)=="");
	}
	if(isBlank(appregDateFrom) || isBlank(appregDateTo)){
		dateEmpty=true;
		alertStr.push(xenos$GLE$i18n.gleTransaction.query.entry_Date_empty);
		if(isBlank(appregDateFrom)){
			alertStr.push(xenos$GLE$i18n.gleTransaction.query.entry_fromDate_empty);
		}
		if(isBlank(appregDateTo)){
			 alertStr.push(xenos$GLE$i18n.gleTransaction.query.entry_toDate_empty);
		}
	}
	if(dateEmpty==false){
		if(!isBlank(appregDateFrom) && isDateCustom(appregDateFrom)==false && !isBlank(appregDateTo) && isDateCustom(appregDateTo)==false) {
			dateFormatValidationFails=true;
			alertStr.push(xenos$GLE$i18n.gleTransaction.query.date_format_check);
		}else{
			if(!isBlank(appregDateFrom) && isDateCustom(appregDateFrom)==false) {
				dateFormatValidationFails=true;
				alertStr.push(xenos$GLE$i18n.gleTransaction.query.date_format_check_from);
			}
			
			if(!isBlank(appregDateTo) && isDateCustom(appregDateTo)==false) {
				dateFormatValidationFails=true;
				alertStr.push(xenos$GLE$i18n.gleTransaction.query.date_format_check_to);
			}
		}
	}
	if(dateFormatValidationFails==false) {
		// Validate Entry Date From - To
		if(!isBlank(appregDateTo) && !isValidDateRange(appregDateFrom, appregDateTo)){
			alertStr.push(xenos$GLE$i18n.gleTransaction.query.date_from_to_check);
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
		xenos.ns.views.gleTranQry.formatDateFrom(appregDateFrom);
		xenos.ns.views.gleTranQry.formatDateTo(appregDateTo);
	}
	return true;
}
//function formatDateFrom(appregDateFrom){
xenos.ns.views.gleTranQry.formatDateFrom = function(appregDateFrom) {
		if(appregDateFrom.length == 7){
			$("#appregDateFrom").val(appregDateFrom.substr(0,6)+"0"+appregDateFrom.substr(6));
		}
	  }
	  
// function formatDateTo(appregDateTo){
xenos.ns.views.gleTranQry.formatDateTo = function(appregDateTo) {
		if(appregDateTo.length == 7){
			$("#appregDateTo").val(appregDateTo.substr(0,6)+"0"+appregDateTo.substr(6));
		}
	  }