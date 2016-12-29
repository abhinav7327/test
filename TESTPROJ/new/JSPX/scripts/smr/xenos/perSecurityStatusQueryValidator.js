//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos.ns.views.perSecurityStatusQuery.validateSubmit = function(){

	var requestedDateFrom  = $.trim($('#requestedDateFrom').val());
	var requestedDateTo    = $.trim($('#requestedDateTo').val());
	
	var validationMessages = [];
	
	
	// From date should be less than To date
	if((isDateCustom(requestedDateFrom) && isDateCustom(requestedDateTo)) &&  !isValidDateRange(requestedDateFrom, requestedDateTo)){
		validationMessages.push(xenos$SMR$i18n.perSecQ.daterange_invalid);
	}
	
	if(!isDateCustom(requestedDateFrom) && !VALIDATOR.isNullValue(requestedDateFrom)){
		validationMessages.push(xenos$SMR$i18n.commons.date_format_check + [requestedDateFrom]);
	};
	
	if(!isDateCustom(requestedDateTo) && !VALIDATOR.isNullValue(requestedDateTo)){
		validationMessages.push(xenos$SMR$i18n.commons.date_format_check + [requestedDateTo]);
	};
	
	//Show the error message
	if(validationMessages.length > 0){
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
		return false;
	}else{
		$('.formHeader').find('.formTabErrorIco').css('display', 'none');
	}	
	
 return true;
} 