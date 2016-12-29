//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $



//Negative value check for quantity.
camSecurityIo$validateNegativeQuantity = function (tempQuantity){	
	var quantity = tempQuantity.replace(/\,/g,"");	
	if(quantity != ''){		
		if(isNaN(quantity)){
			return "notNumber";
		}else if(quantity < 0){			
			return "negative";
		}else if(quantity > 0){
			return camSecurityIo$precisionCheck(quantity);
		}
	}
	return "-1"; 
 }

//Negative value check for bookValueLc.
camSecurityIo$validateNegativeBookValueLc = function (tempBookValueLc){
	var bookValueLc = tempBookValueLc.replace(/\,/g,"");	
		if(bookValueLc != ''){		
			if(isNaN(bookValueLc)){
				return "notNumber";
			}else if(bookValueLc < 0){			
				return "negative";
			}else if(bookValueLc > 0){
				return camSecurityIo$precisionCheck(bookValueLc);
			}
		}
		return "-1";

}

//Negative value check for bookValueBc.
camSecurityIo$validateNegativeBookValueBc = function (tempBookValueBc){
	var bookValueBc = tempBookValueBc.replace(/\,/g,"");	
		if(bookValueBc != ''){		
			if(isNaN(bookValueBc)){
				return "notNumber";
			}else if(bookValueBc < 0){			
				return "negative";
			}else if(bookValueBc > 0){
				return camSecurityIo$precisionCheck(bookValueBc);
			}
		}
		return "-1";
}

//Negative value check for accruedInterestPaidLc.
camSecurityIo$validateNegativeAccruedInterestPaidLc = function (tempAccruedIntPaidLc){
	var accruedInterestPaidLc = tempAccruedIntPaidLc.replace(/\,/g,"");	
		if(accruedInterestPaidLc != ''){		
			if(isNaN(accruedInterestPaidLc)){
				return "notNumber";
			}else if(accruedInterestPaidLc < 0){			
				return "negative";
			}else if(accruedInterestPaidLc > 0){
				return camSecurityIo$precisionCheck(accruedInterestPaidLc);
			}
		}
		return "-1";
}

//Negative value check for accruedInterestPaidBc.
camSecurityIo$validateNegativeAccruedInterestPaidBc = function (tempAccruedInterestPaidBc){
	var accruedInterestPaidBc = tempAccruedInterestPaidBc.replace(/\,/g,"");	
		if(accruedInterestPaidBc != ''){		
			if(isNaN(accruedInterestPaidBc)){
				return "notNumber";
			}else if(accruedInterestPaidBc < 0){			
				return "negative";
			}else if(accruedInterestPaidBc > 0){
				return camSecurityIo$precisionCheck(accruedInterestPaidBc);
			}
		}
		return "-1";
}

//Method to check 15 digits before decimal and 3 digits after decimal.
camSecurityIo$precisionCheck = function (tempNumber){
	if(tempNumber != 'null' && tempNumber != ''){
		var number = tempNumber.replace(/\,/g,"");
		if(!isNaN(number)){			
			var countBeforeDecimal = number.split(".")[0]
			var countAfterDecimal = number.split(".")[1];
			if((countBeforeDecimal != 'null' && typeof(countBeforeDecimal) != 'undefined' && countBeforeDecimal.length > 15) && (countAfterDecimal != 'null' && typeof(countAfterDecimal) != 'undefined'  && countAfterDecimal.length > 3)){
				return "both";				
			}			
			if((countBeforeDecimal != 'null' && typeof(countBeforeDecimal) != 'undefined' && countBeforeDecimal.length > 15)){
				return "moreThan15BeforeDecimal";
			}
			if((countAfterDecimal != 'null' && typeof(countAfterDecimal) != 'undefined' && countAfterDecimal.length > 3)){
				return "moreThan3AfterDecimal";
			}
		}
	}
}

//Method to format date with 7 digits.
camSecurityIo$formateDate = function (date,id){
	if(date != 'null' && date != ' ' && typeof(date) != 'undefined' && id != 'null' && id != ' ' && typeof(id) != 'undefined'){
		if(date.length == 7){
			$("#"+id).val(date.substr(0,6)+"0"+date.substr(6));
		}	
	}
}

