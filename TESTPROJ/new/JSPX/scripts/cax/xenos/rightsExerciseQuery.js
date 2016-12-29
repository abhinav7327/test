//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos.ns.views.rightsExerciseQuery.validate = function(){
	

	var alertStr = [];
	var dateList = [];
	
	var exDateFromStr = $('#exDateFromStr').val();
	var exDateToStr = $('#exDateToStr').val();
	
	var recordDateFromStr = $('#recordDateFromStr').val();
	var recordDateToStr = $('#recordDateToStr').val();
	
	var deadlineDateFromStr = $('#deadlineDateFromStr').val();
	var deadlineDateToStr = $('#deadlineDateToStr').val();
	
	var expiryDateFromStr = $('#expiryDateFromStr').val();
	var expiryDateToStr = $('#expiryDateToStr').val();
	
	var paymentDateFromStr = $('#paymentDateFromStr').val();
	var paymentDateToStr = $('#paymentDateToStr').val();
	
	
	var exerciseDateFromStr = $('#exerciseDateFromStr').val();
	var exerciseDateToStr = $('#exerciseDateToStr').val();
	
	var paymentDateTakeUpFromStr = $('#paymentDateTakeUpFromStr').val();
	var paymentDateTakeUpToStr = $('#paymentDateTakeUpToStr').val();
	
	
	var availableDateFromStr = $('#availableDateFromStr').val();
	var availableDateToStr = $('#availableDateToStr').val();
	
	var dateFormatValidationFails = false;
	var dateRangeValidationFails = false;
	
	if(exDateFromStr.length>0 && isDateCustom(exDateFromStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.rightsExerciseQuery.date_format_check + exDateFromStr);
	}
	
	if(dateFormatValidationFails==false && exDateToStr.length>0 && isDateCustom(exDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.rightsExerciseQuery.date_format_check + exDateToStr);
	}
	
	if(dateFormatValidationFails==false && recordDateFromStr.length>0 && isDateCustom(recordDateFromStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.rightsExerciseQuery.date_format_check + recordDateFromStr);
	}
	
	if(dateFormatValidationFails==false && recordDateToStr.length>0 && isDateCustom(recordDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.rightsExerciseQuery.date_format_check + recordDateToStr);
	}
	
	if(dateFormatValidationFails==false && deadlineDateFromStr.length>0 && isDateCustom(deadlineDateFromStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.rightsExerciseQuery.date_format_check + deadlineDateFromStr);
	}
	
	if(dateFormatValidationFails==false && deadlineDateToStr.length>0 && isDateCustom(deadlineDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.rightsExerciseQuery.date_format_check + deadlineDateToStr);
	}
	
	if(dateFormatValidationFails==false && expiryDateFromStr.length>0 && isDateCustom(expiryDateFromStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.rightsExerciseQuery.date_format_check + expiryDateFromStr);
	}
	
	if(dateFormatValidationFails==false && expiryDateToStr.length>0 && isDateCustom(expiryDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.rightsExerciseQuery.date_format_check + expiryDateToStr);
	}
	
	if(dateFormatValidationFails==false && paymentDateFromStr.length>0 && isDateCustom(paymentDateFromStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.rightsExerciseQuery.date_format_check + paymentDateFromStr);
	}
	
	if(dateFormatValidationFails==false && paymentDateToStr.length>0 && isDateCustom(paymentDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.rightsExerciseQuery.date_format_check + paymentDateToStr);
	}
	
	if(dateFormatValidationFails==false && isDateCustom(exerciseDateFromStr)==false && exerciseDateFromStr.length>0) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.rightsExerciseQuery.date_format_check + exerciseDateFromStr);
	}
	
	if(dateFormatValidationFails==false && exerciseDateToStr.length>0 && isDateCustom(exerciseDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.rightsExerciseQuery.date_format_check + exerciseDateToStr);
	}
	
	if(dateFormatValidationFails==false && isDateCustom(paymentDateTakeUpFromStr)==false && paymentDateTakeUpFromStr.length>0) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.rightsExerciseQuery.date_format_check + paymentDateTakeUpFromStr);
	}
	
	if(dateFormatValidationFails==false && paymentDateTakeUpToStr.length>0 && isDateCustom(paymentDateTakeUpToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.rightsExerciseQuery.date_format_check + paymentDateTakeUpToStr);
	}
	
	if(dateFormatValidationFails==false && isDateCustom(availableDateFromStr)==false && availableDateFromStr.length>0) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.rightsExerciseQuery.date_format_check + availableDateFromStr);
	}
	
	if(dateFormatValidationFails==false && availableDateToStr.length>0 && isDateCustom(availableDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos$CAX$i18n.rightsExerciseQuery.date_format_check + availableDateToStr);
	}
	
	
	
	



	if(dateFormatValidationFails==false) {

		
		// Ex Date From - To
		if(!isValidDateRange(exDateFromStr, exDateToStr)){
			dateRangeValidationFails = true;
		}
		// Record Date From - To
		if(dateRangeValidationFails == false && !isValidDateRange(recordDateFromStr, recordDateToStr)){
			dateRangeValidationFails = true;
		}
		
		// Deadline Date From - To
		if(dateRangeValidationFails == false && !isValidDateRange(deadlineDateFromStr, deadlineDateToStr)){
			dateRangeValidationFails = true;
		}
		// Expiry Date From - To
		if(dateRangeValidationFails == false && !isValidDateRange(expiryDateFromStr, expiryDateToStr)){
			dateRangeValidationFails = true;
		}
		// Payment Date (New Share) From - To
		if(dateRangeValidationFails == false && !isValidDateRange(paymentDateFromStr, paymentDateToStr)){
			dateRangeValidationFails = true;
		}
		// Expercise Date From - To
		if(dateRangeValidationFails == false && !isValidDateRange(exerciseDateFromStr, exerciseDateToStr)){
			dateRangeValidationFails = true;
		}
		// Payment Date (Take up Cost) From To
		if(dateRangeValidationFails == false && !isValidDateRange(paymentDateTakeUpFromStr, paymentDateTakeUpToStr)){
			dateRangeValidationFails = true;
		}
		// Avaialble Date From To
		if(dateRangeValidationFails == false && !isValidDateRange(availableDateFromStr, availableDateToStr)){
			dateRangeValidationFails = true;
		}
		
		
		
		if(dateRangeValidationFails) {
			alertStr.push(xenos$CAX$i18n.rightsExerciseQuery.date_from_to_check);
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
			xenos.ns.views.rightsExerciseQuery.formatDate($('#exDateFromStr'));
			xenos.ns.views.rightsExerciseQuery.formatDate($('#exDateToStr'));
			
			xenos.ns.views.rightsExerciseQuery.formatDate($('#recordDateFromStr'));
			xenos.ns.views.rightsExerciseQuery.formatDate($('#recordDateToStr'));
			
			xenos.ns.views.rightsExerciseQuery.formatDate($('#deadlineDateFromStr'));
			xenos.ns.views.rightsExerciseQuery.formatDate($('#deadlineDateToStr'));
			
			xenos.ns.views.rightsExerciseQuery.formatDate($('#expiryDateFromStr'));
			xenos.ns.views.rightsExerciseQuery.formatDate($('#expiryDateToStr'));
			
			xenos.ns.views.rightsExerciseQuery.formatDate($('#paymentDateFromStr'));
			xenos.ns.views.rightsExerciseQuery.formatDate($('#paymentDateToStr'));
			
			xenos.ns.views.rightsExerciseQuery.formatDate($('#exerciseDateFromStr'));
			xenos.ns.views.rightsExerciseQuery.formatDate($('#exerciseDateToStr'));
			
			xenos.ns.views.rightsExerciseQuery.formatDate($('#paymentDateTakeUpFromStr'));
			xenos.ns.views.rightsExerciseQuery.formatDate($('#paymentDateTakeUpToStr'));
			
			xenos.ns.views.rightsExerciseQuery.formatDate($('#availableDateFromStr'));
			xenos.ns.views.rightsExerciseQuery.formatDate($('#availableDateToStr'));
			
	return true;
	}
	
}

//Format Date method

xenos.ns.views.rightsExerciseQuery.formatDateOnchange = function(date) {
	if(checkDate(date)){	
		var dateVal = date.value;
		if(dateVal.length == 7){
			$("#" + date.id).val(dateVal.substr(0,6)+"0"+dateVal.substr(6));
			}
		}else{
		xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos$CAX$i18n.rightsExerciseQuery.date_format_check + "" + date.value));
		}

	  }
xenos.ns.views.rightsExerciseQuery.formatDate = function(date) {
	
	var dateVal = date.val();
		if(dateVal.length == 7){
			$(date.selector).val(dateVal.substr(0,6)+"0"+dateVal.substr(6));
			}
	  }	 