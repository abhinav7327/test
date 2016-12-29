//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos.ns.views.camMovementQry.validateSubmit = function(){
		var dateFrom  = $('#dateFrom').val();
		var dateTo    = $('#dateTo').val();
		var movementBasis  = $('#movementBasis').val();
		var accountNo  = $('#accountNo').val();
		var securityCode  = $('#securityCode').val();
		var instrumentType = $('#instrumentType').val();
		var appUpdDate  = $('#appUpdDate').val();
		
		var mandatoryValidationFails = false;
		var validationMessages = [];
		
		if(VALIDATOR.isNullValue($.trim(movementBasis))){
			validationMessages.push(xenos$CAM$i18n.movementquery.validation.movementbasis_empty);
			mandatoryValidationFails = true;
		}		
		
		// enter both to and from date
		if(VALIDATOR.isNullValue($.trim(dateFrom)) && VALIDATOR.isNullValue($.trim(dateTo))){
			validationMessages.push(xenos$CAM$i18n.movementquery.validation.date_empty);
			mandatoryValidationFails =  true;
		}
		
		// Validate to date
		if(!VALIDATOR.isNullValue($.trim(dateTo)) && !isDateCustom(dateTo)){
			validationMessages.push(xenos$CAM$i18n.movementquery.validation.dateto_invalid);
			mandatoryValidationFails =  true;
		}
		
		// Validate from date
		if(!VALIDATOR.isNullValue($.trim(dateFrom)) && !isDateCustom(dateFrom)){
			validationMessages.push(xenos$CAM$i18n.movementquery.validation.datefrom_invalid);
			mandatoryValidationFails =  true;
		}
		
		// From date should be less than To date
		if((isDateCustom(dateFrom) && isDateCustom(dateTo)) &&  !isValidDateRange(dateFrom, dateTo)){
			validationMessages.push(xenos$CAM$i18n.movementquery.validation.datefrom_less);
			mandatoryValidationFails =  true;
		}
		
		
		// empty check - from date
		if(dateTo.length > 0 && dateFrom.length == 0){
			validationMessages.push(xenos$CAM$i18n.movementquery.validation.date_empty);
			mandatoryValidationFails =  true;
		}
		
		// empty check -  to date
		if(dateFrom.length > 0 && dateTo.length == 0){
			validationMessages.push(xenos$CAM$i18n.movementquery.validation.date_empty);
			mandatoryValidationFails =  true;
		}
		
		
		// From date should be less than To date
		if((isDateCustom(dateFrom) && isDateCustom(dateTo)) &&  !isValidDateRange(dateFrom, dateTo) && !mandatoryValidationFails){
			validationMessages.push(xenos$CAM$i18n.movementquery.validation.daterange_invalid);
			mandatoryValidationFails =  true;
		}
		

		
		// enter both to and from date
		if(!VALIDATOR.isNullValue($.trim(appUpdDate)) && !isDateCustom(appUpdDate)){
			validationMessages.push(xenos$CAM$i18n.movementquery.validation.lastdate_invalid);
			mandatoryValidationFails =  true;
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