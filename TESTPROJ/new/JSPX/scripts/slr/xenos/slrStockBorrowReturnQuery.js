//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos.ns.views.stockBorrowReturn.validateSubmit = function(){

		var tradeDateFrom  = $('#tradeDateFrom').val();
		var tradeDateTo    = $('#tradeDateTo').val();
		var valueDateFrom  = $('#valueDateFrom').val();
		var valueDateTo    = $('#valueDateTo').val();
		
		var validationFails = false;
		
		var validationMessages = [];

		// Validate Trade From Date
		if(!VALIDATOR.isNullValue($.trim(tradeDateFrom)) && !isDateCustom(tradeDateFrom)){
			validationMessages.push(xenos.utils.evaluateMessage(xenos$SLR$i18n.borrowreturnquery.validation.date_format_check,[tradeDateFrom]));
			validationFails =  true;
		}
		
		// Validate Trade To Date
		if(validationFails == false && !VALIDATOR.isNullValue($.trim(tradeDateTo)) && !isDateCustom(tradeDateTo)){
			validationMessages.push(xenos.utils.evaluateMessage(xenos$SLR$i18n.borrowreturnquery.validation.date_format_check,[tradeDateTo]));
			validationFails =  true;
		}
		
		// Validate Value From Date
		if(validationFails == false && !VALIDATOR.isNullValue($.trim(valueDateFrom)) && !isDateCustom(valueDateFrom)){
			validationMessages.push(xenos.utils.evaluateMessage(xenos$SLR$i18n.borrowreturnquery.validation.date_format_check,[valueDateFrom]));
			validationFails =  true;
		}
		
		// Validate Value To date
		if(validationFails == false && !VALIDATOR.isNullValue($.trim(valueDateTo)) && !isDateCustom(valueDateTo)){
			validationMessages.push(xenos.utils.evaluateMessage(xenos$SLR$i18n.borrowreturnquery.validation.date_format_check,[valueDateTo]));
			validationFails =  true;
		}
		
		// Trade From-To Date Range Check.
		if(validationFails == false && (isDateCustom(tradeDateFrom) && isDateCustom(tradeDateTo)) &&  !isValidDateRange(tradeDateFrom, tradeDateTo)){
			validationMessages.push(xenos$SLR$i18n.borrowreturnquery.validation.datefrom_less);
			validationFails =  true;
		}
		
		// Value From-To Date Range Check.
		if(validationFails == false && (isDateCustom(valueDateFrom) && isDateCustom(valueDateTo)) &&  !isValidDateRange(valueDateFrom, valueDateTo)){
			validationMessages.push(xenos$SLR$i18n.borrowreturnquery.validation.datefrom_less);
			validationFails =  true;
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