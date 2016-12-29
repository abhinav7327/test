//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
 xenos.ns.views.onlineReportExecStatusQuery.validateSubmit = function(){
	 var alertStr = [];
		var appRegiDate = $("#appRegiDate").val();
			
		if(appRegiDate.length > 0 && isDateCustom(appRegiDate)==false) {
			
			alertStr.push(xenos$REF$i18n.onlineReportExecStatusQuery.illegal_date_format + " " + appRegiDate);
		}
		//Show the error message
		if(alertStr.length > 0){
			$('.formHeader').find('.formTabErrorIco').css('display', 'block');
			$('.formHeader').find('.formTabErrorIco').off('click');
			$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, alertStr, true));
			return false;
		}else{
			$('.formHeader').find('.formTabErrorIco').css('display', 'none');
			// formatDate(appRegiDate);
			xenos.ns.views.onlineReportExecStatusQuery.formatDate(appRegiDate);
		}
		
		return true;
	 }
	 
	  // function formatDate(appRegiDate){
 xenos.ns.views.onlineReportExecStatusQuery.formatDate = function(appRegiDate) {
		if(appRegiDate.length == 7){
			$("#appRegiDate").val(appRegiDate.substr(0,6)+"0"+appRegiDate.substr(6));
		}
	  }