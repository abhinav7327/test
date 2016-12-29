//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
 xenos.ns.views.batchStatusQuery.validateSubmit = function(){
	var alertStr = [];
	var batchStartDate = $("#batchStartDate").val();
		
	if(batchStartDate.length > 0 && isDateCustom(batchStartDate)==false) {
		
		alertStr.push(xenos$REF$i18n.batchStatusQuery.illegal_date_format + " " + batchStartDate);
	}
	//Show the error message
	if(alertStr.length > 0){
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, alertStr, true));
		return false;
	}else{
		$('.formHeader').find('.formTabErrorIco').css('display', 'none');
		xenos.ns.views.batchStatusQuery.formatDate(batchStartDate);
	}
	
	return true;
 }
 
 xenos.ns.views.batchStatusQuery.formatDate = function (batchStartDate){
	if(batchStartDate.length == 7){
		$("#batchStartDate").val(batchStartDate.substr(0,6)+"0"+batchStartDate.substr(6));
	}
 }