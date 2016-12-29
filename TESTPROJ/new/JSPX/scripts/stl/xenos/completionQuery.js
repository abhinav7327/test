//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
 xenos.ns.views.completionQuery.validateSubmit = function(){

	var alertStr = [];

	//Call to individual date field validation for invalid input.
	var dateFormatValidationFails = customDateValidation(alertStr);
	
	//Call to date range validation.
	if(dateFormatValidationFails == false){
		dateRangeValidation(alertStr);
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
 //This method does individual date field validation for invalid input.
function customDateValidation(alertStr){
	var tradeDateFrom = $('#tradeDateFrom').val();
	var tradeDateTo = $('#tradeDateTo').val();
	var valueDateFrom = $('#valueDateFrom').val();
	var valueDateTo = $('#valueDateTo').val();	
	var entryDateFrom = $('#entryDateFrom').val();
	var entryDateTo = $('#entryDateTo').val();
	var dateFormatValidationFails = false;	
	
	
	//Validation Trade Date From
	if(tradeDateFrom.length>0 && isDateCustom(tradeDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$STL$i18n.stlQuery.date_format_check + tradeDateFrom);
	}
	if(!dateFormatValidationFails){	
		formatDate(tradeDateFrom,$('#tradeDateFrom'));
	}
	//Validation Trade Date To
	if(dateFormatValidationFails==false && tradeDateTo.length>0 && isDateCustom(tradeDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$STL$i18n.stlQuery.date_format_check + tradeDateTo);
	}
		if(!dateFormatValidationFails){	
		formatDate(tradeDateTo,$('#tradeDateTo'));
	}
	//Validation Value Date From
	if(dateFormatValidationFails==false && valueDateFrom.length>0 && isDateCustom(valueDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$STL$i18n.stlQuery.date_format_check + valueDateFrom);
	}
		if(!dateFormatValidationFails){	
		formatDate(valueDateFrom,$('#valueDateFrom'));
	}
	//Validation Value Date To
	if(dateFormatValidationFails==false && valueDateTo.length>0 && isDateCustom(valueDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$STL$i18n.stlQuery.date_format_check + valueDateTo);
	}
		if(!dateFormatValidationFails){	
		formatDate(valueDateTo,$('#valueDateTo'));
	}
	//Validation Entry Date From
	if(dateFormatValidationFails==false && entryDateFrom.length>0 && isDateCustom(entryDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$STL$i18n.stlQuery.date_format_check + entryDateFrom);
	}
		if(!dateFormatValidationFails){	
		formatDate(entryDateFrom,$('#entryDateFrom'));
	}
	//Validation Entry Date To
	if(dateFormatValidationFails==false && entryDateTo.length>0 && isDateCustom(entryDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$STL$i18n.stlQuery.date_format_check + entryDateTo);
	}
		if(!dateFormatValidationFails){	
		formatDate(entryDateTo,$('#entryDateTo'));
	}
	
	return dateFormatValidationFails;
}

//This method does date range validation.
function dateRangeValidation(alertStr){
	var tradeDateFrom = $('#tradeDateFrom').val();
	var tradeDateTo = $('#tradeDateTo').val();
	var valueDateFrom = $('#valueDateFrom').val();
	var valueDateTo = $('#valueDateTo').val();		
	var entryDateFrom = $('#entryDateFrom').val();
	var entryDateTo = $('#entryDateTo').val();
	var dateRangeValidationFails = false;
	
	//Validation Trade Date From - To
	if(!isValidDateRange(tradeDateFrom, tradeDateTo)){
		dateRangeValidationFails = true;
	}
	// Validate Value Date From - To
	if(dateRangeValidationFails == false && !isValidDateRange(valueDateFrom, valueDateTo)){
		dateRangeValidationFails = true;
	}
	
	// Validate Entry Date From - To
	if(dateRangeValidationFails == false && !isValidDateRange(entryDateFrom, entryDateTo)){
		dateRangeValidationFails = true;
	}
	
	if(dateRangeValidationFails) {
		alertStr.push(xenos$STL$i18n.stlQuery.date_from_to_check);
	}
}
function formatDate(date,id){
	if(date.length == 7){
		id.val(date.substr(0,6)+"0"+date.substr(6));
	}
 }
