//$Id$
//$Author: deepikas $
//$Date: 2016-12-23 15:46:56 $




 xenos.ns.views.drvInstructionQuery.validateSubmit = function(){
	var alertStr = [];
	
	var operationObjective = $("#operationObjective").val();
	var tradeDateFromStr = $('#tradeDateFrom').val();
	var tradeDateToStr = $('#tradeDateTo').val();
	var valueDateFromStr = $('#valueDateFrom').val();
	var valueDateToStr = $('#valueDateTo').val();
	var transmissionDate = $('#transmissionDate').val();
	
	var dateFormatValidationFails = false;
	
	if(operationObjective=="QUERY"){
		if($.trim(tradeDateFromStr)=="" && $.trim(tradeDateToStr)=="" && $.trim(valueDateFromStr)=="" && $.trim(valueDateToStr)=="" && $.trim(transmissionDate)==""){
			dateFormatValidationFails = true;
			alertStr.push(xenos.utils.evaluateMessage(xenos$DRV$i18n.drvInstructionQuery.missing_date));
		}
	}
	
	if(dateFormatValidationFails==false && tradeDateFromStr.length>0 && isDateCustom(tradeDateFromStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$DRV$i18n.drvInstructionQuery.date_format_check , [tradeDateFromStr]));
	}
	
	if(dateFormatValidationFails==false && tradeDateToStr.length>0 && isDateCustom(tradeDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$DRV$i18n.drvInstructionQuery.date_format_check , [tradeDateToStr]));
	}
	
	if(dateFormatValidationFails==false && valueDateFromStr.length>0 && isDateCustom(valueDateFromStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$DRV$i18n.drvInstructionQuery.date_format_check , [valueDateFromStr]));
	}
	
	if(dateFormatValidationFails==false && valueDateToStr.length>0 && isDateCustom(valueDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$DRV$i18n.drvInstructionQuery.date_format_check , [valueDateToStr]));
	}
	
	if(dateFormatValidationFails==false && transmissionDate.length>0 && isDateCustom(transmissionDate)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$DRV$i18n.drvInstructionQuery.date_format_check , [transmissionDate]));
	}
	
	if(dateFormatValidationFails==false){
	
		if(xenos.ns.views.drvInstructionQuery.isValidText(tradeDateFromStr) && xenos.ns.views.drvInstructionQuery.isValidText(tradeDateToStr)){
			// Validate Trade Date From - To
			if (!isValidDateRange(tradeDateFromStr,tradeDateToStr)) {
				alertStr.push(xenos$DRV$i18n.drvInstructionQuery.date_from_to_check);
			}
		}
		
		if(xenos.ns.views.drvInstructionQuery.isValidText(valueDateFromStr) && xenos.ns.views.drvInstructionQuery.isValidText(valueDateToStr)){
			// Validate Value Date From - To
			if (!isValidDateRange(valueDateFromStr,valueDateToStr)) {
				alertStr.push(xenos$DRV$i18n.drvInstructionQuery.date_from_to_check);
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
 
 
xenos.ns.views.drvInstructionQuery.isValidText = function(text){
	if(text!='undefined' && text!=null && $.trim(text).length > 0){
		return true;
	}
	return false;
 }
