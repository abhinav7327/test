//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
var xenos$Handler$cpSSIEntry = xenos$Handler$function({
	  get: {
		requestType: xenos$Handler$default.requestType.asynchronous,
		target: '#wizard-page'					

	  },
	  settings: {
		beforeSend: function(request) {
		  request.setRequestHeader('Accept', 'text/html;type=ajax');
		},
		type: 'POST'
	  }
});
			
function proceedCpSsiEntryHandler(e){
	/** var context = $("#content");
	var baseUrl = xenos.context.path + context.find('form').attr('action'); **/
	var valid = validateCpSatndingAdd();
	if(valid){
					   
			xenos$Handler$cpSSIEntry.generic(undefined, {	requestUri: xenos.context.path + '/secure/ref/cpssi/entry/proceed' + '?commandFormId=' + $('[name=commandFormId]').val(),
													settings: {data : populateRequestParam()},
													onHtmlContent :  function(e, options, $target, content) {
														if(content.indexOf('class="xenosError"')!=-1){
															var msg = [];
															$.each($('ul.xenosError li',content), function(index, value) {
															  msg.push($(value).text());
															});
															
															xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
														}else{
															$target.html(content);
															$("#formActionArea .btnsArea .wizReset .inputBtnStyle").show();
															$("#formActionArea .btnsArea .wizSubmit .inputBtnStyle").show();
															//$("#formActionArea .btnsArea .wizBack .inputBtnStyle").hide();
															
															$("#formActionArea .btnsArea .wizReset .inputBtnStyle").removeAttr("disabled");
															$("#formActionArea .btnsArea .wizSubmit .inputBtnStyle").removeAttr("disabled");
															
															$("#formActionArea .btnsArea .wizReset .inputBtnStyle").trigger('click');
															
														}
														
													}
												 }
									);
									return false;
		
		 }
}

/**
* Populate Name X Ref request parameters.
*/
function populateRequestParam(){
	var reqObj = {
					"cpSecRule.counterPartyType": $.trim($('#counterPartyCodeDropDown').val()),
					"cpSecRule.counterPartyCode": $.trim($('#counterPartyCode').val()),
					"cpSecRule.tradingAccountNo": $.trim($('#accountNo').val()),
					"cpSecRule.settlementFor": $.trim($('#stlForDropdown').val()),
					"cpSecRule.cashSecurityFlag": $.trim($('#cashSecurityFlagFld').val()),
					"cpSecRule.market": $.trim($('#marketTxtBox').val()),
					"countryCode": $.trim($('#countryCode').val()),
					"cpSecRule.instrumentType": $.trim($('#instrumentTypeTxtBox').val()),
					"cpSecRule.instrumentCode": $.trim($('#instrumentCode').val()),
					"cpSecRule.settlementCcy": $.trim($('#stlCcy').val()),
					"cpSecRule.settlementType": $.trim($('#stlTypeInitial').val()),
					"cpSecRule.deliveryMethod": $.trim($('#form').val()),
					"cpSecRule.priority": $.trim($('#priorityType').val()),
					"cpSecRule.localAccountNo": $.trim($('#localAccountNo').val()),
					"diffCash": "",
					"cpCashRule.settlementMode": "",
					"cpCashRule.secCash": "",
				};
	return reqObj;
}

function validateCpSatndingAdd(){
		var validationMessages = [];
		var counterPartyTypeVal = $.trim($('#counterPartyCodeDropDown').val());
		var counterPartyCodeVal = $.trim($('#counterPartyCode').val());
		
		var accountNoVal = $.trim($('#accountNo').val());
		
		if(counterPartyTypeVal.length != 0){
			if(counterPartyCodeVal.length == 0) {
				validationMessages.push(xenos$REF$i18n.cpSSIEntry.validation.emptyCounterpartyCode);
			}	
		} else if(accountNoVal.length == 0) {
			validationMessages.push(xenos$REF$i18n.cpSSIEntry.validation.emptyCounterpartyAccount);
		
		}
		
		if (validationMessages.length > 0){
			 xenos.utils.displayGrowlMessage(xenos.notice.type.error, validationMessages);
			 return false;
		}else {
			   xenos.utils.clearGrowlMessage();
		}
		return true;
}
			