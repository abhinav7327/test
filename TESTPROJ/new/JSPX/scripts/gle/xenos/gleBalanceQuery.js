//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos.ns.views.gleBalanceQry.validateSubmit = function(){

	var alertStr = [];
	var ledgerCodeFrom = $('#ledgerCodeFrom').val();
	var balanceEntryDate = $.trim($('#balanceEntryDate').val());
	var balanceType = $('#balanceType').val();
	var dateFormatValidationFails = false;
	var fieldEmpty = false;
	function isBlank(str) {
		return ($.trim(str)=="");
	}
	if(isBlank(ledgerCodeFrom) || isBlank(balanceEntryDate) || isBlank(balanceType)){
		fieldEmpty=true;
		alertStr.push(xenos$GLE$i18n.gleBalance.query.field_empty);
		if(isBlank(ledgerCodeFrom)){
			alertStr.push(xenos$GLE$i18n.gleBalance.query.ledgerCodeFrom_empty);
		}
		if(isBlank(balanceEntryDate)){
			 alertStr.push(xenos$GLE$i18n.gleBalance.query.date_empty);
		}
		if(isBlank(balanceType)){
			 alertStr.push(xenos$GLE$i18n.gleBalance.query.balanceType_empty);
		}
	}
	if(fieldEmpty==false){
		if(!isBlank(balanceEntryDate) && isDateCustom(balanceEntryDate)==false) {
			dateFormatValidationFails=true;
			alertStr.push(xenos$GLE$i18n.gleBalance.query.date_format_check);
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
		xenos.ns.views.gleBalanceQry.formatDate(balanceEntryDate);
	}
	return true;
}
//function formatDate(balanceEntryDate){
xenos.ns.views.gleBalanceQry.formatDate = function(balanceEntryDate) {
		if(balanceEntryDate.length == 7){
			$("#balanceEntryDate").val(balanceEntryDate.substr(0,6)+"0"+balanceEntryDate.substr(6));
		}
	  }