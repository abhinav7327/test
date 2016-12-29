//$Id$
//$Author: madhumitab $
//$Date: 2016-12-23 17:43:52 $

 xenos.ns.views.derivativeTradeEntry.validateSubmit = function(){

	var validationMessages = [];	
	
	var securityCode  				= $('#securityCode').val();
	var openClosePosition  			= $('#openClosePosition').val();
	var tradeDate  					= $('#tradeDate').val();
	var valueDate  					= $('#valueDate').val();
	var fundAccountNo 				= $('#inventoryAccountNo').val();
	var executionOffice 			= $('#executionOffice').val();
	var executionBrokerAccountNo 	= $('#exeBrkAccountNo').val();
	var brokerAccountNo 			= $('#brkAccountNo').val();
	var price 						= $('#price').val();
	var quantity 					= $('#quantity').val();
	var instructionSuppressFlag 	= $('#inxSuppressFlag').val();
	
	if(VALIDATOR.isNullValue(securityCode)){
		validationMessages.push(xenos$DRV$i18n.derivativeTrade.entry.security_code_empty);
	}
	
	if(VALIDATOR.isNullValue(openClosePosition)){
		validationMessages.push(xenos$DRV$i18n.derivativeTrade.entry.open_close_pos_empty);
	}
	
	if(VALIDATOR.isNullValue(tradeDate)){
		validationMessages.push(xenos$DRV$i18n.derivativeTrade.entry.trade_date_empty);
	}
	
	if(VALIDATOR.isNullValue(fundAccountNo)){
		validationMessages.push(xenos$DRV$i18n.derivativeTrade.entry.fund_account_empty);
	}
	
	if(VALIDATOR.isNullValue(executionBrokerAccountNo)){
		validationMessages.push(xenos$DRV$i18n.derivativeTrade.entry.exe_broker_acct_empty);
	}
	
	if(VALIDATOR.isNullValue(brokerAccountNo)){
		validationMessages.push(xenos$DRV$i18n.derivativeTrade.entry.broker_account_empty);
	}
	
	if(VALIDATOR.isNullValue(price)){
		validationMessages.push(xenos$DRV$i18n.derivativeTrade.entry.price_empty);	
	}else {
		formatPrice($('#price'),9,9,validationMessages,$('#price').parent().parent().find('label').text());
	}
	
	if(VALIDATOR.isNullValue(quantity)){
		validationMessages.push(xenos$DRV$i18n.derivativeTrade.entry.quantity_empty);	
	}else {
		formatQuantity($('#quantity'),15,3,validationMessages,$('#quantity').parent().parent().find('label').text());	
	}
	
	if(tradeDate.length > 0 && isDateCustom(tradeDate)==false) {
		validationMessages.push(xenos.utils.evaluateMessage(xenos$DRV$i18n.derivativeTrade.entry.date_format_check, [tradeDate]));
	}
	
	if(valueDate.length>0 && isDateCustom(valueDate)==false) {
		validationMessages.push(xenos.utils.evaluateMessage(xenos$DRV$i18n.derivativeTrade.entry.date_format_check, [valueDate]));
	}
	
	if(!VALIDATOR.isNullValue($('#exchangeRate').val())){
		formatExchangeRate($('#exchangeRate'),10,10, validationMessages,$('#exchangeRate').parent().parent().find('label').text());
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
