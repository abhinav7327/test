//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $





/**
 * This method will be called for basic validations for the submit button of Exchange Rate Query page.
 */
 
 xenos.ns.views.refExchangeRateQuery.validateSubmit = function() {
		var validationMessages = [];
		var exchangeRateStr = $('#exchangeRateStr').get(0);
		if(exchangeRateStr){
			var status = refExchangeRateFormat(exchangeRateStr, 10, 10);
			if(status == false){
				validationMessages.push(xenos$REF$i18n.exchangerate.basicinfo.rate_invalid);
			}
		}
	if (validationMessages.length > 0){
				 xenos.postNotice(xenos.notice.type.error, validationMessages);
				 return false;
			}
	return true;
};

function refExchangeRateFormat(object,digitBeforeDecimalPoint,digitAfterDecimalPoint){
			var val = object.value;
			if(val != null && val.length > 0){
				val = getNumericValue(val);
				if(val == null)
				{
					return false;
					object.focus();
				}
				var status = formatQuantityOrAmount(object,digitBeforeDecimalPoint,digitAfterDecimalPoint);
				if(status == false){
					return false;
			}
			}
			return true;
}

function formatInputExchangeRate(fieldObject, fieldName, digitBeforeDecimalPoint,digitAfterDecimalPoint){
	var amount = fieldObject.value;
	amount = getNumericValue(amount);
	if(amount == null)
	{
		fieldObject.focus();
		return false;
	}
	fieldObject.value = amount;
	return formatQuantityOrAmount(fieldObject,digitBeforeDecimalPoint,digitAfterDecimalPoint);
	
}