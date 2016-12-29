//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $

xenos.ns.views.camSecurityIoEntry.validateSubmit = function (acctBalanceTypeVisibleFlag,$context){
	var validationMessages = [];			
	
	var secInDateStr = $('#secInDateStr',$context).val();
		if(VALIDATOR.isNullValue($.trim(secInDateStr))){
			validationMessages.push(xenos$CAM$i18n.secIO.secindate_empty_new);
			}
		else{
			if(isDateCustom($.trim(secInDateStr))== false){
				validationMessages.push(xenos$CAM$i18n.secIO.date_format_check +" "+ $.trim(secInDateStr));
			}
		}
	

	var spotCalculationDate = $.trim($('#spotCalculationDateStr',$context).val());
			if(spotCalculationDate != 'null' && spotCalculationDate != ''){
				if(isDateCustom($.trim(spotCalculationDate))== false){
					validationMessages.push(xenos$CAM$i18n.secIO.date_format_check +" "+ $.trim(spotCalculationDate));
				}
			}
	if(VALIDATOR.isNullValue($.trim($('#tgtaccountNo',$context).val()))){
		validationMessages.push(xenos$CAM$i18n.secIO.accountno_empty_new);
	}
	if(VALIDATOR.isNullValue($.trim($('#tgtcustodianbank',$context).val()))){
		validationMessages.push(xenos$CAM$i18n.secIO.cutodianbank_empty_new);
	}
	if(VALIDATOR.isNullValue($.trim($('#tgtourSettleAccountNo',$context).val()))){
		validationMessages.push(xenos$CAM$i18n.secIO.oursettleac_empty_new);
	}			
	if(VALIDATOR.isNullValue($.trim($('#tgtsecurityCode',$context).val()))){
		validationMessages.push(xenos$CAM$i18n.secIO.seccode_empty_new);
	}
	if(VALIDATOR.isNullValue($.trim($('#amountStr',$context).val()))){
		validationMessages.push(xenos$CAM$i18n.secIO.quantity_empty_new);
	}
	if(VALIDATOR.isNullValue($.trim($('#secInReasonCode',$context).val()))){
		validationMessages.push(xenos$CAM$i18n.secIO.reason_empty_new);
	}

	if(VALIDATOR.isNullValue($.trim($('#bookValueStr',$context).val()))){
		validationMessages.push(xenos$CAM$i18n.secIO.bookvalue_empty_new);
	}
	
	var bookValueBc = $.trim($('#bookValueBc',$context).val());
	if((spotCalculationDate != 'null' && spotCalculationDate != '') && (bookValueBc == 'null' || bookValueBc == '')){
		validationMessages.push(xenos$CAM$i18n.secIO.spot_bookvalueBc_new);
	}
	/* <!-- Quantity Validation--> */
	var returnedValue = camSecurityIo$validateNegativeQuantity($('#amountStr').val());
	if(returnedValue == 'negative'){
		validationMessages.push(xenos$CAM$i18n.secIO.quantity_negative_new);
	}else if(returnedValue == 'notNumber'){
		validationMessages.push(xenos$CAM$i18n.secIO.quantity_valid_value);
	}else {
		if(returnedValue == 'both'){
			validationMessages.push(xenos$CAM$i18n.secIO.quantity_moreThan15_new);
			validationMessages.push(xenos$CAM$i18n.secIO.quantity_moreThan3_new);
		}
		else if(returnedValue == 'moreThan15BeforeDecimal'){
		validationMessages.push(xenos$CAM$i18n.secIO.quantity_moreThan15_new);
		}
		else if(returnedValue == 'moreThan3AfterDecimal'){
		validationMessages.push(xenos$CAM$i18n.secIO.quantity_moreThan3_new);
		}
	} 

	/* <!-- Accrued Int paid Lc validation--> */
	returnedValue = camSecurityIo$validateNegativeAccruedInterestPaidLc($('#accruedInterestPaidLc').val());
	if(returnedValue == 'negative'){
		validationMessages.push(xenos$CAM$i18n.secIO.accruedInterestPaidLc_negative_new);	
	}else if(returnedValue == 'notNumber'){
		validationMessages.push(xenos$CAM$i18n.secIO.accruedInstLc_valid_value);
	}else {
		if(returnedValue == 'both'){
			validationMessages.push(xenos$CAM$i18n.secIO.quantity_moreThan15_new);
			validationMessages.push(xenos$CAM$i18n.secIO.quantity_moreThan3_new);
		}
		else if(returnedValue == 'moreThan15BeforeDecimal'){
		validationMessages.push(xenos$CAM$i18n.secIO.quantity_moreThan15_new);
		}
		else if(returnedValue == 'moreThan3AfterDecimal'){
		validationMessages.push(xenos$CAM$i18n.secIO.quantity_moreThan3_new);
		}
	}

	/* <!-- Accrued Int paid Bc validation--> */
	returnedValue = camSecurityIo$validateNegativeAccruedInterestPaidBc($('#accruedInterestPaidBc').val());
	if(returnedValue == 'negative'){
		validationMessages.push(xenos$CAM$i18n.secIO.accruedInterestPaidBc_negative_new);	
	}else if(returnedValue == 'notNumber'){
		validationMessages.push(xenos$CAM$i18n.secIO.accruedInstBc_valid_value);
	}else {
		if(returnedValue == 'both'){
			validationMessages.push(xenos$CAM$i18n.secIO.quantity_moreThan15_new);
			validationMessages.push(xenos$CAM$i18n.secIO.quantity_moreThan3_new);
		}
		else if(returnedValue == 'moreThan15BeforeDecimal'){
		validationMessages.push(xenos$CAM$i18n.secIO.quantity_moreThan15_new);
		}
		else if(returnedValue == 'moreThan3AfterDecimal'){
		validationMessages.push(xenos$CAM$i18n.secIO.quantity_moreThan3_new);
		}
	}

	/* <!-- Book Value Bc validation--> */
	returnedValue = camSecurityIo$validateNegativeBookValueBc($('#bookValueBc').val());
	if(returnedValue == 'negative'){
		validationMessages.push(xenos$CAM$i18n.secIO.bookValueBc_negative_new);	
	}else if(returnedValue == 'notNumber'){
		validationMessages.push(xenos$CAM$i18n.secIO.bookValueBc_valid_value);
	}else {
		if(returnedValue == 'both'){
			validationMessages.push(xenos$CAM$i18n.secIO.quantity_moreThan15_new);
			validationMessages.push(xenos$CAM$i18n.secIO.quantity_moreThan3_new);
		}
		else if(returnedValue == 'moreThan15BeforeDecimal'){
		validationMessages.push(xenos$CAM$i18n.secIO.quantity_moreThan15_new);
		}
		else if(returnedValue == 'moreThan3AfterDecimal'){
		validationMessages.push(xenos$CAM$i18n.secIO.quantity_moreThan3_new);
		}
	}
	/* <!-- Book Value Lc validation--> */
	returnedValue = camSecurityIo$validateNegativeBookValueLc($('#bookValueStr').val());
	if(returnedValue == 'negative'){
		validationMessages.push(xenos$CAM$i18n.secIO.bookValueLc_negative_new);	
	}else if(returnedValue == 'notNumber'){
		validationMessages.push(xenos$CAM$i18n.secIO.bookValueLc_valid_value);
	}else {
		if(returnedValue == 'both'){
			validationMessages.push(xenos$CAM$i18n.secIO.quantity_moreThan15_new);
			validationMessages.push(xenos$CAM$i18n.secIO.quantity_moreThan3_new);
		}
		else if(returnedValue == 'moreThan15BeforeDecimal'){
		validationMessages.push(xenos$CAM$i18n.secIO.quantity_moreThan15_new);
		}
		else if(returnedValue == 'moreThan3AfterDecimal'){
		validationMessages.push(xenos$CAM$i18n.secIO.quantity_moreThan3_new);
		}
	}
	if ( validationMessages.length >0){  
		xenos.utils.displayGrowlMessage(xenos.notice.type.error, validationMessages);
		return false;
	}else{
		xenos.utils.clearGrowlMessage();
	}
	if(acctBalanceTypeVisibleFlag == 'true'){					
		$('#acctBalanceTypeVisibleFlag',$context).val('0');
	}
	return true;
					
}