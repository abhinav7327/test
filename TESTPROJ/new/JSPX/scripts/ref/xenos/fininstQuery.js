//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos.ns.views.fininstQuery.validateSubmit = function(){
	var alertStr = [];
	var closeDateFrom = $('#closeDateFrom').val();
	var closeDateTo = $('#closeDateTo').val();
	var dateFormatValidationFails = false;
	
	if(closeDateFrom.length>0 && isDateCustom(closeDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$REF$i18n.fininst.query.date_format_of_from_date_check);
	}
	
	if(closeDateTo.length>0 && isDateCustom(closeDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$REF$i18n.fininst.query.date_format_of_to_date_check);
	}

	if(closeDateFrom.length>0 && closeDateTo.length>0 && dateFormatValidationFails==false) {
		// Validate Trade Date From - To
		if(!isValidDateRange(closeDateFrom, closeDateTo)){
			alertStr.push(xenos$REF$i18n.fininst.query.date_from_to_check);
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
xenos.ns.views.fininstQuery.formatCloseDateFrom = function(closeDateFrom) {
		if(closeDateFrom.length == 7){
			$("#closeDateFrom").val(closeDateFrom.substr(0,6)+"0"+closeDateFrom.substr(6));
		}
	  }
xenos.ns.views.fininstQuery.formatCloseDateTo = function(closeDateTo) {
		if(closeDateTo.length == 7){
			$("#closeDateTo").val(closeDateTo.substr(0,6)+"0"+closeDateTo.substr(6));
		}
	  }