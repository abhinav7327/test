//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
 xenos.ns.views.stlInxQuery.validateSubmit = function(){
	var alertStr = [];
	
	var settleFor = $.trim($('#settleFor').val());
	var tradeReferenceNo = $.trim($('#tradeReferenceNo').val());
	var settlementCcy = $.trim($('#settlementCcy').val());
	var tradeCcy = $.trim($('#tradeCcy').val());
	
	//Call to individual date field validation.
	customDateValidation(alertStr);
	
	if(!VALIDATOR.isNullValue(tradeReferenceNo)){
		if(VALIDATOR.isNullValue(settleFor)){
			alertStr.push(xenos$STL$i18n.mutualFundInstructionQuery.trdFor_valid);
		}
	}
	
	if(!VALIDATOR.isNullValue(settleFor)){
		if(VALIDATOR.isNullValue(tradeReferenceNo)){
			alertStr.push(xenos$STL$i18n.mutualFundInstructionQuery.trdRefNo_valid);
		}
	}
	
	if($('#stlCcyExclude').is(':checked') == true){
		if(VALIDATOR.isNullValue(settlementCcy)){
			alertStr.push(xenos$STL$i18n.mutualFundInstructionQuery.settle_cur_required);
		}
	}
	
	if($('#trdCcyExclude').is(':checked') == true){
		if(VALIDATOR.isNullValue(tradeCcy)){
			alertStr.push(xenos$STL$i18n.mutualFundInstructionQuery.trade_cur_required);
		}
	}
	
	//Show the error message
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
 //This method does individual date field validation for invalid input.
function customDateValidation(alertStr){
	var valueDateFrom = $('#valueDateFrom').val();
	var valueDateTo = $('#valueDateTo').val();	
	var tradeDateFrom = $('#tradeDateFrom').val();
	var tradeDateTo = $('#tradeDateTo').val();
	var inxCreationDate = $('#inxCreationDate').val();
	var transmissionDate = $('#transmissionDate').val();
	var isValidFromDate = true;	
	var isValidToDate = true;
	var isValidInxDate = true;
	var isValidTrxDate = true;	
	
	//Validation Value Date From
	if(valueDateFrom.length>0 && isDateCustom(valueDateFrom)==false) {
		isValidFromDate = false;
		alertStr.push(xenos.utils.evaluateMessage(xenos$STL$i18n.mutualFundInstructionQuery.date_format_check, [valueDateFrom]));
	}
	
	//Validation Value Date To
	if(valueDateTo.length>0 && isDateCustom(valueDateTo)==false) {
		isValidToDate = false;
		alertStr.push(xenos.utils.evaluateMessage(xenos$STL$i18n.mutualFundInstructionQuery.date_format_check, [valueDateTo]));
	}
	
	if((isValidFromDate == true && isValidToDate == true) && !isValidDateRange(valueDateFrom, valueDateTo)){
		alertStr.push(xenos$STL$i18n.mutualFundInstructionQuery.value_date_from_to_check);
	}
	
	isValidFromDate = true;
	isValidToDate = true;
	
	//Validation Trade Date From
	if(tradeDateFrom.length>0 && isDateCustom(tradeDateFrom)==false) {
		isValidFromDate = false;
		alertStr.push(xenos.utils.evaluateMessage(xenos$STL$i18n.mutualFundInstructionQuery.date_format_check, [tradeDateFrom]));
	}
	
	//Validation Trade Date To
	if(tradeDateTo.length>0 && isDateCustom(tradeDateTo)==false) {
		isValidToDate = false;
		alertStr.push(xenos.utils.evaluateMessage(xenos$STL$i18n.mutualFundInstructionQuery.date_format_check, [tradeDateTo]));
	}
	
	if((isValidFromDate == true && isValidToDate == true) && !isValidDateRange(tradeDateFrom, tradeDateTo)){
		alertStr.push(xenos$STL$i18n.mutualFundInstructionQuery.trade_date_from_to_check);
	}
	
	//Validation Inx Created Date
	if(inxCreationDate.length>0 && isDateCustom(inxCreationDate)==false) {
		isValidInxDate = false;
		alertStr.push(xenos.utils.evaluateMessage(xenos$STL$i18n.mutualFundInstructionQuery.date_format_check, [inxCreationDate]));
	}
	
	if((isValidFromDate == true && isValidInxDate == true) && !isValidDateRange(tradeDateFrom,inxCreationDate)){
		alertStr.push(xenos$STL$i18n.mutualFundInstructionQuery.inx_trade_date_check);
	}
	
	//Validation Transmission Date
	if(transmissionDate.length>0 && isDateCustom(transmissionDate)==false) {
		isValidTrxDate = false;
		alertStr.push(xenos.utils.evaluateMessage(xenos$STL$i18n.mutualFundInstructionQuery.date_format_check, [transmissionDate]));
	}
	
	if((isValidFromDate == true && isValidTrxDate == true) && !isValidDateRange(tradeDateFrom,transmissionDate)){
		alertStr.push(xenos$STL$i18n.mutualFundInstructionQuery.trx_trade_date_check);
	}
}

function formatDate(date,id){
	if(date.length == 7){
		id.val(date.substr(0,6)+"0"+date.substr(6));
	}
 }
