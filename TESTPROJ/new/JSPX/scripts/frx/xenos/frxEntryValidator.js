//$Id$
//$Author: Debojyoti Mukherjee $
//$Date: 2016-12-23 20:08:10 $
xenos.ns.views.frxTradeEntry.validateSubmit = function() {
	var validationMessages = [];

	var dateFormatValidationFails = false;

	var inventoryAccountNo = $('#tgtinventoryAccountNo').val();
	var accountNo = $('#tgtaccountNo').val();
	var tradeDate = $('#tradeDate').val();
	var valueDate = $('#valueDate').val();
	var baseCcy = $('#baseCcy').val();
	var againstCcy = $('#againstCcy').val();
	var baseCcyAmount = $('#baseCcyAmount').val();
	var againstCcyAmount = $('#againstCcyAmount').val();
	var exchangeRate = $('#exchangeRate').val();
	var tradeTime = $('#tradeTime').val();
	var calcMechanism = $('#calcMechanism').val();
	var spotDate = $('#spotDate').val();

	if ($('#tradeType').val() != "Non Deliverable Forward") {

		if (VALIDATOR.isNullValue(inventoryAccountNo)) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.mandatory.fund_acc_empty);
		}
		if (VALIDATOR.isNullValue(accountNo)) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.mandatory.counter_acc_empty);
		}
		if (VALIDATOR.isNullValue(tradeDate)) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.mandatory.trade_date_empty);
		}
		if (VALIDATOR.isNullValue(valueDate)) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.mandatory.value_date_empty);
		}
		if (VALIDATOR.isNullValue(baseCcy)) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.mandatory.buy_ccy_empty);
		}
		if (VALIDATOR.isNullValue(againstCcy)) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.mandatory.sell_ccy_empty);
		}
		if (VALIDATOR.isNullValue(exchangeRate)
				&& VALIDATOR.isNullValue(baseCcyAmount)
				&& VALIDATOR.isNullValue(againstCcyAmount)) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.mandatory.buy_sell_empty_check);
		}
		if (!VALIDATOR.isNullValue(exchangeRate)
				&& (VALIDATOR.isNullValue(baseCcyAmount) && VALIDATOR
						.isNullValue(againstCcyAmount))) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.mandatory.buy_sell_empty_check);
		}
		if (!VALIDATOR.isNullValue(baseCcyAmount)
				&& (VALIDATOR.isNullValue(exchangeRate) && VALIDATOR
						.isNullValue(againstCcyAmount))) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.mandatory.buy_sell_empty_check);
		}
		if (!VALIDATOR.isNullValue(againstCcyAmount)
				&& (VALIDATOR.isNullValue(exchangeRate) && VALIDATOR
						.isNullValue(baseCcyAmount))) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.mandatory.buy_sell_empty_check);
		}
		if (!VALIDATOR.isNullValue(exchangeRate)
				&& VALIDATOR.isNullValue(calcMechanism)) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.mandatory.calcMechanism_empty);
		}

	} else {
		if (VALIDATOR.isNullValue(inventoryAccountNo)) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.mandatory.fund_acc_empty);
		}
		if (VALIDATOR.isNullValue(accountNo)) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.mandatory.counter_acc_empty);
		}
		if (VALIDATOR.isNullValue(tradeDate)) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.mandatory.trade_date_empty);
		}
		if (VALIDATOR.isNullValue(valueDate)) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.mandatory.value_date_empty);
		}
		if (VALIDATOR.isNullValue(baseCcy)) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.mandatory.buy_ccy_empty);
		}
		if (VALIDATOR.isNullValue(againstCcy)) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.mandatory.sell_ccy_empty);
		}
		if (VALIDATOR.isNullValue(baseCcyAmount)) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.mandatory.buy_amt_empty);
		}
		if (VALIDATOR.isNullValue(exchangeRate)) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.mandatory.exchange_empty);
		}
		if(spotDate.length>0 && isDateCustom(spotDate)==false) {
				validationMessages.push(xenos.utils.evaluateMessage(xenos$FRX$i18n.frxEntry.dateTime.spot_date_format , [spotDate]));
		}
	}
	if (tradeDate.length > 0 && isDateCustom(tradeDate) == false) {
		validationMessages
				.push(xenos.utils
						.evaluateMessage(xenos$FRX$i18n.frxEntry.dateTime.trade_date_format
								,[tradeDate]));
	}

	if (valueDate.length > 0 && isDateCustom(valueDate) == false) {
		validationMessages
				.push(xenos.utils
						.evaluateMessage(xenos$FRX$i18n.frxEntry.dateTime.value_date_format, [valueDate]));
	}
	// date range validation
	if (xenos.ns.views.frxTradeEntry.isValidText(tradeDate) && xenos.ns.views.frxTradeEntry.isValidText(valueDate)) {
		if (!isValidDateRange(tradeDate, valueDate)) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.dateTime.compare_date);
		}
	}

	if (!VALIDATOR.isNullValue(baseCcyAmount)) {
		formatAmount($('#baseCcyAmount'), 15, 3, validationMessages, $(
				'#baseCcyAmount').parent().parent().find('label').text());
	}
	if (!VALIDATOR.isNullValue(againstCcyAmount)) {
		formatAmount($('#againstCcyAmount'), 15, 3, validationMessages, $(
				'#againstCcyAmount').parent().parent().find('label').text());
	}
	if (!VALIDATOR.isNullValue(exchangeRate)) {
		formatAmount($('#exchangeRate'), 10, 10, validationMessages, $(
				'#exchangeRate').parent().parent().find('label').text());
	}

	xenos.ns.views.frxTradeEntry.validateTradeTime(validationMessages);

	if ($('#tradeType').val() == "Non Deliverable Forward"
			&& $("#mode").attr("value") == 'AMEND') {
		if ($('#buySell').val() == 'B') {
			if ($('#againstCcy').val() != "" && $('#settleCcy').val() != "") {
				if ($('#againstCcy').val() != $('#settleCcy').val()) {
					validationMessages
							.push(xenos$FRX$i18n.frxAmend.validation.buySell_B);
				}
			}
		} else {
			if ($('#settleCcy').val() != "") {
				validationMessages
						.push(xenos$FRX$i18n.frxAmend.validation.buySell_S);
			}
		}
	}

	// Show the error message
	if (validationMessages.length > 0) {
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on(
				'click',
				xenos.postNotice(xenos.notice.type.error, validationMessages,
						true));
		return false;
	} else {
		$('.formHeader').find('.formTabErrorIco').css('display', 'none');
	}
	return true;
}

xenos.ns.views.frxTradeEntry.callTradeTime=function(e) {
	var tradeTime = $('#tradeTime').val();
	var hh, mm, ss;
	if (tradeTime.length == 6) {
		hh = tradeTime.slice(0, 2);
		mm = tradeTime.slice(2, 4);
		ss = tradeTime.slice(4, 6);
		tradeTime = hh + ":" + mm + ":" + ss;
		e.value = tradeTime
	} else if (tradeTime.length == 4) {
		hh = tradeTime.slice(0, 2);
		mm = tradeTime.slice(2, 4);
		ss = "00";
		tradeTime = hh + ":" + mm + ":" + ss;
		e.value = tradeTime
	} else if (tradeTime.length == 5 && tradeTime.charAt(2) == ":") {
		tradeTime = tradeTime + ":" + "00";
		e.value = tradeTime;
	}
}

xenos.ns.views.frxTradeEntry.validateTradeTime=function(validationMessages) {

	var tradeTime = $('#tradeTime').val();
	var format = /^[a-zA-Z0-9: ]*$/;
	var m = 0;
	var s = 0;
	var validFlag = false;
	
	if (tradeTime != null && tradeTime != "") {
		if (format.test(tradeTime) == false) {
			validationMessages.push(xenos$FRX$i18n.frxEntry.dateTime.error);
			validFlag = true;

		} else if (validFlag == false && tradeTime.length == 8) {
			m = 3;
			s = 6;
			if ((tradeTime.charAt(2) != ":") && (tradeTime.charAt(5) != ":")) {
				validationMessages
						.push(xenos$FRX$i18n.frxEntry.dateTime.invalid_eight);
				validFlag = true;
				console.log("invalid_eight");
			}	
		} else if (tradeTime.length == 6) {
			m = 2;
			s = 4;
			if (isNaN(tradeTime)){ 
				validationMessages
						.push(xenos$FRX$i18n.frxEntry.dateTime.invalid_six);
				validFlag = true;
			}
		} else if (tradeTime.length == 5) {
			m = 3;
			if (tradeTime.charAt(2) != ":") {
				validationMessages
						.push(xenos$FRX$i18n.frxEntry.dateTime.invalid_five);
				validFlag = true;
			}
		} else if (tradeTime.length == 4) {
			m = 2;
			if (isInteger(tradeTime) == false) {
				validationMessages
						.push(xenos$FRX$i18n.frxEntry.dateTime.invalid_four);
				validFlag = true;
			}
		} else {

			validationMessages.push(xenos$FRX$i18n.frxEntry.dateTime.error);
			validFlag = true;
		}

		// ------hours validation------------
		var strHH = tradeTime.charAt(0) + tradeTime.charAt(1);
		var numHH = parseInt(strHH);
		var flag = 0;
		if (validFlag == false && isNaN(numHH)) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.dateTime.nonnumeric_hour);
			flag = 1;
		}
		if (validFlag == false && numHH > 23) {
			validationMessages
					.push(xenos$FRX$i18n.frxEntry.dateTime.notvalid_hour);
			flag = 1;
			
		}

		// ------minutes validation------------
		var strMM = tradeTime.charAt(m) + tradeTime.charAt(m + 1);
		var numMM = parseInt(strMM);
		if (validFlag == false && flag != 1) {
			if(isNaN(numMM)){
				validationMessages
					.push(xenos$FRX$i18n.frxEntry.dateTime.nonnumeric_minute);
				flag = 1;
			}
			else if (numMM > 59) {
				validationMessages
					.push(xenos$FRX$i18n.frxEntry.dateTime.notvalid_minute);
				flag = 1;
			}
		}
		// ------seconds validation------------
		var strSS = '00';
		if ((tradeTime.length == 8) || (tradeTime.length == 6)) {
			strSS = tradeTime.charAt(s) + tradeTime.charAt(s + 1);
			var numSS = parseInt(strSS);
			if (validFlag == false && flag != 1) {
				if (isNaN(numSS)){
					validationMessages
						.push(xenos$FRX$i18n.frxEntry.dateTime.nonnumeric_second);
					flag = 1;
				}
				else if (numSS > 59) {
				validationMessages
						.push(xenos$FRX$i18n.frxEntry.dateTime.notvalid_second);
				}
			}
		}
	}
}

xenos.ns.views.frxTradeEntry.checkTradeTime=function(e) {
	var validationMessages = [];
	xenos.ns.views.frxTradeEntry.validateTradeTime(validationMessages);

	// Show the error message
	if (validationMessages.length > 0) {
		$('#tradeTime').val("");
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on(
				'click',
				xenos.postNotice(xenos.notice.type.error, validationMessages,
						true));
		return false;
	} else {
		$('.formHeader').find('.formTabErrorIco').css('display', 'none');
	}
	return true;
}

xenos.ns.views.frxTradeEntry.isValidText=function(text) {
	if (text != 'undefined' && text != null && $.trim(text).length > 0) {
		return true;
	}
	return false;
}

 xenos.ns.views.frxTradeEntry.formatDate = function(date,id){
		if(date.length == 7){
			id.val(date.substr(0,6)+"0"+date.substr(6));
		}
 }