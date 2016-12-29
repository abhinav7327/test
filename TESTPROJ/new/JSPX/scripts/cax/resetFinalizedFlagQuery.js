//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
 xenos.ns.views.resetFinalizedFlagQuery.validateSubmit = function(){

	var alertStr = [];
	var dateList = [];
	var paymentDateFromStr = $('#paymentDateFromStr').val();
	var paymentDateToStr = $('#paymentDateToStr').val();
	var exDateFromStr = $('#exDateFromStr').val();
	var exDateToStr = $('#exDateToStr').val();

	dateList.push(paymentDateFromStr);
	dateList.push(paymentDateToStr);
	dateList.push(exDateFromStr);
	dateList.push(exDateToStr);
	
	var dateFormatValidationFails = false;
	var dateRangeValidationFails = false;
	
	for(var i=0;i<dateList.length; i+=2)
		{
		if(isDateCustom(dateList[i])==false && dateList[i].length>0) {
			dateFormatValidationFails = true;
			alertStr.push(xenos$CAX$i18n.resetFinalizedFlagQuery.date_format_check + dateList[i]);
			break;
		}
		
		if(isDateCustom(dateList[i+1])==false && dateList[i+1].length>0) {
			dateFormatValidationFails = true;
			alertStr.push(xenos$CAX$i18n.resetFinalizedFlagQuery.date_format_check + dateList[i+1]);
			break;
		}
		
		if(!isValidDateRange(dateList[i], dateList[i+1])){
			dateRangeValidationFails = true;
			alertStr.push(xenos$CAX$i18n.resetFinalizedFlagQuery.date_from_to_check);
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
			xenos.ns.views.resetFinalizedFlagQuery.formatDate( $('#paymentDateFromStr'));
			xenos.ns.views.resetFinalizedFlagQuery.formatDate($('#paymentDateToStr'));
			
			xenos.ns.views.resetFinalizedFlagQuery.formatDate($('#exDateFromStr'));
			xenos.ns.views.resetFinalizedFlagQuery.formatDate( $('#exDateToStr'));
			
			
			
	return true;
	}
}
 
//Format Date method

 xenos.ns.views.resetFinalizedFlagQuery.formatDateOnchange = function(date) {
 	if(checkDate(date)){	
 		var dateVal = date.value;
 		if(dateVal.length == 7){
 			$("#" + date.id).val(dateVal.substr(0,6)+"0"+dateVal.substr(6));
 			}
 		}else{
 		xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos$CAX$i18n.resetFinalizedFlagQuery.date_format_check + "" + date.value));
 		}

 	  }
 xenos.ns.views.resetFinalizedFlagQuery.formatDate = function(date) {
 	
 	var dateVal = date.val();
 		if(dateVal.length == 7){
 			$(date.selector).val(dateVal.substr(0,6)+"0"+dateVal.substr(6));
 			}
 	  }	 