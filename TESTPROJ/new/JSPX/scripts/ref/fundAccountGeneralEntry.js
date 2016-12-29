//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
 
 function validateOnNextForGeneralTabEmpty(){

		var flag = true;
		var alertStr = [];
		
		if(blankCheck($("#shortName").val())){
			alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.short_name_reqd));
			flag = false;
		}
		if(blankCheck($("#officialName1").val())){
			alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.office_name_reqd));
			flag = false;
		}
		if($("#counterpartytype").val() != "BANK/CUSTODIAN"){
			if(blankCheck($("#serviceOffice").val())){
				alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.service_office_empty));
				flag = false;
			}
		}
		if(($("#counterpartytype").val() == "INTERNAL") || ($("#counterpartytype").val() == "BANK/CUSTODIAN")){
			if(blankCheck($("#fundCode").val())){
				alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.fund_code_empty));
				flag = false;
			}
		}
		if($("#counterpartytype").val() == "INTERNAL"){
			if(!blankCheck($("#brokerCode").val())){
				alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.broker_code_blank));
				flag = false;
			}
			if(blankCheck($("#longShortFlag").val())){
				alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.long_short_empty));
				flag = false;
			}
			if($("#longShortFlag").val() == "S"){
				if(blankCheck($("#brokerAccount").val())){
					alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.prime_broker_empty));
					flag = false;
				}
			}
		}
		if($("#counterpartytype").val() == "BROKER"){
			if(blankCheck($("#brokerCode").val())){
				alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.broker_code_empty));
				flag = false;
			}
		}
		if($("#counterpartytype").val() == "BANK/CUSTODIAN"){
			if(blankCheck($("#finInstCode").val())){
				alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.fin_inst_reqd));
				flag = false;
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
		
		return flag;		
}

function onChangeLongShortFlag(){
	if($("#longShortFlag").val() == "S"){
		$("#primeBrokerAccountNo").show();
	}else{
		$("#primeBrokerAccountNo").hide();
	}
}

function blankCheck(parameter){
	var result = false;
	if(parameter == "" || parameter == null || parameter == undefined){
		result = true;
	}
	return result;
}