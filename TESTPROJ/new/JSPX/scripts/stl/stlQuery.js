//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $



 
$(function () {
	$('.failNoticeFlagcheckboxitem').bind('click', function(e){	
		    if($(this).is(':checked') == true){	
			
		    $('.failNoticeFlagcheckboxitem').val("Y");
			$('.settlementStatusToReset').val("");
		    $('.valueDateFromReset').val("");
			$('.valueDateToReset').val("");
			$('.entryDateFromReset').val("");
			$('.entryDateToReset').val("");			
		    $('.settlementStatusToReset').attr("disabled", true);		
		}
		else{
			$('.failNoticeFlagcheckboxitem').val("N");
		    $('.settlementStatusToReset').attr("disabled", false);		
			}			  
	});
														
		if($('.failNoticeFlagcheckboxitem').attr('checked')){	
		    $('.settlementStatusToReset').attr("disabled", true);	
		 						
		}
		else{
		    $('.settlementStatusToReset').attr("disabled", false);	
	       		
			}
			  

	$('.overMoneyDiffFlagcheck').bind('click', function(e){
		if($(this).is(':checked') == true){
			 $('.overMoneyDiffFlagcheck').val("Y");
		}else{
			 $('.overMoneyDiffFlagcheck').val("N");
			}
	});
	
	$('.tripartyPledgeFlag').bind('click', function(e){
		if($(this).is(':checked') == true){
			 $('.tripartyPledgeFlag').val("Y");
		}else{
			 $('.tripartyPledgeFlag').val("N");
			}
	
	});

});
	