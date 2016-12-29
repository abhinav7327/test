//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
function validateInstQryFields() {

	var alertStr = [];	
	
	var issueDateFrom  = $('#issueDateFrom').val();
	var issueDateTo    = $('#issueDateTo').val();
	var maturityDateFrom  = $('#maturityDateFrom').val();
	var maturityDateTo    = $('#maturityDateTo').val();
	var couponDateFrom  = $('#couponDateFrom').val();
	var couponDateTo    = $('#couponDateTo').val();
	var listedDateFrom = $('#listedDateFrom').val();
	var listedDateTo   = $('#listedDateTo').val();
	
	var ipoPaymentDateFrom  = $('#ipoPaymentDateFrom').val();
	var ipoPaymentDateTo    = $('#ipoPaymentDateTo').val();
	var conversionStartDateFrom  = $('#conversionStartDateFrom').val();
	var conversionStartDateTo    = $('#conversionStartDateTo').val();
	var conversionEndDateFrom  = $('#conversionEndDateFrom').val();
	var conversionEndDateTo    = $('#conversionEndDateTo').val();
	var publicOfferStartDateFrom = $('#publicOfferStartDateFrom').val();
	var publicOfferStartDateTo   = $('#publicOfferStartDateTo').val();

	var publicOfferEndDateFrom  = $('#publicOfferEndDateFrom').val();
	var publicOfferEndDateTo    = $('#publicOfferEndDateTo').val();
	var contractStartDate  = $('#contractStartDate').val();
	var contractExpiryDate    = $('#contractExpiryDate').val();
	var appRegiDateFrom  = $('#appRegiDateFrom').val();
	var appRegiDateTo    = $('#appRegiDateTo').val();
	var appUpdDateFrom  = $('#appUpdDateFrom').val();
	var appUpdDateTo    = $('#appUpdDateTo').val();
	var posStartDateFrom = $('#posStartDateFrom').val();
	var posStartDateTo   = $('#posStartDateTo').val();
	var posEndDateFrom = $('#posEndDateFrom').val();
	var posEndDateTo   = $('#posEndDateTo').val();
	
	var dateFormatValidationFails = false;
	
	if(dateFormatValidationFails==false && issueDateFrom.length > 0 && isDateCustom(issueDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [issueDateFrom]));
	}
	
	if(dateFormatValidationFails==false && issueDateTo.length > 0 && isDateCustom(issueDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [issueDateTo]));
	}
	
	if(dateFormatValidationFails==false && maturityDateFrom.length > 0 && isDateCustom(maturityDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [maturityDateFrom]));
	}
	
	if(dateFormatValidationFails==false && maturityDateTo.length > 0 && isDateCustom(maturityDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [maturityDateTo]));
	}
	
	if(dateFormatValidationFails==false && couponDateFrom.length > 0 && isDateCustom(couponDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [couponDateFrom]));
	}
	
	if(dateFormatValidationFails==false && couponDateTo.length > 0 && isDateCustom(couponDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [couponDateTo]));
	}
	
	if(dateFormatValidationFails==false && listedDateFrom.length > 0 && isDateCustom(listedDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [listedDateFrom]));
	}
	
	if(dateFormatValidationFails==false && listedDateTo.length > 0 && isDateCustom(listedDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [listedDateTo]));
	}
	
	if(dateFormatValidationFails==false && ipoPaymentDateFrom.length > 0 && isDateCustom(ipoPaymentDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [ipoPaymentDateFrom]));
	}
	
	if(dateFormatValidationFails==false && ipoPaymentDateTo.length > 0 && isDateCustom(ipoPaymentDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [ipoPaymentDateTo]));
	}
	
	if(dateFormatValidationFails==false && conversionStartDateFrom.length > 0 && isDateCustom(conversionStartDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [conversionStartDateFrom]));
	}
	
	if(dateFormatValidationFails==false && conversionStartDateTo.length > 0 && isDateCustom(conversionStartDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [conversionStartDateTo]));
	}
	
	if(dateFormatValidationFails==false && conversionEndDateFrom.length > 0 && isDateCustom(conversionEndDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [conversionEndDateFrom]));
	}
	
	if(dateFormatValidationFails==false && conversionEndDateTo.length > 0 && isDateCustom(conversionEndDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [conversionEndDateTo]));
	}
	
	if(dateFormatValidationFails==false && publicOfferStartDateFrom.length > 0 && isDateCustom(publicOfferStartDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [publicOfferStartDateFrom]));
	}
	
	if(dateFormatValidationFails==false && publicOfferStartDateTo.length > 0 && isDateCustom(publicOfferStartDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [publicOfferStartDateTo]));
	}
	
	if(dateFormatValidationFails==false && publicOfferEndDateFrom.length > 0 && isDateCustom(publicOfferEndDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [publicOfferEndDateFrom]));
	}
	
	if(dateFormatValidationFails==false && publicOfferEndDateTo.length > 0 && isDateCustom(publicOfferEndDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [publicOfferEndDateTo]));
	}
	
	if(dateFormatValidationFails==false && contractStartDate.length > 0 && isDateCustom(contractStartDate)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [contractStartDate]));
	}
	
	if(dateFormatValidationFails==false && contractExpiryDate.length > 0 && isDateCustom(contractExpiryDate)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [contractExpiryDate]));
	}
	
	if(dateFormatValidationFails==false && appRegiDateFrom.length > 0 && isDateCustom(appRegiDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [appRegiDateFrom]));
	}
	
	if(dateFormatValidationFails==false && appRegiDateTo.length > 0 && isDateCustom(appRegiDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [appRegiDateTo]));
	}
	
	if(dateFormatValidationFails==false && appUpdDateFrom.length > 0 && isDateCustom(appUpdDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [appUpdDateFrom]));
	}
	
	if(dateFormatValidationFails==false && appUpdDateTo.length > 0 && isDateCustom(appUpdDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [appUpdDateTo]));
	}
	
	if(dateFormatValidationFails==false && posStartDateFrom.length > 0 && isDateCustom(posStartDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [posStartDateFrom]));
	}
	
	if(dateFormatValidationFails==false && posStartDateTo.length > 0 && isDateCustom(posStartDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [posStartDateTo]));
	}
	
	if(dateFormatValidationFails==false && posEndDateFrom.length > 0 && isDateCustom(posEndDateFrom)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [posEndDateFrom]));
	}
	
	if(dateFormatValidationFails==false && posEndDateTo.length > 0 && isDateCustom(posEndDateTo)==false) {
		dateFormatValidationFails = true;
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.instrument.date_format_check, [posEndDateTo]));
	}
	
	if(dateFormatValidationFails==false){
	
		if(isValidTextForInstQry(issueDateFrom) && isValidTextForInstQry(issueDateTo)) {
			// Validate Issue Date From - To
			if (!isValidDateRange(issueDateFrom, issueDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(isValidTextForInstQry(maturityDateFrom) && isValidTextForInstQry(maturityDateTo)) {
			// Validate Maturity Date From - To
			if (!isValidDateRange(maturityDateFrom, maturityDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(isValidTextForInstQry(couponDateFrom) && isValidTextForInstQry(couponDateTo)) {
			// Validate Coupon Date From - To
			if (!isValidDateRange(couponDateFrom, couponDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(isValidTextForInstQry(listedDateFrom) && isValidTextForInstQry(listedDateTo)) {
			// Validate Listed Date From - To
			if (!isValidDateRange(listedDateFrom, listedDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(isValidTextForInstQry(ipoPaymentDateFrom) && isValidTextForInstQry(ipoPaymentDateTo)) {
			// Validate IPO Payment Date From - To
			if (!isValidDateRange(ipoPaymentDateFrom, ipoPaymentDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(isValidTextForInstQry(conversionStartDateFrom) && isValidTextForInstQry(conversionStartDateTo)) {
			// Validate Conversion Start Date From - To
			if (!isValidDateRange(conversionStartDateFrom, conversionStartDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(isValidTextForInstQry(conversionEndDateFrom) && isValidTextForInstQry(conversionEndDateTo)) {
			// Validate Conversion End Date From - To
			if (!isValidDateRange(conversionEndDateFrom, conversionEndDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(isValidTextForInstQry(publicOfferStartDateFrom) && isValidTextForInstQry(publicOfferStartDateTo)) {
			// Validate Public Offer Start Date From - To
			if (!isValidDateRange(publicOfferStartDateFrom, publicOfferStartDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(isValidTextForInstQry(publicOfferEndDateFrom) && isValidTextForInstQry(publicOfferEndDateTo)) {
			// Validate Public Offer End Date From - To
			if (!isValidDateRange(publicOfferEndDateFrom, publicOfferEndDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(isValidTextForInstQry(appRegiDateFrom) && isValidTextForInstQry(appRegiDateTo)) {
			// Validate Entry Date From - To
			if (!isValidDateRange(appRegiDateFrom, appRegiDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(isValidTextForInstQry(appUpdDateFrom) && isValidTextForInstQry(appUpdDateTo)) {
			// Validate Last Entry Date From - To
			if (!isValidDateRange(appUpdDateFrom, appUpdDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(isValidTextForInstQry(posStartDateFrom) && isValidTextForInstQry(posStartDateTo)) {
			// Validate Xenos Position Start Date From - To
			if (!isValidDateRange(posStartDateFrom, posStartDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(isValidTextForInstQry(posEndDateFrom) && isValidTextForInstQry(posEndDateTo)) {
			// Validate Xenos Position End Date From - To
			if (!isValidDateRange(posEndDateFrom, posEndDateTo)) {
				dateFormatValidationFails = true;
			}
		}
		
		if(dateFormatValidationFails) {
			alertStr.push(xenos$REF$i18n.instrument.date_from_to_check);
		}
	}
	
	var categoryType  = $('#categoryType').val();
	var categoryId    = $('#categoryId').val();
	if(!isBlank(categoryType) && isBlank(categoryId)) {
		alertStr.push(xenos$REF$i18n.instrument.category_values);
	}
	
	if(alertStr.length > 0){
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, alertStr, true));
		return false;
	}else{
		$('.formHeader').find('.formTabErrorIco').css('display', 'none');
	}
	return true;
}


 function isValidTextForInstQry(text){
	if(text!='undefined' && text!=null && $.trim(text).length > 0){
		return true;
	}
	return false;
 }