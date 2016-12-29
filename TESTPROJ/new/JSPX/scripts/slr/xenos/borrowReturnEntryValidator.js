//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $

  xenos.ns.views.borrowReturnEntry.validateSubmit = function(){

	var validationMessages = [];	
	
	var tradeDate  			= $('#tradeDate').val();
	var valueDate  			= $('#valueDate').val();
	var fundAccountNo 		= $('#tgtinventoryAccountNo').val();
	var corpaction 			= $('#corpaction').val();
	var securitiesEntryGrid	= $('#securitiesEntryGrid').data().gridInstance.getData().getItems();
	
	if(VALIDATOR.isNullValue(tradeDate)){
		validationMessages.push(xenos$SLR$i18n.borrowreturnentry.trade_date_empty);
	} else if(isDateCustom(tradeDate)==false) {
		validationMessages.push(xenos.utils.evaluateMessage(xenos$SLR$i18n.borrowreturnentry.trade_date_invalid, [tradeDate]));
	}
	
	if(VALIDATOR.isNullValue(valueDate)){
		validationMessages.push(xenos$SLR$i18n.borrowreturnentry.value_date_empty);
	} else if(isDateCustom(valueDate)==false) {
		validationMessages.push(xenos.utils.evaluateMessage(xenos$SLR$i18n.borrowreturnentry.value_date_invalid, [valueDate]));
	}
	
	if(VALIDATOR.isNullValue(fundAccountNo)){
		validationMessages.push(xenos$SLR$i18n.borrowreturnentry.func_acc_no_empty);
	}
	
	if(VALIDATOR.isNullValue(corpaction)){
		validationMessages.push(xenos$SLR$i18n.borrowreturnentry.corporate_action_empty);
	}
	
	if(securitiesEntryGrid.length < 1){
		validationMessages.push(xenos$SLR$i18n.borrowreturnentry.securities_empty);
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
