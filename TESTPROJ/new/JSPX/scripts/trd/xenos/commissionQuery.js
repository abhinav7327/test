//$Id$
//$Author: ganapriyaa $
//$Date: 2016-12-26 11:00:08 $
xenos.ns.views.commissionQuery.validateSubmit = function(){
				var alertStr = [];
				var validateStr =[]
				var reportId = $.trim($('#commQueryReportId').val());
				var tradeDateFromStr = $.trim($('#tradeDateFromStr').val());
				var tradeDateToStr = $.trim($('#tradeDateToStr').val());
				var tradeDateFromStr = $('#tradeDateFromStr').val();
				var tradeDateToStr = $('#tradeDateToStr').val();
				var flag =0;
				var dateFormatValidationFails = false;
	
	//check empty fields			
	if(VALIDATOR.isNullValue(reportId)){
		validateStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.commissionQuery.report_id_check));
	}
	
	if(dateFormatValidationFails==false){
		if(!isValidText(tradeDateFromStr) )
			alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.commissionQuery.date_from_empty_check));
	}
	
	if(dateFormatValidationFails==false){
		if(!isValidText(tradeDateToStr) )
			alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.commissionQuery.date_to_empty_check));
	}	
	
	//date format validation [YYYYMMDD]
	if(dateFormatValidationFails==false && tradeDateFromStr.length>0 && isDateCustom(tradeDateFromStr)==false) {
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.commissionQuery.date_from_format_check, [tradeDateFromStr]));
		dateFormatValidationFails = true;
	}
	
	if(dateFormatValidationFails==true && tradeDateToStr.length>0 && isDateCustom(tradeDateToStr)==false) {
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.commissionQuery.date_to_format_check, [tradeDateToStr]));
		dateFormatValidationFails = true;
	}
		
	if(dateFormatValidationFails==false && tradeDateToStr.length>0 && isDateCustom(tradeDateToStr)==false) {
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.commissionQuery.date_to_format_check, [tradeDateToStr]));
		dateFormatValidationFails = true;
	}
	
	//date range validation	
	if(dateFormatValidationFails==false){
		if(isValidText(tradeDateFromStr) && isValidText(tradeDateToStr)){
			if (!isValidDateRange(tradeDateFromStr,tradeDateToStr)) {
				alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.commissionQuery.date_from_to_check));
			}
		}
		
	}	
	//Show the error message for reportid
	if(validateStr.length > 0){
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validateStr, true));
		return false;
	}else if(alertStr.length > 0){
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, alertStr, true));
		return false;
	}else{
		$('.formHeader').find('.formTabErrorIco').css('display', 'none');
	}
	return true;
 }
 	
 xenos.ns.views.commissionQuery.formatDate = function(date,id){
		if(date.length == 7){
			id.val(date.substr(0,6)+"0"+date.substr(6));
		}
 } 
  function isValidText(text){
	if(text!='undefined' && text!=null && $.trim(text).length > 0){
		return true;
	}
	return false;
 }
 