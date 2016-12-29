//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $



 
xenos.ns.views.ncmTxnQuery.validateSubmit = function(){

		var dateFrom  = $('#dateFrom').val();
		var dateTo    = $('#dateTo').val();
		var accountNo  = $('#accountNo').val();
		var currencyCode    = $('#currency').val();
		var securityCode  = $('#securityCode').val();
		
		var mandatoryValidationFails = false;
		
		var validationMessages = [];
		
		// Validate Our Bank Account No has been specified
		if(accountNo.length == 0 && !mandatoryValidationFails){
			validationMessages.push(xenos$NCM$i18n.transactionquery.validation.account_empty);
			mandatoryValidationFails =  true;
		}
		
		// empty check - from date
		if(dateTo.length > 0 && dateFrom.length == 0){
			validationMessages.push(xenos$NCM$i18n.transactionquery.validation.datefrom_empty);
			mandatoryValidationFails =  true;
		}
		
		// empty check -  to date
		if(dateFrom.length > 0 && dateTo.length == 0){
			validationMessages.push(xenos$NCM$i18n.transactionquery.validation.dateto_empty);
			mandatoryValidationFails =  true;
		}
		
		// Validate both from and to dates have been specified
		if(dateFrom.length == 0 && dateTo.length == 0){
			validationMessages.push(xenos$NCM$i18n.transactionquery.validation.daterange_empty);
			mandatoryValidationFails =  true;
		}
		
		// From date should be less than To date
		if((isDateCustom(dateFrom) && isDateCustom(dateTo)) &&  !isValidDateRange(dateFrom, dateTo)){
			validationMessages.push(xenos$NCM$i18n.transactionquery.validation.daterange_invalid);
			mandatoryValidationFails =  true;
		}
		
		// Validate to date
		if(dateTo.length > 0 && !isDateCustom(dateTo)){
			validationMessages.push(xenos$NCM$i18n.transactionquery.validation.dateto_invalid);
			mandatoryValidationFails =  true;
		}
		
		// Validate from date
		if(dateFrom.length > 0 && !isDateCustom(dateFrom)){
			validationMessages.push(xenos$NCM$i18n.transactionquery.validation.datefrom_invalid);
			mandatoryValidationFails =  true;
		}
		
		// Validate that Either Security or Currency has been be entered
		if(securityCode.length == 0 && currencyCode.length == 0 && !mandatoryValidationFails){
			validationMessages.push(xenos$NCM$i18n.transactionquery.validation.securityorcurrency_validation);
		}
		
		// Validate that Security and Currency have not been specifed together
		if(securityCode.length != 0 && currencyCode.length != 0 && !mandatoryValidationFails){
			validationMessages.push(xenos$NCM$i18n.transactionquery.validation.securityandcurrency_validation);
		}
		
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