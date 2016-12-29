//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
 xenos.ns.views.cpssiQuery.validateSubmit = function(){

	var alertStr = [];
	var counterPartyDropDownVal = $('#counterPartyCodeDropDown').val();
	var counterPartyCodeVal = $('#counterPartyCode').val();
	var accountNoVal = $('#accountNo').val();
	var localAccountNoVal = $('#localAccountNo').val();
	if(counterPartyDropDownVal.length != 0 && counterPartyCodeVal.length == 0) {
		alertStr.push(xenos$REF$i18n.cpSSIQuery.validation.validcounterparty);
	}
	
	if(accountNoVal.length != 0 && localAccountNoVal.length != 0) {
		alertStr.push(xenos$REF$i18n.cpSSIQuery.validation.cporlocal);
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