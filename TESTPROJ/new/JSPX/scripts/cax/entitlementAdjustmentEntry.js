xenos.ns.entitlement.adjustmentEntry.onChangeRateType = function(e) {

		var rateType = "";
		if($('#rateType').val() != null) {
			rateType = $.trim($('#rateType').val());
		}
		switch(rateType) {

			case "PERCENT":
				$('#amount').val('');
				$('#taxAmountLbl').css("visibility", "hidden");
				$('#amount').css("visibility", "hidden");
				$('#taxRate').css("visibility", "visible");	
				$('#calTaxAmt').css("visibility", "hidden");
				break;
			case "AMOUNT" :
				$('#rate').val('');
				$('#taxRate').css("visibility", "hidden");
				$('#taxAmountLbl').css("visibility", "visible");
				$('#amount').css("visibility", "visible");
				$('#calTaxAmt').css("visibility", "hidden");
				break;
			case "BP":
				$('#taxRate').css("visibility", "visible");
				$('#amount').val('');
				$('#taxAmountLbl').css("visibility", "hidden");
				$('#amount').css("visibility", "hidden");
				$('#calTaxAmt').css("visibility", "visible");
			break;
			case "CPS" :
				$('#taxRate').css("visibility", "visible");
				$('#taxAmountLbl').css("visibility", "visible");
				$('#amount').css("visibility", "visible");
				$('#calTaxAmt').css("visibility", "visible");
			break;
			case "" :
				$('#taxRate').css("visibility", "visible");
				$('#taxAmountLbl').css("visibility", "visible");
				$('#amount').css("visibility", "visible");
				$('#calTaxAmt').css("visibility", "visible");
			break;
		 }	   
			  
}
