//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $




var NUM_DIGITS_DEFAULT = 15;
var NUM_DECIMAL_DEFAULT = 3;

var NUM_DIGITS_AMOUNT = 15;
var NUM_DECIMAL_AMOUNT = 3;

var NUM_DIGITS_QUANTITY = 15;
var NUM_DECIMAL_QUANTITY = 3;

var NUM_DIGITS_PRICE = 9;
var NUM_DECIMAL_PRICE = 9;

var NUM_DIGITS_ACCINT = 10;
var NUM_DECIMAL_ACCINT = 3;

var NUM_DIGITS_TAXFEE = 12;
var NUM_DECIMAL_TAXFEE = 3;

var NUM_DIGITS_RATE = 3;
var NUM_DECIMAL_RATE = 5;

var NUM_DIGITS_EX_RATE 	= 10;
var NUM_DECIMAL_EX_RATE = 10;

var NUM_DIGITS_REF_EX_RATE = 9;
var NUM_DECIMAL_REF_EX_RATE = 8;


function doDateCheck(trade_from, trade_to, value_from, value_to)
{
	var strArray;
	var strFromDate;
	var strToDate;
	var strFromDate1;
	var strToDate1;

	strFromDate1 = trade_from.value;
     	strArray = strFromDate1.split("-");
	strFromDate = strArray[0] + " " + strArray[1] + " " +  strArray[2];//  Day, Month, Year

	strToDate1 = trade_to.value;
	strArray = strToDate1.split("-");
	strToDate = strArray[0] + " " + strArray[1] + " " +  strArray[2];//  Day, Month, Year

	if((strFromDate1 != "") && (strToDate1 != ""))
	{
     		if (Date.parse(strFromDate) > Date.parse(strToDate))
		{
			alert(xenos.i18n.utilcommonvalidationmessage.trade_date);
			return false;
		}
	}

	strFromDate1 = value_from.value;
	strArray = strFromDate1.split("-");
	strFromDate = strArray[0] + " " + strArray[1] + " " +  strArray[2];//  Day, Month, Year

	strToDate1 = value_to.value;
	strArray = strToDate1.split("-");
	strToDate = strArray[0] + " " + strArray[1] + " " +  strArray[2];//  Day, Month, Year

    	if((strFromDate1 != "") && (strToDate1!= ""))
	{
     		if (Date.parse(strFromDate) > Date.parse(strToDate)) {
			alert(xenos.i18n.utilcommonvalidationmessage.value_date);
			return false;
		}
    	}
    	return true;
}

/**
 * Function that will check if the value is a valid Integer.
 */
function checkIfInt(val)
{
	var length = val.length;
	var dotCount = 0;

	var i=0;
	var char = val.charAt(i);
	// Check if the first character is a '+' or '-'
	//if( (char == '+') || (char == '-') )
		//i++;
	
	for(; i<length; i++)
	{
		char = val.charAt(i);
	
		if( char < '0' || char > '9' )
		{
			return false; // If not a valid number
		}
	}
	
	return true; // Success
}

/**
 * Function that will check if the value is a valid Float.
 */
function checkIfFloat(val, msgArray,label)
{
	var length = val.length;
	var dotCount = 0;

	var i=0;
	var char = val.charAt(i);
	if(char == '-'){
		if(msgArray == null){
			xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos.i18n.error.negative_value,[label]));
		}else{
			msgArray.push(xenos.utils.evaluateMessage(xenos.i18n.error.negative_value,[label]));
		}
		return false;
	}
	// Check if the first character is a '+' or '-'
	//if( (char == '+') || (char == '-') )
		//i++;

	for(; i<length; i++)
	{
		char = val.charAt(i);

		if( char == '.')
		{
			dotCount++;
			if(dotCount > 1)
			{
				if(msgArray == null){
					xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos.i18n.error.decimal_dot_count,[label]));
				}else{
					msgArray.push(xenos.utils.evaluateMessage(xenos.i18n.error.decimal_dot_count,[label]));
				}
				return false;
			}
			continue;
		}

		if( char < '0' || char > '9')
		{
			if(msgArray == null){
				xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos.i18n.error.invalid_char,[label]));
			}else{
				msgArray.push(xenos.utils.evaluateMessage(xenos.i18n.error.invalid_char,[label]));
			}
			return false; // If not a valid number
		}
		
	}

	return true; // Success
}

/**
 * Function that will check if the value of Accrued Interest is a valid Float.
 */
function checkIfAccIntFloat(val)
{
	var length = val.length;
	var dotCount = 0;

	var i=0;
	var char = val.charAt(i);
	// Check if the first character is a '+' or '-'
	if( (char == '+') || (char == '-') )
		i++;

	for(; i<length; i++)
	{
		char = val.charAt(i);

		if( char == '.')
		{
			dotCount++;
			if(dotCount > 1)
			{
				return false;
			}
			continue;
		}

		if( char < '0' || char > '9')
		{
			return false; // If not a valid number
		}
	}

	return true; // Success
}

/**
 * Inserts "COMMA" in the appropriate position for quantity and amount fields.
 */
function formatQuantityOrAmount(fieldObject,digitBeforeDecimalPoint,digitAfterDecimalPoint, msgArray,label)
{
	var result = true;
	var qtyOrAmt = fieldObject.val();
	qtyOrAmt = qtyOrAmt.toString().replace(/\,/g,'');
	var decimalPos = qtyOrAmt.indexOf(".");
	
	if(decimalPos >= 0 && (qtyOrAmt.substr(decimalPos+1,qtyOrAmt.length-1).length == 0)){
		qtyOrAmt = qtyOrAmt.substr(0,decimalPos);
	}
	
	var leadingZero = 0;
	var i = 0;
	var nonzero = false;
	if(decimalPos < 0){
		for(; i < qtyOrAmt.length; i++){
			if(qtyOrAmt.charAt(i) != 0){
				nonzero = true;
				break;
			}
			leadingZero = leadingZero + 1;
		}
		if(leadingZero != 0 && nonzero == true){
			qtyOrAmt = qtyOrAmt.substr(leadingZero,qtyOrAmt.length-1);
		}
	}

	// check precision 
	result = checkPrecision(fieldObject,digitBeforeDecimalPoint,digitAfterDecimalPoint, msgArray,label);	
	
	if (digitBeforeDecimalPoint == null) 
	{
		digitBeforeDecimalPoint = NUM_DIGITS_DEFAULT;
	}
	
	if (digitAfterDecimalPoint == null) 
	{
		digitAfterDecimalPoint = NUM_DECIMAL_DEFAULT;
	}

	if(decimalPos >= 0)
	{
		var strBeforeDecimal = qtyOrAmt.substr(0,decimalPos);
		i = 0;
		var zeroStr = "";
		leadingZero = 0;
		//Escaping zeros from being formated if decimal point is present
		if(strBeforeDecimal.charAt(0) == 0){
			for(; i < strBeforeDecimal.length; i++){
				if(strBeforeDecimal.charAt(i) == 0){
					zeroStr = zeroStr + 0;
					leadingZero = leadingZero + 1;
				}else if(strBeforeDecimal.charAt(i) == ","){
					i = i +1;
				}else if(strBeforeDecimal.charAt(i) != 0){
					break;
				}
			}
		}	
		if(leadingZero != 0){
			strBeforeDecimal = strBeforeDecimal.substr(leadingZero,strBeforeDecimal.length-1);
		}
		
		//var strAfterDecimal = qtyOrAmt.substr(decimalPos, qtyOrAmt.length -1);
		// Modified by By Goutam
		var strAfterDecimal = qtyOrAmt.substr(decimalPos, qtyOrAmt.length );
		var i = strBeforeDecimal.length;

		var count = 0;
		var str = "";
		for(; i > 0; i--)
		{
			char = strBeforeDecimal.charAt(i-1);
			str = char + str;

			count++;
			if(count == 3)
			{
				str = "," + str;
				count = 0;
			}
		}
		char = str.charAt(0);
		if(char == ",")
		{
			fieldObject.val(str.substr(1,str.length-1) + strAfterDecimal);
		}
		else if(char == "-")
		{
			if(str.charAt(1) == ",")
			{
				fieldObject.val(str.charAt(0) + str.substr(2,str.length-1) + strAfterDecimal);
			}
			else
			{
				fieldObject.val(str + strAfterDecimal);
			}
		}
		else
		{
			fieldObject.val(str + strAfterDecimal);
		}
	}
	else
	{
		var qtyOrAmtLength = qtyOrAmt.length;
		var i=qtyOrAmtLength;
		var j = i;
		var count = 0;
		var str = "";
		nonzero = false;
		for(; i > 0; i--){
			if(qtyOrAmt.charAt(i-1) != 0){
				nonzero = true;
			}
		}
		for(; j > 0; j--)
		{
			char = qtyOrAmt.charAt(j-1);
			str = char + str;
			count++;
			if(count == 3 && nonzero == true)
			{
				str = "," + str;
				count = 0;
			}
		}
		char = str.charAt(0);
		if(char == ",")
		{
			fieldObject.val(str.substr(1,str.length-1));
		}
		else if(char == "-")
		{
			if(str.charAt(1) == ",")
			{
				fieldObject.val(str.charAt(0) + str.substr(2,str.length-1));
			}
			else
			{
				fieldObject.val(str);
			}
		}
		else
		{
			fieldObject.val(str);
		}
	}
	return result;

}

/**
 * This is used to format any amount. Replaces B, M or T by equivalent amount.
 * Inserts "COMMA" in the appropriate positions for better readability.
 */
function formatAmount(fieldObject, digitBeforeDecimalPoint, digitAfterDecimalPoint, msgArray,label)
{
	var flag = false;
	var amount = fieldObject.val();
	if(isBlank(amount))
		return true;

	if (digitBeforeDecimalPoint == null) 
	{
		digitBeforeDecimalPoint = NUM_DIGITS_AMOUNT;
	}

	if (digitAfterDecimalPoint == null) 
	{
		digitAfterDecimalPoint = NUM_DECIMAL_AMOUNT;
	}
		
	amount = getNumericValue(amount, digitBeforeDecimalPoint,msgArray, label);
	if(amount == null)
	{
		return false;
	}
	
	fieldObject.val(amount);
	
	return formatQuantityOrAmount(fieldObject,digitBeforeDecimalPoint,digitAfterDecimalPoint, msgArray,label);
}

/**
 * This is used to format any amount. Replaces B, M or T by equivalent quantity.
 * Inserts "COMMA" in the appropriate positions for better readability.
 */
function formatQuantity(fieldObject, digitBeforeDecimalPoint,digitAfterDecimalPoint, msgArray,label)
{
	var quantity = fieldObject.val();
	if(isBlank(quantity))
		return false;

	if (digitBeforeDecimalPoint == null) 
	{
		digitBeforeDecimalPoint = NUM_DIGITS_QUANTITY;
	}
	
	if (digitAfterDecimalPoint == null) 
	{
		digitAfterDecimalPoint = NUM_DECIMAL_QUANTITY;
	}
	
	quantity = getNumericValue(quantity, digitBeforeDecimalPoint,msgArray, label);
	if(quantity == null)
	{		
		return false;
	}
	fieldObject.val(quantity);
	
	return formatQuantityOrAmount(fieldObject,digitBeforeDecimalPoint,digitAfterDecimalPoint, msgArray,label);
}

/**
 * This is for the tradeGeneralEntry.jspx
 * Inserts "COMMA" in the appropriate positions for better readability.
 */
function formatAccruedDays(fieldObject,digitBeforeDecimalPoint,digitAfterDecimalPoint,msgArray,label)
{
	return formatQuantity(fieldObject, digitBeforeDecimalPoint,digitAfterDecimalPoint,msgArray,label);
}

/**
 * This is for the tradeDataEntry.jsp, tradeExecEntry.jsp and tradeTaxEntry.jsp,
 * Inserts "COMMA" in the appropriate position for price field
 */
function formatPrice(fieldObject, digitBeforeDecimalPoint,digitAfterDecimalPoint, msgArray, label)
{
	var flag = false;
	if (digitBeforeDecimalPoint == null) 
	{
		digitBeforeDecimalPoint = NUM_DIGITS_PRICE;
	}
	
	if (digitAfterDecimalPoint == null) 
	{
		digitAfterDecimalPoint = NUM_DECIMAL_PRICE;
	}
	
	return formatAmount(fieldObject, digitBeforeDecimalPoint,digitAfterDecimalPoint,msgArray,label);
}


/**
 * This is for the tradeDataEntry.jsp, tradeExecEntry.jsp and tradeTaxEntry.jsp,
 * Inserts "COMMA" in the appropriate position for Principal Amount field
 */
function formatPrincipalAmount(fieldObject,digitBeforeDecimalPoint,digitAfterDecimalPoint,msgArray,label)
{
	return formatAmount(fieldObject, digitBeforeDecimalPoint,digitAfterDecimalPoint,msgArray,label);
}

/**
 * This is for the tradeDataEntry.jsp, tradeExecEntry.jsp and tradeTaxEntry.jsp,
 * Inserts "COMMA" in the appropriate position for Net Amount field
 */
function formatNetAmount(fieldObject, digitBeforeDecimalPoint, digitAfterDecimalPoint,msgArray,label)
{
	return formatAmount(fieldObject, digitBeforeDecimalPoint,digitAfterDecimalPoint, msgArray,label);
}

/**
 * This is for the tradeDataEntry.jsp, tradeExecEntry.jsp and tradeTaxEntry.jsp,
 * Inserts "COMMA" in the appropriate position for Accrued Interest Amount field
 */
function formatAccruedInterestAmount(fieldObject, digitBeforeDecimalPoint, digitAfterDecimalPoint, msgArray,label)
{
	if (digitBeforeDecimalPoint == null) 
	{
		digitBeforeDecimalPoint = NUM_DIGITS_ACCINT;
	}
	
	if (digitAfterDecimalPoint == null) 
	{
		digitAfterDecimalPoint = NUM_DECIMAL_ACCINT;
	}

	return formatAmount(fieldObject, digitBeforeDecimalPoint,digitAfterDecimalPoint, msgArray,label);
}


/**
 * This is for the tradeTaxEntry.jsp,
 * Inserts "COMMA" in the appropriate position for Tax/Fee Amount field
 */
function formatTaxFeeAmount(fieldObject, digitBeforeDecimalPoint, digitAfterDecimalPoint, msgArray,label)
{
	if (digitBeforeDecimalPoint == null) 
	{
		digitBeforeDecimalPoint = NUM_DIGITS_TAXFEE;
	}
	
	if (digitAfterDecimalPoint == null) 
	{
		digitAfterDecimalPoint = NUM_DECIMAL_TAXFEE;
	}

	return formatAmount(fieldObject, digitBeforeDecimalPoint, digitAfterDecimalPoint, msgArray,label);
}



/**
 * This is for the accntTaxEntry.jsp
 * Inserts "COMMA" in the appropriate position for Rate field
 */
function formatRate(fieldObject, digitBeforeDecimalPoint,digitAfterDecimalPoint,msgArray,label)
{
	if (digitBeforeDecimalPoint == null) 
	{
		digitBeforeDecimalPoint = NUM_DIGITS_RATE;
	}
	
	if (digitAfterDecimalPoint == null) 
	{
		digitAfterDecimalPoint = NUM_DECIMAL_RATE;
	}	

	return formatAmount(fieldObject, digitBeforeDecimalPoint, digitAfterDecimalPoint,msgArray,label);
}

function formatExchangeRate(fieldObject, digitBeforeDecimalPoint,digitAfterDecimalPoint,msgArray,label)
{
	if (digitBeforeDecimalPoint == null) 
	{
		digitBeforeDecimalPoint = NUM_DIGITS_EX_RATE;
	}
	
	if (digitAfterDecimalPoint == null) 
	{
		digitAfterDecimalPoint = NUM_DECIMAL_EX_RATE;
	}	

	return formatAmount(fieldObject, digitBeforeDecimalPoint, digitAfterDecimalPoint, msgArray,label);
}



function formatSignedQuantity(fieldObject, digitBeforeDecimalPoint, digitAfterDecimalPoint,msgArray,label)
{
	var quantity = fieldObject.val();
	var returnVal= false;
	if(quantity == null || quantity.length == 0)
		return returnVal;
	
	var sign = quantity.charAt(0);
	if (sign == '-' || sign == '+')
	{
		fieldObject.val(quantity.substr(1, quantity.length-1));
	}

	returnVal = formatQuantity(fieldObject, digitBeforeDecimalPoint, digitAfterDecimalPoint, msgArray, label);
	
	if (sign == '-')
	{
		fieldObject.val(sign + fieldObject.val());
	}
	return returnVal;
}

/**
 * This function formats the signed rate. (Supports the -ve rate)
 * If the value begins with +ve then it truncates the +ve sign and formats the rest value with proper comma.
 * If the value begins with -ve then it formats the value with proper comma and leaving the -ve as it is.
 * If digitBeforeDecimalPoint is not defined then by default it will be 3
 * If digitAfterDecimalPoint is not defined then by default it will be 5
 * Also Inserts "COMMA" in the appropriate position for the specified Rate field
 * Derived the Label Name internally
 */
function formatSignedRate(fieldObject, digitBeforeDecimalPoint, digitAfterDecimalPoint,msgArray,label)
{
	if (digitBeforeDecimalPoint == null) 
	{
		digitBeforeDecimalPoint = NUM_DIGITS_RATE;
	}
	
	if (digitAfterDecimalPoint == null) 
	{
		digitAfterDecimalPoint = NUM_DECIMAL_RATE;
	}

	var rate = fieldObject.val();
	if(rate == null || rate.length == 0)
		return false;
	
	var sign = rate.charAt(0);
	if (sign == '-' || sign == '+')
	{
		fieldObject.val(rate.substr(1, rate.length-1));
	}

	var isValid = formatAmount(fieldObject, digitBeforeDecimalPoint, digitAfterDecimalPoint, msgArray,label);
	if(isValid == false){
		//$(fieldObject).val("");
		return false;
	}
	
	if (sign == '-')
	{
		fieldObject.val(sign + fieldObject.val());
	}
	return true;
}


/**
 * This method takes care of formatting the passed in number
 * by placing comma appropriately after every 3 digits.
 * @returns Newly generated number
 */
function commaSplit(srcNumber)
{
	var txtNumber = '' + srcNumber;
	if (isNaN(txtNumber) || txtNumber == "")
	{
		alert(xenos.i18n.utilcommonvalidationmessage.non_valid_num);
		return false;
	}
	else
	{
		var rxSplit = new RegExp('([0-9])([0-9][0-9][0-9][,.])');
		var arrNumber = txtNumber.split('.');
		arrNumber[0] += '.';
		do
		{
			arrNumber[0] = arrNumber[0].replace(rxSplit, '$1,$2');
		}
		while (rxSplit.test(arrNumber[0]));
		if (arrNumber.length > 1)
		{
			return arrNumber.join('');
		}
		else
		{
			return arrNumber[0].split('.')[0];
      	}
	}
}


/**
 * Function that will remove the leading and trailing spaces.
 */
function trim(str)
{
	return( rtrim(ltrim(str)));
}


/**
 * Function that will remove the trailing spaces.
 */
function rtrim(str)
{
	re = /(\s+)$/;
	return str.replace(re, "");
}


/**
 * Function that will remove the leading spaces.
 */
function ltrim(str)
{
	re = /^(\s+)/;
	return str.replace(re, "");
}

/**
 * Check whether the number is valid or not and return the numeric portion.
 */
function getValidNumber(number, pos,msgArray,label)
{
	var strBeforeBMT = number.substr(0, pos);
	var strAfterBMT = number.substr(pos+1, number.length-1);
	
	if(number.length == 1 && pos == 0){
		strBeforeBMT = number;
	}
	if(!checkIfFloat(strBeforeBMT, msgArray,label)){
		return null;
	}
	
	if((strBeforeBMT == null || strBeforeBMT.length == 0) || (strAfterBMT != null && strAfterBMT.length > 0)){
		if(msgArray == null){
			// xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos.i18n.error.invalid_BMT,[label]));
			xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos.i18n.error.invalid_char,[label]));
		}else{
			// msgArray.push(xenos.utils.evaluateMessage(xenos.i18n.error.invalid_BMT,[label]));
			msgArray.push(xenos.utils.evaluateMessage(xenos.i18n.error.invalid_char,[label]));
		}
		return null;
	}

	return strBeforeBMT;
}


/**
 * Get numeric value of the given field.
 */
function getNumericValue(number, lengthBeforeDecimal, msgArray, label)
{
	number = trim(number.toUpperCase().replace(/\,/g,""));
	if(number.length == 0)
		return null;
		
	var posOfB = -1;
	posOfB = number.indexOf("B");
	var posOfM = -1;
	posOfM = number.indexOf("M");
	var posOfT = -1;
	posOfT = number.indexOf("T");

	var countBMT = 0;
	if(posOfB >= 0)
		countBMT ++;
	if(posOfM >= 0)
		countBMT ++;
	if(posOfT >= 0)
		countBMT ++;
	
	// If the 'b' is preceded by a character
	if(posOfB >= 1 && isNaN(number.charAt(posOfB - 1))){
	    if(msgArray == null){
	        xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos.i18n.error.invalid_char,[label]));
	    } else {
	        msgArray.push(xenos.utils.evaluateMessage(xenos.i18n.error.invalid_char,[label]));
	    }
	    return null; // If not a valid number
	}

	// At most one of B, M or T could exist
	if(countBMT > 1){
		if(msgArray == null){
			// xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos.i18n.error.invalid_BMT,[label]));
			xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos.i18n.error.invalid_char,[label]));
		}else{
			// msgArray.push(xenos.utils.evaluateMessage(xenos.i18n.error.invalid_BMT,[label]));
			msgArray.push(xenos.utils.evaluateMessage(xenos.i18n.error.invalid_char,[label]));
		}
		return null;
	}

	// Format Billion
	if(posOfB >= 0)
	{
		if(lengthBeforeDecimal < 10){
			if(msgArray == null){
				xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos.i18n.error.input_price,[label]));
			}else{
				msgArray.push(xenos.utils.evaluateMessage(xenos.i18n.error.input_price,[label]));
			}
			return null;
		}else{
			var validNumber = getValidNumber(number, posOfB,msgArray,label);
			if(validNumber == null)
				return null;
			number = validNumber * 1000000000;
		}		
	}
	else if(posOfM >= 0)
	{
		if(lengthBeforeDecimal < 7){
			if(msgArray == null){
				xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos.i18n.error.input_price,[label]));
			}else{
				msgArray.push(xenos.utils.evaluateMessage(xenos.i18n.error.input_price,[label]));
			}
			return null;
		}else{
			var validNumber = getValidNumber(number, posOfM,msgArray,label);
			if(validNumber == null)
				return null;
			number = validNumber * 1000000;
		}
	}
	else if(posOfT >= 0)
	{
		if(lengthBeforeDecimal < 4){
			if(msgArray == null){
				xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos.i18n.error.input_price,[label]));
			}else{
				msgArray.push(xenos.utils.evaluateMessage(xenos.i18n.error.input_price,[label]));
			}
			return null;
		}else{
			var validNumber = getValidNumber(number, posOfT,msgArray,label);
			if(validNumber == null)
				return null;
			number = validNumber * 1000;
		}
	}
	else
		number = getValidNumber(number, number.length,msgArray,label);

	return number;
}


function checkPrecision(objFld,digitBeforeDecimalPoint,digitAfterDecimalPoint, msgArray,label){
	var fldValueArr = new Array();
	var localObjFld;
	var fldLength=0;
	
	if(typeof(objFld)=="string" ){
		localObjFld = document.getElementById(objFld);		
		if(!localObjFld){
			if(msgArray == null){
				xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos.i18n.utilcommonvalidationmessage.obj_not_found,[label]));
			}else{
				msgArray.push(xenos.utils.evaluateMessage(xenos.i18n.utilcommonvalidationmessage.obj_not_found,[label]));
			}
			return false;
		}
	}
	
	if(typeof(objFld)=="object" ){
		localObjFld = objFld;
		if(!objFld){
			if(msgArray == null){
				xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos.i18n.utilcommonvalidationmessage.obj_not_found,[label]));
			}else{
				msgArray.push(xenos.utils.evaluateMessage(xenos.i18n.utilcommonvalidationmessage.obj_not_found,[label]));
			}
			return false;
		}
	}
		
	fldValueArr = localObjFld.val().split(".");
	//replace all , and -
	fldValueArr[0] = fldValueArr[0].toString().replace(/\,/g,'');
	fldValueArr[0] = fldValueArr[0].toString().replace(/\-/g,'');

	//beforePrecission check
	if(digitBeforeDecimalPoint){
		if(fldValueArr[0].length > digitBeforeDecimalPoint){
			if(msgArray == null){
				xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos.i18n.error.invalid_numsize,[digitBeforeDecimalPoint,label]));
			}else{
				msgArray.push(xenos.utils.evaluateMessage(xenos.i18n.error.invalid_numsize,[digitBeforeDecimalPoint,label]));
			}			
			return false;
		}
	}

	// afterPrecision Check	
	if (fldValueArr.length>1 ){       // decimal Point Present
		if(digitAfterDecimalPoint>=0){
			if(fldValueArr[1].length > digitAfterDecimalPoint){
				if(msgArray == null){
					xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos.i18n.error.invalid_decfraction,[digitAfterDecimalPoint,label]));
				}else{
					msgArray.push(xenos.utils.evaluateMessage(xenos.i18n.error.invalid_decfraction,[digitAfterDecimalPoint,label]));
				}
				return false;
			}
		}
	}
	return true;
}

function formAlertForValidField(fieldName,msgArray,label)
{
	msgArray.push(xenos.utils.evaluateMessage(xenos.i18n.message.invalid_values,[label]));
	return true;
}

function isBlank(str) {
	if(str == null || trim(str) == '')
		return true;
	return false;
}

function validateAmountOrQuantity(amountOrQuantityStr, lengthBeforeDecimal, lengthAfterDecimal,msgArray,label){
	var validationStatus;
	if(!isBlank(amountOrQuantityStr)){
		if (!lengthBeforeDecimal){
			lengthBeforeDecimal = NUM_DIGITS_DEFAULT;
		}
		if (!lengthAfterDecimal){
			lengthAfterDecimal = NUM_DECIMAL_DEFAULT;
		}
		var numericValue = getNumericValue(amountOrQuantityStr, lengthBeforeDecimal,msgArray,label);
		if(numericValue != null){
			var fldValueArr = new Array();
			fldValueArr = numericValue.split(".");
			if((fldValueArr[0].length > lengthBeforeDecimal) || (typeof fldValueArr[1] !='undefined' && fldValueArr[1].length > lengthAfterDecimal)){
				validationStatus='invalidLength';
			}
		}else{
			validationStatus='invalidAmountOrQuantity';
		}
	}
	return validationStatus;
}
/**
 * This method takes care of formatting the passed in String
 * to number and also removes comma appropriately.
 * Also, this will format the decimal part of the number based on the decimal digit provided.
 * If the decimal digit is not provided or is undefined then it will format the number without decimal.
 * If the Value passed is undefined then it returns Number(0)
 * @returns Newly generated number
 */
function unComma(val, dec){ 
	var newVal		= 0, 
		defaultVal	= 0,		
		dec		= (dec || 0);
	if ( !val )
		return defaultVal;
	val = val.toString().replace(/,/g, '');
	if ( !val )
		return defaultVal;
	newVal = parseFloat(val);
	if ( isNaN(newVal) )
		return defaultVal;
	newVal = +( newVal.toFixed(dec) );
	return ( newVal || defaultVal );
}
/**
 * This method append one 0 if the date entered is of 7 characters length
 * @param date
 * @param id
 */
function formatDate(date,id){
	if(date.length == 7){
	 id.val(date.substr(0,6)+"0"+date.substr(6));
   }
}