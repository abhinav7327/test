//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
function showDetailUsrConf(){	
	//Check for Suppressed settlement
	if($("#isSuppressed").val() == "Y") {
		handleSuppressionConf($("#nonSuppressedSide").val());
	} else {
		//Normal Case
		$("#wsUSecSide").show();
		onchangeSecStlModeConf();
		handleSSILayoutForSecurityConf();
		$("#wsUCashSide").show();
		$("#uCashSide2_1").show();
		$("#uCashSide2_2").show();
		$("#uCashSide2_3").show();
		$("#uCashSide2_4").show();
		$("#uCashSide2_51").show();
		$("#uCashSide2_52").show();
		$("#uCashSide2_6").show();
		$("#uCashSide2_7").show();
		$("#uCashSide2_8").show();
		$("#uCashSide2_9").show();
		$("#uCashSide2_10").show();
		$("#cashOurdetails").show();
		$("#cashCpdetails").show();
		onchangeCashStlModeConf();
		if($("#uSettleTypeLBL").val() =="AGAINST") {
			//If AGAINST, then expose the DiffSameCash functionality else no
			handleSameCashDiffCashConf($("#diffCashFlag").val());
			//Show the appropriate InxTransmission to populate
			$("#uInxForNormal").hide();
			$("#uInxForSuppress").show();
		} else {
			//Show the appropriate InxTransmission to populate
			$("#uInxForNormal").show();
			$("#uInxForSuppress").hide();
			cashButtonstatus = "X";
			$("#uCashSide2_1").show();
		    $("#uCashSide2_2").show();
		    $("#uCashSide2_3").show();
		    $("#uCashSide2_4").show();
		    $("#uCashSide2_51").show();
			$("#uCashSide2_52").show();
		    $("#uCashSide2_6").show();
		    $("#uCashSide2_7").show();
		    $("#uCashSide2_8").show();
		    $("#uCashSide2_9").show();
		    $("#uCashSide2_10").show();
		    $("#cashOurdetails").show();
		    $("#cashCpdetails").show();
			handleSSILayoutForCashConf();
		}
	}
	//For Pair Off Amendment and Suppressed Free Settlements, we donot allow the user to change the Settlement Type
	if($("#csiVoSettlementFor").val() == "CORPORATE_ACTION" || 
		$("#csiVoSettlementFor").val() == "PAIR_OFF" || 
		 $("#isSuppressed").val() == "Y") {
		//Make the SettlementType as readonly
		$("#uSettleTypeLBL_1").show();
		$("#uSettleTypeLBL_2").show();
	} else {
		//SA.as have different implementation
	    $("#uSettleTypeLBL_1").show();
		$("#uSettleTypeLBL_2").show();
	}
}
function handleSuppressionConf(showSide){
	//Show only the appropriate side
	if(showSide == "CASH") {
	    $("#wsUCashSide").show();
        $("#uCashSide2_1").show();
		$("#uCashSide2_2").show();
		$("#uCashSide2_3").show();
		$("#uCashSide2_4").show();
		$("#uCashSide2_51").show();
		$("#uCashSide2_52").show();
		$("#uCashSide2_6").show();
		$("#uCashSide2_7").show();
		$("#uCashSide2_8").show();
		$("#uCashSide2_9").show();
		$("#uCashSide2_10").show();
		$("#cashOurdetails").show();
		$("#cashCpdetails").show();
		onchangeCashStlModeConf();
		$("#uInxForNormal").hide();
        $("#uInxForSuppress").show();
		handleSSILayoutForCashConf();
	} else {
	    $("#wsUSecSide").show();
		// display secside as per stlmode value (onchangeSecStlMode())
		onchangeSecStlModeConf();
		handleSSILayoutForSecurityConf();
	}
}
function onchangeSecStlModeConf(){
	var secStlMode = $("#uSettlementMode").val();
    
	switch (secStlMode)
	{
		case "EXTERNAL":
			showHideSecurityCounterpartyDetailBlockConf("S");
			showHideSecRowsConf("S");
			$("#uSecCpSettleAc").removeClass('required');
			break;
		case "INTERNAL":
			if($("#isBrokerAccount").val() == "Y") {
				showHideSecurityCounterpartyDetailBlockConf("H");
			} else {
				showHideSecurityCounterpartyDetailBlockConf("S");
				showHideSecRowsConf("H");
				//CpSettleAc is mandatory
				$("#uSecCpSettleAc").addClass('required');
			}
			break;
	}
}
/*
 * Function to handle cashStlDetail.settlementMode combo onchange
 */
function onchangeCashStlModeConf(){
	var cashStlMode = $("#uCashSettlementmode").val();
	
	switch (cashStlMode)
	{
		case "EXTERNAL":
			showHideCashCounterpartyDetailBlockConf("S");
			showHideCashRowsConf("S");
			break;
		case "INTERNAL":
			if($("#isBrokerAccount").val() == "Y") {
				showHideCashCounterpartyDetailBlockConf("H");
			} else {
				showHideCashCounterpartyDetailBlockConf("S");
				showHideCashRowsConf("H");
			}
			break;
	}
}
/*
 * For Amend page: Formats the Counterparty Details field.
 * For Confirm and Ok page : Shows/Hides the Counter Party Details as per the SSI Layout - for Cash side.
 * Skip it for Broker Internal scenario.
 */
function handleSSILayoutForCashConf() {

	if($("#isBrokerAccount").val() != "Y" || $("#uCashSettlementmode").val() != "INTERNAL") {
		if($("#amendConfirmFlag").val() != "A") {
		} else {
			if($("#cashSSILayout").val() == "DTC") {				
			}
			if($("#cashSSILayout").val() == "BONY") {
			}
		}
	}
}
/*
 * For Amend page: Formats the Counterparty Details fields.
 * For Confirm and Ok page : Shows/Hides the Counter Party Details as per the SSI Layout - for Security side.
 * Skip it for Broker Internal scenario.
 */
function handleSSILayoutForSecurityConf(){
	if($("#isBrokerAccount").val() != "Y" || $("#uSettlementMode").val() != "INTERNAL") {
		if($("#amendConfirmFlag").val() != "A") {
		} else {
			if($("#secSSILayout").val() == "DTC") {
			}
			if($("#secSSILayout").val() == "BONY") {
			}
		}
	}
}
/*
 * Function to show/hide the security-side Counterparty details block depending 
 * on the "isBrokerAccount" and "SettlementMode" for the security-side.
 * In case of Broker Internal settlement, Counterparty details are not required.
 */
function showHideSecurityCounterpartyDetailBlockConf(type){
	switch (type)
	{
	case "H":
	    $("#uSecSide2_2").hide();
		$("#uSecSide2_3").hide();
		$("#uSecSide2_4").hide();
		$("#uSecSide2_51").hide();
		$("#uSecSide2_52").hide();
		$("#uSecSide2_6").hide();
		$("#uSecSide2_7").hide();
		$("#uSecSide2_7").hide();
		$("#cpdetails").hide();
		break;
	case "S":
	    $("#uSecSide2_2").show();
		$("#uSecSide2_3").show();
		$("#uSecSide2_4").show();
		$("#uSecSide2_51").show();
		$("#uSecSide2_52").show();
		$("#uSecSide2_6").show();
		$("#uSecSide2_7").show();
		$("#cpdetails").show();
		break;
	}
}
/*
 * Function to show/hide the cash-side Counterparty details block depending 
 * on the "isBrokerAccount" and "SettlementMode" for cash-side.
 * In case of Broker Internal settlement, Counterparty details are not required.
 */
function showHideCashCounterpartyDetailBlockConf(type){
	switch (type)
	{
	case "H":
	    //uCash_cp samirj
	    $("#uCashSide2_2").hide();
		$("#uCashSide2_3").hide();
		$("#uCashSide2_4").hide();
		$("#uCashSide2_51").hide();
		$("#uCashSide2_52").hide();
		$("#uCashSide2_6").hide();
		$("#uCashSide2_7").hide();
		$("#cashCpdetails").hide();
		break;
	case "S":
	    $("#uCashSide2_2").show();
		$("#uCashSide2_3").show();
		$("#uCashSide2_4").show();
		$("#uCashSide2_51").show();
		$("#uCashSide2_52").show();
		$("#uCashSide2_6").show();
		$("#uCashSide2_7").show();
		$("#cashCpdetails").show();
		break;
	}
}
/*
 * Function to show/hide the cash-side fields depending upon the "SettlementMode" for cash-side.
 */
function showHideCashRowsConf(type){
	switch (type)
	{
	case "H":
	    $("#uCashSide2_3").hide();
		$("#uCashSide2_4").hide();
		$("#uCashSide2_5_1").hide();
		$("#uCashSide2_5_2").hide();
		$("#uCashSide2_8").hide();
		$("#uCashSide2_9").hide();
		$("#uCashSide2_10").hide();
		$("#cashOurdetails").hide();
		$("#cashCpdetails").hide();
		break;
	case "S":
	    $("#uCashSide2_3").show();
		$("#uCashSide2_4").show();
		$("#uCashSide2_5_1").show();
		$("#uCashSide2_5_2").show();
		$("#uCashSide2_8").show();
		$("#uCashSide2_9").show();
		$("#uCashSide2_10").show();
		$("#cashOurdetails").show();
		$("#cashCpdetails").show();
		break;
	}
}
/*
 * Function to show/hide the security-side fields depending upon the "SettlementMode" for security-side.
 */
function showHideSecRowsConf(type) {
	switch (type)
	{
	case "H":
	    $("#uSecSide2_3").hide();
		$("#uSecSide2_4").hide();
		$("#uSecSide2_5_1").hide();
		$("#uSecSide2_5_2").hide();
		$("#uSecSide2_8").hide();
		$("#uSecSide2_9").hide();
		$("#uSecSide2_10").hide();
		$("#uSecSide2_10").hide();
		$("#ourdetails").hide();
		$("#cpdetails").hide();
		break;
	case "S":
	     $("#uSecSide2_3").show();
		$("#uSecSide2_4").show();
		$("#uSecSide2_5_1").show();
		$("#uSecSide2_5_2").show();
		$("#uSecSide2_8").show();
		$("#uSecSide2_9").show();
		$("#uSecSide2_10").show();
		$("#ourdetails").show();
		$("#cpdetails").show();
		break;
	}
}
/*
 * Function to handle samecash diffcash button onclick
 */
function handleSameCashDiffCashConf(type){
	switch (type)
	{
		case "D":
			cashButtonstatus ="S";		
			$("#diffCashFlag").val("D");
            $("#uCashSide2_1").show();
		    $("#uCashSide2_2").show();
		    $("#uCashSide2_3").show();
		    $("#uCashSide2_4").show();
		    $("#uCashSide2_51").show();
			$("#uCashSide2_52").show();
		    $("#uCashSide2_6").show();
		    $("#uCashSide2_7").show();
		    $("#uCashSide2_8").show();
		    $("#uCashSide2_9").show();
		    $("#uCashSide2_10").show();
		    $("#cashOurdetails").show();
		    $("#cashCpdetails").show();
			handleSSILayoutForCashConf();
			break;
		case "S":
			cashButtonstatus ="D";
			$("#diffCashFlag").val("S");
			$("#uCashSide2_1").hide();
		    $("#uCashSide2_2").hide();
		    $("#uCashSide2_3").hide();
		    $("#uCashSide2_4").hide();
		    $("#uCashSide2_51").hide();
			$("#uCashSide2_52").hide();
		    $("#uCashSide2_6").hide();
		    $("#uCashSide2_7").hide();
		    $("#uCashSide2_8").hide();
		    $("#uCashSide2_9").hide();
		    $("#uCashSide2_10").hide();
		    $("#cashOurdetails").hide();
		    $("#cashCpdetails").hide();
			break;
	}
}