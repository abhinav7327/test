//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $




 xenos.ns.views.frxInstructionQuery.validateSubmit = function(){
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
			alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxInstructionQuery.missing_date));
		}
	}
	
	if(dateFormatValidationFails==false && tradeDateFromStr.length>0 && isDateCustom(tradeDateFromStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxInstructionQuery.date_format_check , [tradeDateFromStr]));
	}
	
	if(dateFormatValidationFails==false && tradeDateToStr.length>0 && isDateCustom(tradeDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxInstructionQuery.date_format_check , [tradeDateToStr]));
	}
	
	if(dateFormatValidationFails==false && valueDateFromStr.length>0 && isDateCustom(valueDateFromStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxInstructionQuery.date_format_check , [valueDateFromStr]));
	}
	
	if(dateFormatValidationFails==false && valueDateToStr.length>0 && isDateCustom(valueDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxInstructionQuery.date_format_check , [valueDateToStr]));
	}
	
	if(dateFormatValidationFails==false && transmissionDate.length>0 && isDateCustom(transmissionDate)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxInstructionQuery.date_format_check , [transmissionDate]));
	}
	
	if(dateFormatValidationFails==false){
	
		if(xenos.ns.views.frxInstructionQuery.isValidText(tradeDateFromStr) && xenos.ns.views.frxInstructionQuery.isValidText(tradeDateToStr)){
			// Validate Trade Date From - To
			if (!isValidDateRange(tradeDateFromStr,tradeDateToStr)) {
				alertStr.push(xenos$FRX$i18n.frxInstructionQuery.date_from_to_check);
			}
		}
		
		if(xenos.ns.views.frxInstructionQuery.isValidText(valueDateFromStr) && xenos.ns.views.frxInstructionQuery.isValidText(valueDateToStr)){
			// Validate Value Date From - To
			if (!isValidDateRange(valueDateFromStr,valueDateToStr)) {
				alertStr.push(xenos$FRX$i18n.frxInstructionQuery.date_from_to_check);
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
 
 
  xenos.ns.views.frxInstructionQuery.isValidText =function(text){
	if(text!='undefined' && text!=null && $.trim(text).length > 0){
		return true;
	}
	return false;
 }
 
xenos.ns.views.frxInstructionQuery.formatCustomDate = function(date){
	if(date.value.length == 7){
		if(date.id=="tradeDateFrom"){
			$("#tradeDateFrom").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		
		if(date.id=="tradeDateTo"){
			$("#tradeDateTo").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		
		if(date.id=="valueDateFrom"){
			$("#valueDateFrom").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		
		if(date.id=="valueDateTo"){
			$("#valueDateTo").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		
		if($("#operationObjective").val()=="QUERY"){
			if(date.id=="transmissionDate"){
				$("#transmissionDate").val(date.value.substr(0,6)+"0"+date.value.substr(6));
			}
		}
		
	}
}
