//$Id$
//$Author: shalinis $
//$Date: 2016-12-26 10:41:47 $
xenos.ns.views.rightsDetailQueryCriteria.validateSubmit = function(){
		var validationMessages = [];
		var dateList = [];
		
		dateList.push($('#recordDateFromStr').val());
		dateList.push($('#recordDateToStr').val());
		dateList.push($('#paymentDateFromStr').val());
		dateList.push($('#paymentDateToStr').val());
		dateList.push($('#exDateFromStr').val());
		dateList.push($('#exDateToStr').val());
		dateList.push($('#processStartDateFromStr').val());
		dateList.push($('#processStartDateToStr').val());
		dateList.push($('#processEndDateFromStr').val());
		dateList.push($('#processEndDateToStr').val());
		dateList.push($('#availableDateFromStr').val());
		dateList.push($('#availableDateToStr').val());
		dateList.push($('#entryDateFromStr').val());
		dateList.push($('#entryDateToStr').val());
		dateList.push($('#lastEntryDateFromStr').val());
		dateList.push($('#lastEntryDateToStr').val());
		
		for (i = 0; i < dateList.length; i+=2) {
			var dateFrom = dateList[i];
			var dateTo = dateList[i+1];
			
			// Validate format of From Date
			if(dateFrom.length > 0 && isDateCustom(dateFrom)==false) {
				validationMessages.push(xenos$CAX$i18n.rightsdetailquery.validation.dateformat_invalid + ' ' + dateFrom);
			}
			
			// Validate format of To Date
			if(dateTo.length > 0 && isDateCustom(dateTo)==false) {
				validationMessages.push(xenos$CAX$i18n.rightsdetailquery.validation.dateformat_invalid + ' ' + dateTo);
			}
			
			// Validate Date From - To
			if (isValidDateRange(dateFrom, dateTo) == false) {
				validationMessages.push(xenos$CAX$i18n.rightsdetailquery.validation.daterange_invalid);
			}
		}
		// Display errors on screen
		if ( validationMessages.length >0){
			if($('.formHeader').find('.formTabErrorIco:visible').length > 0){	                 	
				$('.formHeader').find('.formTabErrorIco:visible').off('click');
				$('.formHeader').find('.formTabErrorIco:visible').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
			 }else{
				$('.formHeader').find('.formTabErrorIco').css('display', 'block');
				$('.formHeader').find('.formTabErrorIco').off('click');
				$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
			 }
			 return false;
		}else{
			$('.formHeader').find('.formTabErrorIco').css('display', 'none');
		}
	    return true;
}

xenos.ns.views.rightsDetailQueryCriteria.setDetailType = function() {
	$("#detailType").val("RIGHTS_DETAIL");
	return true;
}