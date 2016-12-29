




 
// ActionScript file

/*  Extar additions */
private function showDetailUsrConf():void {	
	//Check for Suppressed settlement
	if(isSuppressed == "Y") {
		handleSuppressionConf(nonSuppressedSide);
	} else {
		//Normal Case
		wsUSecSide.includeInLayout = true;
		wsUSecSide.visible = true;
//		getObj('secSide').style.display="block";
		// display secside as per stlmode value (onchangeSecStlMode())
		onchangeSecStlModeConf()
//		uSettlementMode.enabled = false; -- Not needed for user conf.
//		getObj('securityStlDetail.settlementMode').disabled = true;
		handleSSILayoutForSecurityConf();
		wsUCashSide.includeInLayout = true;
		wsUCashSide.visible = true;
		uCashSide2.includeInLayout =true;
		uCashSide2.visible = true;
//		getObj('cashSide').style.display="block";
//		getObj('cashSide2').style.display="block";
		// display cashside as per stlmode value (onchangeCashStlMode())
		onchangeCashStlModeConf();
		uCashSettlementmode.enabled = false;
//		getObj('cashStlDetail.settlementMode').disabled = true;
		if(uSettleTypeLBL.text=="AGAINST") {
			//If AGAINST, then expose the DiffSameCash functionality else no
			handleSameCashDiffCashConf(diffCashFlag);
			//Show the appropriate InxTransmission to populate
			uInxForNormal.includeInLayout = false;
			uInxForNormal.visible = false;
			uInxForSuppress.includeInLayout = true;
			uInxForSuppress.visible = true;
//			getObj('inxForNormal').style.display="none";
//			getObj('inxForSuppress').style.display="block";
		} else {
			//Show the appropriate InxTransmission to populate
			uInxForNormal.includeInLayout = true;
			uInxForNormal.visible = true;
			uInxForSuppress.includeInLayout = false;
			uInxForSuppress.visible = false;
//			getObj('inxForNormal').style.display="block";
//			getObj('inxForSuppress').style.display="none";
			cashButtonstatus = "X";
			//showCashButton();
			uCashSide2.includeInLayout =true;
		    uCashSide2.visible = true;
//			document.getElementById('cashSide2').style.display="block";
			handleSSILayoutForCashConf();
		}
	}
	//For Pair Off Amendment and Suppressed Free Settlements, we donot allow the user to change the Settlement Type
	if(csiVoSettlementFor == "CORPORATE_ACTION" || 
		csiVoSettlementFor == "PAIR_OFF" || 
		 isSuppressed == "Y") {
		//Make the SettlementType as readonly
		uSettleTypeLBL.includeInLayout = true;
		uSettleTypeLBL.includeInLayout = true;
//		getObj('settleTypeFLD').style.display="none";
//		getObj('settleTypeLBL').style.display="block";
	} else {
	    uSettleTypeLBL.includeInLayout = false;
		uSettleTypeLBL.includeInLayout = false;
//		getObj('settleTypeFLD').style.display="block";
//		getObj('settleTypeLBL').style.display="none";
	}
}
public function handleSuppressionConf(showSide:String):void {
	//Show only the appropriate side
	if(showSide == "CASH") {
	    wsUCashSide.includeInLayout = true;
	    wsUCashSide.visible = true;
//		getObj('cashSide').style.display="block";
        uCashSide2.includeInLayout = true;
        uCashSide2.visible = true;
//		getObj('cashSide2').style.display="block";
		// display cashside as per stlmode value (onchangeCashStlMode())
		onchangeCashStlModeConf();
//		getObj('cashStlDetail.settlementMode').disabled = true;
		uCashSettlementmode.enabled = false;
		//Show the appropriate InxTransmission to populate
//		getObj('inxForNormal').style.display="none";
//		getObj('inxForSuppress').style.display="block";
        uInxForNormal.includeInLayout = false;
        uInxForNormal.visible = false;
        uInxForSuppress.includeInLayout = true;
        uInxForSuppress.visible = true;
        
		handleSSILayoutForCashConf();
	} else {
	    wsUSecSide.includeInLayout = true;
	    wsUSecSide.visible = true;	    
//		getObj('secSide').style.display="block";
		// display secside as per stlmode value (onchangeSecStlMode())
		onchangeSecStlModeConf();
//		getObj('securityStlDetail.settlementMode').disabled = true;
//        uSettlementMode.enabled = false;
        
		handleSSILayoutForSecurityConf();
	}
}
/*
 * Function to handle cashStlDetail.settlementMode combo onchange
 */
private function onchangeCashStlModeConf():void {
	var cashStlMode:String = uCashSettlementmode.text;
	
	switch (cashStlMode)
	{
		case "EXTERNAL":
			showHideCashCounterpartyDetailBlockConf("S");
			showHideCashRowsConf("S");

            ulblCashCpSettleAc.styleName = "FormLabelHeading";
//			getObj('cashCpSettleAc').className="lblNormalWt";
			break;
		case "INTERNAL":
		
			if(isBrokerAccount == "Y") {
				showHideCashCounterpartyDetailBlockConf("H");
			} else {
				showHideCashCounterpartyDetailBlockConf("S");
				showHideCashRowsConf("H");
				//CpSettleAc is mandatory
				ulblCashCpSettleAc.styleName = "ReqdLabel";
//				getObj('cashCpSettleAc').className="lblReqdWt";
			}
			break;
	}
}
/*
 * Function to show/hide the cash-side Counterparty details block depending 
 * on the "isBrokerAccount" and "SettlementMode" for cash-side.
 * In case of Broker Internal settlement, Counterparty details are not required.
 */
private function showHideCashCounterpartyDetailBlockConf(type:String):void {
	switch (type)
	{
	case "H":
	    uCash_cp.includeInLayout = false;
	    uCash_cp.visible = false;
//		document.getElementById('cash_cp').style.display="none";
        uOurHeaderCash.includeInLayout = true;
        uOurHeaderCash.visible = true;
//		document.getElementById('ourHeaderCash').style.display="block";
		//document.getElementById('ourBlkCash').style.display="none"; Not implemented as it soes not contail anything for Security trade
		break;
	case "S":
	    uCash_cp.includeInLayout = true;
	    uCash_cp.visible = true;
		//document.getElementById('cash_cp').style.display="block";		
		break;
	}
}
/*
 * Function to show/hide the cash-side fields depending upon the "SettlementMode" for cash-side.
 */
private function showHideCashRowsConf(type:String):void{
	switch (type)
	{
	case "H":
	    uCashRow1.includeInLayout = false;
	    uCashRow1.visible = false;
	    uCashRow2.includeInLayout = false;
	    uCashRow2.visible = false;
	    uCashRow3.includeInLayout = false;
	    uCashRow3.visible = false;
	    uCashRow4.includeInLayout = false;
	    uCashRow4.visible = false;
	    uCashRow5.includeInLayout = false;
	    uCashRow5.visible = false;
	    uOurHeaderCash.includeInLayout = false;
	    uOurHeaderCash.visible = false;
	    
//		document.getElementById('cashRow1').style.display="none";
//		document.getElementById('cashRow2').style.display="none";
//		document.getElementById('cashRow3').style.display="none";
//		document.getElementById('cashRow4').style.display="none";
//		document.getElementById('cashRow5').style.display="none";
//		document.getElementById('ourHeaderCash').style.display="none";
        //Not implemented
//		document.getElementById('ourBlkCash').style.display="block";
		break;
	case "S":
	    uCashRow1.includeInLayout = true;
	    uCashRow1.visible = true;
	    uCashRow2.includeInLayout = true;
	    uCashRow2.visible = true;
	    uCashRow3.includeInLayout = true;
	    uCashRow3.visible = true;
	    uCashRow4.includeInLayout = true;
	    uCashRow4.visible = true;
	    uCashRow5.includeInLayout = true;
	    uCashRow5.visible = true;
	    uOurHeaderCash.includeInLayout = true;
	    uOurHeaderCash.visible = true;
	    
//		document.getElementById('cashRow1').style.display="block";
//		document.getElementById('cashRow2').style.display="block";
//		document.getElementById('cashRow3').style.display="block";
//		document.getElementById('cashRow4').style.display="block";
//		document.getElementById('cashRow5').style.display="block";
//		document.getElementById('ourHeaderCash').style.display="block";
		//Not implemented
//		document.getElementById('ourBlkCash').style.display="none";
		break;
	}
}
/*
 * For Amend page: Formats the Counterparty Details field.
 * For Confirm and Ok page : Shows/Hides the Counter Party Details as per the SSI Layout - for Cash side.
 * Skip it for Broker Internal scenario.
 */
private function handleSSILayoutForCashConf():void {

	if(isBrokerAccount != "Y" || uCashSettlementmode.text != "INTERNAL") {
		
		//Not a Broker Internal Scenario
		
		if(amendConfirmFlag != "A") {
//			if(getObj('cashSSILayout').value == "BONY") {
//				document.getElementById('cashBONY').style.display="block";
//				document.getElementById('cashDTC').style.display="none";
//				document.getElementById('cashInternational').style.display="none";
//			} else if(getObj('cashSSILayout').value == "DTC") {
//				document.getElementById('cashBONY').style.display="none";
//				document.getElementById('cashDTC').style.display="block";
//				document.getElementById('cashInternational').style.display="none";
//			} else {
//				document.getElementById('cashBONY').style.display="none";
//				document.getElementById('cashDTC').style.display="none";
//				document.getElementById('cashInternational').style.display="block";
//			}
		} else {
			if(cashSSILayout == "DTC") {				
				//Format the initial onload display in the following format: Id/Name
				
//				//ParticipantId and ParticipantName
//				if((trim(getObj('cashStlDetail.dtcParticipantId').value).length != 0) && (trim(getObj('cashStlDetail.dtcParticipantName').value).length != 0)) {
//					getObj('cashStlDetail.dtcParticipantId').value=getObj('cashStlDetail.dtcParticipantId').value+"/"+getObj('cashStlDetail.dtcParticipantName').value;
//					getObj('cashStlDetail.dtcParticipantName').value = "";
//				}
//
//				//InstitutionId and InstitutionName
//				if((trim(getObj('cashStlDetail.dtcInstitutionId').value).length != 0) && (trim(getObj('cashStlDetail.dtcInstitutionName').value).length != 0)) {
//					getObj('cashStlDetail.dtcInstitutionId').value=getObj('cashStlDetail.dtcInstitutionId').value+"/"+getObj('cashStlDetail.dtcInstitutionName').value;
//					getObj('cashStlDetail.dtcInstitutionName').value = "";
//				}
//
//				//AgentId and AgentName
//				if((trim(getObj('cashStlDetail.dtcAgentId').value).length != 0) && (trim(getObj('cashStlDetail.dtcAgentName').value).length != 0)) {
//					getObj('cashStlDetail.dtcAgentId').value=getObj('cashStlDetail.dtcAgentId').value+"/"+getObj('cashStlDetail.dtcAgentName').value;
//					getObj('cashStlDetail.dtcAgentName').value = "";
//				}
//
//				//BeneficiaryName
//				getObj('mapCashSdVO(beneficiaryName)').value = getObj('mapCashSdVO(beneficiaryNameDtc)').value;
			}

			if(cashSSILayout == "BONY") {
				//BeneficiaryName
//				getObj('mapCashSdVO(beneficiaryName)').value = getObj('mapCashSdVO(beneficiaryNameBony)').value;
			}
		}
	}
}
/*
 * For Amend page: Formats the Counterparty Details fields.
 * For Confirm and Ok page : Shows/Hides the Counter Party Details as per the SSI Layout - for Security side.
 * Skip it for Broker Internal scenario.
 */
private function handleSSILayoutForSecurityConf():void {
	if(isBrokerAccount != "Y" || uSettlementMode.text != "INTERNAL") {
		
		//Not a Broker Internal Scenario

		if(amendConfirmFlag != "A") {
//			if(secSSILayout == "BONY") {
//				document.getElementById('secBONY').style.display="block";
//				document.getElementById('secDTC').style.display="none";
//				document.getElementById('secInternational').style.display="none";
//			} else if(getObj('secSSILayout').value == "DTC") {
//				document.getElementById('secBONY').style.display="none";
//				document.getElementById('secDTC').style.display="block";
//				document.getElementById('secInternational').style.display="none";
//			} else {
//				document.getElementById('secBONY').style.display="none";
//				document.getElementById('secDTC').style.display="none";
//				document.getElementById('secInternational').style.display="block";
//			}
		} else {
			if(secSSILayout == "DTC") {
				
//				//Format the initial onload display in the following format: Id/Name
//
//				//ParticipantId and ParticipantName
//				if((trim(getObj('securityStlDetail.dtcParticipantId').value).length != 0) && (trim(getObj('securityStlDetail.dtcParticipantName').value).length != 0)) {
//					getObj('securityStlDetail.dtcParticipantId').value=getObj('securityStlDetail.dtcParticipantId').value+"/"+getObj('securityStlDetail.dtcParticipantName').value;
//					getObj('securityStlDetail.dtcParticipantName').value = "";
//				}
//
//				//InstitutionId and InstitutionName
//				if((trim(getObj('securityStlDetail.dtcInstitutionId').value).length != 0) && (trim(getObj('securityStlDetail.dtcInstitutionName').value).length != 0)) {
//					getObj('securityStlDetail.dtcInstitutionId').value=getObj('securityStlDetail.dtcInstitutionId').value+"/"+getObj('securityStlDetail.dtcInstitutionName').value;
//					getObj('securityStlDetail.dtcInstitutionName').value = "";
//				}
//
//				//AgentId and AgentName
//				if((trim(getObj('securityStlDetail.dtcAgentId').value).length != 0) && (trim(getObj('securityStlDetail.dtcAgentName').value).length != 0)) {
//					getObj('securityStlDetail.dtcAgentId').value=getObj('securityStlDetail.dtcAgentId').value+"/"+getObj('securityStlDetail.dtcAgentName').value;
//					getObj('securityStlDetail.dtcAgentName').value = "";
//				}
//
//				//BeneficiaryName
//				getObj('mapSecSdVO(beneficiaryName)').value = getObj('mapSecSdVO(beneficiaryNameDtc)').value;
			}

			if(secSSILayout == "BONY") {
				//BeneficiaryName
//				getObj('mapSecSdVO(beneficiaryName)').value = getObj('mapSecSdVO(beneficiaryNameBony)').value;
			}
		}
	}
}
/*
 * Function to handle securityStlDetail.settlementMode combo onchange
 */
private function onchangeSecStlModeConf():void {
	var secStlMode:String = uSettlementMode.text;
    
	switch (secStlMode)
	{
		case "EXTERNAL":
			showHideSecurityCounterpartyDetailBlockConf("S");
			showHideSecRowsConf("S");
			uSecCpSettleAc.styleName = "FormLabelHeading";
//			getObj('secCpSettleAc').className="lblNormalWt";
			break;
		case "INTERNAL":
			if(isBrokerAccount == "Y") {
				showHideSecurityCounterpartyDetailBlockConf("H");
			} else {
				showHideSecurityCounterpartyDetailBlockConf("S");
				showHideSecRowsConf("H");
				//CpSettleAc is mandatory
				uSecCpSettleAc.styleName = "ReqdLabel";
//				getObj('secCpSettleAc').className="lblReqdWt";
			}
			break;
	}
}
/*
 * Function to show/hide the security-side Counterparty details block depending 
 * on the "isBrokerAccount" and "SettlementMode" for the security-side.
 * In case of Broker Internal settlement, Counterparty details are not required.
 */
private function showHideSecurityCounterpartyDetailBlockConf(type:String):void {
	switch (type)
	{
	case "H":
	    uSec_cp.includeInLayout = false;
	    uSec_cp.visible = false;
//		document.getElementById('sec_cp').style.display="none";
        uOurHeader.includeInLayout = true;
        uOurHeader.visible = true;
//		document.getElementById('ourHeader').style.display="block";
        //Not Implemented
//		document.getElementById('ourBlk').style.display="none";
		break;
	case "S":
	    uSec_cp.includeInLayout = true;
	    uSec_cp.visible = true;
//		document.getElementById('sec_cp').style.display="block";		
		break;
	}
}
/*
 * Function to show/hide the security-side fields depending upon the "SettlementMode" for security-side.
 */
private function showHideSecRowsConf(type:String):void {
	switch (type)
	{
	case "H":
	    uSecRow1.includeInLayout = false;
	    uSecRow1.visible = false;
	    uSecRow2.includeInLayout = false;
	    uSecRow2.visible = false;
	    uSecRow3.includeInLayout = false;
	    uSecRow3.visible = false;
	    uSecRow4.includeInLayout = false;
	    uSecRow4.visible = false;
	    uSecRow5.includeInLayout = false;
	    uSecRow5.visible = false;
	    uOurHeader.includeInLayout = false;
	    uOurHeader.visible = false;
//		document.getElementById('secRow1').style.display="none";
//		document.getElementById('secRow2').style.display="none";
//		document.getElementById('secRow3').style.display="none";
//		document.getElementById('secRow4').style.display="none";
//		document.getElementById('secRow5').style.display="none";
//		document.getElementById('ourHeader').style.display="none";
		//Not Implemented
//		document.getElementById('ourBlk').style.display="block";
		break;
	case "S":
	    uSecRow1.includeInLayout = true;
	    uSecRow1.visible = true;
	    uSecRow2.includeInLayout = true;
	    uSecRow2.visible = true;
	    uSecRow3.includeInLayout = true;
	    uSecRow3.visible = true;
	    uSecRow4.includeInLayout = true;
	    uSecRow4.visible = true;
	    uSecRow5.includeInLayout = true;
	    uSecRow5.visible = true;
	    uOurHeader.includeInLayout = true;
	    uOurHeader.visible = true;
//		document.getElementById('secRow1').style.display="block";
//		document.getElementById('secRow2').style.display="block";
//		document.getElementById('secRow3').style.display="block";
//		document.getElementById('secRow4').style.display="block";
//		document.getElementById('secRow5').style.display="block";
//		document.getElementById('ourHeader').style.display="block";
		//Not Implemented
//		document.getElementById('ourBlk').style.display="none";
		break;
	}
}
/*
 * Function to handle samecash diffcash button onclick
 */
private function handleSameCashDiffCashConf(type:String):void {
	switch (type)
	{
		case "D":
			cashButtonstatus ="S";		
			//showCashButton(); //not needed for conf pages
			// set diffCashFlag to DIFFCASH - D
			diffCashFlag = "D";
//			document.getElementById('diffCashFlag').value="D";
            uCashSide2.includeInLayout = true;
            uCashSide2.visible = true;
//			document.getElementById('cashSide2').style.display="block";
			handleSSILayoutForCashConf();
			break;
		case "S":
			cashButtonstatus ="D";
			//showCashButton();
			// set diffCashFlag to SameCash - S
			diffCashFlag = "S";
//			document.getElementById('diffCashFlag').value="S";
            uCashSide2.includeInLayout = false;
            uCashSide2.visible = false;
//			document.getElementById('cashSide2').style.display="none";
			break;
	}
}