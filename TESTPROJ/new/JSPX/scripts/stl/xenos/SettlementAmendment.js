//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
var cashButtonstatus = $("#cashButtonstatus").val();
var viewType = $("#viewType").val();
var siVOSettlementInfoStatus = $("#siVOSettlementInfoStatus").val();
var cashSIVOSettlementInfoStatus = $("#cashSIVOSettlementInfoStatus").val();
function showDetail(){	
	if($("#isSuppressed").val() == "Y") {
		handleSuppression($("#nonSuppressedSide").val());
	} else {
		$("#wsSecSide").show();
		onchangeSecStlMode();
		$('#securitySettlementMode').attr('disabled', 'disabled');
		handleSSILayoutForSecurity();
		$("#wsCashSide").show();
		$("#cashSide2").show();
		onchangeCashStlMode();
		$('#cashSettlementmode').attr('disabled', 'disabled');
		if($("#settleTypeFLD").val()=="AGAINST") {
			handleSameCashDiffCash($("#diffCashFlag").val());
			$("#inxForNormal").hide();
			$("#inxForSuppress").show();
		} else {
			//Show the appropriate InxTransmission to populate
			$("#inxForNormal").show();
			$("#inxForSuppress").hide();
			cashButtonstatus = "X";
			showCashButton();
			$("#cashSide2").show();
			handleSSILayoutForCash();
			}
		}
			//For Pair Off Amendment and Suppressed Free Settlements, we donot allow the user to change the Settlement Type
		if($("#csiVoSettlementFor").val() == "CORPORATE_ACTION" || 
			$("#csiVoSettlementFor").val() == "PAIR_OFF" || 
			$("#isSuppressed").val() == "Y") {
			//Make the SettlementType as readonly
			$("#settleTypeFLD").hide();
			$("#settleTypeLBL").show();
		} else {
		    $("#settleTypeFLD").show();
			$("#settleTypeLBL").hide();
	      }
}
	
function handleSuppression(showSide){
		if(showSide == "CASH") {
			$("#wsCashSide").show();
			$("#cashSide2").show();
			onchangeCashStlMode();
			$('#cashSettlementmode').attr('disabled', 'disabled');
			$("#inxForNormal").hide();
			$("#inxForSuppress").show();
			handleSSILayoutForCash();
		} else {
			$("#wsSecSide").show();	    
			onchangeSecStlMode();
			$('#securitySettlementMode').attr('disabled', 'disabled');       
			handleSSILayoutForSecurity();
		}
	}
	
function handleSSILayoutForCash(){

	if($("#isBrokerAccount").val() != "Y" || $("#cashSettlementmode").val() != "INTERNAL") {
		
		if($("#amendConfirmFlag").val() != "A") {

		} else {
			if($("#cashSSILayout").val() == "DTC") {				
			}

			if($("#cashSSILayout").val() == "BONY") {
			}
		}
	}
}
function handleSSILayoutForSecurity(){
	if($("#isBrokerAccount").val() != "Y" || $("#securitySettlementMode").val() != "INTERNAL") {

		if($("#amendConfirmFlag").val() != "A") {

		} else {
			if($("#secSSILayout").val() == "DTC") {

			}

			if($("#secSSILayout").val() == "BONY") {
			}
		}
	}
}	
function showCashButton(){
	switch (cashButtonstatus)
	{
		case "D":
		    $("#diffcash").show();
			$("#samecash").hide();
			break;
		case "S":
		    $("#diffcash").hide();
			$("#samecash").show();
			break;
		case "X":
		    $("#diffcash").hide();
			$("#samecash").hide();
			break;
	}
}
function onchangeCashStlMode(){
		var cashStlMode = $("#cashSettlementmode").val();
		
		switch (cashStlMode)
		{
			case "EXTERNAL":
				showHideCashCounterpartyDetailBlock("S");
				showHideCashRows("S");

	            lblCashCpSettleAc.styleName = "FormLabelHeading";
				break;
			case "INTERNAL":
			
				if($("#isBrokerAccount").val() == "Y") {
					showHideCashCounterpartyDetailBlock("H");
				} else {
					showHideCashCounterpartyDetailBlock("S");
					showHideCashRows("H");
					//CpSettleAc is mandatory
					lblCashCpSettleAc.styleName = "ReqdLabel";
				}
				break;
		}
	}
	
function showHideCashCounterpartyDetailBlock(type) {
		switch (type)
		{
		case "H":
		    $("#cash_cp").hide();
			$("#ourHeaderCash").show();	
			break;
		case "S":
		    $("#cash_cp").show();	
			break;
		}
	}
function showHideCashRows(type){
		switch (type)
		{
		case "H":
		$("#cashRow1").hide();
		$("#cashRow2").hide();
		$("#cashRow3").hide();
		$("#cashRow4").hide();
		$("#cashRow5").hide();
		$("#ourHeaderCash").hide();
			break;
		case "S":
		$("#cashRow1").show();
		$("#cashRow2").show();
		$("#cashRow3").show();
		$("#cashRow4").show();
		$("#cashRow5").show();
		$("#ourHeaderCash").show();
			break;
		}
	}
function onchangeSecStlMode() {
	var secStlMode = $("#securitySettlementMode").val();
    
	switch (secStlMode)
	{
		case "EXTERNAL":
			showHideSecurityCounterpartyDetailBlock("S");
			showHideSecRows("S");
			$("#secCpSettleAc").addClass("FormLabelHeading");
			break;
		case "INTERNAL":
			if($("#isBrokerAccount").val() == "Y") {
				showHideSecurityCounterpartyDetailBlock("H");
			} else {
				showHideSecurityCounterpartyDetailBlock("S");
				showHideSecRows("H");
				$("#secCpSettleAc").addClass("ReqdLabel");
			}
			break;
	}
}
function showHideSecurityCounterpartyDetailBlock(type){
	switch (type)
	{
	case "H":
	    $("#sec_cp").hide();
		$("#ourHeader").hide();
		break;
	case "S":
	    $("#sec_cp").show();
		break;
	}
}
function showHideSecRows(type){
	switch (type)
	{
	case "H":
	    $("#secRow1").hide();
		$("#secRow2").hide();
		$("#secRow3").hide();
		$("#secRow4").hide();
		$("#secRow5").hide();
		$("#ourHeader").hide();
		break;
	case "S":
	    $("#secRow1").show();
		$("#secRow2").show();
		$("#secRow3").show();
		$("#secRow4").show();
		$("#secRow5").show();
	    $("#ourHeader").show();
		break;
	}
}
function handleSameCashDiffCash(type){
	switch (type)
	{
		case "D":
			cashButtonstatus ="S";		
			showCashButton();
			$("#diffCashFlag").val("D");
			$("#cashSide2").show();
			handleSSILayoutForCash();
			break;
		case "S":
			cashButtonstatus ="D";
			showCashButton();
			$("#diffCashFlag").val("S");
            $("#cashSide2").hide();
			break;
	}
}
/*
 * Function to Validate the details so that the mandatory fields are present 
 * before submitting the form.
 */
validateSettlementAmendment = function() {
    var validationMessages = [];
    var settleType = $("#settleTypeFLD").css('display') != "none"? $("#settleTypeFLD").val() : $("span#settleTypeLBL").text();
	if(settleType=="FREE") {  
		//FREE scenario
		if($("#isSuppressed").val() == "Y") 
		{
			//Suppressed FREE scenario
			if($("#nonSuppressedSide").val() == "CASH") {
				//Security side Suppressed
				
				if(!validateCashSide(validationMessages)) {
					return false;
				}
				
				//Enable the Settlement Mode field
				$("#cashSettlementmode").removeAttr('disabled');
				handleCashAmendment();

				return true;
			} else {
				//Cash side suppressed
				
				if(!validateSecuritySide(validationMessages)) {
					return false;
				}
				
				//Enable the Settlement Mode field
				$("#securitySettlementMode").removeAttr('disabled');
				handleSecurityAmendment();

				return true;
			}
		} else {
			//Normal FREE scenario

			if(!validateSecuritySide(validationMessages)) {
				return false;
			} 
			
			if(!validateCashSide(validationMessages)) {
				return false;
			} 

			validateCashSide(validationMessages);
			//Enable the Settlement Mode fields
			$("#securitySettlementMode").removeAttr('disabled');
			handleSecurityAmendment();
			$("#cashSettlementmode").removeAttr('disabled');
			handleCashAmendment();

			return true;
		}
	} else {
		//AGAINST scenario
		
		if(!validateSecuritySide(validationMessages)) {
			return false;
		} 
		
		if(!validateCashSide(validationMessages)) {
			return false;
		}

		//Enable the Settlement Mode fields
		$("#securitySettlementMode").removeAttr('disabled');
		handleSecurityAmendment();
		$("#cashSettlementmode").removeAttr('disabled');
		handleCashAmendment();

		if(validationMessages.length > 0){
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, alertStr, true));
		return false;
	    }else{
		$('.formHeader').find('.formTabErrorIco').css('display', 'none');
	    }	
		
		return true;
	}
}
/* 
 * Validates the Detail Security-side part. 
 */
function validateSecuritySide(validationMessages)
{
	$("#secSdVoSettlementInfoStatus").val(siVOSettlementInfoStatus);
	//Validate Counterparty details  - skip it for Broker Internal Scenario
	if(($("#isBrokerAccount").val() != "Y") && ($("#securitySettlementMode").val() != "INTERNAL")) {

		if ($("#secSSILayout").val() == "BONY") {

		} else if ($("#secSSILayout").val() == "DTC") {

		} else {
			if ($.trim($("#cpBank").val()).length == 0) 
			{
				if($("#secSdVoSettlementInfoStatus").val() != "UNKNOWN") {
				     validationMessages.push(xenos$STL$i18n.message.error.specifybank);
					return false;
				}
			}
			
			if ($("#securitySettlementMode").val() == "INTERNAL")
			{
				if ($.trim($("#cpSettleAc").val()).length == 0) 
				{
					if($("#secSdVoSettlementInfoStatus").val() != "UNKNOWN") {
					  validationMessages.push(xenos$STL$i18n.message.error.specifycpstlaccount);
						return false;
					}
				}
			}
		}
	}
	
	//Validate Own details
	if($("#securitySettlementMode").val() == "EXTERNAL" || $("#isBrokerAccount").val() == "Y") {
		
		if ($.trim($("#ourBank").val()).length == 0) 
		{
	         validationMessages.push(xenos$STL$i18n.message.error.specifyourbank);	
			return false;
		}
		
		if ($.trim($("#ourSettleAc").val()).length == 0) 
		{
		     validationMessages.push(xenos$STL$i18n.message.error.specifyourstlaccount);
			return false;
		}
	}
	
	return true;
}
/* 
 * Validates the Detail Cash-side part. 
 */
function validateCashSide(validationMessages){
    var settleType = $('#settleTypeFLD').is(':visible') == true? $("#settleTypeFLD").val() : $("#settleTypeLBL").val();
	if(settleType=="FREE") { 
		$("#cashSdVoSettlementInfoStatus").val(cashSIVOSettlementInfoStatus);
	    //cashSdVoSettlementInfoStatus = cashSIVOSettlementInfoStatus;
	} else {
		$("#cashSdVoSettlementInfoStatus").val(siVOSettlementInfoStatus);
	    //cashSdVoSettlementInfoStatus = siVOSettlementInfoStatus;
	}

	if(settleType=="AGAINST" && $("#diffCashFlag").val() =="S"){    
		//Skip if SettlementType = AGAINST and DiffCashFlag is set to "S" i.e. same cash.
		return true;
	}
	
	//Validate Counterparty details - skip it for Broker Internal Scenario

	if($("#isBrokerAccount").val() != "Y" && $("#cashSettlementmode").val() != "INTERNAL") {

		if ($("#cashSSILayout").val() == "BONY") {

		} else if ($("#cashSSILayout").val() == "DTC") {

		} else {
			if ($.trim($("#cashCpBank").val()).length == 0)  
			{
				if($("#cashSdVoSettlementInfoStatus").val() != "UNKNOWN") {
				    validationMessages.push(xenos$STL$i18n.message.error.specifybank);
					return false;
				}
			}
			
			if ($("#cashSettlementmode").val() == "INTERNAL")
			{
				if ($.trim($("#cashCpSettleAc").val()).length == 0)
				{
					if($("#cashSdVoSettlementInfoStatus").val() != "UNKNOWN") {
					    validationMessages.push(xenos$STL$i18n.message.error.specifycpstlaccount);
						return false;
					}
				}
			}
		}
	}
	
	//Validate Own details
	if( $("#cashSettlementmode").val() == "EXTERNAL" || $("#isBrokerAccount").val() == "Y") {
		
		if ($.trim($("#cashOurBank").val()).length == 0)
		{
		    validationMessages.push(xenos$STL$i18n.message.error.specifyourbank);
			return false;
		}
		
		if ($.trim($("#cashOurSettleAc").val()).length == 0)
		{
		     validationMessages.push(xenos$STL$i18n.message.error.specifyourstlaccount);
			return false;
		}
	}
	
	return true;
}
/*
 * Function to populate the respective back-end fields according to the Cash Cp SSI choosen.
 * Skip it for Broker Internal scenario.
 */
function handleCashAmendment(){
	
	if($("#isBrokerAccount").val() != "Y" || $("#cashSettlementmode").val() != "INTERNAL") {

		if($("#cashSSILayout").val() == "DTC") {
		}

		if($("#cashSSILayout").val() == "BONY") {
			//Beneficiary Name
		}
	}
}
/*
 * Function to populate the respective back-end fields according to the Security Cp SSI choosen.
 * Skip it for Broker Internal scenario.
 */
function handleSecurityAmendment(){

	if($("#isBrokerAccount").val() != "Y" || $("#securitySettlementMode").val() != "INTERNAL") { 
		if($("#secSSILayout").val() == "DTC") {			
		}
		if($("#secSSILayout").val() == "BONY") {
		}
	}
}
/*
 * If SettlementType = AGAINST and if we select the Security side Counterparty -
 * we populate the Cash side Counterparty details with the Security side Counterparty details.
 */
function copySecurityCpDetailsToCash(){
	clearCashCpDetails();
	//Set the SSI Layout of Cash side
	$("#cashSSILayout").val() = $("#secSSILayout").val();
	$("#cashBeneficiaryName").val() = $("#beneficiaryName").val();
	cashFurtherCredit = secSDFurtherCredit;
	
	var value = $("#securitySettlementMode").val() != null? $("#securitySettlementMode").val():""; 
	if(value != null && value != ""){
	    var index =-1;
        /*for each(var item in (cashSettlementmode.dataProvider as ArrayCollection)){                                       
            if(item.value == value){
                index = (cashSettlementmode.dataProvider as ArrayCollection).getItemIndex(item);        
            }
        }*/
         $("#cashSettlementmode option:selected").index()=index !=-1 ? index : $("#cashSettlementmode option:selected").index();	
	}
	$("#cashPlaceofsettlement").val() = $("#placeofsettlement").val();
	$("#cashBrokerBic").val() = $("#brokerBic").val();
	$("#cashParticipantId").val() = $("#participantId").val();
	$("#cashParticipantId2").val() = $("#participantId2").val();

	if($("#secSSILayout").val() == "BONY") {

	} else if($("#secSSILayout").val() == "DTC") {

	} else {
		$("#cashCpBank").val() = $("#cpBank").val();
		cashCpBankCodeType = cpBankCodeType;
		$("#cashCpSettleAc").val() = $("#cpSettleAc").val();
	
		if(this.securitySettlementMode.selectedItem.value == "EXTERNAL") {			
			$("#cashCpSettleAcName1stLine").val() = $("#cpSettleAcName1stLine").val();
			$("#cashCpSettleAcName2ndLine").val() = $("#cpSettleAcName2ndLine").val();
			$("#cashCpSettleAcName3rdLine").val() = $("#cpSettleAcName3rdLine").val();
			$("#cashCpSettleAcName4thLine").val() = $("#cpSettleAcName4thLine").val();
			$("#cashCpIntermediaryInfo").val() = $("#cpIntermediaryInfo").val();
			cashCpChainIndex = secCpChainIndex;
		}
	}
	onchangeCashStlMode();
}
 
/**
 *	Function to clear the Cash side Counterparty Details block fields.
 */
function  clearCashCpDetails(){
	//Clear INTERNATIONAL details
	$("#cashCpBank").val("");
	$("#cashCpBankCodeType").val("");
	$("#cashCpSettleAc").val("");
	$("#cashCpSettleAcName1stLine").val("");
	$("#cashCpSettleAcName2ndLine").val("");
	$("#cashCpSettleAcName3rdLine").val("");
	$("#cashCpSettleAcName4thLine").val("");
	$("#cashCpIntermediaryInfo").val("");
	$("#cashCpChainIndex").val("-1");
	
	$("#cashBeneficiaryName").val("");
	$("#cashFurtherCredit").val("");


	$("#cashPlaceofsettlement").val("");
	$("#cashBrokerBic").val("");
	$("#cashParticipantId").val("");
	$("#cashParticipantId2").val("");

}
function onchangeInxTransmissionForCash(validationMessages){
    if($("#settleTypeFLD").val() =="AGAINST")
	{
		if($("#inxForSuppress").val() != $("#inxForNormal").val())
		{
		     validationMessages.push(xenos$STL$i18n.message.error.nodiffflag);
			$("#inxForNormal").focus();
		}
	}
	}



