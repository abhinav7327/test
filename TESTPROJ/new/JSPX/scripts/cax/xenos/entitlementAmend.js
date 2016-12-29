//$Id$
//$Author: prashmitap $
//$Date: 2016-12-23 18:05:46 $
/**
* Validate Screen Fields.
*/
xenos.ns.entitlement.amend.validateSubmitEntitlementAmend = function(){
		var validationMessages = [];
		var paymentDate = $.trim($('#paymentDate').val());
		var securityBalance = $.trim($('#securityBalanceStr').val());
		var underlineSecurityBV = $.trim($('#underlineSecurityBV').val());
		var allottedQuantityStr = $.trim($('#allottedQuantityStr').val());
		var allottedAmountStr = $.trim($('#allottedAmountStr').val());
		var splAmountOrQtyStr = $.trim($('#splAmountOrQtyStr').val());
		var fractionalShareStr = $.trim($('#fractionalShareStr').val());
		var availableDate = $.trim($('#availableDate').val());
		
		if(VALIDATOR.isNullValue(securityBalance)){
			validationMessages.push(xenos$CAX$i18n.entitlementAdjustmentEntry.security_balance_empty);
		}
		else {
			if(!formatSignedQuantity($('#securityBalanceStr'),15,3,null,$('#securityBalanceStr').parent().parent().find('label').text())) { 
				return false;
			}
		}
		
		if(VALIDATOR.isNullValue(paymentDate)){
			validationMessages.push(xenos$CAX$i18n.entitlementAdjustmentEntry.payment_date_empty);
		}
		else {
			if(paymentDate.length > 0 && isDateCustom(paymentDate)==false) {
				validationMessages.push(xenos$CAX$i18n.entitlementAdjustmentEntry.dateformat_invalid + ' ' + paymentDate);
			}
		}
		if(!VALIDATOR.isNullValue(availableDate)){
			if(availableDate.length > 0 && isDateCustom(availableDate)==false) {
				validationMessages.push(xenos$CAX$i18n.entitlementAdjustmentEntry.dateformat_invalid + ' ' + availableDate);
			}
		}
		if(!VALIDATOR.isNullValue(underlineSecurityBV)){
			if(!formatSignedQuantity($('#underlineSecurityBV'),15,3,null,$('#underlineSecurityBV').parent().parent().find('label').text())) {
				return false;
			}
		}
		if(!VALIDATOR.isNullValue(allottedQuantityStr)){
			if(!formatSignedQuantity($('#allottedQuantityStr'),15,3,null,$('#allottedQuantityStr').parent().parent().find('label').text())) {
				return false;
			}
		}
		if(!VALIDATOR.isNullValue(allottedAmountStr)){
			if(!formatSignedQuantity($('#allottedAmountStr'),15,3,null,$('#allottedAmountStr').parent().parent().find('label').text())) {
				return false;
			}
		}
		if(!VALIDATOR.isNullValue(splAmountOrQtyStr)){
			if(!formatSignedQuantity($('#splAmountOrQtyStr'),15,3,null,$('#splAmountOrQtyStr').parent().parent().find('label').text())) {
				return false;
			}
		}
		if(!VALIDATOR.isNullValue(fractionalShareStr)){
			if(!formatSignedQuantity($('#fractionalShareStr'),15,3,null,$('#fractionalShareStr').parent().parent().find('label').text())) {
				return false;
			}
		}
		if(validationMessages.length > 0) {
			xenos.utils.displayGrowlMessage(xenos.notice.type.error, validationMessages);
			return false;
		}else{
			xenos.utils.clearGrowlMessage();
		}
		return true;
};

/**
 * A common request handler to be used server communication for JSON.
 */
var xenos$entitlement$amend$Handler$RequestHandler = xenos$Handler$function({
		get: {
			contentType: 'json',
			requestType: xenos$Handler$default.requestType.asynchronous
		},	
		settings: {
			beforeSend: function(request) {
				request.setRequestHeader('Accept', 'application/json');
			},
			type: 'POST'
		}
	});
	
/**
* A common request handler to be used server communication for HTML.
*/
var xenos$entitlement$amend$Handler$RequestHandlerHtml = xenos$Handler$function({
	get: {
		requestType: xenos$Handler$default.requestType.asynchronous
	},	
	settings : {
		beforeSend : function(request) {
		request.setRequestHeader('Accept', 'text/html;type=ajax');
	},
	type : 'POST'
	}
});	

/**
  * Method to populate data for cash related entitlements for the amend screen.
  * @param mapObj - The keyList containing the key and the value.
  * @param detailType - Detail Type RIGHTS_DETAIL' or 'NCM_RIGHTS_DETAIL'
  */ 
  xenos.ns.entitlement.amend.loadCashPart = function(corporateActionId, detailType) {
	var initcol = [];
	var index = 0;
	var item = null;
	if(detailType == "RIGHTS_DETAIL")
	{
		$('#cashPartGiveUpIndicator').css('display','block');
	}
	else {
		$('#cashPartGiveUpIndicator').css('display','none');
	}

	 switch(corporateActionId) { 
		case "CASH_DIVIDEND":
			$('#cashPartSplAmountOrQtyStr').css('display','block');
		case "CAPITAL_REPAYMENT": 
			$('#cashPartSplAmountOrQtyStr').css('display','block');      
		case "OPTIONAL_STOCK_DIV":
			$('#cashPartSplAmountOrQtyStr').css('display','block');
		case "DIV_REINVESTMENT":
			$('#cashPartSplAmountOrQtyStr').css('display','block');
			$('#splQRow').css('display','block'); 
		break;
		case "COUPON_PAYMENT":
			$('#cashPartSplAmountOrQtyStr').css('display','none');
		case "REDEMPTION_BOND":
			$('#cashPartSplAmountOrQtyStr').css('display','none');
			$('#splQRow').css('display','none'); 
		break;          
	}       
  };
  
  /**
  * Method to populate data for stock related entitlements for the amend screen.
  * @param mapObj - The keyList containing the key and the value.
  * @param detailType - Detail Type RIGHTS_DETAIL' or 'NCM_RIGHTS_DETAIL'* 
  */ 
  xenos.ns.entitlement.amend.loadStockPart = function(corporateActionId, detailType, hiddenCashInLieuFlag) {
	
	$('#stockPartFractionalShareStr').css('display','block');

	$('#stockPartCashInLieuFlag').css('display','block');

	/** Populating cashInLieuLabel : for NAME_CHANGE its should be hidden
	 *  For rest - should be visible.
	 */ 
	if(corporateActionId == "NAME_CHANGE"){
		$('#stockPartCashInLieuFlag').css('display','none');
	} else {
		$('#stockPartCashInLieuFlag').css('display','block');
	}
	if(hiddenCashInLieuFlag == "Y") {
		$('#allottedQuantityStr').val('');
		$('#allottedQuantityStr').attr('readonly',true);
		$('#allottedAmountStr').attr('readonly',false);
	} else {
		$('#allottedQuantityStr').attr('readonly',false);
		$('#allottedAmountStr').attr('readonly',true);
		$('#allottedAmountStr').val('');
	}
		
	/** Populating splAmountOrQtyRow : for Stock Dividend its should be visible
	 *  For Stock Split - should be hidden.
	 */
	 switch(corporateActionId) {  
	   case "STOCK_DIVIDEND": 
			$('#stockPartSplAmtOrQtyStr').css('display','block');
	   case "BONUS_ISSUE":
			$('#stockPartSplAmtOrQtyStr').css('display','block');
	   case "STOCK_MERGER":
			$('#stockPartSplAmtOrQtyStr').css('display','block');
	   case "RIGHTS_ALLOCATION":
			$('#stockPartSplAmtOrQtyStr').css('display','block');
	   case "RIGHTS_EXPIRY":
			$('#stockPartSplAmtOrQtyStr').css('display','block');
	  break;
	  case "STOCK_SPLIT":
			$('#stockPartSplAmtOrQtyStr').css('display','none');
	  case "NAME_CHANGE":
			$('#stockPartSplAmtOrQtyStr').css('display','none');
	  case "SPIN_OFF":
			$('#stockPartSplAmtOrQtyStr').css('display','none');
	  case "REVERSE_STOCK_SPLIT": 
			$('#stockPartSplAmtOrQtyStr').css('display','none');
	  case "OTHERS":
			$('#stockPartSplAmtOrQtyStr').css('display','none');
	  break;            
	} 
  };
  
  
  /**
  * Method to populate others detail type
  * @param Object - The keyList containg the key and the value.
  */   
  xenos.ns.entitlement.amend.loadOthersEventPart = function(isFlagForCash) {	
	$('#eventTypeNameDiv').css('display','block');

	$('#stockPartFractionalShareStr').css('display','none');
	$('#stockPartCashInLieuFlag').css('display','none');
							  
	if(isFlagForCash == "true") {
		$('#allottedQuantityStr').attr('readonly',true);
		$('#allottedAmountStr').attr('readonly',false);		    
	} else {
		$('#allottedAmountStr').attr('readonly',true);
		$('#allottedQuantityStr').attr('readonly',false);		    
	}	
  };
  
  /**
  * Method to check whether Alloted Security is editable or not
  */
  xenos.ns.entitlement.amend.editableAllotSec = function(editableAllotedSec, isIncome) {
	if(editableAllotedSec == 'Y'){
		isEditableFlag = true;
		$('#allottedInstrument').css('display', 'none');
		$('#allottedInstrumentText').css('display', 'block');
		$('#allottedInstrumentName').css('display', 'none');
		$('#allottedInstrumentNameText').css('display', 'block');
		if(isIncome == true){
			isIncomeFlag = true;
			$('#allotCcy').css('display', 'block');
			$('#allotSecurityCode').css('display', 'none');	
		}else{
			isIncomeFlag = false;
			$('#allotCcy').css('display', 'none');
			$('#allotSecurityCode').css('display', 'block');
		}
	}else{
		$('#allottedInstrument').css('display', 'block');
		$('#allottedInstrumentText').css('display', 'none');
		$('#allottedInstrumentName').css('display', 'block');
		$('#allottedInstrumentNameText').css('display', 'none');
		$('#allotCcy').css('display', 'none');
		$('#allotSecurityCode').css('display', 'none');
	}
};

/**
* -----------------------------
* Calculation related functions
* -----------------------------
*/

/**
* Method to call the getCalculatedAmount method to calculate the allotted attributes for the entitlement.
* It fills the request object with the index of detailTaxFeeList to be deleted (i.e the rowNUm)  before sending the request.
*/
xenos.ns.entitlement.amend.calculateHandler = function(e) {
var securityBalance = $('#securityBalanceStr').val();
var rowIndex = -1;
if(VALIDATOR.isNullValue(securityBalance)) {
	xenos.utils.displayGrowlMessage(xenos.notice.type.error, xenos$CAX$i18n.entitlementAdjustmentEntry.security_balance_empty);
}else{
	var baseUrl = xenos.context.path + "/secure/cax/entitlement/adjustment";
	var requestUrl = baseUrl + "/amend/getCalculatedAmount/" + rowIndex + ".json?commandFormId=" + $('[name=commandFormId]').val();
			
			xenos$entitlement$amend$Handler$RequestHandler.generic(e, {	requestUri: requestUrl,
													settings: {
														data: $("#commandForm").serialize()
													},
													onJsonContent :  function(e, options, $target, content) {
														if(content.success == true){
															xenos.ns.entitlement.amend.updateCalculatedFields(content.value[0]);
														} else {
															xenos.utils.displayGrowlMessage(xenos.notice.type.error, content.value[0]);
														}
													}
												 }
			);
	}
};
	
/**
* Function to update allotted amount
*/
xenos.ns.entitlement.amend.updateCalculatedFields = function(data){
	if(data){
		$('#allottedAmountStr').val(data.allottedAmountStr);
		$('#splAmountOrQtyStr').val(data.splAmountOrQtyStr);
		$('#cashInLieuFlagExp').val(data.cashInLieuFlagExp);
		$('#allottedQuantityStr').val(data.allottedQuantityStr);
		$('#fractionalShareStr').val(data.fractionalShareStr);
	}
};

/**
* ------------------------------
* Tax Fee Grid related functions
* ------------------------------
*/

/**
* Validate TaxFee Entry attributes.
*/
 xenos.ns.entitlement.amend.validateTaxFeeAttributes = function(){
		var validationMessages = [];
		var taxFeeId = $.trim($('#taxFeeId').val());
		var rate = $.trim($('#rate').val());
		var rateType = $.trim($('#rateType').val());
		var amount = $.trim($('#amount').val());
		if(VALIDATOR.isNullValue(taxFeeId)){
			validationMessages.push(xenos$CAX$i18n.entitlementAdjustmentEntry.enter_taxFeeId);
		}
		if(VALIDATOR.isNullValue(rateType)){
			if(VALIDATOR.isNullValue(amount)){
				validationMessages.push(xenos$CAX$i18n.entitlementAdjustmentEntry.enter_taxFeeAmount);
			}
			if(VALIDATOR.isNullValue(rate)){
				validationMessages.push(xenos$CAX$i18n.entitlementAdjustmentEntry.enter_taxRate);
			}
			validationMessages.push(xenos$CAX$i18n.entitlementAdjustmentEntry.enter_taxRateType);
		}
		else{
			switch(rateType) {

				case "PERCENT":
					if(VALIDATOR.isNullValue(rate)){
						validationMessages.push(xenos$CAX$i18n.entitlementAdjustmentEntry.enter_taxRate);
					}else {
						return formatRate($('#rate'),8,10,null,$('#rate').parent().parent().find('label').text());
					} 				
					break;
				case "AMOUNT" :
					if(VALIDATOR.isNullValue(amount)){
						validationMessages.push(xenos$CAX$i18n.entitlementAdjustmentEntry.enter_taxFeeAmount);
					}else {
						return formatTaxFeeAmount($('#amount'),13,5,null,$('#amount').parent().parent().find('label').text());
					}
					break;
				case "BP":
					if(VALIDATOR.isNullValue(rate)){
						validationMessages.push(xenos$CAX$i18n.entitlementAdjustmentEntry.enter_taxRate);
					}else {
						return formatRate($('#rate'),8,10,null,$('#rate').parent().parent().find('label').text());
					} 	
				break;
				case "CPS" :
					if(VALIDATOR.isNullValue(rate)){
						validationMessages.push(xenos$CAX$i18n.entitlementAdjustmentEntry.enter_taxRate);
					}else {
						return formatRate($('#rate'),8,10,null,$('#rate').parent().parent().find('label').text());
					}
					
					if(VALIDATOR.isNullValue(amount)){
						validationMessages.push(xenos$CAX$i18n.entitlementAdjustmentEntry.enter_taxFeeAmount);
					}else {
						return formatTaxFeeAmount($('#amount'),13,5,null,$('#amount').parent().parent().find('label').text());
					}
				break;
			 }
		}
		
		if(validationMessages.length > 0) {
			xenos.utils.displayGrowlMessage(xenos.notice.type.error, validationMessages);
			return false;
		}
		return true;
};

/**
* Method to call the getCalculatedTaxFeeAmount method to calculate the allotted attributes for the entitlement.
* It fills the request object with the index of detailTaxFeeList to be deleted (i.e the rowNUm)  before sending the request.
*/
xenos.ns.entitlement.amend.taxAmountCalculateHandler = function(e) {

	var baseUrl = xenos.context.path + "/secure/cax/entitlement/adjustment";
	var requestUrl = baseUrl + "/amend/getCalculatedTaxFeeAmount.json?commandFormId=" + $('[name=commandFormId]').val();
	xenos$entitlement$amend$Handler$RequestHandler.generic(e, {	requestUri: requestUrl,
											settings: {
												data: $("#commandForm").serialize()
											},
											onJsonContent :  function(e, options, $target, content) {
												if(content.success == true){
													xenos.ns.entitlement.amend.updateCalculatedTaxFeeFields(content.value[0]);
												} else {
													xenos.utils.displayGrowlMessage(xenos.notice.type.error, content.value[0]);
												}
											}
										 }
	);
};

/**
* Function to update calculated tax fee amount
*/
xenos.ns.entitlement.amend.updateCalculatedTaxFeeFields = function(data){
	if(data){
		$('#amount').val(data.amount);
	}
}

/**
* This method sets the Tax Fee Requirements depending on the rate type.
*/ 
xenos.ns.entitlement.amend.onChangeRateType = function() {

var rateType = "";
if($('#rateType').val() != null) {
	rateType = $.trim($('#rateType').val());
}
switch(rateType) {

	case "PERCENT":
		$('#amount').val('');
		$('#taxAmountLbl').css("visibility", "hidden");
		$('#amount').css("visibility", "hidden");
		$('#taxRate').css("visibility", "visible");	
		$('#calTaxAmt').css("visibility", "hidden");
		break;
	case "AMOUNT" :
		$('#rate').val('');
		$('#taxRate').css("visibility", "hidden");
		$('#taxAmountLbl').css("visibility", "visible");
		$('#amount').css("visibility", "visible");
		$('#calTaxAmt').css("visibility", "hidden");
		break;
	case "BP":
		$('#taxRate').css("visibility", "visible");
		$('#amount').val('');
		$('#taxAmountLbl').css("visibility", "hidden");
		$('#amount').css("visibility", "hidden");
		$('#calTaxAmt').css("visibility", "visible");
	break;
	case "CPS" :
		$('#taxRate').css("visibility", "visible");
		$('#taxAmountLbl').css("visibility", "visible");
		$('#amount').css("visibility", "visible");
		$('#calTaxAmt').css("visibility", "visible");
	break;
	case "" :
		$('#taxRate').css("visibility", "visible");
		$('#taxAmountLbl').css("visibility", "visible");
		$('#amount').css("visibility", "visible");
		$('#calTaxAmt').css("visibility", "visible");
	break;
 }
};

/**
* ---------------------------------------------------------------
* Functions related to Entitlement Amend User Confirmation Screen
* ---------------------------------------------------------------
*/ 

/**
* Method to populate others detail type
* @param Object - The keyList containg the key and the value.
*/   
xenos.ns.entitlement.amend.loadOthersEventPartConfirm = function(isFlagForCash) {

$('#stockPartFractionalShareStrRow').css('display','none');
$('#eventtypenameLbl').css('display','block');
$('#eventtypename').css('display','block');
};

/**
  * Method to populate data for cash related entitlements for the amend screen.
  * @param mapObj - The keyList containing the key and the value.
  * @param detailType - Detail Type RIGHTS_DETAIL' or 'NCM_RIGHTS_DETAIL'
  */ 
  xenos.ns.entitlement.amend.loadCashPartConfirm = function(corporateActionId, detailType) {
	var initcol = [];
	var index = 0;
	var item = null;
	
	if(detailType == 'RIGHTS_DETAIL') {
		$('#cashPartGiveUpIndicator').css('display','block');
		$('#cashPartGiveUpIndicatorSpan').css('display','block');
	}
	$('#netAmount').css('display','table-row');

	 switch(corporateActionId) { 
		case "CASH_DIVIDEND":
		case "CAPITAL_REPAYMENT": 
		case "OPTIONAL_STOCK_DIV":
		case "DIV_REINVESTMENT":
		break;
		case "COUPON_PAYMENT":
			$('#cashPartSplAmountOrQtyStr').css('display','none');
		case "REDEMPTION_BOND":
			$('#cashPartSplAmountOrQtyStr').css('display','none');
		break;          
	}      
  };
		  
 /**
  * Method to populate data for stock related entitlements for the amend screen.
  * @param mapObj - The keyList containing the key and the value.
  * @param detailType - Detail Type RIGHTS_DETAIL' or 'NCM_RIGHTS_DETAIL'* 
  */ 
  xenos.ns.entitlement.amend.loadStockPartConfirm = function(corporateActionId) {

	/** Populating cashInLieuLabel : for NAME_CHANGE its should be hidden
	 *  For rest - should be visible.
	 */ 
	 if(corporateActionId == "NAME_CHANGE"){
		$('#stockPartCashInLieuFlag').css('display','none');
		$('#stockPartCashInLieuFlagSpan').css('display','none');
	} else {
		$('#stockPartCashInLieuFlag').css('display','block');
		$('#stockPartCashInLieuFlagSpan').css('display','block');
	};

	/** Populating splAmountOrQtyRow : for Stock Dividend its should be visible
	 *  For Stock Split - should be hidden.
	 */
	 switch(corporateActionId) {  
	   case "STOCK_DIVIDEND": 
	   case "BONUS_ISSUE":
	   case "STOCK_MERGER":
	   case "RIGHTS_ALLOCATION":
	   case "RIGHTS_EXPIRY":
	  break;
	  case "STOCK_SPLIT":
			$('#stockPartSplAmtOrQtyStr').css('display','none');
	  case "NAME_CHANGE":
			$('#stockPartSplAmtOrQtyStr').css('display','none');
	  case "SPIN_OFF":
			$('#stockPartSplAmtOrQtyStr').css('display','none');
	  case "REVERSE_STOCK_SPLIT": 
			$('#stockPartSplAmtOrQtyStr').css('display','none');
	  case "OTHERS":
			$('#stockPartSplAmtOrQtyStr').css('display','none');
	  break;            
	} 
  };