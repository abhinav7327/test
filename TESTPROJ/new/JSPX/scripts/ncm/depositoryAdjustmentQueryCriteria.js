//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
 xenos.ns.views.depositoryAdjustmentQueryCriteria.validateSubmit = function(){
	 
		var validationMessages = [];
		var dateRangeValidationFails = false;
		
		// Validate both from and to dates have been specified
		if($.trim($('#adjustmentDateFrom').val()).length> 0 && isDateCustom($.trim($('#adjustmentDateFrom').val()))==false){
			dateRangeValidationFails=true;
			validationMessages.push(xenos$NCM$i18n.depoadjquery.validation.datefrom_invalid);
		}
		if($.trim($('#adjustmentDateTo').val()).length> 0 && isDateCustom($.trim($('#adjustmentDateTo').val()))==false){
			dateRangeValidationFails=true;
			validationMessages.push(xenos$NCM$i18n.depoadjquery.validation.dateto_invalid);
		}
		if($.trim($('#adustmentDateTo').val()).length==0 && $.trim($('#adjustmentDateFrom').val()).length==0){
			validationMessages.push(xenos$NCM$i18n.depoadjquery.validation.date_empty);
		}
		if(dateRangeValidationFails==false && !isValidDateRange($.trim($('#adjustmentDateFrom').val()), $.trim($('#adjustmentDateTo').val()))){
			validationMessages.push(xenos$NCM$i18n.depoadjquery.validation.datefrom_less);
		}
		
		// Validate both from and to dates have been specified
		if($.trim($('#appRegiDateFrom').val()).length> 0 && isDateCustom($.trim($('#appRegiDateTo').val()))==false){
			dateRangeValidationFails=true;
			validationMessages.push(xenos$NCM$i18n.depoadjquery.validation.app_reg_date_to_invalid);
		}
		if($.trim($('#appRegiDateTo').val()).length> 0 && isDateCustom($.trim($('#appRegiDateFrom').val()))==false){
			dateRangeValidationFails=true;
			validationMessages.push(xenos$NCM$i18n.depoadjquery.validation.app_reg_date_from_invalid);
		}
		
		// Validate both from and to dates have been specified
		if($.trim($('#updateDateFrom').val()).length> 0 && isDateCustom($.trim($('#updateDateTo').val()))==false){
			dateRangeValidationFails=true;
			validationMessages.push(xenos$NCM$i18n.depoadjquery.validation.app_up_date_to_invalid);
		}
		if($.trim($('#updateDateTo').val()).length> 0 && isDateCustom($.trim($('#updateDateFrom').val()))==false){
			dateRangeValidationFails=true;
			validationMessages.push(xenos$NCM$i18n.depoadjquery.validation.app_up_date_from_invalid);
		}
		
		if(validationMessages.length > 0){
			$('.formHeader').find('.formTabErrorIco').css('display', 'block');
			$('.formHeader').find('.formTabErrorIco').off('click');
			$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
			return false;
		}else{
			$('.formHeader').find('.formTabErrorIco').css('display', 'none');
		}
		return true;
		
	};
	
	

xenos.ns.views.depositoryAdjustmentQueryCriteria.formatDate = function(date){
		if(date.value.length == 7){
			if(date.id=="adjustmentDateFrom"){
				$("#adjustmentDateFrom").val(date.value.substr(0,6)+"0"+date.value.substr(6));
			}
			if(date.id=="adjustmentDateTo"){
				$("#adjustmentDateTo").val(date.value.substr(0,6)+"0"+date.value.substr(6));
			}
			if(date.id=="appRegiDateFrom"){
				$("#appRegiDateFrom").val(date.value.substr(0,6)+"0"+date.value.substr(6));
			}
			if(date.id=="appRegiDateTo"){
				$("#appRegiDateTO").val(date.value.substr(0,6)+"0"+date.value.substr(6));
			}
			if(date.id=="updateDateFrom"){
				$("#updateDateFrom").val(date.value.substr(0,6)+"0"+date.value.substr(6));
			}
			if(date.id=="updateDateTo"){
				$("#updateDateTo").val(date.value.substr(0,6)+"0"+date.value.substr(6));
			}
		}
	 };