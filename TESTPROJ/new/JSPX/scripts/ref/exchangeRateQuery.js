//$Id$
//$Author: dheerajk $
//$Date: 2016-12-24 13:39:18 $
xenos.ns.views.exchangeRateQuery.validateSubmit = function(){
	
	var alertStr = [];
	var baseDateFrom = $('#baseDateFromStr').val();
	var baseDateTo = $('#baseDateToStr').val();
	var dateFormatValidationFails = false;
	
	if(baseDateFrom.length>0 && isDateCustom(baseDateFrom)==false){
		dateFormatValidationFails = true;
		alertStr.push(xenos$REF$i18n.exchangerate.query.date_format_of_from_date_check + baseDateFrom);
	}
	
	if(baseDateTo.length>0 && isDateCustom(baseDateTo)==false){
		dateFormatValidationFails = true;
		alertStr.push(xenos$REF$i18n.exchangerate.query.date_format_of_to_date_check + baseDateTo);
	}
	
	if(baseDateFrom.length>0 && baseDateTo.length>0 && dateFormatValidationFails==false){
		if(!isValidDateRange(baseDateFrom,baseDateTo)){
			alertStr.push(xenos$REF$i18n.exchangerate.query.date_from_to_check);
		}
	}
	
	formatExchangeRate($("#exchangeRateStr"), 10, 10, alertStr, $("#exchangeRateStr").parent().parent().find('label').text());
	
	if(alertStr.length>0){
		$('.formHeader').find('.formTabErrorIco').css('display','block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, alertStr, true));
		return false;
	}
	else{
		$('.formHeader').find('.formTabErrorIco').css('display','none');
	}
	return true;
}

xenos.ns.views.exchangeRateQuery.formatDate = function(date){
	if(date.value.length == 7){
		if(date.id=="baseDateFromStr"){
			$("#baseDateFromStr").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		if(date.id=="baseDateToStr"){
			$("#baseDateToStr").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
	}
 }