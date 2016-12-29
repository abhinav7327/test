//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
 
 function validateOnNextForCustodianTabEmpty(){

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
		if(blankCheck($("#finInstCode").val())){
			alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.fin_inst_reqd));
			flag = false;
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

function validatePrevious(){
	var alertStr = [];
	if(blankCheck($("#shortName").val())){
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.short_name_reqd));
		flag = false;
	}
	if(blankCheck($("#officialName1").val())){
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.office_name_reqd));
		flag = false;
	}
	if(blankCheck($("#finInstCode").val())){
		alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.fin_inst_reqd));
		flag = false;
	}
}

function showAccountNoPopUp(){	
		if(!$("#defaultAcSelect").is(':checked')){
			$("#actPopupDiv").show();
		}else{
			$("#actPopupDiv").hide();
		}
}

function blankCheck(parameter){
	var result = false;
	if(parameter == "" || parameter == null || parameter == undefined){
		result = true;
	}
	return result;
}