




 
// ActionScript file

import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.XenosStringUtils;

import flash.events.Event;
import flash.events.FocusEvent;

import mx.collections.ArrayCollection;

[Bindable]
private var summaryResult:ArrayCollection = new ArrayCollection;
            
[Bindable]
private var xmlData:XML = new XML();
[Bindable]
private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);

private var clientSettlementInfoPk : String = "";
private var settlementFor : String = "";
private var mode : String = "";

private var keylist:ArrayCollection = new ArrayCollection();
private var receiveContextList:ArrayCollection = new ArrayCollection(); 
private var returnContextList:ArrayCollection = new ArrayCollection();
private var popUpFlag:String = ""; 



/* Extra Hidden Attributes for the Amend manipulation */
private var isSuppressed:String = XenosStringUtils.EMPTY_STR;
private var nonSuppressedSide:String = XenosStringUtils.EMPTY_STR;
private var isBrokerAccount:String = XenosStringUtils.EMPTY_STR;
private var cashSSILayout:String = XenosStringUtils.EMPTY_STR;
private var secSSILayout:String = XenosStringUtils.EMPTY_STR;
private var diffCashFlag:String = XenosStringUtils.EMPTY_STR;
private var cashSdVoSettlementInfoStatus:String = XenosStringUtils.EMPTY_STR; //mapCashSdVO(settlementInfoStatus)
private var cashSIVOSettlementInfoStatus:String = XenosStringUtils.EMPTY_STR;  //cashSettlementInfoVO.settlementInfoStatus
private var siVOSettlementInfoStatus:String = XenosStringUtils.EMPTY_STR;  //settlementInfoVO.settlementInfoStatus
private var secSdVoSettlementInfoStatus:String = XenosStringUtils.EMPTY_STR; //mapSecSdVO(settlementInfoStatus)
private var csiVoSettlementFor:String = XenosStringUtils.EMPTY_STR; //clientSettlementInfoVO.settlementFor
private var secSDetailDeliveryMethod:String = XenosStringUtils.EMPTY_STR; //securityStlDetail.deliveryMethod
private var siVoInventoryAccountPk:String = XenosStringUtils.EMPTY_STR; //settlementInfoVO.inventoryAccountPk
private var cashSiVoInventoryAccountPk:String = XenosStringUtils.EMPTY_STR; //cashSettlementInfoVO.inventoryAccountPk
private var security:String = "SECURITY";
private var cash:String = "CASH";
private var amendConfirmFlag:String = "A";
private var cpListHitCopy:String = "N";
private var isBrokerInternalCase:String = "N";
private var secCpChainIndex:String = XenosStringUtils.EMPTY_STR;
private var secOurChainIndex:String = XenosStringUtils.EMPTY_STR;
private var cashCpChainIndex:String = XenosStringUtils.EMPTY_STR;
private var cashOurChainIndex:String = XenosStringUtils.EMPTY_STR;
private var secSDFurtherCredit:String = XenosStringUtils.EMPTY_STR; //securityStlDetail.furtherCredit
private var cpBankCodeType:String = XenosStringUtils.EMPTY_STR; //securityStlDetail.cpBankCodeType
private var cashFurtherCredit:String = XenosStringUtils.EMPTY_STR; // cashStlDetail.furtherCredit
private var cashCpBankCodeType:String = XenosStringUtils.EMPTY_STR; //   cashStlDetail.cpBankCodeType
private var secCpIntermediaryInfoListName:String ="SEC_CP_INTERMEDIARY_LIST";
private var secOurIntermediaryInfoListName:String ="SEC_OUR_INTERMEDIARY_LIST";
private var cashCpIntermediaryInfoListName:String ="CASH_CP_INTERMEDIARY_LIST";
private var cashOurIntermediaryInfoListName:String ="CASH_OUR_INTERMEDIARY_LIST";

/*     -----------------------------------  */
private var cashButtonstatus : String = "D"; // D- Diff Cash | S - Same Cash | X- none to Show
private var viewType:String ="";

public function loadAll():void {
	parseUrlString();
	super.setXenosEntryControl(new XenosEntry());
	
	if(this.mode == 'amend') {
		initLabel.includeInLayout = false;
		initLabel.visible = false;
   		this.dispatchEvent(new Event('amendEntryInit'));
   		vstack.selectedChild = qry;
   		this.sec_cpSSIPop.addEventListener(FocusEvent.FOCUS_IN,showReturnContext);   		
   		this.cash_cpSSIPop.addEventListener(FocusEvent.FOCUS_IN,showReturnContext);   		
   		this.secOurDetl.addEventListener(FocusEvent.FOCUS_IN,showReturnContext);
   		this.cashOurDetl.addEventListener(FocusEvent.FOCUS_IN,showReturnContext);
 	} else if(this.mode == 'view') {
 		this.dispatchEvent(new Event('cancelEntrySave'));
 		this.printPanel.includeInLayout = true;
 		this.printPanel.visible = true;
 		//TODO
 	}
}
/**
 * Extracts the parameters and set them to some variables for query criteria 
 * from the Module Loader Info.
 */ 
public function parseUrlString():void {
    try {
        // Remove everything before the question mark, including
        // the question mark.
        var myPattern:RegExp = /.*\?/; 
        var s:String = this.loaderInfo.url.toString();
        s = s.replace(myPattern, "");
        // Create an Array of name=value Strings.
        var params:Array = s.split(Globals.AND_SIGN); 
         // Print the params that are in the Array.
        var keyStr:String;
        var valueStr:String;
        var paramObj:Object = params;
      
        // Set the values of the salutation.
        for (var i:int = 0; i < params.length; i++) {
            var tempA:Array = params[i].split("=");  
            if (tempA[0] == "csiPk") {
                clientSettlementInfoPk = tempA[1];
            } else if(tempA[0] == "settlementFor") {
                settlementFor = tempA[1];
            } else if(tempA[0] == "mode") {
                mode = tempA[1];
            }
        }
    } catch (e:Error) {
        trace(e);
    }
}

/**
  * This is the method to access the Collection of data items receive
  * through the context from the account popup. This will be implemented as per specifdic  
  * requriment. 
  */
public function showReturnContext(e:FocusEvent):void {    	

    if(!XenosStringUtils.isBlank(popUpFlag)){
        if(returnContextList.length > 0){
            if(XenosStringUtils.equals(popUpFlag,"CP_SSI_SEC")){
                populateCpSsiFieldsSEC();    
            }else if(XenosStringUtils.equals(popUpFlag,"CP_SSI_CASH")){
                populateCpSsiFieldsCASH();    
            }else if(XenosStringUtils.equals(popUpFlag,"OWN_SSI_SEC")){
                populateOwnSsiFieldsSEC();    
            }else if(XenosStringUtils.equals(popUpFlag,"OWN_SSI_CASH")){
                populateOwnSsiFieldsCASH();    
            }
            
        }
    }
}
private function populateCpSsiFieldsSEC():void {
		
	for (var i:int = 0; i<returnContextList.length; i++) {
        
        var itemObject:HiddenObject;
        
        itemObject = HiddenObject (returnContextList.getItemAt(i));
        
        var propertyName:String   = itemObject.m_propertyName;
        var propertyValues:Array = itemObject.m_propertyValues;
        
        if(propertyName == 'cpListHitCopy') {
            cpListHitCopy = propertyValues.length != 0? propertyValues[0]:"";
        	//populateField(bankCode,propertyValues);
        } else if(propertyName == 'secCpChainIndex') {
            secCpChainIndex = propertyValues.length != 0? propertyValues[0]:"";        	
        } else if(propertyName == 'mapSecSdVO(cpBank)') {
        	populateField(cpBank,propertyValues);        	
        } else if(propertyName == 'mapSecSdVO(cpSettleAc)') {
        	populateField(cpSettleAc,propertyValues);
        }else if(propertyName == 'securityStlDetail.cpExtSettleAccountName1') {
        	populateField(cpSettleAcName1stLine,propertyValues);
        }else if(propertyName == 'securityStlDetail.cpExtSettleAccountName2') {
        	populateField(cpSettleAcName2ndLine,propertyValues);
        }else if(propertyName == 'securityStlDetail.cpExtSettleAccountName3') {
        	populateField(cpSettleAcName3rdLine,propertyValues);
        }else if(propertyName == 'securityStlDetail.cpExtSettleAccountName4') {
        	populateField(cpSettleAcName4thLine,propertyValues);
        }else if(propertyName == 'mapSecSdVO(cpIntermediaryInfo)') {
        	populateField(cpIntermediaryInfo,propertyValues);
        }/*else if(propertyName == 'mapSecSdVO(deliveryInstruction)') {
        	populateField(fullDeliveryInx,propertyValues);
        }*/else if(propertyName == 'mapSecSdVO(beneficiaryName)') {
        	populateField(beneficiaryName,propertyValues);
        }else if(propertyName == 'securityStlDetail.furtherCredit') {
            secSDFurtherCredit = propertyValues.length != 0? propertyValues[0]:"";        	
        }else if(propertyName == 'securityStlDetail.settlementMode') {
        	//populateField(cpSettleAc,propertyValues);
        	var value:String = propertyValues.length != 0? propertyValues[0]:""; 
        	if(value != null && value != ""){
        	    var index:int =-1;
                for each(var item:Object in (settlementMode.dataProvider as ArrayCollection)){                                       
                    if(item.value == value){
                        index = (settlementMode.dataProvider as ArrayCollection).getItemIndex(item);        
                    }
                }                
                this.settlementMode.selectedIndex = index !=-1 ? index : this.settlementMode.selectedIndex;
        	}            
        }else if(propertyName == 'secSSILayout') {
            secSSILayout = propertyValues.length != 0? propertyValues[0]:"";        	
        }else if(propertyName == 'mapSecSdVO(placeOfSettlement)') {
        	populateField(placeofsettlement,propertyValues);
        }else if(propertyName == 'securityStlDetail.participantId') {
        	populateField(participantId,propertyValues);
        }else if(propertyName == 'securityStlDetail.brokerBic') {
        	populateField(brokerBic,propertyValues);
        }else if(propertyName == 'securityStlDetail.cpBankCodeType') {
            cpBankCodeType = propertyValues.length != 0? propertyValues[0]:"";        	
        }else if(propertyName == 'securityStlDetail.participantId2') {
        	populateField(participantId2,propertyValues);
        }
    }
    returnContextList.removeAll();
    
    //changes needed after opening the popup
	if(amendConfirmFlag == "A" && cpListHitCopy == "Y") {
		onchangeSecStlMode();		
		settlementMode.enabled = false;		
	}
	//If SettlementType = "AGAINST" and the Cp List is hit - we copy the Security side Counterparty details to the Cash side Counterparty details
	if(settleTypeLBL.text == "AGAINST" && cpListHitCopy == "Y") {
		copySecurityCpDetailsToCash();
	}
	//Reset the cpListHitCopy flag.
	cpListHitCopy = "N";
}
private function populateOwnSsiFieldsSEC():void {
		
	for (var i:int = 0; i<returnContextList.length; i++) {
        
        var itemObject:HiddenObject;
        
        itemObject = HiddenObject (returnContextList.getItemAt(i));
        
        var propertyName:String   = itemObject.m_propertyName;
        var propertyValues:Array = itemObject.m_propertyValues;
        
        if(propertyName == 'secOurChainIndex') {
            secOurChainIndex = propertyValues.length != 0? propertyValues[0]:"";
        	//populateField(bankCode,propertyValues);
        } else if(propertyName == 'mapSecSdVO(ourBank)') {
            ourBank.text = propertyValues.length != 0? propertyValues[0]:"";        	
        } else if(propertyName == 'mapSecSdVO(ourSettleAc)') {
            ourSettleAc.text = propertyValues.length != 0? propertyValues[0]:"";        	
        } else if(propertyName == 'mapSecSdVO(ourIntermediaryInfo)') {
            ourIntermediaryInfo.text = propertyValues.length != 0? propertyValues[0]:"";        	
        }
    }
    returnContextList.removeAll();
}
private function populateCpSsiFieldsCASH():void{
    for (var i:int = 0; i<returnContextList.length; i++) {
        
        var itemObject:HiddenObject;
        
        itemObject = HiddenObject (returnContextList.getItemAt(i));
        
        var propertyName:String   = itemObject.m_propertyName;
        var propertyValues:Array = itemObject.m_propertyValues;
        
        if(propertyName == 'cpListHitCopy') {
            cpListHitCopy = propertyValues.length != 0? propertyValues[0]:"";
        	//populateField(bankCode,propertyValues);
        } else if(propertyName == 'cashCpChainIndex') {
            cashCpChainIndex = propertyValues.length != 0? propertyValues[0]:"";
        } else if(propertyName == 'mapCashSdVO(cpBank)') {
        	populateField(cashCpBank,propertyValues);        	
        } else if(propertyName == 'mapCashSdVO(cpSettleAc)') {
        	populateField(cashCpSettleAc,propertyValues);
        }else if(propertyName == 'cashStlDetail.cpExtSettleAccountName1') {
        	populateField(cashCpSettleAcName1stLine,propertyValues);
        }else if(propertyName == 'cashStlDetail.cpExtSettleAccountName2') {
        	populateField(cashCpSettleAcName2ndLine,propertyValues);
        }else if(propertyName == 'cashStlDetail.cpExtSettleAccountName3') {
        	populateField(cashCpSettleAcName3rdLine,propertyValues);
        }else if(propertyName == 'cashStlDetail.cpExtSettleAccountName4') {
        	populateField(cashCpSettleAcName4thLine,propertyValues);
        }else if(propertyName == 'mapCashSdVO(cpIntermediaryInfo)') {
        	populateField(cashCpIntermediaryInfo,propertyValues);
        }/*else if(propertyName == 'mapCashSdVO(deliveryInstruction)') {
        	populateField(cashFullDeliveryInx,propertyValues);
        }*/else if(propertyName == 'mapCashSdVO(beneficiaryName)') {
        	populateField(cashBeneficiaryName,propertyValues);
        }else if(propertyName == 'cashStlDetail.furtherCredit') {
            cashFurtherCredit = propertyValues.length != 0? propertyValues[0]:"";        	
        }else if(propertyName == 'cashStlDetail.settlementMode') {
        	//populateField(cpSettleAc,propertyValues);
        	var value:String = propertyValues.length != 0? propertyValues[0]:""; 
        	if(value != null && value != ""){
        	    var index:int =-1;
                for each(var item:Object in (cashSettlementmode.dataProvider as ArrayCollection)){                                       
                    if(item.value == value){
                        index = (cashSettlementmode.dataProvider as ArrayCollection).getItemIndex(item);        
                    }
                }                
                this.cashSettlementmode.selectedIndex = index !=-1 ? index : this.cashSettlementmode.selectedIndex;
        	}         	
        }else if(propertyName == 'cashSSILayout') {
            cashSSILayout = propertyValues.length != 0? propertyValues[0]:"";        	
        }else if(propertyName == 'mapCashSdVO(placeOfSettlement)') {
        	populateField(cashPlaceofsettlement,propertyValues);
        }else if(propertyName == 'cashStlDetail.participantId') {
        	populateField(cashParticipantId,propertyValues);
        }else if(propertyName == 'cashStlDetail.brokerBic') {
        	populateField(cashBrokerBic,propertyValues);
        }else if(propertyName == 'cashStlDetail.cpBankCodeType') {
            cashCpBankCodeType = propertyValues.length != 0? propertyValues[0]:"";        	
        }else if(propertyName == 'cashStlDetail.participantId2') {
        	populateField(cashParticipantId2,propertyValues);
        }
    }
    returnContextList.removeAll();
    
    // Post operations of the popup close
    //In case of Amendment:disable the settlement Mode field and clear Our Details
	if(amendConfirmFlag == "A" && cpListHitCopy == "Y") {
		onchangeCashStlMode();
		cashSettlementmode.enabled = false;		
	}
	//Reset the cpListHitCopy flag.
	cpListHitCopy = "N";
}
private function populateOwnSsiFieldsCASH():void{
    for (var i:int = 0; i<returnContextList.length; i++) {
        
        var itemObject:HiddenObject;
        
        itemObject = HiddenObject (returnContextList.getItemAt(i));
        
        var propertyName:String   = itemObject.m_propertyName;
        var propertyValues:Array = itemObject.m_propertyValues;
        
        if(propertyName == 'cashOurChainIndex') {
            cashOurChainIndex = propertyValues.length != 0? propertyValues[0]:"";
        	//populateField(bankCode,propertyValues);
        } else if(propertyName == 'mapCashSdVO(ourBank)') {
            cashOurBank.text = propertyValues.length != 0? propertyValues[0]:"";             
        } else if(propertyName == 'mapCashSdVO(ourSettleAc)') {
            cashOurSettleAc.text = propertyValues.length != 0? propertyValues[0]:"";        	
        } else if(propertyName == 'mapCashSdVO(ourIntermediaryInfo)') {
            cashOurIntermediaryInfo.text = propertyValues.length != 0? propertyValues[0]:"";        	
        }
    }
    returnContextList.removeAll();
}
private function populateField(obj:Object,propValues:Array):void {
	if(obj!=null) {
		for (var j:int = 0; j<propValues.length; j++) {
	        if(obj.id.search('Label')> -1 ) {
	        	obj.text =  "("+propValues[j]+")";
	        } else {
	        	obj.text =  propValues[j];
	        }
	    }
	}
}
/* Amend Action */

override public function preAmendInit():void{    
	super.getInitHttpService().url = "stl/stlAmendmentDispatch.action?rnd="+Math.random();
	var reqObject:Object = new Object();	
	reqObject.method = "doEdit";
  	reqObject.csiPk = this.clientSettlementInfoPk;
  	reqObject.settlementFor = this.settlementFor;
  	reqObject.SCREEN_KEY = 360;
  	super.getInitHttpService().request = reqObject;
}
override public function preCancel():void{                
    this.back.includeInLayout = false;
    this.back.visible = false;
    this.buttonPanel.includeInLayout = false;
    this.buttonPanel.visible = false;
    
    changeCurrentState();                              
    super._validator = null;
    super.getSaveHttpService().url = "stl/stlAmendmentDispatch.action?rnd=" + Math.random();
    var reqObject:Object = new Object();    
    reqObject.method= "doView";
    reqObject.csiPk = this.clientSettlementInfoPk;
  	reqObject.settlementFor = this.settlementFor;        
    super.getSaveHttpService().request = reqObject;
}

override public function preResetAmend(): void {
	super.getResetHttpService().url = "stl/stlAmendmentDispatch.action?rnd="+Math.random();
	
	var reqObject:Object = new Object();	
	reqObject.method = "doEdit";
  	reqObject.csiPk = this.clientSettlementInfoPk;
  	reqObject.settlementFor = this.settlementFor;
  	reqObject.SCREEN_KEY = 360;
	
	super.getResetHttpService().request = reqObject;
}
override public function preAmendConfirm():void {
    var reqObj :Object = new Object();
    this.uConfSubmit.enabled = false;
    
    super.getConfHttpService().url = "stl/stlAmendmentDispatch.action?rnd="+Math.random();  
    reqObj.method= "doConfirm";
    reqObj.SCREEN_KEY = 362;    
    super.getConfHttpService().request = reqObj;
}
override public function preConfirmAmendResultHandler():Object
{
    addCommonResultKes();     
    return keylist;
}
override public function preCancelResultHandler():Object{
    addCommonResultKes();             
    return keylist;
}
          
override public function preAmendResultInit():Object {	
	if(this.parentDocument.owner.errPageResultSummary != null) {
		this.parentDocument.owner.errPageResultSummary.removeError();
	}
	if(this.parentDocument.owner.errPageResultSummaryPending != null) {
		this.parentDocument.owner.errPageResultSummaryPending.removeError();
	}
	return addCommonResultKes();
	
} 
private function addCommonResultKes():Object{
    //key define
	keylist = new ArrayCollection();
	
	keylist.addItem("clientSettlementInfoVO.settlementReferenceNo");
	keylist.addItem("clientSettlementInfoVO.versionNo");
	keylist.addItem("settlementInfoVO.otherAttributes.entry");	
	keylist.addItem("clientSettlementInfoVO.otherAttributes.entry");
	keylist.addItem("dropDownListValues.settlementTypeList.item");
	keylist.addItem("clientSettlementInfoVO.settlementType");
	keylist.addItem("settlementInfoVO.settlementInfoStatus");
	keylist.addItem("settlementInfoVO.settlementStatus");
	keylist.addItem("securityStlDetail.otherAttributes.entry");
	keylist.addItem("securityStlDetail.bondTaxExemption");
	keylist.addItem("securityStlDetail.deliveryMethod");
	keylist.addItem("securityStlDetail.settlementMode"); //11
	keylist.addItem("dropDownListValues.settlementModeList.item");
	keylist.addItem("settlementInfoVO.transmissionReqdFlag"); 
	keylist.addItem("dropDownListValues.inxTransmissionList.item");
	keylist.addItem("securityStlDetail.cpExtSettleAccountName1");
	keylist.addItem("securityStlDetail.cpExtSettleAccountName2");
	keylist.addItem("securityStlDetail.cpExtSettleAccountName3");
	keylist.addItem("securityStlDetail.cpExtSettleAccountName4");
	keylist.addItem("securityStlDetail.brokerBic");
	keylist.addItem("securityStlDetail.participantId");
	keylist.addItem("securityStlDetail.participantId2"); //21
	keylist.addItem("securityStlDetail.description");
	
	keylist.addItem("cashStlDetail.otherAttributes.entry");
	keylist.addItem("cashStlDetail.wayOfPayment");
	keylist.addItem("dropDownListValues.wayOfPaymentList.item");
	keylist.addItem("cashStlDetail.settlementMode");
	keylist.addItem("cashSettlementInfoVO.transmissionReqdFlag");
	keylist.addItem("cashStlDetail.cpExtSettleAccountName1");
	keylist.addItem("cashStlDetail.cpExtSettleAccountName2");
	keylist.addItem("cashStlDetail.cpExtSettleAccountName3");
	keylist.addItem("cashStlDetail.cpExtSettleAccountName4");//31
	keylist.addItem("cashStlDetail.brokerBic");
	keylist.addItem("cashStlDetail.participantId");
	keylist.addItem("cashStlDetail.participantId2");
	keylist.addItem("cashStlDetail.description");
	
	/* Extra for hidden field population */
	keylist.addItem("isSuppressed"); //36
	keylist.addItem("nonSuppressedSide");
	keylist.addItem("isBrokerAccount");
	keylist.addItem("cashSSILayout");
	keylist.addItem("secSSILayout");
	keylist.addItem("diffCashFlag");//41
	keylist.addItem("cashSettlementInfoVO.settlementInfoStatus");
	keylist.addItem('clientSettlementInfoVO.settlementFor');
	keylist.addItem('settlementInfoVO.inventoryAccountPk');
	keylist.addItem('cashSettlementInfoVO.inventoryAccountPk');
	keylist.addItem('secCpChainIndex');
	keylist.addItem('secOurChainIndex');
	keylist.addItem('cashCpChainIndex');
	keylist.addItem('cashOurChainIndex');
	keylist.addItem('securityStlDetail.furtherCredit');
	keylist.addItem('securityStlDetail.cpBankCodeType');//51
	keylist.addItem('cashStlDetail.furtherCredit');
	keylist.addItem('cashStlDetail.cpBankCodeType');
	keylist.addItem('viewType');
	keylist.addItem('Errors.error');
	
	return keylist;
}
override public function postAmendResultInit(mapObj:Object): void {
	
	if(mapObj!=null) {
		var errorArrCol:ArrayCollection = mapObj["Errors.error"] as ArrayCollection;
		if(errorArrCol.length>0) {
			this.parentDocument.owner.errPageResultSummary.showError(errorArrCol);
            this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
			return;
		} else {
			//U get the xml from Server and then accordingly populate
			commonAmendResult(mapObj);
			this.parentDocument.title =this.parentApplication.xResourceManager.getKeyValue('stl.amendment.title.securitytrade');
			app.submitButtonInstance = submit;
			submit.setFocus();
		}
	}	
}

private function commonAmendResult(mapObj:Object):void{
        
    var initcol:ArrayCollection;
    var index:int=0;
    var mapSecSiVOColl:ArrayCollection;
    var mapCsiVOColl:ArrayCollection;
    var mapSecSdVOColl:ArrayCollection;
    var mapCashSdVOColl:ArrayCollection;
                
    errPage.clearError(super.getInitResultEvent());
    
    mapSecSiVOColl = mapObj[keylist.getItemAt(2)] as ArrayCollection;
    mapCsiVOColl = mapObj[keylist.getItemAt(3)] as ArrayCollection;
    mapSecSdVOColl = mapObj[keylist.getItemAt(8)] as ArrayCollection;
    mapCashSdVOColl = mapObj[keylist.getItemAt(23)] as ArrayCollection;
    
    /* Populating the header part */
    this.tradeRefNo.text = mapObj[keylist.getItemAt(0)].toString() + "-" + mapObj[keylist.getItemAt(1)].toString();
    this.tradingAccount.text = getVoAttbValue(mapSecSiVOColl,"tradingAc");
    this.tradingAcName.text = getVoAttbValue(mapSecSiVOColl,"tradingAcName");
    //this.accountBalanceType.text = getVoAttbValue(mapCsiVOColl,"accountBalanceTypeDispStr");
    this.tradedate.text = getVoAttbValue(mapCsiVOColl,"tradeDate");
    this.valuedate.text = getVoAttbValue(mapSecSiVOColl,"valueDate");
    
    initcol = new ArrayCollection();
    index=-1;
    for each(var item:Object in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
        initcol.addItem(item);
                
        if(item.value == mapObj[keylist.getItemAt(5)].toString()){
            index = (mapObj[keylist.getItemAt(4)] as ArrayCollection).getItemIndex(item);        
        }
    }
    this.settleTypeFLD.dataProvider = initcol;
    this.settleTypeFLD.selectedIndex = index !=-1 ? index : 0;
    this.settleTypeLBL.text = mapObj[keylist.getItemAt(5)].toString();
    
    this.price.text = getVoAttbValue(mapCsiVOColl,"price");
    this.stlInfoStatus.text = mapObj[keylist.getItemAt(6)].toString();
    this.stlStatus.text = mapObj[keylist.getItemAt(7)].toString();
    /* header part complete */
    
    /* Start the Security Side */
    this.securityCode.text = getVoAttbValue(mapSecSdVOColl,"securityCode");
    this.securityName.text = getVoAttbValue(mapSecSdVOColl,"securityName");
    this.quantity.text = getVoAttbValue(mapSecSdVOColl,"quantity");
    this.bondTaxExemption.text = mapObj[keylist.getItemAt(9)].toString();
    this.deliverReceive.text = getVoAttbValue(mapSecSdVOColl,"deliverReceive");
    this.form.text = mapObj[keylist.getItemAt(10)].toString();
    
    initcol = new ArrayCollection();
    index=-1;
    for each(item in (mapObj[keylist.getItemAt(12)] as ArrayCollection)){
        initcol.addItem(item);
                
        if(item.value == mapObj[keylist.getItemAt(11)].toString()){
            index = (mapObj[keylist.getItemAt(12)] as ArrayCollection).getItemIndex(item);        
        }
    }
    this.settlementMode.dataProvider = initcol;
    this.settlementMode.selectedIndex = index !=-1 ? index : 0;
    
    initcol = new ArrayCollection();
    index=-1;
    for each(item in (mapObj[keylist.getItemAt(14)] as ArrayCollection)){
        initcol.addItem(item);
                
        if(item.value == mapObj[keylist.getItemAt(13)].toString()){
            index = (mapObj[keylist.getItemAt(14)] as ArrayCollection).getItemIndex(item);        
        }
    }
    this.inxTransmission.dataProvider = initcol;
    this.inxTransmission.selectedIndex = index !=-1 ? index : 0;
    
    this.cpBank.text = getVoAttbValue(mapSecSdVOColl,"cpBank");
    this.cpSettleAc.text = getVoAttbValue(mapSecSdVOColl,"cpSettleAc");
    this.cpSettleAcName1stLine.text = mapObj[keylist.getItemAt(15)].toString();
    this.cpSettleAcName2ndLine.text = mapObj[keylist.getItemAt(16)].toString();
    this.cpSettleAcName3rdLine.text = mapObj[keylist.getItemAt(17)].toString();
    this.cpSettleAcName4thLine.text = mapObj[keylist.getItemAt(18)].toString();
    this.cpIntermediaryInfo.text = getVoAttbValue(mapSecSdVOColl,"cpIntermediaryInfo");
//    this.fullDeliveryInx.text = getVoAttbValue(mapSecSdVOColl,"deliveryInstruction");
    this.beneficiaryName.text = getVoAttbValue(mapSecSdVOColl,"beneficiaryName");
    this.placeofsettlement.text = getVoAttbValue(mapSecSdVOColl,"placeOfSettlement");
    this.brokerBic.text = mapObj[keylist.getItemAt(19)].toString();
    this.participantId.text = mapObj[keylist.getItemAt(20)].toString();
    this.participantId2.text = mapObj[keylist.getItemAt(21)].toString();
    
    this.ourBank.text = getVoAttbValue(mapSecSdVOColl,"ourBank");
    this.ourSettleAc.text = getVoAttbValue(mapSecSdVOColl,"ourSettleAc");
    this.ourIntermediaryInfo.text = getVoAttbValue(mapSecSdVOColl,"ourIntermediaryInfo");
    this.ourSettleAc.text = getVoAttbValue(mapSecSdVOColl,"ourSettleAc");
    this.description.text = mapObj[keylist.getItemAt(22)].toString();
    
    /* End Security Side */
    
    /* Start the Cash Side */
    
    this.settlementCcy.text = getVoAttbValue(mapCashSdVOColl,"settlementCcy");
    this.netamount.text = getVoAttbValue(mapCashSdVOColl,"amount");
    this.paymentReceive.text = getVoAttbValue(mapCashSdVOColl,"deliverReceive");
    
    initcol = new ArrayCollection();
    initcol.addItem({label:" ", value: " "});
    index=-1;
    for each(item in (mapObj[keylist.getItemAt(25)] as ArrayCollection)){
        initcol.addItem(item);
                
        if(item.value == mapObj[keylist.getItemAt(24)].toString()){
            index = (mapObj[keylist.getItemAt(25)] as ArrayCollection).getItemIndex(item);        
        }
    }
    this.wayofpayment.dataProvider = initcol;
    this.wayofpayment.selectedIndex = index !=-1 ? index+1 : 0;
    
    initcol = new ArrayCollection();    
    index=-1;
    for each(item in (mapObj[keylist.getItemAt(12)] as ArrayCollection)){
        initcol.addItem(item);
                
        if(item.value == mapObj[keylist.getItemAt(26)].toString()){
            index = (mapObj[keylist.getItemAt(12)] as ArrayCollection).getItemIndex(item);        
        }
    }
    this.cashSettlementmode.dataProvider = initcol;
    this.cashSettlementmode.selectedIndex = index !=-1 ? index : 0;
    
    initcol = new ArrayCollection();    
    index=-1;
    for each(item in (mapObj[keylist.getItemAt(14)] as ArrayCollection)){
        initcol.addItem(item);
                
        if(item.value == mapObj[keylist.getItemAt(27)].toString()){
            index = (mapObj[keylist.getItemAt(14)] as ArrayCollection).getItemIndex(item);        
        }
    }
    this.inxForNormal.dataProvider = initcol;
    this.inxForNormal.selectedIndex = index !=-1 ? index : 0;
    
    initcol = new ArrayCollection();    
    index=-1;
    for each(item in (mapObj[keylist.getItemAt(14)] as ArrayCollection)){
        initcol.addItem(item);
                
        if(item.value == mapObj[keylist.getItemAt(13)].toString()){
            index = (mapObj[keylist.getItemAt(14)] as ArrayCollection).getItemIndex(item);        
        }
    }
    this.inxForSuppress.dataProvider = initcol;
    this.inxForSuppress.selectedIndex = index !=-1 ? index : 0;
    
    
    this.cashCpBank.text = getVoAttbValue(mapCashSdVOColl,"cpBank");
    this.cashCpSettleAc.text = getVoAttbValue(mapCashSdVOColl,"cpSettleAc");
    this.cashCpSettleAcName1stLine.text = mapObj[keylist.getItemAt(28)].toString();
    this.cashCpSettleAcName2ndLine.text = mapObj[keylist.getItemAt(29)].toString();
    this.cashCpSettleAcName3rdLine.text = mapObj[keylist.getItemAt(30)].toString();
    this.cashCpSettleAcName4thLine.text = mapObj[keylist.getItemAt(31)].toString();
    this.cashCpIntermediaryInfo.text = getVoAttbValue(mapCashSdVOColl,"cpIntermediaryInfo");
//    this.cashFullDeliveryInx.text = getVoAttbValue(mapCashSdVOColl,"deliveryInstruction");
    this.cashBeneficiaryName.text = getVoAttbValue(mapCashSdVOColl,"beneficiaryName");
    this.cashPlaceofsettlement.text = getVoAttbValue(mapCashSdVOColl,"placeOfSettlement");
    this.cashBrokerBic.text = mapObj[keylist.getItemAt(32)].toString();
    this.cashParticipantId.text = mapObj[keylist.getItemAt(33)].toString();
    this.cashParticipantId2.text = mapObj[keylist.getItemAt(34)].toString();
    
    this.cashOurBank.text = getVoAttbValue(mapCashSdVOColl,"ourBank");
    this.cashOurSettleAc.text = getVoAttbValue(mapCashSdVOColl,"ourSettleAc");
    this.cashOurIntermediaryInfo.text = getVoAttbValue(mapCashSdVOColl,"ourIntermediaryInfo");
    this.cashDescription.text = mapObj[keylist.getItemAt(35)].toString();
    
    /* End the Cash Side */
    /* Populate Hidden Fields */
    populateHiddenFields(mapObj);
    
    cashSdVoSettlementInfoStatus = getVoAttbValue(mapCashSdVOColl,"settlementInfoStatus");
    secSdVoSettlementInfoStatus = getVoAttbValue(mapSecSdVOColl,"settlementInfoStatus");
    /* End Populating Hidden Fields */
    
    //Modify the Layout as desired by the data of the settlement record
    showDetail();
}            
private function populateHiddenFields(mapObj:Object):void{
    isSuppressed = mapObj[keylist.getItemAt(36)].toString();
    nonSuppressedSide = mapObj[keylist.getItemAt(37)].toString();
    isBrokerAccount = mapObj[keylist.getItemAt(38)].toString();
    cashSSILayout = mapObj[keylist.getItemAt(39)].toString();
    secSSILayout = mapObj[keylist.getItemAt(40)].toString();
    diffCashFlag = mapObj[keylist.getItemAt(41)].toString();
    cashSIVOSettlementInfoStatus = mapObj[keylist.getItemAt(42)].toString();
    siVOSettlementInfoStatus = mapObj[keylist.getItemAt(6)].toString();
    csiVoSettlementFor = mapObj[keylist.getItemAt(43)].toString();
    secSDetailDeliveryMethod = mapObj[keylist.getItemAt(10)].toString();
    siVoInventoryAccountPk = mapObj[keylist.getItemAt(44)].toString();
    cashSiVoInventoryAccountPk = mapObj[keylist.getItemAt(45)].toString();
    secCpChainIndex = mapObj[keylist.getItemAt(46)].toString();
    secOurChainIndex = mapObj[keylist.getItemAt(47)].toString();
    cashCpChainIndex = mapObj[keylist.getItemAt(48)].toString();
    cashOurChainIndex = mapObj[keylist.getItemAt(49)].toString();
    secSDFurtherCredit = mapObj[keylist.getItemAt(50)].toString();
    cpBankCodeType = mapObj[keylist.getItemAt(51)].toString();
    cashFurtherCredit = mapObj[keylist.getItemAt(52)].toString();
    cashCpBankCodeType = mapObj[keylist.getItemAt(53)].toString();
    
    
}
override public function preAmend(): void {
	//TODO
//	setValidator();
    super.getSaveHttpService().url = "stl/stlAmendmentDispatch.action?rnd="+Math.random();  
     
    var reqObj : Object = populateRequestForAmend();

    super.getSaveHttpService().method = "POST";
    super.getSaveHttpService().request = reqObj;
}
override public function preAmendResultHandler():Object{
    //addCommonResultKes();
    return keylist
}
override public function postAmendResultHandler(mapObj:Object):void
{        
    commonResult(mapObj);
    
    if(!errPage.isError()){
        this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('stl.amendment.title.securitytrade')+ " - "+ this.parentApplication.xResourceManager.getKeyValue('stl.message.userconfirmation');
        app.submitButtonInstance = uConfSubmit;
        uConfSubmit.enabled = true;
        uConfSubmit.setFocus();
    }
    
}
override public function postConfirmAmendResultHandler(mapObj:Object):void
{
    submitUserConfResult(mapObj);
    if(mapObj != null && mapObj["errorFlag"].toString() != "error"){
        this.parentDocument.title =this.parentApplication.xResourceManager.getKeyValue('stl.amendment.title.securitytrade')+ " - "+ this.parentApplication.xResourceManager.getKeyValue('stl.message.sysconfirmation');
        this.uConfSubmit.enabled = true;        
    }
}
override public function postCancelResultHandler(mapObj:Object): void{
    commonResult(mapObj);    
    if(!errPage.isError())
        this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('stl.amendment.view.title.securitytrade');
    
    //uConfLabel.text="Market Price Cancel";
    uConfSubmit.includeInLayout = false;
    uConfSubmit.visible = false;
    cancelSubmit.visible = false;
    cancelSubmit.includeInLayout = false;
        
    //app.submitButtonInstance = cancelSubmit;
    //this.cancelSubmit.setFocus();
}
override public function doAmendSystemConfirm(e:Event):void
{   
    this.sConfSubmit.enabled = false;
    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
}
private function commonResult(mapObj:Object):void{
    if(mapObj!=null){            
        if(mapObj["errorFlag"].toString() == "error"){
            //result = mapObj["errorMsg"] .toString();
            if(mode != "cancel"){
              errPage.showError(mapObj["errorMsg"]);                        
            }else{
                errPage.showError(mapObj["errorMsg"]);
                //XenosAlert.error(mapObj["errorMsg"]);
            }
        }else if(mapObj["errorFlag"].toString() == "noError"){
            
         errPage.clearError(super.getSaveResultEvent());                            
         commonResultPart(mapObj);
         changeCurrentState();
         
         //app.submitButtonInstance = uConfSubmit;
         uConfSubmit.setFocus();
            
        }else{
            errPage.removeError();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }            
    }
}
/**
 * This method is used to get value from the map VO 
 * w.r.t. the given key
 */ 
public function getVoAttbValue(attbList:ArrayCollection, attbKey:String):String {
	var attbValue:String = "";
	if(null != attbList){		
		for(var i:int = 0; i<attbList.length; i++){
			var temp:String = XML(attbList.getItemAt(i)).attribute("key");
			if(XenosStringUtils.equals(temp,attbKey)){
				attbValue = attbList[i].value;
				break;
			}
		}					
	}	
	return attbValue;
}

private function populateRequestForAmend():Object {
    var reqObj:Object = new Object();
//    XenosAlert.info("Populating request");
    reqObj['method']= "doSubmit";
    reqObj['SCREEN_KEY'] = 361;
    
    reqObj['diffCashFlag'] = diffCashFlag;
    reqObj['isSuppressed'] = isSuppressed;
    reqObj['nonSuppressedSide'] = nonSuppressedSide;
    reqObj['isBrokerAccount'] = isBrokerAccount;
    reqObj['clientSettlementInfoVO.settlementFor'] = csiVoSettlementFor;
    reqObj['settlementInfoVO.settlementInfoStatus'] = siVOSettlementInfoStatus;
    reqObj['cashSettlementInfoVO.settlementInfoStatus'] = cashSIVOSettlementInfoStatus;
    reqObj['securityStlDetail.deliveryMethod'] = secSDetailDeliveryMethod;
    reqObj['settlementInfoVO.inventoryAccountPk'] = siVoInventoryAccountPk;
    reqObj['cashSettlementInfoVO.inventoryAccountPk'] = cashSiVoInventoryAccountPk;
    reqObj['security'] = security;
    reqObj['cash'] = cash;
    reqObj['amendConfirmFlag'] = amendConfirmFlag;
    reqObj['cpListHitCopy'] = cpListHitCopy;
    reqObj['isBrokerInternalCase'] = isBrokerInternalCase;
    reqObj['secCpChainIndex'] = secCpChainIndex;
    reqObj['secOurChainIndex'] = secOurChainIndex;
    reqObj['cashCpChainIndex'] = cashCpChainIndex;
    reqObj['cashOurChainIndex'] = cashOurChainIndex;
//    reqObj['actTypeContext'] = S%7CB
//    reqObj['cpTypeContext'] = CLIENT%7CINTERNAL
//    reqObj['cpTypeContextOwn'] = BROKER%7CINTERNAL
    reqObj['secSSILayout'] = secSSILayout;
    reqObj['cashSSILayout'] = cashSSILayout
//    reqObj['securityStlDetail.dtcInstitutionName'] = 
//    reqObj['securityStlDetail.dtcAgentName'] = 
//    reqObj['securityStlDetail.dtcParticipantName'] = 
    reqObj['securityStlDetail.furtherCredit'] = secSDFurtherCredit;
    reqObj['securityStlDetail.cpBankCodeType'] = cpBankCodeType;
//    reqObj['mapSecSdVO(beneficiaryNameBony)'] = 
//    reqObj['mapSecSdVO(beneficiaryNameDtc)'] = 
    reqObj['mapSecSdVO(settlementInfoStatus)'] = secSdVoSettlementInfoStatus;
//    reqObj['cashStlDetail.dtcInstitutionName'] = 
//    reqObj['cashStlDetail.dtcAgentName'] = 
//    reqObj['cashStlDetail.dtcParticipantName'] = 
    reqObj['cashStlDetail.furtherCredit'] = cashFurtherCredit;
    reqObj['cashStlDetail.cpBankCodeType'] = cashCpBankCodeType;
//    reqObj['mapCashSdVO(contraId)'] = 
//    reqObj['mapCashSdVO(beneficiaryNameBony)'] = 
//    reqObj['mapCashSdVO(beneficiaryNameDtc)'] = 
    reqObj['mapCashSdVO(settlementInfoStatus)'] = cashSdVoSettlementInfoStatus;
//    reqObj['mapSecSdVO(contraId)'] = 
//    reqObj['securityStlDetail.dtcInstitutionId'] = 
//    reqObj['securityStlDetail.dtcAgentId'] = 
//    reqObj['securityStlDetail.dtcAgentAccountNo'] = 
//    reqObj['securityStlDetail.dtcParticipantId'] = 
//    reqObj['mapCashSdVO(contraId)'] = 
//    reqObj['cashStlDetail.dtcInstitutionId'] = 
//    reqObj['cashStlDetail.dtcAgentId'] = 
//    reqObj['cashStlDetail.dtcAgentAccountNo'] = 
//    reqObj['cashStlDetail.dtcParticipantId'] = 
    reqObj['mapSecSiVO(tradingAc)'] = tradingAccount.text;
    reqObj['mapSecSiVO(tradingAcName)'] = tradingAcName.text;
    //reqObj['mapCsiVO(accountBalanceTypeDispStr)'] = accountBalanceType.text;
    reqObj['mapCsiVO(tradeDate)'] = tradedate.text;
    reqObj['mapSecSiVO(valueDate)'] = valuedate.text;
    reqObj['clientSettlementInfoVO.settlementType'] = this.settleTypeFLD.selectedItem.value != null ? this.settleTypeFLD.selectedItem.value : "";
    reqObj['mapCsiVO(price)'] = price.text;
    reqObj['mapSecSdVO(securityCode)'] = securityCode.text;
    reqObj['mapSecSdVO(securityName)'] = securityName.text;
    reqObj['mapSecSdVO(quantity)'] = quantity.text;
    reqObj['mapSecSdVO(deliverReceive)'] = deliverReceive.text;
    reqObj['securityStlDetail.settlementMode'] = this.settlementMode.selectedItem.value != null ? this.settlementMode.selectedItem.value : "";
    if(inxForSuppress.includeInLayout == true){ // the value of inxTransmission needs to be sent on high priority basis.     
        reqObj['settlementInfoVO.transmissionReqdFlag'] = this.inxForSuppress.selectedItem.value != null ? this.inxForSuppress.selectedItem.value : "";
    }    
    reqObj['settlementInfoVO.transmissionReqdFlag'] = this.inxTransmission.selectedItem.value != null ? this.inxTransmission.selectedItem.value : "";
    reqObj['mapSecSdVO(cpBank)'] = cpBank.text;
    reqObj['mapSecSdVO(cpSettleAc)'] = cpSettleAc.text;
    reqObj['securityStlDetail.cpExtSettleAccountName1'] = cpSettleAcName1stLine.text;
    reqObj['securityStlDetail.cpExtSettleAccountName2'] = cpSettleAcName2ndLine.text;
    reqObj['securityStlDetail.cpExtSettleAccountName3'] = cpSettleAcName3rdLine.text;
    reqObj['securityStlDetail.cpExtSettleAccountName4'] = cpSettleAcName4thLine.text;
    reqObj['mapSecSdVO(cpIntermediaryInfo)'] = cpIntermediaryInfo.text;
//    reqObj['mapSecSdVO(deliveryInstruction)'] = fullDeliveryInx.text;
    reqObj['mapSecSdVO(beneficiaryName)'] = beneficiaryName.text;
    reqObj['mapSecSdVO(placeOfSettlement)'] = placeofsettlement.text;
    reqObj['securityStlDetail.brokerBic'] = brokerBic.text;
    reqObj['securityStlDetail.participantId'] = participantId.text;
    reqObj['securityStlDetail.participantId2'] = participantId2.text;
    reqObj['mapSecSdVO(ourBank)'] = ourBank.text;
    reqObj['mapSecSdVO(ourSettleAc)'] = ourSettleAc.text;
    reqObj['mapSecSdVO(ourIntermediaryInfo)'] = ourIntermediaryInfo.text;
    reqObj['securityStlDetail.description'] = description.text;
    reqObj['mapCashSdVO(settlementCcy)'] = settlementCcy.text;
    reqObj['mapCashSdVO(amount)'] = netamount.text;
    reqObj['mapCashSdVO(deliverReceive)'] = paymentReceive.text;
    reqObj['cashStlDetail.wayOfPayment'] = this.wayofpayment.selectedItem.value != null ? this.wayofpayment.selectedItem.value : "";
    reqObj['cashStlDetail.settlementMode'] = this.cashSettlementmode.selectedItem.value != null ? this.cashSettlementmode.selectedItem.value : "";
    
    reqObj['cashSettlementInfoVO.transmissionReqdFlag'] = this.inxForNormal.selectedItem.value != null ? this.inxForNormal.selectedItem.value : "";
    reqObj['mapCashSdVO(cpBank)'] = cashCpBank.text;
    reqObj['mapCashSdVO(cpSettleAc)'] = cashCpSettleAc.text;
    reqObj['cashStlDetail.cpExtSettleAccountName1'] = cashCpSettleAcName1stLine.text;
    reqObj['cashStlDetail.cpExtSettleAccountName2'] = cashCpSettleAcName2ndLine.text;
    reqObj['cashStlDetail.cpExtSettleAccountName3'] = cashCpSettleAcName3rdLine.text;
    reqObj['cashStlDetail.cpExtSettleAccountName4'] = cashCpSettleAcName4thLine.text;
    reqObj['mapCashSdVO(cpIntermediaryInfo)'] = cashCpIntermediaryInfo.text;
//    reqObj['mapCashSdVO(deliveryInstruction)'] = cashFullDeliveryInx.text;
    reqObj['mapCashSdVO(beneficiaryName)'] = cashBeneficiaryName.text;
    reqObj['mapCashSdVO(placeOfSettlement)'] = cashPlaceofsettlement.text;
    reqObj['cashStlDetail.brokerBic'] = cashBrokerBic.text;
    reqObj['cashStlDetail.participantId'] = cashParticipantId.text;
    reqObj['cashStlDetail.participantId2'] = cashParticipantId2.text;
    reqObj['mapCashSdVO(ourBank)'] = cashOurBank.text;
    reqObj['mapCashSdVO(ourSettleAc)'] = cashOurSettleAc.text;
    reqObj['mapCashSdVO(ourIntermediaryInfo)'] = cashOurIntermediaryInfo.text;
    reqObj['cashStlDetail.description'] = cashDescription.text;
    reqObj['secCpIntermediaryInfoListName'] = secCpIntermediaryInfoListName;
    reqObj['secOurIntermediaryInfoListName'] = secOurIntermediaryInfoListName;
    reqObj['cashCpIntermediaryInfoListName'] = cashCpIntermediaryInfoListName;
    reqObj['cashOurIntermediaryInfoListName'] = cashOurIntermediaryInfoListName;
    
    return reqObj;
}
private function doBack():void{
    vstack.selectedChild = qry;
    if(this.mode == "amend"){
        this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('stl.amendment.title.securitytrade');
        app.submitButtonInstance = submit;         
        submit.setFocus();
    }
    
} 
private function changeCurrentState():void{    
    vstack.selectedChild = rslt;        
}
private function commonResultPart(mapObj:Object):void{
    var initcol:ArrayCollection;
    var index:int=0;
    var mapSecSiVOColl:ArrayCollection;
    var mapCsiVOColl:ArrayCollection;
    var mapSecSdVOColl:ArrayCollection;
    var mapCashSdVOColl:ArrayCollection;
                
    errPage.clearError(super.getInitResultEvent());
    
    mapSecSiVOColl = mapObj[keylist.getItemAt(2)] as ArrayCollection;
    mapCsiVOColl = mapObj[keylist.getItemAt(3)] as ArrayCollection;
    mapSecSdVOColl = mapObj[keylist.getItemAt(8)] as ArrayCollection;
    mapCashSdVOColl = mapObj[keylist.getItemAt(23)] as ArrayCollection;
    
    /* Populating the header part */
    this.uTradeRefNo.text = mapObj[keylist.getItemAt(0)].toString() + "-" + mapObj[keylist.getItemAt(1)].toString();
    this.uTradingAccount.text = getVoAttbValue(mapSecSiVOColl,"tradingAc");
    this.uTradingAcName.text = getVoAttbValue(mapSecSiVOColl,"tradingAcName");
    //this.uAccountBalanceType.text = getVoAttbValue(mapCsiVOColl,"accountBalanceTypeDispStr");
    this.uTradedate.text = getVoAttbValue(mapCsiVOColl,"tradeDate");
    this.uValuedate.text = getVoAttbValue(mapSecSiVOColl,"valueDate");
    this.uSettleTypeLBL.text = mapObj[keylist.getItemAt(5)].toString();    
    this.uPrice.text = getVoAttbValue(mapCsiVOColl,"price");
    this.uStlInfoStatus.text = mapObj[keylist.getItemAt(6)].toString();
    this.uStlStatus.text = mapObj[keylist.getItemAt(7)].toString();
    /* header part complete */
    
    /* Start the Security Side */
    this.uSecurityCode.text = getVoAttbValue(mapSecSdVOColl,"securityCode");
    this.uSecurityName.text = getVoAttbValue(mapSecSdVOColl,"securityName");
    this.uQuantity.text = getVoAttbValue(mapSecSdVOColl,"quantity");
    this.uBondTaxExemption.text = mapObj[keylist.getItemAt(9)].toString();
    this.uDeliverReceive.text = getVoAttbValue(mapSecSdVOColl,"deliverReceive");
    this.uForm.text = mapObj[keylist.getItemAt(10)].toString();
    this.uSettlementMode.text = mapObj[keylist.getItemAt(11)].toString();    
    this.uInxTransmission.text = mapObj[keylist.getItemAt(13)].toString();
    
    this.uCpBank.text = getVoAttbValue(mapSecSdVOColl,"cpBank");
    this.uCpSettleAc.text = getVoAttbValue(mapSecSdVOColl,"cpSettleAc");
    this.uCpSettleAcName1stLine.text = mapObj[keylist.getItemAt(15)].toString();
    this.uCpSettleAcName2ndLine.text = mapObj[keylist.getItemAt(16)].toString();
    this.uCpSettleAcName3rdLine.text = mapObj[keylist.getItemAt(17)].toString();
    this.uCpSettleAcName4thLine.text = mapObj[keylist.getItemAt(18)].toString();
    this.uCpIntermediaryInfo.text = getVoAttbValue(mapSecSdVOColl,"cpIntermediaryInfo");

    this.uBeneficiaryName.text = getVoAttbValue(mapSecSdVOColl,"beneficiaryName");
    this.uPlaceofsettlement.text = getVoAttbValue(mapSecSdVOColl,"placeOfSettlement");
    this.uBrokerBic.text = mapObj[keylist.getItemAt(19)].toString();
    this.uParticipantId.text = mapObj[keylist.getItemAt(20)].toString();
    this.uParticipantId2.text = mapObj[keylist.getItemAt(21)].toString();
    
    this.uOurBank.text = getVoAttbValue(mapSecSdVOColl,"ourBank");
    this.uOurSettleAc.text = getVoAttbValue(mapSecSdVOColl,"ourSettleAc");
    this.uOurIntermediaryInfo.text = getVoAttbValue(mapSecSdVOColl,"ourIntermediaryInfo");    
    this.uDescription.text = mapObj[keylist.getItemAt(22)].toString();
    
    /* End Security Side */
    
    /* Start the Cash Side */
    
    this.uSettlementCcy.text = getVoAttbValue(mapCashSdVOColl,"settlementCcy");
    this.uNetamount.text = getVoAttbValue(mapCashSdVOColl,"amount");
    this.uWayofpayment.text = mapObj[keylist.getItemAt(24)].toString();
    this.uPaymentReceive.text = getVoAttbValue(mapCashSdVOColl,"deliverReceive");
    this.uCashSettlementmode.text = mapObj[keylist.getItemAt(26)].toString();
    this.uInxForNormal.text = mapObj[keylist.getItemAt(27)].toString();
    this.uInxForSuppress.text = mapObj[keylist.getItemAt(13)].toString();
    
    this.uCashCpBank.text = getVoAttbValue(mapCashSdVOColl,"cpBank");
    this.uCashCpSettleAc.text = getVoAttbValue(mapCashSdVOColl,"cpSettleAc");
    this.uCashCpSettleAcName1stLine.text = mapObj[keylist.getItemAt(28)].toString();
    this.uCashCpSettleAcName2ndLine.text = mapObj[keylist.getItemAt(29)].toString();
    this.uCashCpSettleAcName3rdLine.text = mapObj[keylist.getItemAt(30)].toString();
    this.uCashCpSettleAcName4thLine.text = mapObj[keylist.getItemAt(31)].toString();
    this.uCashCpIntermediaryInfo.text = getVoAttbValue(mapCashSdVOColl,"cpIntermediaryInfo");

    this.uCashBeneficiaryName.text = getVoAttbValue(mapCashSdVOColl,"beneficiaryName");
    this.uCashPlaceofsettlement.text = getVoAttbValue(mapCashSdVOColl,"placeOfSettlement");
    this.uCashBrokerBic.text = mapObj[keylist.getItemAt(32)].toString();
    this.uCashParticipantId.text = mapObj[keylist.getItemAt(33)].toString();
    this.uCashParticipantId2.text = mapObj[keylist.getItemAt(34)].toString();
    
    this.uCashOurBank.text = getVoAttbValue(mapCashSdVOColl,"ourBank");
    this.uCashOurSettleAc.text = getVoAttbValue(mapCashSdVOColl,"ourSettleAc");
    this.uCashOurIntermediaryInfo.text = getVoAttbValue(mapCashSdVOColl,"ourIntermediaryInfo");
    this.uCashDescription.text = mapObj[keylist.getItemAt(35)].toString();
    
    this.viewType = mapObj[keylist.getItemAt(54)].toString();
    
    if(viewType == "view"){
        altSecCodeRow.includeInLayout = true;
        altSecCodeRow.visible = true;
        uAltSecurityCode.text = getVoAttbValue(mapSecSdVOColl,"altSecurityId");
    }
    
    /* End the Cash Side */
    /* Populate Hidden Fields */
    populateHiddenFields(mapObj);
    
    cashSdVoSettlementInfoStatus = getVoAttbValue(mapCashSdVOColl,"settlementInfoStatus");
    secSdVoSettlementInfoStatus = getVoAttbValue(mapSecSdVOColl,"settlementInfoStatus");
    /* End Populating Hidden Fields */
    
    //Modify the Layout as desired by the data of the settlement record
    showDetailUsrConf();
}
private function submitUserConfResult(mapObj:Object):void{
    //var mapObj:Object = mkt.userConfResultEvent(event);
    if(mapObj!=null){                
        if(mapObj["errorFlag"].toString() == "error"){
            //XenosAlert.error(mapObj["errorMsg"].toString());
            errPage.showError(mapObj["errorMsg"]);
            
            doBack();
                            
        }else if(mapObj["errorFlag"].toString() == "noError"){
            if(mode!="cancel")
              errPage.clearError(super.getConfResultEvent());
            this.back.includeInLayout = false;
            this.back.visible = false;
            uConfSubmit.enabled = true;    
//            uConfLabel.includeInLayout = false;
//            uConfLabel.visible = false;
            uConfSubmit.includeInLayout = false;
            uConfSubmit.visible = false;
            sConfLabel.includeInLayout = true;
            sConfLabel.visible = true;
            sConfSubmit.includeInLayout = true;
            sConfSubmit.visible = true;
            
            this.uTradeRefNo.text = mapObj[keylist.getItemAt(0)].toString() + "-" + mapObj[keylist.getItemAt(1)].toString();
            this.viewType = mapObj[keylist.getItemAt(54)].toString();            
            if(this.viewType == "ok"){
                uTradeRefNo.setStyle("fontWeight", "bold");
            }
            
            app.submitButtonInstance = sConfSubmit;
            sConfSubmit.setFocus();
            
        }else{
            errPage.removeError();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred')+ mapObj["errorFlag"].toString());
        }            
    }
}
