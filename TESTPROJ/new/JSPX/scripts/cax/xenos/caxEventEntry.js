//$Id$
//$Author: shalinis $
//$Date: 2016-12-27 11:13:15 $
/*
 * +=======================================================================+
 * |                                                                       |
 * |          Copyright (C) 2000-2004 Nomura Securities Co., Ltd.          |
 * |                          All Rights Reserved                          |
 * |                                                                       |
 * |    This document is the sole property of Nomura Securities Co.,       |
 * |    Ltd. No part of this document may be reproduced in any form or     |
 * |    by any means - electronic, mechanical, photocopying, recording     |
 * |    or otherwise - without the prior written permission of Nomura      |
 * |    Securities Co., Ltd.                                               |
 * |                                                                       |
 * |    Unless required by applicable law or agreed to in writing,         |
 * |    software distributed under the License is distributed on an        |
 * |    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,       |
 * |    either express or implied.                                         |
 * |                                                                       |
 * +=======================================================================+
 */

xenos.ns.cax.eventEntry.validateCashDividend = function(corporateActionId) {

	var validationCashDividendMsg = [];
	var errMsg = xenos.ns.cax.eventEntry.validateCommonPart(corporateActionId) || [];
	
	$.each(errMsg, function(index,message){
		validationCashDividendMsg.push(message);
	});
	
	var announementDt 	= 	$.trim($('#announcemntDt').val());
	var expirationDt 	= 	$.trim($('#expirationDt').val());
	var creditDt 		= 	$.trim($('#creditDt').val());
	var financialYrEndDt = 	$.trim($('#finnancialYrEndDt').val());
	var splAllotementAmount = $.trim($('#splAllotementAmountStr').val());
	var splPerShare 	= 	$.trim($('#splPerShareStr').val());
	var bookClosingDt 	= 	$.trim($('#bookClosingDate').val());
	var allotmentAmt 	= 	$.trim($('#allotmentAmountStr').val());
	var perShare 		= 	$.trim($('#perShareStr').val());
	var blockVoucherQty	=   $.trim($('#blockVoucherQty').val());
	
	//Invalid Spl Allotment Amount
	if(!VALIDATOR.isNullValue(splAllotementAmount)) {
		formatAmount($('#splAllotementAmountStr'),11,7,validationCashDividendMsg,$('#splAllotementAmountStr').parent().parent().find('label').text());
	}
	
	
	//Invalid Spl Per share
	if(!VALIDATOR.isNullValue(splPerShare)) {
		formatQuantity($('#splPerShareStr'),5,0,validationCashDividendMsg,$('#splPerShareStr').parent().parent().find('label').text());
	}
	
	//Illegal Announement Date
	if(announementDt.length>0 && isDateCustom(announementDt)==false) {
		validationCashDividendMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_announcemntDt + announementDt +" !");
	}  
	
	//Illegal Expiration Date
	if(expirationDt.length>0 && isDateCustom(expirationDt)==false) {
		validationCashDividendMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_protectExpDt + expirationDt +" !");
	} 
	
	//Illegal Credit Date
	if(creditDt.length>0 && isDateCustom(creditDt)==false) {
		validationCashDividendMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_creditDt + creditDt +" !");
	} 
	
	//Illegal Financial Yr End Date
	if(financialYrEndDt.length>0 && isDateCustom(financialYrEndDt)==false) {
		validationCashDividendMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_finYrEndDt + financialYrEndDt +" !");
	} 
	
	 if((splAllotementAmount == "") != (splPerShare == "")) {
		validationCashDividendMsg.push(xenos$CAX$i18n.rightsConditionEntry.splAlltmnt_splPershare);
	 
	 }
	 
	 //Book Closing Dt 
	 if(bookClosingDt.length>0 && isDateCustom(bookClosingDt)==false) {
		validationCashDividendMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_bookClosingDt + bookClosingDt +" !");
	} 
	
	//Block Voucher Quantity Invalid	
	if(!VALIDATOR.isNullValue(blockVoucherQty)) {	
		formatQuantity($('#blockVoucherQty'),20,10,validationCashDividendMsg,$('#blockVoucherQty').parent().parent().find('label').text());
	}
					
	return validationCashDividendMsg;
 
 }
 
xenos.ns.cax.eventEntry.validateBonusIssue = function(corporateActionId) {
	
	var validationBonusIssueMsg = [];
	var errMsg = xenos.ns.cax.eventEntry.validateCommonPart(corporateActionId) || [];
	
	$.each(errMsg, function(index,message){
		validationBonusIssueMsg.push(message);
	});
	
	var payOutCcy 		= 	$.trim($('#payOutCcy').val());
	var payoutPrice 	=	$.trim($('#payoutPrice').val());
	var splAlltQty 		= 	$.trim($('#specialAllotmentQuantity').val());
	var splPerShare 	= 	$.trim($('#specialPerShare').val());
	var bookClosingDt	=	$.trim($('#bookDateValue').val());
	var perShareValue	= 	$.trim($('#perShareValue').val());
	var eventType 			= 	$.trim($('#subEventType').val());
	var faceValue 		=   $.trim($('#faceValue').val());
	
	// Stock Dividend Part
	var dueBillEndDt = $.trim($('#dueBillEndDateStr').val());
	var announcementDt = $.trim($('#announcementDateValue').val());
	var protectExpirationDt = $.trim($('#protectExpirationDateValue').val());
	var creditDt = $.trim($('#creditDateValue').val());
	var dividendNo = $.trim($('#dividendNo').val());
	var blockVoucherQty = $.trim($('#blockVoucherQuantityValue').val());
	var financialYearEndDt = $.trim($('#financialYearEndDateValue').val());
	
	
	if(eventType != 'BONUS_ISSUE') {
		//Illegal Announcement Date
		 if(announcementDt.length>0 && isDateCustom(announcementDt)==false) {
			validationBonusIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_announcemntDt + announcementDt +" !");
		} 
	
	    //Illegal Protect Expiration Date
		 if(protectExpirationDt.length>0 && isDateCustom(protectExpirationDt)==false) {
			validationBonusIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_protectExpDt + protectExpirationDt +" !");
		} 
		
		//Illegal Credit Date
		if(creditDt.length>0 && isDateCustom(creditDt)==false) {
			validationBonusIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_creditDt + creditDt +" !");
		} 
		
		//Illegal Financial Year End Date
		if(financialYearEndDt.length>0 && isDateCustom(financialYearEndDt)==false) {
			validationBonusIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_finYrEndDt + financialYearEndDt +" !");
		} 
		
		//Illegal Due Bill End Date
		if(dueBillEndDt.length>0 && isDateCustom(dueBillEndDt)==false) {
			validationBonusIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_dueBillEndDt + dueBillEndDt +" !");
		} 
	}
	
	//Simultaneous validation of payput CCY and Payout Price
	if((payOutCcy == "") != (payoutPrice == "")) {
		validationBonusIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.payoutPrice_payoutCcy);
	 
	 }
	 
	 //Simultaneous validation of spl Allotment Quantity and Spl Allotment Price
	 if((splAlltQty == "") != (splPerShare == "")) {
		validationBonusIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.splAllotmnt_SplQty);
	 
	 }
	 
	 //Illegal Book Date
	 if(bookClosingDt.length>0 && isDateCustom(bookClosingDt)==false) {
		validationBonusIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_bookClosingDt + bookClosingDt +" !");
	}  
	 
	//Spl Allotment Amount Invalid 
	if(!VALIDATOR.isNullValue(splAlltQty)) {
		formatQuantity($('#specialAllotmentQuantity'),11,7,validationBonusIssueMsg,$('#specialAllotmentQuantity').parent().parent().find('label').text());
	}

	//Per Share Invalid
	if(!VALIDATOR.isNullValue(perShareValue)) {
		formatQuantity($('#perShareStr'),11,9,validationBonusIssueMsg,$('#perShareStr').parent().parent().find('label').text());
	}
	
	//Spl Per Share Invalid	
	if(!VALIDATOR.isNullValue(splPerShare)) {
		formatQuantity($('#specialPerShare'),5,0,validationBonusIssueMsg,$('#specialPerShare').parent().parent().find('label').text());
	}
	
	//Face Value Invalid	
	if(!VALIDATOR.isNullValue(faceValue)) {
		formatPrice($('#faceValue'),11,7,validationBonusIssueMsg,$('#faceValue').parent().parent().find('label').text());
	}
	
	//Payout Price Invalid	
	if(!VALIDATOR.isNullValue(payoutPrice)) {
		formatPrice($('#payoutPrice'),15,3,validationBonusIssueMsg,$('#payoutPrice').parent().parent().find('label').text());
	}
	
	//Block Voucher Quantity Invalid	
	if(!VALIDATOR.isNullValue(blockVoucherQty)) {
		formatQuantity($('#blockVoucherQuantityValue'),20,10,validationBonusIssueMsg,$('#blockVoucherQuantityValue').parent().parent().find('label').text());
	}
	
	return validationBonusIssueMsg;
 
 }

xenos.ns.cax.eventEntry.validateStockEventsEntry = function(corporateActionId) {
	
	var validationStockEventMsg = [];
	var errMsg = xenos.ns.cax.eventEntry.validateCommonPart(corporateActionId) || [];
	
	$.each(errMsg, function(index,message){
		validationStockEventMsg.push(message);
	});

	var announcementDt 		= 	$.trim($('#announcemntDt').val());
	var expirationDt 		=	$.trim($('#protectExpDt').val());
	var payOutCcy 			= 	$.trim($('#payOutCcy').val());
	var payoutPrice 		=	$.trim($('#payoutPrice').val());
	var bookClosingDt		=	$.trim($('#bookClosingDate').val());
	var perShareValue		= 	$.trim($('#perShareStr').val());
	var dueBillEndDt		=   $.trim($('#dueBillEndDateStr').val());
	
	//Illegal Announement Date
	if(announcementDt.length>0 && isDateCustom(announcementDt)==false) {
		validationStockEventMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_announcemntDt + announcementDt +" !");
	}  
	
	//Illegal Expiration Date
	if(expirationDt.length>0 && isDateCustom(expirationDt)==false) {
		validationStockEventMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_protectExpDt + expirationDt +" !");
	} 
	
	//Simultaneous validation of payput CCY and Payout Price
	if((payOutCcy == "") != (payoutPrice == "")) {
		validationStockEventMsg.push(xenos$CAX$i18n.rightsConditionEntry.payoutPrice_payoutCcy);
	 
	 }
	 
	 //Illegal Book Closing Date
	if(bookClosingDt.length>0 && isDateCustom(bookClosingDt)==false) {
		validationStockEventMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_bookClosingDt + bookClosingDt +" !");
	} 
	 	
	//PayoutPrice Invalid
	if(!VALIDATOR.isNullValue(payoutPrice)) {
		formatPrice($('#payoutPrice'),15,3,validationStockEventMsg,$('#payoutPrice').parent().parent().find('label').text());
	}
	
	//Illegal Due Bill End Date
	if(dueBillEndDt.length>0 && isDateCustom(dueBillEndDt)==false) {
		validationStockEventMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_dueBillEndDt + dueBillEndDt +" !");
	} 
	
	
	
	return validationStockEventMsg;
}

xenos.ns.cax.eventEntry.validateCouponPaymentEntry = function(corporateActionId) {
	
	var validationCouponPaymntMsg = [];
	var errMsg = xenos.ns.cax.eventEntry.validateCommonPart(corporateActionId) || [];
	
	$.each(errMsg, function(index,message){
		validationCouponPaymntMsg.push(message);
	});

	var creditDt 	= 	$.trim($('#creditDt').val());
	var couponDt	=	$.trim($('#couponDateValue').val());
	var couponRt	=	$.trim($('#couponRateValue').val());
	var prevFactor	=	$.trim($('#previousFactorStr').val());
	var currFactor	=	$.trim($('#currentFactorStr').val());
	var originalRecordDt = $.trim($('#originalRecordDateValue').val());
	var perOriginalFaceval = $.trim($('#perShareStr').val());
	var allotmentAmnt = $.trim($('#allotmentAmountQty').val());
	
	//Illegal Credit Date
	if(creditDt.length>0 && isDateCustom(creditDt)==false) {
		validationCouponPaymntMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_creditDt + creditDt);
	} 
	
	//Illegal Original Record Date
	if(originalRecordDt.length>0 && isDateCustom(originalRecordDt)==false) {
		validationCouponPaymntMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_originalRecDt + originalRecordDt +" !");
	}
	
	//Coupon Date
	if(VALIDATOR.isNullValue(couponDt)) {
		validationCouponPaymntMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_couponDate);
	} else if(couponDt.length>0 && isDateCustom(couponDt)==false) {
		validationCouponPaymntMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_couponDt + couponDt );
	}
	
	//Coupon Rate
	if(VALIDATOR.isNullValue(couponRt)) {
		validationCouponPaymntMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_couponRate);
	} else {
		formatRate($('#couponRateValue'),11,7,validationCouponPaymntMsg,$('#couponRateValue').parent().parent().find('label').text());
	}
	
	//Allotment Amount
	if(!VALIDATOR.isNullValue(allotmentAmnt)) {
		formatQuantity($('#allotmentAmountQty'),11,9,validationCouponPaymntMsg,$('#allotmentAmountQty').parent().parent().find('label').text());
	} 
	
	//Per Original Face Value
	if(!VALIDATOR.isNullValue(perOriginalFaceval)) {
		formatQuantity($('#perShareStr'),11,9,validationCouponPaymntMsg,$('#perShareStr').parent().parent().find('label').text());
	} 
	
	//Per Original Face Value
	//Prev Factor Current Factor
	if((prevFactor == "") != (currFactor == "")) {
		validationCouponPaymntMsg.push(xenos$CAX$i18n.rightsConditionEntry.prevFactor_currFactor);
	
	}
	
	// Invalid Previous Factor
	if(!VALIDATOR.isNullValue(prevFactor)) {
		formatAmount($('#previousFactorStr'),1,8,validationCouponPaymntMsg,$('#previousFactorStr').parent().parent().find('label').text());
	} 
	
	// Invalid Current Factor
	if(!VALIDATOR.isNullValue(currFactor)) {
		formatAmount($('#currentFactorStr'),1,8,validationCouponPaymntMsg,$('#currentFactorStr').parent().parent().find('label').text());
	} 
	
	
	return validationCouponPaymntMsg;
}
 
xenos.ns.cax.eventEntry.validateCommonPart = function(corporateActionId) {
	
	var validationMsg = [];
	
	var conditionStatus 	= 	$.trim($('#conditionStatus').val());
	var instrumentCode		= 	$.trim($('#instrumentCode').val());
	var recordDate 			= 	$.trim($('#recordDate').val()); 
	var allottedInstrument 	= 	$.trim($('#allottedInstrument').val());
	var exDate 				= 	$.trim($('#exDate').val());
	var paymentDate 		= 	$.trim($('#paymentDateValue').val());
	var allotmentAmt 		= 	$.trim($('#allotmentAmountQty').val());
	var processingFrequency = 	$.trim($('#processingFrequency').val());
	var processStartDt 		= 	$.trim($('#processStartDateValue').val());
	var processEndDt 		= 	$.trim($('#processEndDateValue').val());
	var perShareStr			= 	$.trim($('#perShareStr').val());
	
		
	var dateFormatValidationFails = false;
	
	//Processing Frequency
	if(processingFrequency == 'DAILY') {
	
		//Process Start Date
		if(VALIDATOR.isNullValue(processStartDt)) {
				validationMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_processStartDate);
		} 	 
		
		//Illegal Process Start Date
		 if(processStartDt.length>0 && isDateCustom(processStartDt)==false) {
			validationMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_processStDt + processStartDt +" !");
		}  
		
		//Process End Date
		if(VALIDATOR.isNullValue(processEndDt)) {
				validationMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_processEndDate);
		} 	 
		
		//Illegal Process End Date
		 if(processEndDt.length>0 && isDateCustom(processEndDt)==false) {
			validationMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_processEnDt + processEndDt +" !");
		}  
	}
	
	//Processing Frequency
	if(processingFrequency == 'TRIGGER') { 
		
		//Process End Date
		if(VALIDATOR.isNullValue(processStartDt)) {
				validationMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_processStartDate);
		} 	 
		
		//Illegal Process End Date
		 if(processStartDt.length>0 && isDateCustom(processStartDt)==false) {
			validationMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_processStDt + processStartDt +" !");
		}  
	}
	
	//Event Type Status 
	  if(VALIDATOR.isNullValue(conditionStatus)){                
		validationMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_eventTypeStatus);
	}
	
	if(corporateActionId !='COUPON_PAYMENT') {
		//Ex Date
		if(VALIDATOR.isNullValue(exDate)) {
				validationMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_exDateStr);
		}
		
		//Illegal Ex Date
		if(exDate.length>0 && isDateCustom(exDate)==false) {
				validationMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_exDt + exDate +" !");
		}
	}
	
	
	//Payment Date
	if(corporateActionId !='OTHERS') {
		if(VALIDATOR.isNullValue(paymentDate)) {
				if(corporateActionId =='RIGHTS_ALLOCATION') {
					validationMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_paymentDtNewShare);
				} else {
					validationMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_paymentDateStr);
				}
		}
		
		//Illegal Payment Date
		if(paymentDate.length>0 && isDateCustom(paymentDate)==false) {
				if(corporateActionId =='RIGHTS_ALLOCATION') {
					validationMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_paymntDtNewShare + paymentDate +" !");
				} else {
				validationMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_paymntDt + paymentDate +" !");
				}
			}
	}	
	
	
	//Record Date
	if(VALIDATOR.isNullValue(recordDate)) {
			validationMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_recordDate);
	} 	 
	
	//Record Date format validation
	 if(recordDate.length>0 && isDateCustom(recordDate)==false) {
		validationMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_recordDt + recordDate +" !");
	}  
	
	// Instrument Code
	if(VALIDATOR.isNullValue(instrumentCode)){                
		validationMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_instrumentCode);
	}
	
	//Alloted CCY code
	if(VALIDATOR.isNullValue(allottedInstrument)) {
			validationMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_allotedSecurityCode);
	} 
	
	if(corporateActionId !='COUPON_PAYMENT' &&  corporateActionId !='STOCK_MERGER') {
	//Allotment Qty or Amount
	if(VALIDATOR.isNullValue(allotmentAmt)) {
			validationMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_allotmentQuantityStr);
	} else {
	// Invalid Allotment Amount
			formatPrice($('#allotmentAmountQty'),11,9,validationMsg,$('#allotmentAmountQty').parent().parent().find('label').text());
		}
		
	if(VALIDATOR.isNullValue(perShareStr)) {
			validationMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_perShare);
		} else {
			formatQuantity($('#perShareStr'),11,9,validationMsg,$('#perShareStr').parent().parent().find('label').text())
		}		
	}
	
	 if(corporateActionId =='NAME_CHANGE' ||  corporateActionId =='SPIN_OFF') {
		if(!VALIDATOR.isNullValue(instrumentCode) && !VALIDATOR.isNullValue(allottedInstrument)) {
			if(instrumentCode == allottedInstrument) {
				validationMsg.push(xenos$CAX$i18n.rightsConditionEntry.same_security_allotmentIns);
			}
			
		}
	
	} 
	
	return validationMsg;
 
 }
 
xenos.ns.cax.eventEntry.validateStockMergerEntry = function(corporateActionId) {
	
	var validationStockMsg = [];
	var instrumentCode 	= 	$.trim($('#instrumentCode').val());
	var allotmntQty 	= 	$.trim($('#allotmentQuantityStr').val());
	var perShare		= 	$.trim($('#perShareValue').val());
	var ccyCashDiv		= 	$.trim($('#ccyCashDividend').val());
	var allotmntAmont	= 	$.trim($('#allotmentAmountStr').val());
	var perShareCashDividend	= $.trim($('#perShareCashDividend').val());
	var payOutCcy	= $.trim($('#payOutCcy').val());
	var payOutPrice	= $.trim($('#payoutPrice').val());
	
	
	// Instrument Code
	if(VALIDATOR.isNullValue(instrumentCode)){
		validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.blank_instrumentCode);
	}
	
	//Allotment Quantity
	if(VALIDATOR.isNullValue(allotmntQty)) {
			validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.blank_allotmentQty);
	} else  {
			formatQuantity($('#allotmentQuantityStr'),11,9,validationStockMsg,$('#allotmentQuantityStr').parent().parent().find('label').text());
	} 
	
	//Per share
	if(VALIDATOR.isNullValue(perShare)) {
			validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.blank_perShare);
	} else  {
			formatQuantity($('#perShareValue'),11,9,validationStockMsg,$('#perShareValue').parent().parent().find('label').text());
	} 
	
	//Allotment Amount
	if(!VALIDATOR.isNullValue(allotmntAmont)) {
		formatAmount($('#allotmentAmountStr'),11,9,validationStockMsg,$('#allotmentAmountStr').parent().parent().find('label').text());
	}
	
	//Payout Cash Dividend
	if(!VALIDATOR.isNullValue(perShareCashDividend)) {
		formatPrice($('#perShareCashDividend'),11,9,validationStockMsg,$('#perShareCashDividend').parent().parent().find('label').text());
		
	}
	
	//Payout Price
	if(!VALIDATOR.isNullValue(payOutPrice)) {
		formatPrice($('#payoutPrice'),15,3,validationStockMsg,$('#payoutPrice').parent().parent().find('label').text());
	}
	
	//Payout Price and Payout Ccy
	if((payOutCcy == "") != (payOutPrice == "")) {
			validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.payoutPrice_payoutCcy);
	        	
	 } 
	return validationStockMsg;
	
	
	}
	
xenos.ns.cax.eventEntry.validateStockMergerSubmit = function(isStockPresent) {
		
		var validationStockMsg = [];
		
		var exDate 				= 	$.trim($('#exDate').val());
		var recordDt 			= 	$.trim($('#recordDate').val());
		var bookClosingDt 		= 	$.trim($('#bookClosingDate').val());
		var allottedInstrument 	= 	$.trim($('#allottedInstrument').val());
		var paymentDt 			= 	$.trim($('#paymentDateValue').val());
		var announcemntDt 		= 	$.trim($('#announcemntDt').val());
		var expirationDt 		= 	$.trim($('#expirationDt').val());
		
		var conditionStatus 	= 	$.trim($('#conditionStatus').val());
	
	var processingFrequency = 	$.trim($('#processingFrequency').val());
	var processStartDt 		= 	$.trim($('#processStartDateValue').val());
	var processEndDt 		= 	$.trim($('#processEndDateValue').val());
	
	//Processing Frequency
	if(processingFrequency == 'DAILY') {
	
		//Process Start Date
		if(VALIDATOR.isNullValue(processStartDt)) {
				validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_processStartDate);
		} 	 
		
		//Illegal Process Start Date
		 if(processStartDt.length>0 && isDateCustom(processStartDt)==false) {
			validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_processStDt + processStartDt +" !");
		}  
		
		//Process End Date
		if(VALIDATOR.isNullValue(processEndDt)) {
				validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_processEndDate);
		} 	 
		
		//Illegal Process End Date
		 if(processEndDt.length>0 && isDateCustom(processEndDt)==false) {
			validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_processEnDt + processEndDt +" !");
		}  
	}
	
	//Processing Frequency
	if(processingFrequency == 'TRIGGER') { 
		
		//Process End Date
		if(VALIDATOR.isNullValue(processStartDt)) {
				validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_processStartDate);
		} 	 
		
		//Illegal Process End Date
		 if(processStartDt.length>0 && isDateCustom(processStartDt)==false) {
			validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_processStDt + processStartDt +" !");
		}  
	}
	
	//Event Type Status 
	  if(VALIDATOR.isNullValue(conditionStatus)){                
		validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_eventTypeStatus);
	}
		
	//Allotment Instrument
	if(VALIDATOR.isNullValue(allottedInstrument)) {
		validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_allotedSecurityCode);
	}
	
	//Ilegal Announcement Date
	if(announcemntDt.length>0 && isDateCustom(announcemntDt)==false) {
		validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_announcemntDt + announcemntDt +" !");
	}
	
	//Ex Date
	if(VALIDATOR.isNullValue(exDate)) {
		validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_exDateStr);
	} 
	
	//Ilegal Ex Date
	if(exDate.length>0 && isDateCustom(exDate)==false) {
		validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_exDt + exDate +" !");
	} 
	
	//Payment Date
	if(VALIDATOR.isNullValue(paymentDt)) {
		validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_paymentDateStr);
	}
	
	//Ilegal Payment Date
	if(paymentDt.length>0 && isDateCustom(paymentDt)==false) {
		validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_paymntDt + paymentDt +" !");
	} 
	
	//Record Date
	if(VALIDATOR.isNullValue(recordDt)) {
		validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_recordDate);
	}
	
	//Ilegal Record Date
	if(recordDt.length>0 && isDateCustom(recordDt)==false) {
		validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_recordDt + recordDt +" !");
	} 
	
	//Illegal Expiration Date
	if(expirationDt.length>0 && isDateCustom(expirationDt)==false) {
		validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_expirationDt + expirationDt +" !");
	} 
	
	//Illegal Book Closing Date
	if(bookClosingDt.length>0 && isDateCustom(bookClosingDt)==false) {
		validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_bookClosingDt + bookClosingDt +" !");
	} 
	
	if(isStockPresent == false) {
		validationStockMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_stock);
	}
	return validationStockMsg;
	
	}
	
xenos.ns.cax.eventEntry.validateRightsIssue = function(corporateActionId) {
	
	var validateRightsIssueMsg = [];
	var errMsg = xenos.ns.cax.eventEntry.validateCommonPart(corporateActionId) || [];
	
	$.each(errMsg, function(index,message){
		validateRightsIssueMsg.push(message);
	});
	
	var rightsExpiryDt	= 	$.trim($('#rightsExpiryDateStr').val());
	var creditDt		= 	$.trim($('#creditDateStr').val());
	var deadlineDt		= 	$.trim($('#deadLineDateStr').val());
	var paymntDtTakeUp	= 	$.trim($('#paymentDateTakeUpStr').val()); 
	var takeUpCost		=   $.trim($('#subsCostPerShareStr').val()); 
	var takeUpCcy		= 	$.trim($('#subscriptionCcy').val()); 	
	var rightsPaymentDt =   $.trim($('#rightsPaymentDateStr').val());
	var allottedRightsIns = $.trim($('#allottedRightsInstrument').val());
	var allottedRightsQty = $.trim($('#allottedRightsQuantityStr').val());
	var perShareRights  = $.trim($('#perShareRightsStr').val());
	var instrumentCode  = $.trim($('#instrumentCode').val());
	var allottedInstrument = $.trim($('#allottedInstrument').val());
	
	//Illegal Rights Expiry Date
	if(rightsExpiryDt.length>0 && isDateCustom(rightsExpiryDt)==false) {
		validateRightsIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_rightsExpiry + rightsExpiryDt +" !");
	}

	//Illegal Credit Date
	if(creditDt.length>0 && isDateCustom(creditDt)==false) {
		validateRightsIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_creditDate + creditDt +" !");
	}
	
	//Illegal Deadline Date
	if(deadlineDt.length>0 && isDateCustom(deadlineDt)==false) {
		validateRightsIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_deadlineDate + deadlineDt +" !");
	}
	
	//Payment Date (Take Up)
	if(VALIDATOR.isNullValue(paymntDtTakeUp)) {
		validateRightsIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_paymntDtTakeUp);
	} else if(isDateCustom(paymntDtTakeUp)==false) {
		validateRightsIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_paymntDtTakeUp + paymntDtTakeUp +" !");
	}
	
	//Take Up Cost
	if(VALIDATOR.isNullValue(takeUpCost)) {
		validateRightsIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_takeupCost);
	} else {	
		formatAmount($('#subsCostPerShareStr'),11,7,validateRightsIssueMsg,$('#subsCostPerShareStr').parent().parent().find('label').text());
	}
	
	//Take Up Ccy
	if(VALIDATOR.isNullValue(takeUpCcy)) {
		validateRightsIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_takeupCcy);
	}
	
	//Payment Date (Rights)
	if(VALIDATOR.isNullValue(rightsPaymentDt)) {
		validateRightsIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_paymntDtRights);
	} else if(isDateCustom(rightsPaymentDt)==false) {
		validateRightsIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_paymntDtRights + rightsPaymentDt +" !");
	}
	
	//Allotted Rights Instrument
	if(VALIDATOR.isNullValue(allottedRightsIns)) {
		validateRightsIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_allotedRightsIns);
	}
	
	//Allotted Rights Quantity
	if(VALIDATOR.isNullValue(allottedRightsQty)) {
		validateRightsIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_allotedRightsQuantity);
	} else {
		formatQuantity($('#allottedRightsQuantityStr'),15,3,validateRightsIssueMsg,$('#allottedRightsQuantityStr').parent().parent().find('label').text());
	}
 	
	//Per Share
	if(VALIDATOR.isNullValue(perShareRights)) {
		validateRightsIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_perShareRights);
	} else {
		formatQuantity($('#perShareRightsStr'),11,9,validateRightsIssueMsg,$('#perShareRightsStr').parent().parent().find('label').text());
	}
	
	// Same Security and Allotted Security
	if(instrumentCode!="" && allottedRightsIns !="") {
		if(instrumentCode==allottedRightsIns) {
			validateRightsIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.same_security_allottedRightsIns);
		}
	}
	
	// Same Allotment Security and Allotted Security
	if(allottedInstrument!="" && allottedRightsIns !="") {
		if(allottedInstrument==allottedRightsIns) {
			validateRightsIssueMsg.push(xenos$CAX$i18n.rightsConditionEntry.same_allotmentSecurity_allottedRightsIns);
		}
	}
	
	return validateRightsIssueMsg;
	}
	
xenos.ns.cax.eventEntry.validateRedemptionBond = function(corporateActionId) {
	
	var validateRedemptionMsg = [];
	
	var instrumntCode	= 	$.trim($('#instrumentCode').val());
	var redemptionCcy	= 	$.trim($('#redemptionCurrency').val());
	var redemptionDt	= 	$.trim($('#redemptionDateStr').val());
	var paymntDt	= 	$.trim($('#paymentDateValue').val());
	var recordDt	= 	$.trim($('#recordDate').val());
	var creditDt	= 	$.trim($('#creditDateStr').val());
	var rateOfNominal	= 	$.trim($('#rateOfNominalStr').val());
	var redemptionPrice	= 	$.trim($('#redemptionPriceStr').val());
	var conditionStatus 	= 	$.trim($('#conditionStatus').val());
	
	var processingFrequency = 	$.trim($('#processingFrequency').val());
	var processStartDt 		= 	$.trim($('#processStartDateValue').val());
	var processEndDt 		= 	$.trim($('#processEndDateValue').val());
	
	//Processing Frequency
	if(processingFrequency == 'DAILY') {
	
		//Process Start Date
		if(VALIDATOR.isNullValue(processStartDt)) {
				validateRedemptionMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_processStartDate);
		} 	 
		
		//Illegal Process Start Date
		 if(processStartDt.length>0 && isDateCustom(processStartDt)==false) {
			validateRedemptionMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_processStDt + processStartDt +" !");
		}  
		
		//Process End Date
		if(VALIDATOR.isNullValue(processEndDt)) {
				validateRedemptionMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_processEndDate);
		} 	 
		
		//Illegal Process End Date
		 if(processEndDt.length>0 && isDateCustom(processEndDt)==false) {
			validateRedemptionMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_processEnDt + processEndDt +" !");
		}  
	}
	
	//Processing Frequency
	if(processingFrequency == 'TRIGGER') { 
		
		//Process End Date
		if(VALIDATOR.isNullValue(processStartDt)) {
				validateRedemptionMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_processStartDate);
		} 	 
		
		//Illegal Process End Date
		 if(processStartDt.length>0 && isDateCustom(processStartDt)==false) {
			validateRedemptionMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_processStDt + processStartDt +" !");
		}  
	}
	
	//Event Type Status 
	  if(VALIDATOR.isNullValue(conditionStatus)){                
		validateRedemptionMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_eventTypeStatus);
	}
	
	//Instrument Code
	if(VALIDATOR.isNullValue(instrumntCode)) {
		validateRedemptionMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_instrumentCode);
	}
	
	//Redemption Ccy
	if(VALIDATOR.isNullValue(redemptionCcy)) {
		validateRedemptionMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_redemptionCcy);
	}
	
	//Illegal Redemption Date
	if(redemptionDt.length>0 && isDateCustom(redemptionDt)==false) {
		validateRedemptionMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_redemptionDt + redemptionDt +" !");
	}
	
	//Illegal Payment Date
	if(paymntDt.length>0 && isDateCustom(paymntDt)==false) {
		validateRedemptionMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_paymntDt + paymntDt +" !");
	} 
	
	//Illegal Record Date
	if(recordDt.length>0 && isDateCustom(recordDt)==false) {
		validateRedemptionMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_recordDt + recordDt +" !");
	}
	
	//Illegal Credit Date
	if(creditDt.length>0 && isDateCustom(creditDt)==false) {
		validateRedemptionMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_creditDate + creditDt +" !");
	}
	
	//Rate of Nominal
	if(VALIDATOR.isNullValue(rateOfNominal)) {
		validateRedemptionMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_rateNominal);
	}
	
	//Redemption Price
	if(VALIDATOR.isNullValue(redemptionPrice)) {
		validateRedemptionMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_redemptionPrice);
	}
    
	//Redemption Nominal Rate Invalid 
	if(!VALIDATOR.isNullValue(rateOfNominal)) {
		formatRate($('#rateOfNominalStr'),3,5,validateRedemptionMsg,$('#rateOfNominalStr').parent().parent().find('label').text());	
	}
	
	//Redemption Price Invalid 
	if(!VALIDATOR.isNullValue(redemptionPrice)) {	
		formatPrice($('#redemptionPriceStr'),11,7,validateRedemptionMsg,$('#redemptionPriceStr').parent().parent().find('label').text());
	}
	
	return validateRedemptionMsg;
}

xenos.ns.cax.eventEntry.validateStockCashOption	= function(corporateActionId) {
	
	var validateStockCashMsg = [];
	var errMsg = xenos.ns.cax.eventEntry.validateCommonPart(corporateActionId) || [];
	
	$.each(errMsg, function(index,message){
		validateStockCashMsg.push(message);
	});
	
	var deadLineDt	= 	$.trim($('#deadLineDateStr').val());
	var expiryDt = $.trim($('#rightsExpiryDateStr').val());
	var bookClisingDt = $.trim($('#bookDateValue').val());
	var splAllotementAmount = $.trim($('#splAllotementAmountStr').val());
	var splPerShare		= $.trim($('#splPerShareStr').val());
	
	// Expiry Date
	if(VALIDATOR.isNullValue(expiryDt)) {
		validateStockCashMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_expiryDt);
	} 
	
	//Illegal Rights Expiry Date
	if(expiryDt.length>0 && isDateCustom(expiryDt)==false) {
		validateStockCashMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_rightsExpiry + expiryDt +" !");
	}
	
	//Illegal Deadline Date
	if(deadLineDt.length>0 && isDateCustom(deadLineDt)==false) {
		validateStockCashMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_deadlineDate + deadLineDt +" !");
	}
	
	//Book closing Date
	if(bookClisingDt.length>0 && isDateCustom(bookClisingDt)==false) {
		validateStockCashMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_bookClosingDt + bookClisingDt +" !");
	}
	
	//Invalid Spl Allotment Amount
	if(!VALIDATOR.isNullValue(splAllotementAmount)) {
		formatAmount($('#splAllotementAmountStr'),11,7,validateStockCashMsg,$('#splAllotementAmountStr').parent().parent().find('label').text());	
	}
	
	//Invalid Spl Per share
	if(!VALIDATOR.isNullValue(splPerShare)) {
		formatQuantity($('#splPerShareStr'),11,9,validateStockCashMsg,$('#splPerShareStr').parent().parent().find('label').text());
		
	}
	
	return validateStockCashMsg;
	
	}
	
xenos.ns.cax.eventEntry.validateOthers = function(corporateActionId) {
	
	var validateOthersMsg = [];
	var errMsg = xenos.ns.cax.eventEntry.validateCommonPart(corporateActionId) || [];
	
	$.each(errMsg, function(index,message){
		validateOthersMsg.push(message);
	});
	
	var exerciseDt	= 	$.trim($('#exerciseDateStr').val());
	var expiryDt	= 	$.trim($('#rightsExpiryDateStr').val());
	var deadlineDate	= 	$.trim($('#deadLineDateStr').val());
	var eventTypeName = $.trim($('#eventTypeName').val());
	var payOutPrice = $.trim($('#payOutPriceStr').val());
	
	
	
	//Illegal Exercise Date
	if(exerciseDt.length>0 && isDateCustom(exerciseDt)==false) {
		validateOthersMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_exerciseDt + exerciseDt +" !");
	}
	
	//Illegal expiry Date
	if(expiryDt.length>0 && isDateCustom(expiryDt)==false) {
		validateOthersMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_rightsExpiry + expiryDt +" !");
	}
	
	//Illegal Deadline Date
	if(deadlineDate.length>0 && isDateCustom(deadlineDate)==false) {
		validateOthersMsg.push(xenos$CAX$i18n.rightsConditionEntry.date_format_check_deadlineDate + deadlineDate +" !");
	}
	
	//Missing Event Type Name
	if(VALIDATOR.isNullValue(eventTypeName)){                
		validateOthersMsg.push(xenos$CAX$i18n.rightsConditionEntry.enter_eventTypeName);
	}
	
	//Payput Price
	if(!VALIDATOR.isNullValue(payOutPrice)) {
		formatQuantity($('#payOutPriceStr'),15,3,validateOthersMsg,$('#payOutPriceStr').parent().parent().find('label').text());
	}

	return validateOthersMsg;
}	

/**
 * Disable the fields for an event type in AMEND operation
 */
xenos.ns.cax.eventEntry.disableFieldsForAmend = function() {
	
	// common parts in main jspx
	$("#subEventType").attr("disabled", true);
	$("#caEventRefNo").attr("disabled", true);
	// event type specific fields
	if ($('#subEventType').val() == 'CASH_DIVIDEND' || $('#subEventType').val() == 'CAPITAL_REPAYMENT' 
		|| $('#subEventType').val() == 'SPECIAL_CASH_DIVIDEND' || $('#subEventType').val() == 'SCHEME_OF_ARRANGEMENT_CASH'){
		$("#bookClosingDate").attr("disabled", true);
		$("#bookClosingDate").siblings($(".ui-datepicker-trigger")).hide();
		$("#dividendNo").attr("disabled", true);
		$("#extRefNo").attr("disabled", true);
	}else if ($('#subEventType').val() == 'CONVERSION' || $('#subEventType').val() == 'COUPON_PAYMENT' 
			  || $('#subEventType').val() == 'EXCHANGE' || $('#subEventType').val() == 'NAME_CHANGE' 
			  || $('#subEventType').val() == 'ASSIMILATION' || $('#subEventType').val() == 'FUNGIBILITY' 
			  || $('#subEventType').val() == 'RIGHTS_REGISTRATION' || $('#subEventType').val() == 'TAKE_OVER'){
		$("#extRefNo").attr("disabled", true);
	}else if ($('#subEventType').val() == 'REVERSE_STOCK_SPLIT' || $('#subEventType').val() == 'SPIN_OFF' 
			  || $('#subEventType').val() == 'STOCK_SPLIT' || $('#subEventType').val() == 'STOCK_SPLIT_WITH_CODE_CHANGE' 
			  || $('#subEventType').val() == 'CONSOLIDATION'){
		$("#instrumentCode").attr("disabled", true);
		$("#instrumentCode").closest("div").find('.popupBtnIco').hide();
		$("#exDate").attr("disabled", true);
		$("#exDate").siblings($(".ui-datepicker-trigger")).hide();
		$("#recordDate").attr("disabled", true);
		$("#recordDate").siblings($(".ui-datepicker-trigger")).hide();
		$("#bookClosingDate").attr("disabled", true);
		$("#bookClosingDate").siblings($(".ui-datepicker-trigger")).hide();
		$("#extRefNo").attr("disabled", true);
	}else if ($('#subEventType').val() == 'STOCK_DIVIDEND'){
		$("#bookDateValue").attr("disabled", true);
		$("#bookDateValue").siblings($(".ui-datepicker-trigger")).hide();
		$("#dividendNo").attr("disabled", true);
	}else if ($('#subEventType').val() == 'DIV_REINVESTMENT' || $('#subEventType').val() == 'OPTIONAL_STOCK_DIV' 
			  || $('#subEventType').val() == 'SCRIPT_DIVIDEND'){
		$("#bookDateValue").attr("disabled", true);
		$("#bookDateValue").siblings($(".ui-datepicker-trigger")).hide();
	}else{
		// do nothing
	}
}

/**
 * Enable the fields for an event type in AMEND operation.
 * Fields disabled from disableFieldsForAmend() function should be enabled using this function.
 */
xenos.ns.cax.eventEntry.enableFieldsForAmend = function() {
	
	$("#subEventType").attr("disabled", false);
	$("#caEventRefNo").attr("disabled", false);
	$("#bookClosingDate").attr("disabled", false);
	$("#bookClosingDate").siblings($(".ui-datepicker-trigger")).show();
	$("#dividendNo").attr("disabled", false);
	$("#extRefNo").attr("disabled", false);
	$("#instrumentCode").attr("disabled", false);
	$("#instrumentCode").closest("div").find('.popupBtnIco').show();
	$("#exDate").attr("disabled", false);
	$("#exDate").siblings($(".ui-datepicker-trigger")).show();
	$("#recordDate").attr("disabled", false);
	$("#recordDate").siblings($(".ui-datepicker-trigger")).show();
	$("#bookDateValue").attr("disabled", false);
	$("#bookDateValue").siblings($(".ui-datepicker-trigger")).show();
}
