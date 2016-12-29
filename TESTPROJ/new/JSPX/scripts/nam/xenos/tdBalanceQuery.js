//$Id$
//$Author: ArunKumar $
//$Date: 2016-12-24 12:26:23 $ 
xenos.ns.views.tdBalanceQuery.validateSubmit = function(){
	var alertStr = [];
	var date = $("#date").val();
	//Show exception if date is blank
	if(date.length == 0) {
		alertStr.push(xenos$NAM$i18n.tdBalanceQuery.blank_date);
	}	
	//Show exception if date is invalid
	if(date.length > 0 && isDateCustom(date)==false) {
		
		alertStr.push(xenos$NAM$i18n.tdBalanceQuery.invalid_date);
	}
	//Show the error message
	if(alertStr.length > 0){
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, alertStr, true));
		return false;
	}else{
		$('.formHeader').find('.formTabErrorIco').css('display', 'none');
		xenos.ns.views.tdBalanceQuery.formatDate(date);
	}
	return true;
 } 	
xenos.ns.views.tdBalanceQuery.formatDate = function(date) {
		if(date.length == 7){
			$("#date").val(date.substr(0,6)+"0"+date.substr(6));
		}
}