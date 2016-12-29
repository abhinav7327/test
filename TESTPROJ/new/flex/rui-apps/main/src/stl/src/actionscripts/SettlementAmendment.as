




// ActionScript file for holding the common functionality of the Settlement Amendment
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.stl.popupImpl.CpSSIPopup;
import com.nri.rui.stl.popupImpl.OurCustomizedPopup;

import mx.core.UIComponent;
import mx.managers.PopUpManager;
import mx.utils.StringUtil;



/*  Extra additions */
private function showDetail():void {	
	//Check for Suppressed settlement
	if(isSuppressed == "Y") {
		handleSuppression(nonSuppressedSide);
	} else {
		//Normal Case
		wsSecSide.includeInLayout = true;
		wsSecSide.visible = true;
		// display secside as per stlmode value (onchangeSecStlMode())
		onchangeSecStlMode();
		settlementMode.enabled = false;
		handleSSILayoutForSecurity();
		wsCashSide.includeInLayout = true;
		wsCashSide.visible = true;
		cashSide2.includeInLayout =true;
		cashSide2.visible = true;
		// display cashside as per stlmode value (onchangeCashStlMode())
		onchangeCashStlMode();
		cashSettlementmode.enabled = false;
		if(settleTypeFLD.selectedItem.value=="AGAINST") {
			//If AGAINST, then expose the DiffSameCash functionality else no
			handleSameCashDiffCash(diffCashFlag);
			//Show the appropriate InxTransmission to populate
			inxForNormal.includeInLayout = false;
			inxForNormal.visible = false;
			inxForSuppress.includeInLayout = true;
			inxForSuppress.visible = true;
		} else {
			//Show the appropriate InxTransmission to populate
			inxForNormal.includeInLayout = true;
			inxForNormal.visible = true;
			inxForSuppress.includeInLayout = false;
			inxForSuppress.visible = false;
			cashButtonstatus = "X";
			showCashButton();
			cashSide2.includeInLayout =true;
		    cashSide2.visible = true;
			handleSSILayoutForCash();
		}
	}

	//For Pair Off Amendment and Suppressed Free Settlements, we donot allow the user to change the Settlement Type
	if(csiVoSettlementFor == "CORPORATE_ACTION" || 
		csiVoSettlementFor == "PAIR_OFF" || 
		 isSuppressed == "Y") {
		//Make the SettlementType as readonly
		settleTypeFLD.visible = false;
		settleTypeFLD.includeInLayout = false;
		settleTypeLBL.visible = true;
		settleTypeLBL.includeInLayout = true;
	} else {
	    settleTypeFLD.includeInLayout = true;
		settleTypeFLD.includeInLayout = true;
	    settleTypeLBL.includeInLayout = false;
		settleTypeLBL.includeInLayout = false;
	}
}
/*
 * Function to handle Suppressed Settlement.
 * In Suppressed Settlement, one of the Sides is suppressed and the Settelment Type is 'FREE'.
 * The SettlementType cannot be changed for a Suppressed case.
 * Therefore,depending on the value of the 'showSide' - the side will be shown.
 */
public function handleSuppression(showSide:String):void {
	//Show only the appropriate side
	if(showSide == "CASH") {
	    wsCashSide.includeInLayout = true;
	    wsCashSide.visible = true;
        cashSide2.includeInLayout = true;
        cashSide2.visible = true;
		// display cashside as per stlmode value (onchangeCashStlMode())
		onchangeCashStlMode();
		cashSettlementmode.enabled = false;
		//Show the appropriate InxTransmission to populate
        inxForNormal.includeInLayout = false;
        inxForNormal.visible = false;
        inxForSuppress.includeInLayout = true;
        inxForSuppress.visible = true;
        
		handleSSILayoutForCash();
	} else {
	    wsSecSide.includeInLayout = true;
	    wsSecSide.visible = true;	    
		// display secside as per stlmode value (onchangeSecStlMode())
		onchangeSecStlMode();
        settlementMode.enabled = false;        
		handleSSILayoutForSecurity();
	}
}
/*
 * For Amend page: Formats the Counterparty Details field.
 * For Confirm and Ok page : Shows/Hides the Counter Party Details as per the SSI Layout - for Cash side.
 * Skip it for Broker Internal scenario.
 */
private function handleSSILayoutForCash():void {

	if(isBrokerAccount != "Y" || cashSettlementmode.selectedItem.value != "INTERNAL") {
		
		//Not a Broker Internal Scenario
		
		if(amendConfirmFlag != "A") {

		} else {
			if(cashSSILayout == "DTC") {				
				//Format the initial onload display in the following format: Id/Name
			}

			if(cashSSILayout == "BONY") {
			}
		}
	}
}
/*
 * For Amend page: Formats the Counterparty Details fields.
 * For Confirm and Ok page : Shows/Hides the Counter Party Details as per the SSI Layout - for Security side.
 * Skip it for Broker Internal scenario.
 */
private function handleSSILayoutForSecurity():void {
	if(isBrokerAccount != "Y" || settlementMode.selectedItem.value != "INTERNAL") {
		
		//Not a Broker Internal Scenario

		if(amendConfirmFlag != "A") {

		} else {
			if(secSSILayout == "DTC") {

			}

			if(secSSILayout == "BONY") {
				//BeneficiaryName
			}
		}
	}
}
/*
 * Function to handle cashDiff button 
 */
private function showCashButton():void {
	switch (cashButtonstatus)
	{
		case "D":
		    diffcash.includeInLayout = true;
		    diffcash.visible = true;
		    samecash.includeInLayout = false;
		    samecash.visible = false;
			break;
		case "S":
		    diffcash.includeInLayout = false;
		    diffcash.visible = false;
		    samecash.includeInLayout = true;
		    samecash.visible = true;
			break;
		case "X":
		    diffcash.includeInLayout = false;
		    diffcash.visible = false;
		    samecash.includeInLayout = false;
		    samecash.visible = false;
			break;
	}
}
/*
 * Function to handle cashStlDetail.settlementMode combo onchange
 */
private function onchangeCashStlMode():void {
	var cashStlMode:String = cashSettlementmode.selectedItem.value;
	
	switch (cashStlMode)
	{
		case "EXTERNAL":
			showHideCashCounterpartyDetailBlock("S");
			showHideCashRows("S");

            lblCashCpSettleAc.styleName = "FormLabelHeading";
			break;
		case "INTERNAL":
		
			if(isBrokerAccount == "Y") {
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

/*
 * Function to show/hide the cash-side Counterparty details block depending 
 * on the "isBrokerAccount" and "SettlementMode" for cash-side.
 * In case of Broker Internal settlement, Counterparty details are not required.
 */
private function showHideCashCounterpartyDetailBlock(type:String):void {
	switch (type)
	{
	case "H":
	    cash_cp.includeInLayout = false;
	    cash_cp.visible = false;
        ourHeaderCash.includeInLayout = true;
        ourHeaderCash.visible = true;
		//document.getElementById('ourBlkCash').style.display="none"; Not implemented as it soes not contail anything for Security trade
		break;
	case "S":
	    cash_cp.includeInLayout = true;
	    cash_cp.visible = true;		
		break;
	}
}
/*
 * Function to show/hide the cash-side fields depending upon the "SettlementMode" for cash-side.
 */
private function showHideCashRows(type:String):void{
	switch (type)
	{
	case "H":
	    cashRow1.includeInLayout = false;
	    cashRow1.visible = false;
	    cashRow2.includeInLayout = false;
	    cashRow2.visible = false;
	    cashRow3.includeInLayout = false;
	    cashRow3.visible = false;
	    cashRow4.includeInLayout = false;
	    cashRow4.visible = false;
	    cashRow5.includeInLayout = false;
	    cashRow5.visible = false;
	    ourHeaderCash.includeInLayout = false;
	    ourHeaderCash.visible = false;	    
        //Not implemented
//		document.getElementById('ourBlkCash').style.display="block";
		break;
	case "S":
	    cashRow1.includeInLayout = true;
	    cashRow1.visible = true;
	    cashRow2.includeInLayout = true;
	    cashRow2.visible = true;
	    cashRow3.includeInLayout = true;
	    cashRow3.visible = true;
	    cashRow4.includeInLayout = true;
	    cashRow4.visible = true;
	    cashRow5.includeInLayout = true;
	    cashRow5.visible = true;
	    ourHeaderCash.includeInLayout = true;
	    ourHeaderCash.visible = true;
		//Not implemented
//		document.getElementById('ourBlkCash').style.display="none";
		break;
	}
}
/*
 * Function to handle securityStlDetail.settlementMode combo onchange
 */
private function onchangeSecStlMode():void {
	var secStlMode:String = settlementMode.selectedItem.value;
    
	switch (secStlMode)
	{
		case "EXTERNAL":
			showHideSecurityCounterpartyDetailBlock("S");
			showHideSecRows("S");
			secCpSettleAc.styleName = "FormLabelHeading";
			break;
		case "INTERNAL":
			if(isBrokerAccount == "Y") {
				showHideSecurityCounterpartyDetailBlock("H");
			} else {
				showHideSecurityCounterpartyDetailBlock("S");
				showHideSecRows("H");
				//CpSettleAc is mandatory
				secCpSettleAc.styleName = "ReqdLabel";
			}
			break;
	}
}
/*
 * Function to show/hide the security-side Counterparty details block depending 
 * on the "isBrokerAccount" and "SettlementMode" for the security-side.
 * In case of Broker Internal settlement, Counterparty details are not required.
 */
private function showHideSecurityCounterpartyDetailBlock(type:String):void {
	switch (type)
	{
	case "H":
	    sec_cp.includeInLayout = false;
	    sec_cp.visible = false;
        ourHeader.includeInLayout = true;
        ourHeader.visible = true;
		break;
	case "S":
	    sec_cp.includeInLayout = true;
	    sec_cp.visible = true;
		break;
	}
}
/*
 * Function to show/hide the security-side fields depending upon the "SettlementMode" for security-side.
 */
private function showHideSecRows(type:String):void {
	switch (type)
	{
	case "H":
	    secRow1.includeInLayout = false;
	    secRow1.visible = false;
	    secRow2.includeInLayout = false;
	    secRow2.visible = false;
	    secRow3.includeInLayout = false;
	    secRow3.visible = false;
	    secRow4.includeInLayout = false;
	    secRow4.visible = false;
	    secRow5.includeInLayout = false;
	    secRow5.visible = false;
	    ourHeader.includeInLayout = false;
	    ourHeader.visible = false;
		break;
	case "S":
	    secRow1.includeInLayout = true;
	    secRow1.visible = true;
	    secRow2.includeInLayout = true;
	    secRow2.visible = true;
	    secRow3.includeInLayout = true;
	    secRow3.visible = true;
	    secRow4.includeInLayout = true;
	    secRow4.visible = true;
	    secRow5.includeInLayout = true;
	    secRow5.visible = true;
	    ourHeader.includeInLayout = true;
	    ourHeader.visible = true;
		break;
	}
}
/*
 * Function to handle samecash diffcash button onclick
 */
private function handleSameCashDiffCash(type:String):void {
	switch (type)
	{
		case "D":
			cashButtonstatus ="S";		
			showCashButton();
			// set diffCashFlag to DIFFCASH - D
			diffCashFlag = "D";
            cashSide2.includeInLayout = true;
            cashSide2.visible = true;
			handleSSILayoutForCash();
			break;
		case "S":
			cashButtonstatus ="D";
			showCashButton();
			// set diffCashFlag to SameCash - S
			diffCashFlag = "S";
            cashSide2.includeInLayout = false;
            cashSide2.visible = false;
			break;
	}
}
private function onclickSecCpDetails():void {
    //pass the context data to the popup
    receiveContextList = new ArrayCollection(); 
    returnContextList = new ArrayCollection(); 
    
    popUpFlag = "CP_SSI_SEC";      

    
    if(isSuppressed == "Y") {
		//Only Security side present
		receiveContextList.addItem(new HiddenObject("security", [security]));
		receiveContextList.addItem(new HiddenObject("mapSecSiVO(tradingAc)",[tradingAccount.text]));
		receiveContextList.addItem(new HiddenObject("mapSecSdVO(securityCode)",[securityCode.text]));
		receiveContextList.addItem(new HiddenObject("securityStlDetail.deliveryMethod",[secSDetailDeliveryMethod]));		
		receiveContextList.addItem(new HiddenObject("secCpIntermediaryInfoListName",[secCpIntermediaryInfoListName]));
		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementType",[settleTypeFLD.selectedItem.value != null? settleTypeFLD.selectedItem.value : ""]));
		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementFor",[csiVoSettlementFor]));		
		
	} else {
		//Both sides are present
		receiveContextList.addItem(new HiddenObject("security",[security]));
		receiveContextList.addItem(new HiddenObject("mapSecSiVO(tradingAc)",[tradingAccount.text]));
		receiveContextList.addItem(new HiddenObject("mapSecSdVO(securityCode)",[securityCode.text]));
		receiveContextList.addItem(new HiddenObject("securityStlDetail.deliveryMethod",[secSDetailDeliveryMethod]));
		receiveContextList.addItem(new HiddenObject("secCpIntermediaryInfoListName",[secCpIntermediaryInfoListName]));
		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementType",[settleTypeFLD.selectedItem.value != null? settleTypeFLD.selectedItem.value : ""]));
		receiveContextList.addItem(new HiddenObject("mapCashSdVO(settlementCcy)",[settlementCcy.text]));
		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementFor",[csiVoSettlementFor]));				
		
	}

    //create the cpSSI popup        
    var cpSsiPopup:CpSSIPopup=CpSSIPopup
    (PopUpManager.createPopUp( UIComponent(this.parentApplication), CpSSIPopup , true));

    
    //Center the Popup Window in the Application's container
    PopUpManager.centerPopUp(cpSsiPopup);    
    
    // Pass a reference to the returnning context items
    cpSsiPopup.returnContextItems = returnContextList;
    // Pass a reference to the popup context items
    cpSsiPopup.receiveCtxItems = receiveContextList;
    
    cpSsiPopup.popUpQueryPage.resultFormat = "xml";
    //initialize the account popup
    cpSsiPopup.initPopup();

}
/**
 * Function to check for the presence of required fields before firing the popup
 * for Security side Our details List.
 */
private function onclickSecOurDetails():void {
    //pass the context data to the popup
    receiveContextList = new ArrayCollection(); 
    returnContextList = new ArrayCollection();
    
    popUpFlag = "OWN_SSI_SEC";
    
    //Evaluate to see if Security side is Broker Internal.
	if(isBrokerAccount == "Y" && settlementMode.selectedItem.value == "INTERNAL") {
		//Set isBrokerInternalCase flag to "Y"
		isBrokerInternalCase = "Y";
	} else {
		isBrokerInternalCase = "N";
	}
	
	if(isSuppressed == "Y") {
		//Only Security side present
		if(csiVoSettlementFor == "CORPORATE_ACTION") {
			//populateRequest(new Array('security','mapSecSiVO(tradingAc)','mapSecSdVO(securityCode)','securityStlDetail.deliveryMethod','secSSILayout','secOurIntermediaryInfoListName','clientSettlementInfoVO.settlementType','clientSettlementInfoVO.settlementFor','isBrokerInternalCase'),new Array('secOurChainIndex','mapSecSdVO(ourBank)','mapSecSdVO(ourSettleAc)','mapSecSdVO(ourIntermediaryInfo)'),'../stl/ourCustomizedPopupDispatch.action?','method=load',true,700,433);
			//populateRequest(new Array('security','mapSecSiVO(tradingAc)','mapSecSdVO(securityCode)','securityStlDetail.deliveryMethod','secSSILayout','secOurIntermediaryInfoListName','clientSettlementInfoVO.settlementType','clientSettlementInfoVO.settlementFor','isBrokerInternalCase'),new Array('secOurChainIndex','mapSecSdVO(ourBank)','mapSecSdVO(ourSettleAc)','mapSecSdVO(ourIntermediaryInfo)'),'../stl/ourCustomizedPopupDispatch.action?','method=load',true,700,433);
			//XenosAlert.info("suppressed, Security Our");
			receiveContextList.addItem(new HiddenObject("security", [security]));
    		receiveContextList.addItem(new HiddenObject("mapSecSiVO(tradingAc)",[tradingAccount.text]));
    		receiveContextList.addItem(new HiddenObject("mapSecSdVO(securityCode)",[securityCode.text]));
    		receiveContextList.addItem(new HiddenObject("securityStlDetail.deliveryMethod",[secSDetailDeliveryMethod]));
    		receiveContextList.addItem(new HiddenObject("secSSILayout", [secSSILayout]));
    		receiveContextList.addItem(new HiddenObject("secOurIntermediaryInfoListName", [secOurIntermediaryInfoListName]));
    		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementType", [settleTypeFLD.selectedItem.value != null? settleTypeFLD.selectedItem.value : ""]));
    		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementFor", [csiVoSettlementFor]));
    		receiveContextList.addItem(new HiddenObject("isBrokerInternalCase", [isBrokerInternalCase]));
		} else {
			//populateRequest(new Array('security','mapSecSiVO(tradingAc)','mapSecSdVO(securityCode)','securityStlDetail.deliveryMethod',
			//'secSSILayout','secOurIntermediaryInfoListName','clientSettlementInfoVO.settlementType','clientSettlementInfoVO.settlementFor','isBrokerInternalCase',
			//'settlementInfoVO.inventoryAccountPk'),new Array('secOurChainIndex','mapSecSdVO(ourBank)','mapSecSdVO(ourSettleAc)','mapSecSdVO(ourIntermediaryInfo)'),'../stl/ourCustomizedPopupDispatch.action?','method=load',true,700,433);
			receiveContextList.addItem(new HiddenObject("security", [security]));
    		receiveContextList.addItem(new HiddenObject("mapSecSiVO(tradingAc)",[tradingAccount.text]));
    		receiveContextList.addItem(new HiddenObject("mapSecSdVO(securityCode)",[securityCode.text]));
    		receiveContextList.addItem(new HiddenObject("securityStlDetail.deliveryMethod",[secSDetailDeliveryMethod]));
    		receiveContextList.addItem(new HiddenObject("secSSILayout", [secSSILayout]));
    		receiveContextList.addItem(new HiddenObject("secOurIntermediaryInfoListName", [secOurIntermediaryInfoListName]));
    		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementType", [settleTypeFLD.selectedItem.value != null? settleTypeFLD.selectedItem.value : ""]));
    		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementFor", [csiVoSettlementFor]));
    		receiveContextList.addItem(new HiddenObject("isBrokerInternalCase", [isBrokerInternalCase]));
    		receiveContextList.addItem(new HiddenObject("settlementInfoVO.inventoryAccountPk", [siVoInventoryAccountPk]));
		}
	} else {
		//Both sides are present
		if(csiVoSettlementFor == "CORPORATE_ACTION") {
			//populateRequest(new Array('security','mapSecSiVO(tradingAc)','mapSecSdVO(securityCode)','securityStlDetail.deliveryMethod','secSSILayout','secOurIntermediaryInfoListName','mapCashSdVO(settlementCcy)','clientSettlementInfoVO.settlementType','clientSettlementInfoVO.settlementFor','isBrokerInternalCase'),new Array('secOurChainIndex','mapSecSdVO(ourBank)','mapSecSdVO(ourSettleAc)','mapSecSdVO(ourIntermediaryInfo)'),'../stl/ourCustomizedPopupDispatch.action?','method=load',true,700,433);
			//populateRequest(new Array('security','mapSecSiVO(tradingAc)','mapSecSdVO(securityCode)','securityStlDetail.deliveryMethod','secSSILayout','secOurIntermediaryInfoListName','mapCashSdVO(settlementCcy)','clientSettlementInfoVO.settlementType','clientSettlementInfoVO.settlementFor','isBrokerInternalCase'),new Array('secOurChainIndex','mapSecSdVO(ourBank)','mapSecSdVO(ourSettleAc)','mapSecSdVO(ourIntermediaryInfo)'),'../stl/ourCustomizedPopupDispatch.action?','method=load',true,700,433);
			//XenosAlert.info("NOT suppressed, Security Our");
			receiveContextList.addItem(new HiddenObject("security", [security]));
    		receiveContextList.addItem(new HiddenObject("mapSecSiVO(tradingAc)",[tradingAccount.text]));
    		receiveContextList.addItem(new HiddenObject("mapSecSdVO(securityCode)",[securityCode.text]));
    		receiveContextList.addItem(new HiddenObject("securityStlDetail.deliveryMethod",[secSDetailDeliveryMethod]));
    		receiveContextList.addItem(new HiddenObject("secSSILayout", [secSSILayout]));
    		receiveContextList.addItem(new HiddenObject("secOurIntermediaryInfoListName", [secOurIntermediaryInfoListName]));
    		receiveContextList.addItem(new HiddenObject("mapCashSdVO(settlementCcy)", [settlementCcy.text]));
    		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementType", [settleTypeFLD.selectedItem.value != null? settleTypeFLD.selectedItem.value : ""]));
    		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementFor", [csiVoSettlementFor]));
    		receiveContextList.addItem(new HiddenObject("isBrokerInternalCase", [isBrokerInternalCase]));
		} else {
			//populateRequest(new Array('security','mapSecSiVO(tradingAc)','mapSecSdVO(securityCode)','securityStlDetail.deliveryMethod','secSSILayout','secOurIntermediaryInfoListName',
			//'mapCashSdVO(settlementCcy)','clientSettlementInfoVO.settlementType','clientSettlementInfoVO.settlementFor','isBrokerInternalCase','settlementInfoVO.inventoryAccountPk'),new Array('secOurChainIndex','mapSecSdVO(ourBank)','mapSecSdVO(ourSettleAc)','mapSecSdVO(ourIntermediaryInfo)'),'../stl/ourCustomizedPopupDispatch.action?','method=load',true,700,433);
			receiveContextList.addItem(new HiddenObject("security", [security]));
    		receiveContextList.addItem(new HiddenObject("mapSecSiVO(tradingAc)",[tradingAccount.text]));
    		receiveContextList.addItem(new HiddenObject("mapSecSdVO(securityCode)",[securityCode.text]));
    		receiveContextList.addItem(new HiddenObject("securityStlDetail.deliveryMethod",[secSDetailDeliveryMethod]));
    		receiveContextList.addItem(new HiddenObject("secSSILayout", [secSSILayout]));
    		receiveContextList.addItem(new HiddenObject("secOurIntermediaryInfoListName", [secOurIntermediaryInfoListName]));
    		receiveContextList.addItem(new HiddenObject("mapCashSdVO(settlementCcy)", [settlementCcy.text]));
    		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementType", [settleTypeFLD.selectedItem.value != null? settleTypeFLD.selectedItem.value : ""]));
    		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementFor", [csiVoSettlementFor]));
    		receiveContextList.addItem(new HiddenObject("isBrokerInternalCase", [isBrokerInternalCase]));
    		receiveContextList.addItem(new HiddenObject("settlementInfoVO.inventoryAccountPk", [siVoInventoryAccountPk]));
		}
	}
	
	//create the cpSSI popup  for CASH side      
    var ownSsiPopup:OurCustomizedPopup=OurCustomizedPopup
    (PopUpManager.createPopUp( UIComponent(this.parentApplication), OurCustomizedPopup , true));

    
    //Center the Popup Window in the Application's container
    PopUpManager.centerPopUp(ownSsiPopup);
    
    // Pass a reference to the returnning context items
    ownSsiPopup.returnContextItems = returnContextList;
    // Pass a reference to the popup context items
    ownSsiPopup.receiveCtxItems = receiveContextList;
    
    ownSsiPopup.popUpQueryPage.resultFormat = "xml";
    //initialize the account popup
    ownSsiPopup.initPopup();	
}
/*
 * Function to check for the presence of required fields before firing the popup
 * for Cash side Cp details List.
 */
private function onclickCashCpDetails():void{
    //pass the context data to the popup
    receiveContextList = new ArrayCollection(); 
    returnContextList = new ArrayCollection();
    
    popUpFlag = "CP_SSI_CASH";
    
    if(isSuppressed == "Y") {
		//Only Cash side present
		receiveContextList.addItem(new HiddenObject("cash", [cash]));
		receiveContextList.addItem(new HiddenObject("mapSecSiVO(tradingAc)", [tradingAccount.text]));
		receiveContextList.addItem(new HiddenObject("mapCashSdVO(settlementCcy)", [settlementCcy.text]));
		receiveContextList.addItem(new HiddenObject("cashCpIntermediaryInfoListName", [cashCpIntermediaryInfoListName]));
		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementType", [settleTypeFLD.selectedItem.value != null? settleTypeFLD.selectedItem.value : ""]));
		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementFor", [csiVoSettlementFor]));		
		
//		populateRequest(new Array('cash','mapSecSiVO(tradingAc)','mapCashSdVO(settlementCcy)','cashCpIntermediaryInfoListName','clientSettlementInfoVO.settlementType','clientSettlementInfoVO.settlementFor'),new Array('cpListHitCopy','cashCpChainIndex','mapCashSdVO(cpBank)','mapCashSdVO(cpSettleAc)','cashStlDetail.cpExtSettleAccountName1','cashStlDetail.cpExtSettleAccountName2','cashStlDetail.cpExtSettleAccountName3','cashStlDetail.cpExtSettleAccountName4','mapCashSdVO(cpIntermediaryInfo)','mapCashSdVO(contraId)','mapCashSdVO(deliveryInstruction)','cashStlDetail.dtcInstitutionId','cashStlDetail.dtcAgentId','cashStlDetail.dtcAgentAccountNo','cashStlDetail.dtcParticipantId','mapCashSdVO(beneficiaryName)','cashStlDetail.furtherCredit','cashStlDetail.settlementMode','cashSSILayout','mapCashSdVO(placeOfSettlement)','cashStlDetail.participantId','cashStlDetail.brokerBic','cashStlDetail.cpBankCodeType','cashStlDetail.participantId2'),'../stl/cpSsiPopupDispatch.action?','method=load',true,700,500);
	} else {
	    receiveContextList.addItem(new HiddenObject("cash", [cash]));
		receiveContextList.addItem(new HiddenObject("mapSecSiVO(tradingAc)", [tradingAccount.text]));
		receiveContextList.addItem(new HiddenObject("mapCashSdVO(settlementCcy)", [settlementCcy.text]));
		receiveContextList.addItem(new HiddenObject("mapSecSdVO(securityCode)", [securityCode.text]));
		receiveContextList.addItem(new HiddenObject("securityStlDetail.deliveryMethod", [secSDetailDeliveryMethod]));
		receiveContextList.addItem(new HiddenObject("cashCpIntermediaryInfoListName", [cashCpIntermediaryInfoListName]));
		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementType", [settleTypeFLD.selectedItem.value != null? settleTypeFLD.selectedItem.value : ""]));
		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementFor", [csiVoSettlementFor]));		
		//Both sides are present
//		populateRequest(new Array('cash','mapSecSiVO(tradingAc)','mapCashSdVO(settlementCcy)','mapSecSdVO(securityCode)','securityStlDetail.deliveryMethod','cashCpIntermediaryInfoListName','clientSettlementInfoVO.settlementType','clientSettlementInfoVO.settlementFor'),new Array('cpListHitCopy','cashCpChainIndex','mapCashSdVO(cpBank)','mapCashSdVO(cpSettleAc)','cashStlDetail.cpExtSettleAccountName1','cashStlDetail.cpExtSettleAccountName2','cashStlDetail.cpExtSettleAccountName3','cashStlDetail.cpExtSettleAccountName4','mapCashSdVO(cpIntermediaryInfo)','mapCashSdVO(contraId)','mapCashSdVO(deliveryInstruction)','cashStlDetail.dtcInstitutionId','cashStlDetail.dtcAgentId','cashStlDetail.dtcAgentAccountNo','cashStlDetail.dtcParticipantId','mapCashSdVO(beneficiaryName)','cashStlDetail.furtherCredit','cashStlDetail.settlementMode','cashSSILayout','mapCashSdVO(placeOfSettlement)','cashStlDetail.participantId','cashStlDetail.brokerBic','cashStlDetail.cpBankCodeType','cashStlDetail.participantId2'),'../stl/cpSsiPopupDispatch.action?','method=load',true,700,500);
	}
    //create the cpSSI popup  for CASH side      
    var cpSsiPopup:CpSSIPopup=CpSSIPopup
    (PopUpManager.createPopUp( UIComponent(this.parentApplication), CpSSIPopup , true));

    
    //Center the Popup Window in the Application's container
    PopUpManager.centerPopUp(cpSsiPopup);
    
    // Pass a reference to the returnning context items
    cpSsiPopup.returnContextItems = returnContextList;
    // Pass a reference to the popup context items
    cpSsiPopup.receiveCtxItems = receiveContextList;
    
    cpSsiPopup.popUpQueryPage.resultFormat = "xml";
    //initialize the account popup
    cpSsiPopup.initPopup();

}
private function onclickCashOurDetails():void {
    //pass the context data to the popup
    receiveContextList = new ArrayCollection(); 
    returnContextList = new ArrayCollection();
    
    popUpFlag = "OWN_SSI_CASH";
    
    //Evaluate to see if Security side is Broker Internal.
//	if(('isBrokerAccount').value == "Y" && getObj('cashStlDetail.settlementMode').value == "INTERNAL") {
    if(isBrokerAccount == "Y" && cashSettlementmode.selectedItem.value == "INTERNAL"){
		//Set isBrokerInternalCase flag to "Y"
		isBrokerInternalCase = "Y";
	} else {
		isBrokerInternalCase = "N";
	}

	if(isSuppressed == "Y") {
		//Only Cash side present
		if(csiVoSettlementFor == "CORPORATE_ACTION") {
			//populateRequest(new Array('cash','mapSecSiVO(tradingAc)','mapCashSdVO(settlementCcy)','cashSSILayout','cashOurIntermediaryInfoListName','clientSettlementInfoVO.settlementType','clientSettlementInfoVO.settlementFor','isBrokerInternalCase'),new Array('cashOurChainIndex','mapCashSdVO(ourBank)','mapCashSdVO(ourSettleAc)','mapCashSdVO(ourIntermediaryInfo)'),'../stl/ourCustomizedPopupDispatch.action?','method=load',true,700,433);
			//populateRequest(new Array('cash','mapSecSiVO(tradingAc)','mapCashSdVO(settlementCcy)','cashSSILayout','cashOurIntermediaryInfoListName','clientSettlementInfoVO.settlementType','clientSettlementInfoVO.settlementFor','isBrokerInternalCase'),new Array('cashOurChainIndex','mapCashSdVO(ourBank)','mapCashSdVO(ourSettleAc)','mapCashSdVO(ourIntermediaryInfo)'),'../stl/ourCustomizedPopupDispatch.action?','method=load',true,700,433);
			//XenosAlert.info("suppressed, Cash Our");
			receiveContextList.addItem(new HiddenObject("cash", [cash]));
    		receiveContextList.addItem(new HiddenObject("mapSecSiVO(tradingAc)", [tradingAccount.text]));
    		receiveContextList.addItem(new HiddenObject("mapCashSdVO(settlementCcy)", [settlementCcy.text]));
    		receiveContextList.addItem(new HiddenObject("cashSSILayout", [cashSSILayout]));
    		receiveContextList.addItem(new HiddenObject("cashOurIntermediaryInfoListName", [cashOurIntermediaryInfoListName]));
    		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementType", [settleTypeFLD.selectedItem.value != null? settleTypeFLD.selectedItem.value : ""]));
    		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementFor", [csiVoSettlementFor]));		
    		receiveContextList.addItem(new HiddenObject("isBrokerInternalCase", [isBrokerInternalCase]));
		} else {
			//populateRequest(new Array('cash','mapSecSiVO(tradingAc)','mapCashSdVO(settlementCcy)','cashSSILayout','cashOurIntermediaryInfoListName','clientSettlementInfoVO.settlementType','clientSettlementInfoVO.settlementFor','isBrokerInternalCase','settlementInfoVO.inventoryAccountPk'),new Array('cashOurChainIndex','mapCashSdVO(ourBank)','mapCashSdVO(ourSettleAc)','mapCashSdVO(ourIntermediaryInfo)'),'../stl/ourCustomizedPopupDispatch.action?','method=load',true,700,433);
    		receiveContextList.addItem(new HiddenObject("cash", [cash]));
    		receiveContextList.addItem(new HiddenObject("mapSecSiVO(tradingAc)", [tradingAccount.text]));
    		receiveContextList.addItem(new HiddenObject("mapCashSdVO(settlementCcy)", [settlementCcy.text]));
    		receiveContextList.addItem(new HiddenObject("cashSSILayout", [cashSSILayout]));
    		receiveContextList.addItem(new HiddenObject("cashOurIntermediaryInfoListName", [cashOurIntermediaryInfoListName]));
    		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementType", [settleTypeFLD.selectedItem.value != null? settleTypeFLD.selectedItem.value : ""]));
    		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementFor", [csiVoSettlementFor]));		
    		receiveContextList.addItem(new HiddenObject("isBrokerInternalCase", [isBrokerInternalCase]));
    		receiveContextList.addItem(new HiddenObject("settlementInfoVO.inventoryAccountPk", [siVoInventoryAccountPk]));			
		}
	} else {
		//Both sides are present
		if(csiVoSettlementFor == "CORPORATE_ACTION") {
			//populateRequest(new Array('cash','mapSecSiVO(tradingAc)','mapCashSdVO(settlementCcy)','mapSecSdVO(securityCode)','securityStlDetail.deliveryMethod','cashSSILayout','cashOurIntermediaryInfoListName','clientSettlementInfoVO.settlementType','clientSettlementInfoVO.settlementFor','isBrokerInternalCase'),new Array('cashOurChainIndex','mapCashSdVO(ourBank)','mapCashSdVO(ourSettleAc)','mapCashSdVO(ourIntermediaryInfo)'),'../stl/ourCustomizedPopupDispatch.action?','method=load',true,700,433);
			//populateRequest(new Array('cash','mapSecSiVO(tradingAc)','mapCashSdVO(settlementCcy)','mapSecSdVO(securityCode)','securityStlDetail.deliveryMethod','cashSSILayout','cashOurIntermediaryInfoListName','clientSettlementInfoVO.settlementType','clientSettlementInfoVO.settlementFor','isBrokerInternalCase'),new Array('cashOurChainIndex','mapCashSdVO(ourBank)','mapCashSdVO(ourSettleAc)','mapCashSdVO(ourIntermediaryInfo)'),'../stl/ourCustomizedPopupDispatch.action?','method=load',true,700,433);
			//XenosAlert.info("NOT suppressed, Cash Our");
			receiveContextList.addItem(new HiddenObject("cash", [cash]));
    		receiveContextList.addItem(new HiddenObject("mapSecSiVO(tradingAc)",[tradingAccount.text]));
    		receiveContextList.addItem(new HiddenObject("mapCashSdVO(settlementCcy)",[settlementCcy.text]));
    		receiveContextList.addItem(new HiddenObject("mapSecSdVO(securityCode)", [securityCode.text]));
    		receiveContextList.addItem(new HiddenObject("securityStlDetail.deliveryMethod",[secSDetailDeliveryMethod]));
    		receiveContextList.addItem(new HiddenObject("cashSSILayout", [cashSSILayout]));
    		receiveContextList.addItem(new HiddenObject("cashOurIntermediaryInfoListName", [cashOurIntermediaryInfoListName]));
    		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementType", [settleTypeFLD.selectedItem.value != null? settleTypeFLD.selectedItem.value : ""]));
    		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementFor", [csiVoSettlementFor]));
    		receiveContextList.addItem(new HiddenObject("isBrokerInternalCase", [isBrokerInternalCase]));
		} else {
			//populateRequest(new Array('cash','mapSecSiVO(tradingAc)','mapCashSdVO(settlementCcy)','mapSecSdVO(securityCode)','securityStlDetail.deliveryMethod','cashSSILayout',
			//'cashOurIntermediaryInfoListName','clientSettlementInfoVO.settlementType','clientSettlementInfoVO.settlementFor','isBrokerInternalCase','settlementInfoVO.inventoryAccountPk'),new Array('cashOurChainIndex','mapCashSdVO(ourBank)','mapCashSdVO(ourSettleAc)','mapCashSdVO(ourIntermediaryInfo)'),'../stl/ourCustomizedPopupDispatch.action?','method=load',true,700,433);
			receiveContextList.addItem(new HiddenObject("cash", [cash]));
    		receiveContextList.addItem(new HiddenObject("mapSecSiVO(tradingAc)",[tradingAccount.text]));
    		receiveContextList.addItem(new HiddenObject("mapCashSdVO(settlementCcy)",[settlementCcy.text]));
    		receiveContextList.addItem(new HiddenObject("mapSecSdVO(securityCode)", [securityCode.text]));
    		receiveContextList.addItem(new HiddenObject("securityStlDetail.deliveryMethod",[secSDetailDeliveryMethod]));
    		receiveContextList.addItem(new HiddenObject("cashSSILayout", [cashSSILayout]));
    		receiveContextList.addItem(new HiddenObject("cashOurIntermediaryInfoListName", [cashOurIntermediaryInfoListName]));
    		receiveContextList.addItem(new HiddenObject("mapCashSdVO(settlementCcy)", [settlementCcy.text]));
    		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementType", [settleTypeFLD.selectedItem.value != null? settleTypeFLD.selectedItem.value : ""]));
    		receiveContextList.addItem(new HiddenObject("clientSettlementInfoVO.settlementFor", [csiVoSettlementFor]));
    		receiveContextList.addItem(new HiddenObject("isBrokerInternalCase", [isBrokerInternalCase]));
    		receiveContextList.addItem(new HiddenObject("settlementInfoVO.inventoryAccountPk", [siVoInventoryAccountPk]));
		}
	}
	//create the cpSSI popup  for CASH side      
    var ownSsiPopup:OurCustomizedPopup=OurCustomizedPopup
    (PopUpManager.createPopUp( UIComponent(this.parentApplication), OurCustomizedPopup , true));

    
    //Center the Popup Window in the Application's container
    PopUpManager.centerPopUp(ownSsiPopup);
    
    // Pass a reference to the returnning context items
    ownSsiPopup.returnContextItems = returnContextList;
    // Pass a reference to the popup context items
    ownSsiPopup.receiveCtxItems = receiveContextList;
    
    ownSsiPopup.popUpQueryPage.resultFormat = "xml";
    //initialize the account popup
    ownSsiPopup.initPopup();	
}

/*
 * Function to Validate the details so that the mandatory fields are present 
 * before submitting the form.
 */
private function validateSettlementAmendment():Boolean {
    var settleType:String = settleTypeFLD.visible == true? settleTypeFLD.selectedItem.value : settleTypeLBL.text;
	if(settleType=="FREE") {  
		//FREE scenario
		if(isSuppressed == "Y") 
		{
			//Suppressed FREE scenario
			if(nonSuppressedSide == "CASH") {
				//Security side Suppressed
				
				if(!validateCashSide()) {
					return false;
				}
				
				//Enable the Settlement Mode field
				cashSettlementmode.enabled = true;
				handleCashAmendment();

				return true;
			} else {
				//Cash side suppressed
				
				if(!validateSecuritySide()) {
					return false;
				}
				
				//Enable the Settlement Mode field
				settlementMode.enabled = true;
				handleSecurityAmendment();

				return true;
			}
		} else {
			//Normal FREE scenario

			if(!validateSecuritySide()) {
				return false;
			} 
			
			if(!validateCashSide()) {
				return false;
			} 

			validateCashSide();
			//Enable the Settlement Mode fields
			settlementMode.enabled = true;
			handleSecurityAmendment();
			cashSettlementmode.enabled = true;
			handleCashAmendment();

			return true;
		}
	} else {
		//AGAINST scenario
		
		if(!validateSecuritySide()) {
			return false;
		} 
		
		if(!validateCashSide()) {
			return false;
		}

		//Enable the Settlement Mode fields
		settlementMode.enabled = true;
		handleSecurityAmendment();
		cashSettlementmode.enabled = true;
		handleCashAmendment();

		return true;
	}
}
/* 
 * Validates the Detail Security-side part. 
 */
private function validateSecuritySide():Boolean
{
	secSdVoSettlementInfoStatus = siVOSettlementInfoStatus;
	//Validate Counterparty details  - skip it for Broker Internal Scenario

	if(isBrokerAccount != "Y" && settlementMode.selectedItem.value != "INTERNAL") {

		if (secSSILayout == "BONY") {

		} else if (secSSILayout == "DTC") {

		} else {
			if (StringUtil.trim(cpBank.text).length == 0) 
			{
				if(secSdVoSettlementInfoStatus != "UNKNOWN") {
					XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.specifybank'));
					return false;
				}
			}
			
			if (settlementMode.selectedItem.value == "INTERNAL")
			{
				if (StringUtil.trim(cpSettleAc.text).length == 0) 
				{
					if(secSdVoSettlementInfoStatus != "UNKNOWN") {
						XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.specifycpstlaccount'));
						return false;
					}
				}
			}
		}
	}
	
	//Validate Own details
	if(settlementMode.selectedItem.value == "EXTERNAL" || isBrokerAccount == "Y") {
		
		if (StringUtil.trim(ourBank.text).length == 0) 
		{
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.specifyourbank'));
			return false;
		}
		
		if (StringUtil.trim(ourSettleAc.text).length == 0) //
		{
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.specifyourstlaccount'));
			return false;
		}
	}
	
	return true;
}
/* 
 * Validates the Detail Cash-side part. 
 */
private function validateCashSide():Boolean {
    var settleType:String = settleTypeFLD.visible == true? settleTypeFLD.selectedItem.value : settleTypeLBL.text;
	if(settleType=="FREE") { 
	    cashSdVoSettlementInfoStatus = cashSIVOSettlementInfoStatus;
	} else {
	    cashSdVoSettlementInfoStatus = siVOSettlementInfoStatus;
	}

	if(settleType=="AGAINST" && diffCashFlag =="S"){    
		//Skip if SettlementType = AGAINST and DiffCashFlag is set to "S" i.e. same cash.
		return true;
	}
	
	//Validate Counterparty details - skip it for Broker Internal Scenario

	if(isBrokerAccount != "Y" && cashSettlementmode.selectedItem.value != "INTERNAL") {

		if (cashSSILayout == "BONY") {

		} else if (cashSSILayout == "DTC") {

		} else {
			if (StringUtil.trim(cashCpBank.text).length == 0)  
			{
				if(cashSdVoSettlementInfoStatus != "UNKNOWN") {
					XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.specifybank'));
					return false;
				}
			}
			
			if (cashSettlementmode.selectedItem.value == "INTERNAL")
			{
				if (StringUtil.trim(cashCpSettleAc.text).length == 0)
				{
					if(cashSdVoSettlementInfoStatus != "UNKNOWN") {
						XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.specifycpstlaccount'));
						return false;
					}
				}
			}
		}
	}
	
	//Validate Own details
	if(cashSettlementmode.selectedItem.value == "EXTERNAL" || isBrokerAccount == "Y") {
		
		if (StringUtil.trim(cashOurBank.text).length == 0)
		{
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.specifyourbank'));
			return false;
		}
		
		if (StringUtil.trim(cashOurSettleAc.text).length == 0)
		{
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.specifyourstlaccount'));
			return false;
		}
	}
	
	return true;
}
/*
 * Function to populate the respective back-end fields according to the Cash Cp SSI choosen.
 * Skip it for Broker Internal scenario.
 */
private function handleCashAmendment():void {
	
	if(isBrokerAccount != "Y" || cashSettlementmode.selectedItem.value != "INTERNAL") {

		if(cashSSILayout == "DTC") {
		}

		if(cashSSILayout == "BONY") {
			//Beneficiary Name
		}
	}
}
/*
 * Function to populate the respective back-end fields according to the Security Cp SSI choosen.
 * Skip it for Broker Internal scenario.
 */
private function handleSecurityAmendment():void {

	if(isBrokerAccount != "Y" || settlementMode.selectedItem.value != "INTERNAL") { 
		if(secSSILayout == "DTC") {			
		}
		if(secSSILayout == "BONY") {
		}
	}
}
/*
 * If SettlementType = AGAINST and if we select the Security side Counterparty -
 * we populate the Cash side Counterparty details with the Security side Counterparty details.
 */
private function copySecurityCpDetailsToCash():void {
	clearCashCpDetails();
	//Set the SSI Layout of Cash side
	cashSSILayout = secSSILayout;
	cashBeneficiaryName.text = beneficiaryName.text;
	cashFurtherCredit = secSDFurtherCredit;
	
	var value:String = settlementMode.selectedItem.value != null? settlementMode.selectedItem.value:""; 
	if(value != null && value != ""){
	    var index:int =-1;
        for each(var item:Object in (cashSettlementmode.dataProvider as ArrayCollection)){                                       
            if(item.value == value){
                index = (cashSettlementmode.dataProvider as ArrayCollection).getItemIndex(item);        
            }
        }                
        this.cashSettlementmode.selectedIndex = index !=-1 ? index : this.cashSettlementmode.selectedIndex;
	}
	cashPlaceofsettlement.text = placeofsettlement.text;
	cashBrokerBic.text = brokerBic.text;
	cashParticipantId.text = participantId.text;
	cashParticipantId2.text = participantId2.text;

	if(secSSILayout == "BONY") {

	} else if(secSSILayout == "DTC") {

	} else {
		cashCpBank.text = cpBank.text;
		cashCpBankCodeType = cpBankCodeType;
		cashCpSettleAc.text = cpSettleAc.text;
	
		if(this.settlementMode.selectedItem.value == "EXTERNAL") {			
			cashCpSettleAcName1stLine.text = cpSettleAcName1stLine.text;
			cashCpSettleAcName2ndLine.text = cpSettleAcName2ndLine.text;
			cashCpSettleAcName3rdLine.text = cpSettleAcName3rdLine.text;
			cashCpSettleAcName4thLine.text = cpSettleAcName4thLine.text;
			cashCpIntermediaryInfo.text = cpIntermediaryInfo.text;
			cashCpChainIndex = secCpChainIndex;
		}
	}
	onchangeCashStlMode();
}
 
/**
 *	Function to clear the Cash side Counterparty Details block fields.
 */
private function  clearCashCpDetails():void {
	//Clear INTERNATIONAL details
	cashCpBank.text = "";
	cashCpBankCodeType = "";
	cashCpSettleAc.text = "";
	cashCpSettleAcName1stLine.text = "";
	cashCpSettleAcName2ndLine.text = "";
	cashCpSettleAcName3rdLine.text = "";
	cashCpSettleAcName4thLine.text = "";
	cashCpIntermediaryInfo.text = "";
	cashCpChainIndex = "-1";
	
	cashBeneficiaryName.text = "";
	cashFurtherCredit = "";


	cashPlaceofsettlement.text = "";
	cashBrokerBic.text = "";
	cashParticipantId.text = "";
	cashParticipantId2.text = "";

}
private function onchangeInxTransmissionForCash():void{
    if(this.settleTypeFLD.selectedItem.value=="AGAINST")
	{
		if(inxForSuppress.selectedItem.value != inxForNormal.selectedItem.value)
		{
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.nodiffflag'));
			inxForNormal.setFocus();
		}
	}
}