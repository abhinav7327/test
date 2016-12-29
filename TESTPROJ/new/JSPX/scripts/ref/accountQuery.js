//$Id$
//$Author: dheerajk $
//$Date: 2016-12-24 13:39:18 $
xenos.ns.views.accountQuery.validateSubmit = function(){
	
	var alertStr = [];
	var accountOpenDateFrom = $('#accountOpenDateFrom').val();
	var accountOpenDateTo = $('#accountOpenDateTo').val();
	var accountClosingDateFrom = $('#accountClosingDateFrom').val();
	var accountClosingDateTo = $('#accountClosingDateTo').val();
	var dateFormatValidationFails = false;
	
	if(accountOpenDateFrom.length>0 && isDateCustom(accountOpenDateFrom)==false){
		dateFormatValidationFails = true;
		alertStr.push(xenos$REF$i18n.accountQuery.date_format_of_from_date_check + accountOpenDateFrom);
	}
	
	if(accountOpenDateTo.length>0 && isDateCustom(accountOpenDateTo)==false){
		dateFormatValidationFails = true;
		alertStr.push(xenos$REF$i18n.accountQuery.date_format_of_to_date_check + accountOpenDateTo);
	}
	
	if(accountOpenDateFrom.length>0 && accountOpenDateTo.length>0 && dateFormatValidationFails==false){
		if(!isValidDateRange(accountOpenDateFrom,accountOpenDateTo)){
			alertStr.push(xenos$REF$i18n.accountQuery.date_from_to_check);
		}
	}
	
	if(accountClosingDateFrom.length>0 && isDateCustom(accountClosingDateFrom)==false){
		dateFormatValidationFails = true;
		alertStr.push(xenos$REF$i18n.accountQuery.date_format_of_from_date_check + accountClosingDateFrom);
	}
	
	if(accountClosingDateTo.length>0 && isDateCustom(accountClosingDateTo)==false){
		dateFormatValidationFails = true;
		alertStr.push(xenos$REF$i18n.accountQuery.date_format_of_to_date_check + accountClosingDateTo);
	}
	
	if(accountClosingDateFrom.length>0 && accountClosingDateTo.length>0 && dateFormatValidationFails==false){
		if(!isValidDateRange(accountClosingDateFrom,accountClosingDateTo)){
			alertStr.push(xenos$REF$i18n.accountQuery.date_from_to_check);
		}
	}
	
	if(alertStr.length>0){
		$('.formHeader').find('.formTabErrorIco').css('display','block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, alertStr, true));
		return false;
	}
	else{
		$('.formHeader').find('.formTabErrorIco').css('display','none');
	}
	return true;
}

xenos.ns.views.accountQuery.formatDate = function(date){
	if(date.value.length == 7){
		if(date.id=="accountOpenDateFrom"){
			$("#accountOpenDateFrom").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		if(date.id=="accountOpenDateTo"){
			$("#accountOpenDateTo").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		if(date.id=="accountClosingDateFrom"){
			$("#accountClosingDateFrom").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		if(date.id=="accountClosingDateTo"){
			$("#accountClosingDateTo").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
	}
 }