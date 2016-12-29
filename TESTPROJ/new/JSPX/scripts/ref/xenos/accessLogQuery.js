//$Id$
//$Author: pritampa $
//$Date: 2016-12-23 17:13:05 $

 xenos.ns.views.accessLogQuery.validateSubmit = function(){

	var alertStr = [];
	var enteryDateSystemFrom = $('#creationDateFrom').val();
	var enteryDateSystemTo = $('#creationDateTo').val();
	var enteryDateFrom = $('#appRegiDateFrom').val();
	var enteryDateTo = $('#appRegiDateTo').val();
	var dateFormatValidationFails1 = false;
	var dateFormatValidationFails2 = false;
	
	if(isDateCustom(enteryDateSystemFrom) == false && enteryDateSystemFrom.length>0) {
		dateFormatValidationFails1 = true;
		alertStr.push(xenos$REF$i18n.accessLog.query.date_format_check + enteryDateSystemFrom);
	}
	
	if(dateFormatValidationFails1 == false && enteryDateSystemTo.length>0 && isDateCustom(enteryDateSystemTo) == false) {
		dateFormatValidationFails1 = true;
		alertStr.push(xenos$REF$i18n.accessLog.query.date_format_check + enteryDateSystemTo);
	}
	
	// Validate Entry System Date From - To
	if((enteryDateSystemFrom != null && enteryDateSystemFrom.length > 0) && (enteryDateSystemTo != null && enteryDateSystemTo.length > 0)){
		if (enteryDateSystemFrom > enteryDateSystemTo) {
			alertStr.push(xenos$REF$i18n.accessLog.query.date_from_to_check);
		}
	}
	
	
	if(isDateCustom(enteryDateFrom) == false && enteryDateFrom.length>0 ) {
		dateFormatValidationFails2 = true;
		alertStr.push(xenos$REF$i18n.accessLog.query.date_format_check + enteryDateFrom);
	}
	
	if(dateFormatValidationFails2 == false && enteryDateTo.length>0 && isDateCustom(enteryDateTo) == false) {
		dateFormatValidationFails2 = true;
		alertStr.push(xenos$REF$i18n.accessLog.query.date_format_check + enteryDateTo);
	}
	
	// Validate Entry Date From - To
	if((enteryDateFrom != null && enteryDateFrom.length > 0) && (enteryDateTo != null && enteryDateTo.length > 0)){
		if (enteryDateFrom > enteryDateTo) {
			alertStr.push(xenos$REF$i18n.accessLog.query.date_from_to_check);
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
xenos.ns.views.accessLogQuery.formatCreationDateFrom = function(creationDateFrom) {
		if(creationDateFrom.length == 7){
			$("#creationDateFrom").val(creationDateFrom.substr(0,6)+"0"+creationDateFrom.substr(6));
		}
	  }
xenos.ns.views.accessLogQuery.formatCreationDateTo = function(creationDateTo) {
		if(creationDateTo.length == 7){
			$("#creationDateTo").val(creationDateTo.substr(0,6)+"0"+creationDateTo.substr(6));
		}
	  }
xenos.ns.views.accessLogQuery.formatAppRegiDateFrom = function(appRegiDateFrom) {
	if(appRegiDateFrom.length == 7){
		$("#appRegiDateFrom").val(appRegiDateFrom.substr(0,6)+"0"+appRegiDateFrom.substr(6));
	}
  }
xenos.ns.views.accessLogQuery.formatAppRegiDateTo = function(appRegiDateTo) {
		if(appRegiDateTo.length == 7){
			$("#appRegiDateTo").val(appRegiDateTo.substr(0,6)+"0"+appRegiDateTo.substr(6));
		}
	  }