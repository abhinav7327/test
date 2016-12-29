//$Id$
//$Author: nitesha $
//$Date: 2016-12-23 17:22:58 $




function xenos$ns$views$tradeEntry$validateValueDate(validationMessages){

	var valueDate  = $('#valueDate').val();

	if(valueDate.length>0 && isDateCustom(valueDate)==false) {
		validationMessages.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeEntry.invalid_entry.date_format_check, [valueDate]));
	}
}

function xenos$ns$views$tradeEntry$validateQuantity(validationMessages){

	var quantity = $('#quantity').val();

	if(VALIDATOR.isNullValue(quantity)){
		validationMessages.push(xenos$TRD$i18n.tradeEntry.generalinfo.quantity_empty);	
	} else {
		formatQuantity($('#quantity'),15,3,validationMessages,$('#quantity').parent().parent().find('label').text());	
	}
}
 
function xenos$ns$views$tradeEntry$validateInputPrice(validationMessages){

	var inputPrice = $('#inputPrice').val();
	if(VALIDATOR.isNullValue(inputPrice)){
		validationMessages.push(xenos$TRD$i18n.tradeEntry.generalinfo.inputprice_notempty);	
	} else {
		formatPrice($('#inputPrice'),9,9,validationMessages,$('#inputPrice').parent().parent().find('label').text());
	}
}

function xenos$ns$views$tradeEntry$validateInputPriceFormat(validationMessages){
	var inputPrice = $('#inputPriceFormat').val();
	if(VALIDATOR.isNullValue(inputPrice)){
		validationMessages.push(xenos$TRD$i18n.tradeEntry.generalinfo.inputpriceformat_missing);	
	}
}
   function xenos$ns$views$tradeEntry$validateTradeTime(validationMessages){
 
	var tradeTime = $('#tradeTime').val();
	
	var m = 0;
	var s = 0;
	
	if (tradeTime.length == 8){
		m = 3;
		s = 6;
		if ((tradeTime.charAt(2) != ":") || (tradeTime.charAt(5) != ":")){ 
			validationMessages.push(xenos$TRD$i18n.tradeEntry.tradetime.invalid_eight);
		}
	}else if (tradeTime.length == 6){
		m = 2;
		s = 4;
		if (isNaN(tradeTime)){
			validationMessages.push(xenos$TRD$i18n.tradeEntry.tradetime.invalid_six);
		}
	  }else if (tradeTime.length == 5){
		  m = 3;
		  if (tradeTime.charAt(2) != ":"){
			validationMessages.push(xenos$TRD$i18n.tradeEntry.tradetime.invalid_five);
		  }
	  }else if (tradeTime.length == 4){ 
		m = 2;
		if (parseInt(tradeTime)==0){
			validationMessages.push(xenos$TRD$i18n.tradeEntry.tradetime.invalid_four);
		}
	  }/* else {
		validationMessages.push(xenos$TRD$i18n.tradeEntry.tradetime.error);
	  } */

	 if(tradeTime != null && tradeTime != ""){
	  //------hours validation------------
		 var strHH = tradeTime.charAt(0) + tradeTime.charAt(1);
		 var numHH = parseInt(strHH);
		 if (isNaN(numHH)){
			validationMessages.push(xenos$TRD$i18n.tradeEntry.tradetime.nonnumeric_hour);
		  } 
		 if (numHH > 23){
			validationMessages.push(xenos$TRD$i18n.tradeEntry.tradetime.notvalid_hour);
		  }
		
		 //------minutes validation------------
		 var strMM = tradeTime.charAt(m) + tradeTime.charAt(m+1);
		 var numMM = parseInt(strMM);
		 if (isNaN(numMM)){
			validationMessages.push(xenos$TRD$i18n.tradeEntry.tradetime.nonnumeric_minute);
		  } 
		 if (numMM > 59){
			validationMessages.push(xenos$TRD$i18n.tradeEntry.tradetime.notvalid_minute);
		  }
		
		 //------seconds validation------------
		 var strSS = '00';
		 if ((tradeTime.length == 8) || (tradeTime.length == 6)){
			strSS = tradeTime.charAt(s) + tradeTime.charAt(s+1);
			var numSS = parseInt(strSS);
			if (isNaN(numSS)){
				validationMessages.push(xenos$TRD$i18n.tradeEntry.tradetime.nonnumeric_second);
			}
		   if (numSS > 59){
				validationMessages.push(xenos$TRD$i18n.tradeEntry.tradetime.notvalid_second);
		   }
		  }
	}
 }
 
function xenos$ns$views$tradeEntry$validateIndexRatio(validationMessages){

	var indexRatio = $('#indexratioStr').val();

	if(!VALIDATOR.isNullValue(indexRatio)){
		formatRate($('#indexratioStr'),8,10,validationMessages,$('#indexratioStr').parent().parent().find('label').text());
	}
} 

function xenos$ns$views$tradeEntry$validateExchangeRate(validationMessages){
	if(!VALIDATOR.isNullValue($('#exchangeRate').val())){
		formatExchangeRate($('#exchangeRate'),10,10, validationMessages,$('#exchangeRate').parent().parent().find('label').text());
	}
}
	
 
xenos$ns$views$tradeEntry$validateGeneralSubmit = function(){

	var validationMessages = [];	
	
	var buySell  = $('#buySellOrientation').val();
	var tradeDate  = $('#tradeDate').val();
	
	var inventoryAccountNo 	= $('#tgtinventoryaccountno').val();
	var brokerAccount 		= $('#tgtbrokeraccountno').val();
	var securityInfo 		= $('#tgtsecurityCode').val();	
	
	var dateFormatValidationFails = false;
	
	if(VALIDATOR.isNullValue(buySell)){
		validationMessages.push(xenos$TRD$i18n.tradeEntry.generalinfo.buysellflag_empty);
	}
	
	if(VALIDATOR.isNullValue(tradeDate)){
		validationMessages.push(xenos$TRD$i18n.tradeEntry.generalinfo.tradedate_empty);
	}
		
	if(VALIDATOR.isNullValue(inventoryAccountNo)){
		validationMessages.push(xenos$TRD$i18n.tradeEntry.generalinfo.inventory_empty);
	}
	
	if(VALIDATOR.isNullValue(brokerAccount)){
		validationMessages.push(xenos$TRD$i18n.tradeEntry.generalinfo.accountno_empty);
	}
	
	if(VALIDATOR.isNullValue(securityInfo)){
		validationMessages.push(xenos$TRD$i18n.tradeEntry.generalinfo.security_empty);
	}
	
	xenos$ns$views$tradeEntry$validateQuantity(validationMessages);
	
	xenos$ns$views$tradeEntry$validateInputPrice(validationMessages);
	
	xenos$ns$views$tradeEntry$validateInputPriceFormat(validationMessages);
	
	xenos$ns$views$tradeEntry$validateExchangeRate(validationMessages);
	
	xenos$ns$views$tradeEntry$validateIndexRatio(validationMessages);	
	
	if(tradeDate.length > 0 && isDateCustom(tradeDate)==false) {
		validationMessages.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeEntry.invalid_entry.date_format_check, [tradeDate]));
	}
	
	xenos$ns$views$tradeEntry$validateValueDate(validationMessages);

	xenos$ns$views$tradeEntry$validateTradeTime(validationMessages);
	
	
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
 
 function xenos$ns$views$tradeEntry$callTradeTime(e){

	var timeVal = e.value;
	var hh = "";
	var mm = "";
	var ss = "";

	if(timeVal.length == 0){
		var dt = new Date();
		hh = dt.getHours().toString();
		if(dt.getHours()<10){
			hh = "0" + hh ;
		}
		mm = dt.getMinutes().toString();
		if(dt.getMinutes()<10){
			mm = "0" + mm ;
		}
		ss = dt.getSeconds().toString();
		if(dt.getSeconds()<10){
		  ss = "0" + ss ;
		}
		timeVal = hh +":" + mm + ":" +ss ;
		e.value = timeVal;
	}
}

//This method does client side validation before navigating to user confirmation
xenos$ns$views$tradeEntry$validateDetailSubmit = function(){
	var validationMessages = [];	
	
	var remarks					  = $("#remarks").val();
	var accruedInterestAmount	  = $("#accruedInterestAmount").val();
	var accruedDays				  = $("#accruedDays").val();
	var accruedStartDate		  = $("#accruedStartDate").val();
	
	xenos$ns$views$tradeEntry$validateQuantity(validationMessages);
	
	xenos$ns$views$tradeEntry$validateInputPrice(validationMessages);
	
	xenos$ns$views$tradeEntry$validateInputPriceFormat(validationMessages);
	
	xenos$ns$views$tradeEntry$validateExchangeRate(validationMessages);
	
	xenos$ns$views$tradeEntry$validateIndexRatio(validationMessages);
	
	if(VALIDATOR.isNullValue(remarks)){
		validationMessages.push(xenos$TRD$i18n.tradeEntry.detailinfo.remarks);
	}	
	
	if(VALIDATOR.isNullValue(accruedInterestAmount)){
		//validationMessages.push(xenos$TRD$i18n.tradeEntry.generalinfo.accruedInterestAmount_empty);	
	} else {
		formatAccruedInterestAmount($('#accruedInterestAmount'),15,3,validationMessages,$('#accruedInterestAmount').parent().parent().find('label').text());	
	}
	
	if(VALIDATOR.isNullValue(accruedDays)){
		//validationMessages.push(xenos$TRD$i18n.tradeEntry.generalinfo.accruedDays_notempty);	
	} else {
		formatAccruedDays($('#accruedDays'),5,0,validationMessages,$('#accruedDays').parent().parent().find('label').text());
	}
	
	xenos$ns$views$tradeEntry$validateValueDate(validationMessages);
	
	if(accruedStartDate.length > 0 && isDateCustom(accruedStartDate)==false) {
		validationMessages.push(xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeEntry.invalid_entry.date_format_check, [accruedStartDate]));
	}
	
	xenos$ns$views$tradeEntry$validateTradeTime(validationMessages);
	
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

xenos$ns$views$tradeSummaryQuery$formatCustomDate = function(date){
	if(date.value.length == 7){
		if(date.id=="tradeDate"){
			$("#tradeDate").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		
		if(date.id=="valueDate"){
			$("#valueDate").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		
		if(date.id=="accruedStartDate"){
			$("#accruedStartDate").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
	}
}