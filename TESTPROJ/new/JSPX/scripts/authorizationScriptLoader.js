//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
$(document).ready(function() {
	var selValue = $('.authStatus').val();        	
    var pendingTypeSelected = $('.pendingTypeDropDown').val(); 
    if(selValue == 'REJECTED' || selValue == 'AUTHORIZED'){
		$('.pendingType').hide();
		$('.authorizationAction').hide();
        $('.actionBy').hide();
		$('.actionByValue').val("");
	}else{
		$('.pendingType').show();
		$('.authorizationAction').show();
        if(pendingTypeSelected == "OTHER'S ENTRY"){
			$('.actionBy').show();
		}else{
			$('.actionBy').hide();
			$('.actionByValue').val("");
		}
	}
    
	//On change event handler for authorization status field
	function onChangeAuthStatus(e){
		var selValue = $('.authStatus').val();        	
        var pendingTypeSelected = $('.pendingTypeDropDown').val(); 
        if(selValue == 'REJECTED' || selValue == 'AUTHORIZED'){
			$('.pendingType').hide();
			$('.authorizationAction').hide();
            $('.actionBy').hide();
			$('.actionByValue').val("");
		}else{
			$('.pendingType').show();
			$('.authorizationAction').show();
	        if(pendingTypeSelected == "OTHER'S ENTRY"){
				$('.actionBy').show();
			}else{
				$('.actionBy').hide();
				$('.actionByValue').val("");
			}
         }
	}
    
	//On change event handler for pending type field
	function onChangePendingType(e){
		 var pendingTypeSelected = $('.pendingTypeDropDown').val();  
		 if(pendingTypeSelected == "OTHER'S ENTRY"){
			$('.actionBy').show();
		 }else{
			$('.actionBy').hide();
		 }
		 $('.actionByValue').val(""); 
	}
	
	$('.authStatus').unbind('change');
	$('.authStatus').bind('change', onChangeAuthStatus);
	$('.pendingTypeDropDown').unbind('change');
	$('.pendingTypeDropDown').bind('change', onChangePendingType);

});