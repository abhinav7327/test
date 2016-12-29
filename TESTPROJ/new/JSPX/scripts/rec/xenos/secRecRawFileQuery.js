//$Id$
//$Author: rameezr $
//$Date: 2016-12-23 14:58:01 $
xenos.ns.secRecRawFileQry.validateRawFileQryFields = function() {

		var alertStr = [];	

		var receivedDateFrom  = $('#receivedDateFrom').val();
		var receivedDateTo    = $('#receivedDateTo').val();
		
		
		var dateFormatValidationFails = false;
		
		if(dateFormatValidationFails==false && receivedDateFrom.length > 0 && isDateCustom(receivedDateFrom)==false) {
			dateFormatValidationFails = true;
			alertStr.push(xenos.utils.evaluateMessage(xenos$REC$i18n.securityRecon.date_format_check, [receivedDateFrom]));
		}
		
		if(dateFormatValidationFails==false && receivedDateTo.length > 0 && isDateCustom(receivedDateTo)==false) {
			dateFormatValidationFails = true;
			alertStr.push(xenos.utils.evaluateMessage(xenos$REC$i18n.securityRecon.date_format_check, [receivedDateTo]));
		}
		
		
		if(dateFormatValidationFails==false){
		
			if(isRawFileQryFieldValidText(receivedDateFrom) && isRawFileQryFieldValidText(receivedDateTo)) {
				
				if (!isValidDateRange(receivedDateFrom, receivedDateTo)) {
					dateFormatValidationFails = true;
					alertStr.push(xenos$REC$i18n.securityRecon.date_from_to_check);
				}
			}
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
		
function isRawFileQryFieldValidText(text){
	if(text!='undefined' && text!=null && $.trim(text).length > 0){
		return true;
	}
	return false;
}
function bankAndBankAcFromFundHandler(){
	
	var fundCode = $('#fundCode').val();
	if(fundCode!==""){
		var reqObj =  {"fundCode" : fundCode};
		var xenos$Handler$bankAndBankAcFromFund = xenos$Handler$function({
			get : {
				requestType : xenos$Handler$default.requestType.asynchronous,
				contentType : 'json'
			},
			settings : {
				beforeSend : function(request) {
					request.setRequestHeader('Accept', 'application/json;type=ajax');
				},
				type: 'POST'
			}
		});
		var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
		var fragmentName = '&fragments=content';
		var $target = $(this);
		var context = $target.closest('.formContent');
		var requestUrl = xenos.context.path + "/secure/rec/sec/rawfile/query/loadBankAndBankAccountFromFund.json" + commandFormId + fragmentName;
		xenos$Handler$bankAndBankAcFromFund.generic(undefined,{
				requestUri : requestUrl,
				settings: {
					data : reqObj
				},
				onJsonContent : function(e, options, $target, content) {
					if (content.success == false) {
						var msg = [];
						$.each(content.value, function(index, value) {
							msg.push(value);
						});
						xenos.postNotice(xenos.notice.type.error, msg, true);
					}else{
						var mutipleBankPresent = content.value[0].multipleBankPresent;
						var mutipleBankAccountPresent = content.value[0].multipleBankAccountPresent;
						var pageLoading = content.value[0].pageLoading;
						if(mutipleBankPresent == true || pageLoading == true){
							$('#bank').val("");
							$('#bank').attr("readonly",false);
							$('.secReconBank').show();
							$('#reconBank').removeAttr("fundCodeContext");
						}
						if(mutipleBankPresent == false && pageLoading == false){
							$('#bank').val(content.value[0].bank);
							$('#bank').attr("readonly",true);
							$('.secReconBank').hide();
							$('#sendRefNo').focus();
						}
						if(mutipleBankAccountPresent == true || pageLoading == true){
							$('#accountNo').val("");
							$('#accountNo').attr("readonly",false);
							$('#accountNo').show();
						}
						if(mutipleBankAccountPresent == false && pageLoading == false){
							$('#accountNo').val(content.value[0].accountNo);
							$('#accountNo').attr("readonly",true);
							$('.secReconBankAcc').hide();
						}
						$('#reconBank').attr("fundCodeContext",$('#fundCode').val());
					}  
				}
		});
		
	}
	
	
}

xenos.ns.secRecRawFileQry.formatRcvDateFrom = function(rcvDateFrom) {
	if(rcvDateFrom.length == 7){
		$("#receivedDateFrom").val(rcvDateFrom.substr(0,6)+"0"+rcvDateFrom.substr(6));
	}
}
xenos.ns.secRecRawFileQry.formatRcvDateTo = function(rcvDateTo) {
	if(rcvDateTo.length == 7){
		$("#receivedDateTo").val(rcvDateTo.substr(0,6)+"0"+rcvDateTo.substr(6));
	}
}