//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
 
 function validateOnNextForFundTabEmpty(){

		var flag = true;
		var alertStr = [];
		
		if(blankCheck($("#fundCode").val())){
			alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.fund_code_blank));
			flag = false;
		}
		if(blankCheck($("#fundName").val())){
			alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.fund_name_blank));
			flag = false;
		}
		if(blankCheck($("#officeId").val())){
			alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.lm_office_blank));
			flag = false;
		}
		if(blankCheck($("#fundCategory").val())){
			alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.fund_category));
			flag = false;
		}
		if(blankCheck($("#baseCurrency").val())){
			alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.base_curr_blank));
			flag = false;
		}
		if(blankCheck($("#lmPositionCustody").val())){
			alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.lm_position_custody));
			flag = false;
		}
		if(blankCheck($("#taxFeeInclusion").val())){
			alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.taxFee_incl_empty));
			flag = false;
		}
		if(blankCheck($("#iconRequired").val())){
			alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.icon_reqd_blank));
			flag = false;
		}
		if(blankCheck($("#cashViewerReqd").val())){
			alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.cash_viewer_blank));
			flag = false;
		}
		if(blankCheck($("#fbpIfRequired").val())){
			alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.fbif_empty));
			flag = false;
		}
		if(blankCheck($("#gemsRequired").val())){
			alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.gems_required));
			flag = false;
		}
		if(blankCheck($("#formaRequired").val())){
			alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.form_required));
			flag = false;
		}

		if(!blankCheck($("#instructionCopyRcvBic").val())){
			if($("#instructionCopyRcvBic").val().length != 11){
				alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.rcv_BIC_length));
				flag = false;
			}
			if(blankCheck($("#copyInstructionType").val())){
				alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.copy_inst_type));
				flag = false;
			}
		}else{
			if(!blankCheck($("#copyInstructionType").val())){
				alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.receivebiccopy));
				flag = false;
			}
		}
		if(!blankCheck($("#startDateStr").val()) && !isDateCustom($("#startDateStr").val())){
			alertStr.push(xenos.utils.evaluateMessage('Illegal Start date format '+$("#startDateStr").val()));
			flag = false;
		}
		if(!blankCheck($("#closeDateStr").val()) && !isDateCustom($("#closeDateStr").val())){
			alertStr.push(xenos.utils.evaluateMessage('Illegal Close date format '+$("#closeDateStr").val()));
			flag = false;
		}
		if(!blankCheck($("#startDateStr").val()) && !blankCheck($("#closeDateStr").val()) && isDateCustom($("#startDateStr").val()) && isDateCustom($("#closeDateStr").val())){
			if(!isValidDateRange($("#startDateStr").val(), $("#closeDateStr").val())){
				alertStr.push(xenos.utils.evaluateMessage(xenos$REF$i18n.account.common.invalid_start_end_date));
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

 

function blankCheck(parameter){
	var result = false;
	if(parameter == "" || parameter == null || parameter == undefined){
		result = true;
	}
	return result;
}


function onChangeLMOffice(onChange) {

	var lmOfficeVal = $("#officeId option:selected").val();
	var index = 0;
	var index1 = 0;
	var index2 = 0;
	if(lmOfficeVal == "") {
		$("#iconRequired option").eq(0).prop('selected', true);
		$("#iconRequired").prop("disabled", true);
		index = getIndexOfDropdownValue($("#tfRequired"),"N");
		$("#tfRequired option").eq(index).prop('selected', true);
		$("#tfRequired").prop("disabled", true);
	}else if (onChange) {
		if(lmOfficeVal == "UK") {
			index1 = getIndexOfDropdownValue($("#iconRequired"),"Y");
			$("#iconRequired option").eq(index1).prop('selected', true);
			$("#iconRequired").prop("disabled", false);
			index2 = getIndexOfDropdownValue($("#tfRequired"),"Y");
			$("#tfRequired option").eq(index2).prop('selected', true);
			$("#tfRequired").prop("disabled", false);
		}else {
			index1 = getIndexOfDropdownValue($("#iconRequired"),"N");
			$("#iconRequired option").eq(index1).prop('selected', true);
			$("#iconRequired").prop("disabled", false);
			index2 = getIndexOfDropdownValue($("#tfRequired"),"N");
			$("#tfRequired option").eq(index2).prop('selected', true);
			$("#tfRequired").prop("disabled", false);
		}
	}else {
		$("#iconRequired").prop("disabled", false);
		$("#tfRequired").prop("disabled", false);
	}
}


function onChangeFundCategory(onChange){
	
	var fundCategoryVal = $("#fundCategory option:selected").val();
	var index = 0;
	var index1 = 0;
	var index2 = 0;
	var index3 = 0;
	if(fundCategoryVal == "") {
		$("#gemsRequired option").eq(0).prop('selected', true);
		$("#gemsRequired").prop("disabled", true);
		$("#formaRequired option").eq(0).prop('selected', true);
		$("#formaRequired").prop("disabled", true);
		$("#cashViewerReqd option").eq(0).prop('selected', true);
		$("#cashViewerReqd").prop("disabled", true);
	}
	if(onChange) {
		if(fundCategoryVal == "ADVISORY_FUND") {
			index = getIndexOfDropdownValue($("#gemsRequired"),"Y");
			$("#gemsRequired option").eq(index).prop('selected', true);
			$("#gemsRequired").prop("disabled", false);
			
			$("#disabledFieldsDataAppender #gemsRequiredHidden").remove();
			
			index1 = getIndexOfDropdownValue($("#formaRequired"),"N");
			$("#formaRequired option").eq(index1).prop('selected', true);
			$("#formaRequired").prop("disabled", true);
			
			$('<input type="hidden" id="formaRequiredHidden" value="N" name="fund.formaRequired" />').appendTo("#disabledFieldsDataAppender");
			
			index2 = getIndexOfDropdownValue($("#cashViewerReqd"),"N");
			$("#cashViewerReqd option").eq(index2).prop('selected', true);
			$("#cashViewerReqd").prop("disabled", true);
			
			$('<input type="hidden" id="cashViewerReqdHidden" value="N" name="fund.cashViewerReqd" />').appendTo("#disabledFieldsDataAppender");

			index3 = getIndexOfDropdownValue($("#lmPositionCustody"),"N");
			$("#lmPositionCustody option").eq(index3).prop('selected', true);
		}
		if(fundCategoryVal == "MUTUAL_FUND") {
			index = getIndexOfDropdownValue($("#gemsRequired"),"N");
			$("#gemsRequired option").eq(index).prop('selected', true);
			$("#gemsRequired").prop("disabled", true);
			
			$('<input type="hidden" id="gemsRequiredHidden" value="N" name="fund.gemsRequired" />').appendTo("#disabledFieldsDataAppender");
			
			index1 = getIndexOfDropdownValue($("#formaRequired"),"Y");
			$("#formaRequired option").eq(index1).prop('selected', true);
			$("#formaRequired").prop("disabled", false);
			
			$("#disabledFieldsDataAppender #formaRequiredHidden").remove();
			
			index2 = getIndexOfDropdownValue($("#cashViewerReqd"),"Y");
			$("#cashViewerReqd option").eq(index2).prop('selected', true);
			$("#cashViewerReqd").prop("disabled", false);
			
			$("#disabledFieldsDataAppender #cashViewerReqdHidden").remove();
			
			index3 = getIndexOfDropdownValue($("#lmPositionCustody"),"Y");
			$("#lmPositionCustody option").eq(index3).prop('selected', true);
		}
	}else{
		if(fundCategoryVal == "ADVISORY_FUND") {
			index1 = getIndexOfDropdownValue($("#formaRequired"),"N");
			$("#formaRequired option").eq(index1).prop('selected', true);
			$("#formaRequired").prop("disabled", true);
			
			$('<input type="hidden" id="formaRequiredHidden" value="N" name="fund.formaRequired" />').appendTo("#disabledFieldsDataAppender");
			
			index2 = getIndexOfDropdownValue($("#cashViewerReqd"),"N");
			$("#cashViewerReqd option").eq(index2).prop('selected', true);
			$("#cashViewerReqd").prop("disabled", true);
			
			$('<input type="hidden" id="cashViewerReqdHidden" value="N" name="fund.cashViewerReqd" />').appendTo("#disabledFieldsDataAppender");
		}
		if(fundCategoryVal == "MUTUAL_FUND") {
			index = getIndexOfDropdownValue($("#gemsRequired"),"N");
			$("#gemsRequired option").eq(index).prop('selected', true);
			$("#gemsRequired").prop("disabled", true);
		}
	}
}


function changeCxlForexTagReqd() {
	
	var value = $("#cxlforextagreqd").val() != null ? $("#cxlforextagreqd").val() : "";
	
	if(value != "Y"){
		$("#settlementCcy").prop('disabled',true);
		$("#forexCcy").prop('disabled',true);
		$("#settlementCcyBtn").prop('disabled',true);
		$("#forexCcyBtn").prop('disabled',true);
		$("#addForexInstEntryBtn").prop('disabled',true);
	}else{
		$("#settlementCcy").prop('disabled',false);
		$("#forexCcy").prop('disabled',false);
		$("#settlementCcyBtn").prop('disabled',false);
		$("#forexCcyBtn").prop('disabled',false);
		$("#addForexInstEntryBtn").prop('disabled',false);
	}
}


function getIndexOfDropdownValue(list,value){
	var index = 0;
	if(value == "" || value == null || value == undefined){
		return index;
	}
	for(var i = 0; i < list.children('option').length; i++){
		if(list.children('option').eq(i).val() == value){
			index = i;
			break;
		}
	}
	return index;
}

function formatDate(target){
	var value=target.value;
	if(value.length == 7){
		$("#"+target.id).val(value.substr(0,6)+"0"+value.substr(6));
	}
 }

function blankCheck(parameter){
	var result = false;
	if(parameter == "" || parameter == null || parameter == undefined){
		result = true;
	}
	return result;
}