//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos.ns.views.gleJournalQry.validateSubmit = function(){

	var alertStr = [];
	var ledgerCodeFrom = $.trim($('#ledgerCodeFrom').val());
	var ledgerCodeTo = $.trim($('#ledgerCodeTo').val());
	var balanceEntryDate = $.trim($('#balanceEntryDate').val());
	var balanceEntryDateTo = $.trim($('#balanceEntryDateTo').val());
	var currency = $.trim($('#currency').val());
	var dateFormatValidationFails = false;
	var fieldEmpty = false;
	
	function isBlank(str) {
		return ($.trim(str)=="");
	}
	
	if(isBlank(ledgerCodeFrom) || isBlank(ledgerCodeTo) || isBlank(balanceEntryDate) || isBlank(currency)){
		fieldEmpty=true;
		alertStr.push(xenos$GLE$i18n.gleJournal.query.field_empty);
		if(isBlank(ledgerCodeFrom)){
			alertStr.push(xenos$GLE$i18n.gleJournal.query.ledgerCodeFrom_empty);
		}
		if(isBlank(ledgerCodeTo)){
			alertStr.push(xenos$GLE$i18n.gleJournal.query.ledgerCodeTo_empty);
		}
		if(isBlank(balanceEntryDate)){
			alertStr.push(xenos$GLE$i18n.gleJournal.query.balanceEntryDate_empty);
		}
		if(isBlank(currency)){
			alertStr.push(xenos$GLE$i18n.gleJournal.query.currency_empty);
		}
	}
	
	if(fieldEmpty==false){
		if(!isBlank(balanceEntryDate) && isDateCustom(balanceEntryDate)==false) {
			dateFormatValidationFails=true;
			alertStr.push(xenos$GLE$i18n.gleJournal.query.dateFrom_format_check);
		}
		if(!isBlank(balanceEntryDateTo) && isDateCustom(balanceEntryDateTo)==false) {
			dateFormatValidationFails=true;
			alertStr.push(xenos$GLE$i18n.gleJournal.query.dateTo_format_check);
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
		xenos.ns.views.gleJournalQry.formatDate(balanceEntryDateTo);
	}
	
	return true;
}

// date formatter function
xenos.ns.views.gleJournalQry.formatDate = function(balanceEntryDateTo) {
	if(balanceEntryDateTo.trim().length == 7){
		$("#balanceEntryDateTo").val(balanceEntryDateTo.substr(0,6)+"0"+balanceEntryDateTo.substr(6));
	}
}