 xenos.ns.views.empQuery.validateSubmit = function(){

	var alertStr = [];
	var defaultOffice = $('#defaultOffice').val();
	var startDateStr = $('#startDateStr').val();
	var lastLogDateStr = $('#lastLogDateStr').val();
	
	
	if(defaultOffice.length == 0) {
		alertStr.push(xenos$REF$i18n.employeeQuery.default_office_empty);
	}
	
	if(lastLogDateStr.length>0 && isDateCustom(lastLogDateStr)==false) {
		alertStr.push(xenos$REF$i18n.employeeQuery.illegal_lastaccessdate_fromat + " " + lastLogDateStr);
	}
	
	if(startDateStr.length>0 && isDateCustom(startDateStr)==false) {
		alertStr.push(xenos$REF$i18n.employeeQuery.illegal_startdate_fromat + " " + startDateStr);
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

xenos.ns.views.empQuery.formatDate = function(date){
	if(date.value.length == 7){
		if(date.id=="startDateStr"){
			$("#startDateStr").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
		if(date.id=="lastLogDateStr"){
			$("#lastLogDateStr").val(date.value.substr(0,6)+"0"+date.value.substr(6));
		}
	}
 }