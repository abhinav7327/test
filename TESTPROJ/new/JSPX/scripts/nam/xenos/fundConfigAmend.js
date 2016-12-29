//$Id$
//$Author: Saravanan $
//$Date: 2016-12-24 17:14:00 $

/**
 * Used to validate fundCategory as "TSTAR/OTHERS"
 */
function fundConfigAmendValidate(){

	var fundCategoryval = $('#fundCategory :selected').text();
	
	if (fundCategoryval == 'TSTAR') {
		$('#defaultUndAssetFlagFX').attr("disabled", "disabled");
		$('#actualIntrimFlag').attr("disabled", "disabled");
		$('#autoComplForMT566Reqd').attr("disabled", "disabled");
		$('#accInfoRequired').attr("disabled", "disabled");
		$('#fpsAdjustment').removeAttr("disabled");
	} else if (fundCategoryval == 'OTHERS'){
		$('#fpsAdjustment').attr("disabled", "disabled");
	}
}

/**
 * Based on accInfoRequiredflg as "Y",
 *  If account info required is 'Y' 
 *    then GX & ODW, Smart Port, DEX Required, Balance to NBL, Shariah flag,GST Flag, Official Name ,Report Date Format, Business Start Date, Business End Date and Investment Start Date fields should be shown.
 *  If accounting info required is 'N' 
 *    then Fields should be not shown and following attributes updated (GX ODW, Smart Port, DEX Required, Balance to NBL,Shariah flag and GST Flag fields value is set as 'N'. 
      Official Name field is set as NULL value and Report Date Format is set as 'MM/DD',Business Start Date, Business End Date and Investment Start Date set as NULL)
 */
function loadAccountInfoRequiredFields(){
    
	var accInfoRequiredflg = $('#accInfoRequired').val();
	
	if( accInfoRequiredflg == 'Y' || accInfoRequiredflg == 'y' ){
		$('.accountingControlShow').show();	
	}else {
		$('.accountingControlShow').hide();
	}
}

$("#accInfoRequired").change(function(){
    
    loadAccountInfoRequiredFields();
});

function fundConfigAmendValidateDetailSubmit() {
	var validationMessages = [];
	var businessStartDate  = $('#businessStartDateStr').val();
	var businessStartDate  = $('#businessStartDateStr').val(); 
	var businessEndDate    = $('#businessEndDateStr').val(); 
	var investmentStartDate    = $('#investmentStartDateStr').val();
	var dateFormatValidationFails = false;
	var fundCategoryval = $('#fundCategory :selected').text();
	var result = true;
	
	if (null != fundCategoryval && fundCategoryval == "OTHERS") {
		if ($('#defaultUndAssetFlagFX').val() ==='') {
		    validationMessages.push(xenos$NAM$i18n.fundConfigAmendForm.alert.defUndAssetFXMissing);
		}

		if ($('#actualIntrimFlag').val() ==='') {
		    validationMessages.push(xenos$NAM$i18n.fundConfigAmendForm.alert.actualIntrimMissing);
		}

		if ($('#autoComplForMT566Reqd').val() ==='') {
		    validationMessages.push(xenos$NAM$i18n.fundConfigAmendForm.alert.autoCompMT566ReqdMissing);
		}

		if ($('#accInfoRequired').val() ==='') {
		    validationMessages.push(xenos$NAM$i18n.fundConfigAmendForm.alert.accInfoReqMissing);
		}
	}
	
	if (null != $('#accInfoRequired').val() && $('#accInfoRequired').val() == 'Y') {  
		if ($('#gxOdwRequired').val() ==='') {
		    validationMessages.push(xenos$NAM$i18n.fundConfigAmendForm.alert.gXODWReqMissing);
		}

		if ($('#smartPortRequired').val() ==='') {
		    validationMessages.push(xenos$NAM$i18n.fundConfigAmendForm.alert.smartPortReqMissing);
		}

		if ($('#dexRequired').val() ==='') {
		    validationMessages.push(xenos$NAM$i18n.fundConfigAmendForm.alert.dEXReqMissing);
		}

		if ($('#balanceToNBL').val() ==='') {
		    validationMessages.push(xenos$NAM$i18n.fundConfigAmendForm.alert.balToNBLMissing);
		}

		if ($('#shariahFlag').val() ==='') {
		    validationMessages.push(xenos$NAM$i18n.fundConfigAmendForm.alert.shariahFlagMissing);
		}

		if ($('#gstFlag').val() ==='') {
		    validationMessages.push(xenos$NAM$i18n.fundConfigAmendForm.alert.gstFlagMissing);
		}

		if ($('#reportDateFormat').val() ==='') {
		    validationMessages.push(xenos$NAM$i18n.fundConfigAmendForm.alert.repDateFormatMissing);
		}
        
		if (($('#gxOdwRequired').val() !='' && $('#gxOdwRequired').val() == 'Y') || ($('#smartPortRequired').val() !='' && $('#smartPortRequired').val() == 'Y')) {
			if ($('#businessStartDateStr').val() ==='') {
			    validationMessages.push(xenos$NAM$i18n.fundConfigAmendForm.alert.businessStartDateMissing);
			}
		}
		
		if(businessStartDate.length > 0 && isDateCustom(businessStartDate)==false) {
			dateFormatValidationFails = true;
			validationMessages.push(xenos.utils.evaluateMessage(xenos$NAM$i18n.fundConfigAmendForm.alert.InvalidStartDate, [businessStartDate]));
		} else {	
			xenos.ns.views.namFundConfigQuery.formatDate(businessStartDate,$('#businessStartDateStr'));
		}
		
		if(businessEndDate.length > 0 && isDateCustom(businessEndDate)==false) {
			dateFormatValidationFails = true;
			validationMessages.push(xenos.utils.evaluateMessage(xenos$NAM$i18n.fundConfigAmendForm.alert.InvalidEndDate, [businessEndDate]));
		} else {	
			xenos.ns.views.namFundConfigQuery.formatDate(businessEndDate,$('#businessEndDateStr'));
		}
		
		if(investmentStartDate.length > 0 && isDateCustom(investmentStartDate)==false) {
			dateFormatValidationFails = true;
			validationMessages.push(xenos.utils.evaluateMessage(xenos$NAM$i18n.fundConfigAmendForm.alert.InvalidInvestmentDate, [investmentStartDate]));
		} else {	
			xenos.ns.views.namFundConfigQuery.formatDate(investmentStartDate,$('#investmentStartDateStr'));
		}
		
		
		if(dateFormatValidationFails == false) {
			if(namFundConfigAmendisValidText(businessStartDate) && namFundConfigAmendisValidText(businessEndDate)) {
			// Validate Business StartDate and EndDate
				if (!isValidDateRange(businessStartDate, businessEndDate)) {
					dateFormatValidationFails== true;
					validationMessages.push(xenos$NAM$i18n.fundConfigAmendForm.alert.startDateLessEndDate);
				}
			}
		}
	}
	
	if ($('#crimsSuppressReqd').val() ==='') {
		validationMessages.push(xenos$NAM$i18n.fundConfigAmendForm.alert.crimSuppressReqdMissing);
	}
	
	if ($('#balSuppressReqd').val() ==='') {
		validationMessages.push(xenos$NAM$i18n.fundConfigAmendForm.alert.balSuppressReqdMissing);
	}

	if ($('#mt54XShortAccReqd').val() ==='') {
		validationMessages.push(xenos$NAM$i18n.fundConfigAmendForm.alert.mT54XRuleAccReqdMissing);
	}
	
	if ($('#fpsAdjustment').val() ==='') {
		validationMessages.push(xenos$NAM$i18n.fundConfigAmendForm.alert.fpsAdjustmentMissing);
	}
	
	if ($('#sbaRequiredFlag').val() ==='') {
		validationMessages.push(xenos$NAM$i18n.fundConfigAmendForm.alert.sbaRequiredFlagMissing);
	}
	
	result = xenos.ns.views.namFundConfigQuery.famFundExist();
	
	if(result == true && validationMessages.length > 0){
	    result = false;
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
		return result;
	}else {
		$('.formHeader').find('.formTabErrorIco').css('display', 'none');
	}
	
	return result;
} 

xenos.ns.views.namFundConfigQuery.famFundExist = function (){

	if($('#isFundExistinFam').val() == 'Y' || $('#isFundExistinFam').val() == 'y')
	{
		if($('#accInfoRequired').val() == 'N' || $('#accInfoRequired').val() == 'n')
		{
		   xenos.utils.displayGrowlMessage(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos$NAM$i18n.fundConfigAmendForm.error.famTransactionExist,[$('#fundCode').val(),$('#accInfoRequiredLable').text()]));
		   return false;
		}
		if($('#accInfoRequired').val() == 'Y' || $('#accInfoRequired').val() == 'y')
		{
			if($('#gxOdwRequired').val() =='N' || $('#gxOdwRequired').val() =='n')
			{
				xenos.utils.displayGrowlMessage(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos$NAM$i18n.fundConfigAmendForm.error.famTransactionExist,[$('#fundCode').val(),$('#gxOdwRequiredLable').text()]));
		        return false;
			}
			if($('#smartPortRequired').val() =='N' || $('#smartPortRequired').val() =='n')
			{
				xenos.utils.displayGrowlMessage(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos$NAM$i18n.fundConfigAmendForm.error.famTransactionExist,[$('#fundCode').val(),$('#smartPortRequiredLable').text()]));
		        return false;
			}
		}
	}
	return true;
}

function namFundConfigAmendisValidText(text){
	if(text!='undefined' && text!=null && $.trim(text).length > 0){
		return true;
	}
	return false;
}

xenos.ns.views.namFundConfigQuery.formatDate = function (date,id){
	if(date.length == 7){
		id.val(date.substr(0,6)+"0"+date.substr(6));
	}
}