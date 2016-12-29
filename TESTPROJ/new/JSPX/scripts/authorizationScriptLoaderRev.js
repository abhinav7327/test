//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
$(document).ready(function() {
	var $context = $('div.formAuthArea');
	//On change event handler for Query Objective field
	function onChangeQueryObjective(e, param){
		var selValue = $('.queryObjective').val();
			function showHideCompoments(selValue){
				if($.trim(selValue) == 'PENDING'){
					$('.authorizationStatus',$context).hide();
					$('.authorizedBy',$context).hide();
					$('.authorizedDateFromTo',$context).hide();
					$('.pendingType',$context).show();
				} else {
					$('.pendingType',$context).hide();
					$('.authorizationStatus',$context).show();
					$('.authorizedBy',$context).show();
					$('.authorizedDateFromTo',$context).show();
				}
			}
		
			function resetValueCompomnents(selValue){
				if($.trim(selValue) == 'PENDING'){
					$('.authorizationStatusVal',$context).val(""); 
					$('.authorizedByVal',$context).val(""); 
			        $('.authorizedDateFromVal',$context).val(""); 
					$('.authorizedDateToVal',$context).val("");
					$('.pendingTypeVal',$context).val("");
				} else {
					$('.pendingTypeVal',$context).val("");
					$('.authorizationStatusVal',$context).val(""); 
					$('.authorizedByVal',$context).val(""); 
			        $('.authorizedDateFromVal',$context).val(""); 
					$('.authorizedDateToVal',$context).val("");
				}
			}
    	showHideCompoments(selValue);
    	if($.trim(param) != "loading"){
    		resetValueCompomnents(selValue)
    	}
	}
	
	$('.queryObjective',$context).unbind('change');
	$('.queryObjective',$context).bind('change', onChangeQueryObjective);
	$('.queryObjective',$context).trigger('change',['loading']);
	xenos.loadScript([{path: xenos.context.path + '/scripts/xenos-datepicker.js'}], {
		success: function() {	    	
			$('input.dateinput',$context).xenosdatepicker();
		}
	});
});