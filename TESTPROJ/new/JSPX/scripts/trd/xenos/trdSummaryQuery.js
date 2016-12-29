//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $




 xenos.ns.views.tradeSummaryQuery.validateSubmit = function(){
	var alertStr = [];
	
	var accountNo = $('#accountNo').val();
	var inventoryAccountNo = $('#inventoryAccountNo').val();
	var securityId = $('#securityId').val();
	var basketId = $('#basketId').val();
	var tradeDateFromStr = $('#tradeDateFromStr').val();
	var tradeDateToStr = $('#tradeDateToStr').val();
	var valueDateFromStr = $('#valueDateFromStr').val();
	var valueDateToStr = $('#valueDateToStr').val();
	
	var count = 0;

	if($.trim(accountNo).length > 0){
        count++ ;
    }
	if($.trim(inventoryAccountNo).length > 0){
        count++ ;
    }
	if($.trim(securityId).length > 0){
        count++ ;
    }
	if($.trim(basketId).length > 0){
        count+=2 ;
    }
	if($.trim(tradeDateFromStr).length > 0 || $.trim(tradeDateToStr).length > 0){
        count++ ;
    }
	if($.trim(valueDateFromStr).length > 0 || $.trim(valueDateToStr).length > 0){
        count++ ;
    }

	if(count < 2 )
	{
		alertStr.push(xenos$TRD$i18n.tradeSummaryQuery.minimum_criteria);
		count = 0;
	}
	count = 0;
	
	var dateFormatValidationFails = false;
	
	if(dateFormatValidationFails==false && tradeDateFromStr.length>0 && isDateCustom(tradeDateFromStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeSummaryQuery.date_format_check, [tradeDateFromStr]));
	}
	
	if(dateFormatValidationFails==false && tradeDateToStr.length>0 && isDateCustom(tradeDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeSummaryQuery.date_format_check, [tradeDateToStr]));
	}
	
	if(dateFormatValidationFails==false && valueDateFromStr.length>0 && isDateCustom(valueDateFromStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeSummaryQuery.date_format_check, [valueDateFromStr]));
	}
	
	if(dateFormatValidationFails==false && valueDateToStr.length>0 && isDateCustom(valueDateToStr)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeSummaryQuery.date_format_check, [valueDateToStr]));
	}
	
	if(dateFormatValidationFails==false){
	
		if(xenos.ns.views.tradeSummaryQuery.isValidText(tradeDateFromStr) && xenos.ns.views.tradeSummaryQuery.isValidText(tradeDateToStr)){
			// Validate Trade Date From - To
			if (!isValidDateRange(tradeDateFromStr,tradeDateToStr)) {
				alertStr.push(xenos$TRD$i18n.tradeSummaryQuery.date_from_to_check);
			}
		}
		
		if(xenos.ns.views.tradeSummaryQuery.isValidText(valueDateFromStr) && xenos.ns.views.tradeSummaryQuery.isValidText(valueDateToStr)){
			// Validate Value Date From - To
			if (!isValidDateRange(valueDateFromStr,valueDateToStr)) {
				alertStr.push(xenos$TRD$i18n.tradeSummaryQuery.date_from_to_check);
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

xenos.ns.views.tradeSummaryQuery.isValidText = function(text){
	if(text!='undefined' && text!=null && $.trim(text).length > 0){
		return true;
	}
	return false;
}

xenos.ns.views.tradeSummaryQuery.formatCustomDate = function(date){
	if(date.value.length == 7){
		if(date.id=="tradeDateFromStr"){
			$("#tradeDateFromStr").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		
		if(date.id=="tradeDateToStr"){
			$("#tradeDateToStr").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		
		if(date.id=="valueDateFromStr"){
			$("#valueDateFromStr").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		
		if(date.id=="valueDateToStr"){
			$("#valueDateToStr").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
	}
}