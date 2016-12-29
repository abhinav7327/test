//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
 xenos.ns.views.stlQuery.validateSubmit = function(){
	var amountFrom = $('#amountFrom').val();
	var amountTo = $('#amountTo').val();
	var quantityFrom = $('#quantityFrom').val();
	var quantityTo = $('#quantityTo').val();
	var alertStr = [];
	var NBD = NUM_DIGITS_DEFAULT;
	var NAD = NUM_DECIMAL_DEFAULT;
	
	// Validate Amount From
	if(validateAmountOrQuantity(amountFrom) == 'invalidLength'){
		alertStr.push(xenos.utils.evaluateMessage(xenos$STL$i18n.stlQuery.invalidLength, [xenos$STL$i18n.stlQuery.amountForm,NBD,NAD]));
	}
	if(validateAmountOrQuantity(amountFrom) == 'invalidAmountOrQuantity'){
		alertStr.push(xenos$STL$i18n.stlAmdAuth.amountForm);
	}
	
	//Validate Amount To
	if(validateAmountOrQuantity(amountTo) == 'invalidLength'){
		alertStr.push(xenos.utils.evaluateMessage(xenos$STL$i18n.stlQuery.invalidLength, [xenos$STL$i18n.stlQuery.amountTo,NBD,NAD]));
	}
	if(validateAmountOrQuantity(amountTo) == 'invalidAmountOrQuantity'){
		alertStr.push(xenos$STL$i18n.stlAmdAuth.amountTo);
	}
	
	// Validate Quantity From
	if(validateAmountOrQuantity(quantityFrom) == 'invalidLength'){
		alertStr.push(xenos.utils.evaluateMessage(xenos$STL$i18n.stlQuery.invalidLength, [xenos$STL$i18n.stlQuery.quantityFrom,NBD,NAD]));
	}
	if(validateAmountOrQuantity(quantityFrom) == 'invalidAmountOrQuantity'){
		alertStr.push(xenos$STL$i18n.stlAmdAuth.quantityFrom);
	}
	
	//Validate Quantity To
	if(validateAmountOrQuantity(quantityTo) == 'invalidLength'){
		alertStr.push(xenos.utils.evaluateMessage(xenos$STL$i18n.stlQuery.invalidLength, [xenos$STL$i18n.stlQuery.quantityTo,NBD,NAD]));
	}
	if(validateAmountOrQuantity(quantityTo) == 'invalidAmountOrQuantity'){
		alertStr.push(xenos$STL$i18n.stlAmdAuth.quantityTo);
	}

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
	var stlDateFrom = $('#settleDateFrom').val();	
	var stlDateTo = $('#settleDateTo').val();	
	var entryDateFrom = $('#entryDateFrom').val();
	var entryDateTo = $('#entryDateTo').val();
	var lastEntryDateFrom = $('#lastEntryDateFrom').val();
	var lastEntryDateTo = $('#lastEntryDateTo').val();
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
	//Validation Stl Date From
	if(dateFormatValidationFails==false && stlDateFrom.length>0 && isDateCustom(stlDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$STL$i18n.stlQuery.date_format_check + stlDateFrom);
	}
		if(!dateFormatValidationFails){	
		formatDate(stlDateFrom,$('#settleDateFrom'));
	}
	//Validation Stl Date To
	if(dateFormatValidationFails==false && stlDateTo.length>0 && isDateCustom(stlDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$STL$i18n.stlQuery.date_format_check + stlDateTo);
	}
		if(!dateFormatValidationFails){	
		formatDate(stlDateTo,$('#settleDateTo'));
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
	//Validation Last Entry Date From
	if(dateFormatValidationFails==false && lastEntryDateFrom.length>0 && isDateCustom(lastEntryDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$STL$i18n.stlQuery.date_format_check + lastEntryDateFrom);
	}
		if(!dateFormatValidationFails){	
		formatDate(lastEntryDateFrom,$('#lastEntryDateFrom'));
	}
	//Validation Last Entry Date To
	if(dateFormatValidationFails==false && lastEntryDateTo.length>0 && isDateCustom(lastEntryDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$STL$i18n.stlQuery.date_format_check + lastEntryDateTo);
	}
	if(!dateFormatValidationFails){	
		formatDate(lastEntryDateTo,$('#lastEntryDateTo'));
	}
	return dateFormatValidationFails;
}

//This method does date range validation.
function dateRangeValidation(alertStr){
	var tradeDateFrom = $('#tradeDateFrom').val();
	var tradeDateTo = $('#tradeDateTo').val();
	var valueDateFrom = $('#valueDateFrom').val();
	var valueDateTo = $('#valueDateTo').val();	
	var stlDateFrom = $('#settleDateFrom').val();	
	var stlDateTo = $('#settleDateTo').val();	
	var entryDateFrom = $('#entryDateFrom').val();
	var entryDateTo = $('#entryDateTo').val();
	var lastEntryDateFrom = $('#lastEntryDateFrom').val();
	var lastEntryDateTo = $('#lastEntryDateTo').val();
	var dateRangeValidationFails = false;
	
	//Validation Trade Date From - To
	if(!isValidDateRange(tradeDateFrom, tradeDateTo)){
		dateRangeValidationFails = true;
	}
	// Validate Value Date From - To
	if(dateRangeValidationFails == false && !isValidDateRange(valueDateFrom, valueDateTo)){
		dateRangeValidationFails = true;
	}
	
	// Validate Stl Date From - To
	if(dateRangeValidationFails == false && !isValidDateRange(stlDateFrom, stlDateTo)){
		dateRangeValidationFails = true;
	}
	
	// Validate Entry Date From - To
	if(dateRangeValidationFails == false && !isValidDateRange(entryDateFrom, entryDateTo)){
		dateRangeValidationFails = true;
	}
	
	// Validate Last Entry Date From - To
	if(dateRangeValidationFails == false && !isValidDateRange(lastEntryDateFrom, lastEntryDateTo)){
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
