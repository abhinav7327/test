//$Id$
//$Author: surajb $
//$Date: 2016-12-28 12:01:03 $
xenos.ns.views.marginEntry.validateSubmit = function(){

	var validationMessages = [];
	
	var tradeRefNo  		= $('#tradeRefNo').val();
	var baseDateStr  		= $('#baseDateStr').val();
	var marginAmountStr 	= $('#marginAmountStr').val();

	if(VALIDATOR.isNullValue($.trim(tradeRefNo))){
		validationMessages.push(xenos$DRV$i18n.marginEntry.entry.trade_refNo_empty);
	}
	
	 if(VALIDATOR.isNullValue($.trim(baseDateStr))){
		validationMessages.push(xenos$DRV$i18n.marginEntry.entry.date_blank);
	}

	if(isDateCustom(baseDateStr)==false && baseDateStr.length>0) {
		dateFormatValidationFails = true;
		validationMessages.push(xenos.utils.evaluateMessage(xenos$DRV$i18n.marginEntry.entry.date_format_check+" "+baseDateStr));
	} 
	
	if(VALIDATOR.isNullValue($.trim(marginAmountStr))){
		validationMessages.push(xenos$DRV$i18n.marginEntry.entry.margin_amt_empty);
	} 
	
	
	formatSignedRate($('#marginAmountStr'),15,3,validationMessages,$('#marginAmountStr').parent().parent().find('label').text());

	
	//Show the error message
	if(validationMessages.length > 0){
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
		return false;
	}else{
		$('.formHeader').find('.formTabErrorIco').css('display', 'none');
	} 
	// format date on submit
	     xenos.ns.views.marginEntry.formatDate(baseDateStr);
	return true;
}

// function formatDate
xenos.ns.views.marginEntry.formatDate = function(baseDateStr) {
	if(baseDateStr.length == 7){
		$("#baseDateStr").val(baseDateStr.substr(0,6)+"0"+baseDateStr.substr(6));
	}
}
