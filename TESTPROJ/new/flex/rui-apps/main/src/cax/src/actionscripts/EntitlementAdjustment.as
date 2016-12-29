




import com.nri.rui.cax.validator.AdjustmentValidator;
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.OnDataChangeUtil;
import com.nri.rui.core.utils.XenosStringUtils;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.events.ValidationResultEvent;
import mx.rpc.events.ResultEvent;

/**
 * EntitlementAmend - Action Script for Entitlement Amend UI.
 * @author prabjyotk
 * @version 
 */ 

/**
 * Array List to hold the item to be displayed.
 */
 private var keylist:ArrayCollection = new ArrayCollection();
 /**
  * To store the Rights Condition PK passed in the URL. 
  */
 [Bindable]private var rightsConditionPk : String = "";
 /**
  * To store the list of taxes added 
  */ 
 [Bindable]private var detailTaxFeeList:ArrayCollection= new ArrayCollection(); 
 /**
  * To store the editIndexTaxFeeNo. 
  */
 [Bindable]private var editIndexTaxFeeNo : int = -1;
 /**
  *  To store the Corporate Action Id.
  */
 [Bindable]private var corporateActionId:String ="";
 /**
  *  To store stock option or cash option for div reinvestment or optional stock div case.
  */
 [Bindable]private var stockOptionFlag:String ="";
 
 [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection(); 
 [Bindable]private var rdReferenceNo : String;
 [Bindable]private var isIncomeFlag : Boolean = false;
 [Bindable]private var isEditableFlag : Boolean = false;
 
 
 /**
  * This method is called at the time of loading the main page of the entitlement amend screen.
  * called at EntitlementAmend.mxml - creationComplete="loadAll()
  * This method calls the parseUrlString method to parse the URL
  * It fires the Event amendEntryInit to call the method doAmendInit.
  * 
  * @see com.nri.rui.core.containers.XenosEntryModule.doAmendInit 
  */
  public function loadAll():void {
    parseUrlString();    
    super.setXenosEntryControl(new XenosEntry());
    allotSecurityCode.instrumentId.addEventListener(FlexEvent.VALUE_COMMIT, onChangeSecurityCode);
	allotCcy.ccyText.addEventListener(FlexEvent.VALUE_COMMIT, onChangeSecurityCode);
    this.dispatchEvent(new Event('entryInit'));
  }

 /**
  * Extracts the Rights detail PK from the URL String for which the amend processs needs to be initiated.
  * 
  */ 
  private function parseUrlString():void {
    try {
        // Remove everything before the question mark, including
        // the question mark.
        var myPattern:RegExp = /.*\?/; 
        var s:String = this.loaderInfo.url.toString();
        s = s.replace(myPattern, "");
        // Create an Array of name=value Strings.
        var params:Array = s.split(Globals.AND_SIGN); 
        var keyStr:String;
        var valueStr:String;
        var paramObj:Object = params;
        // Set the values of the salutation.
        if(params != null){
              for (var i:int = 0; i < params.length; i++) {
                var tempA:Array = params[i].split("=");  
                if (tempA[0] == "conditionPk") {
                     this.rightsConditionPk = tempA[1];
                }     
            }
        } 
    } catch (e:Error) {
         trace(e);
    }               
  }
 
 /**
  * Method to call the DetailViewForAmend Method to view the details of the entitlement to be amended.
  * This method sets the URL for Entry Screen for a particular Entitlement and sends the Https request to server. 
  * @override 
  * @see com.nri.rui.core.containers.XenosEntryModule.preEntryInit
  */
  override public function preEntryInit():void { 
        
    super.getInitHttpService().url = "cax/entitlementAdjustmentDispatch.action?";
    var reqObject:Object = new Object();
    reqObject.method= "initialExecute";
    reqObject.SCREEN_KEY = "11170";
    reqObject.rightsConditionPk = this.rightsConditionPk;
    super.getInitHttpService().request = reqObject;
  }
    
 /**
  * Method to add the list of keys (ids of the item) to be showed in the Enrty UI.
  * In this case the key id has the name as that of the form attribute. 
  * @override 
  * @see com.nri.rui.core.containers.XenosEntryModule.preEntryResultInit
  */
  override public function preEntryResultInit():Object {
    populateKeyList();  
    return keylist;
  }
  
 /**
  * Method to populate the values of the keys added in the preAmendResultInit() to be shown in the Amend Entry UI.
  * @override 
  * @see com.nri.rui.core.containers.XenosEntryModule.postAmendResultInit
  */ 
  override public function postEntryResultInit(mapObj:Object): void {   
    populateData(mapObj,"ENTRY");   
  }
  
 /**
  * Method to call the submitRightsDetailsAmend Method to view the details of the entitlement amended.
  * This method set the URL for the Amend Confirmation UI.
  * Populates the request object with the values modified and send the request to the server.
  * @override 
  * @see com.nri.rui.core.containers.XenosEntryModule.preAmendInit
  */
  override public function preEntry():void {
  
    setValidator();
    super.getSaveHttpService().url = "cax/entitlementAdjustmentDispatch.action?";  
    super.getSaveHttpService().request = populateRequestParams();
  }
   
 /**
  * Method to add the list of keys (ids of the item) to be showed in the Amend User Confirmation UI.
  * In this case the key id has the name as that of the form attribute. 
  * @override 
  * @see com.nri.rui.core.containers.XenosEntryModule.preAmendResultHandler
  */
  override public function preEntryResultHandler():Object {

    populateKeyList();  
    return keylist
  }
 /**
  * Method to populate the values of the keys added in the preAmendResultHandler() to be shown in the Amend User Confirmation UI.
  * @override 
  * @see com.nri.rui.core.containers.XenosEntryModule.postAmendResultHandler
  */ 
  override public function postEntryResultHandler(mapObj:Object):void {

    if(mapObj!=null){    
        if( mapObj["errorFlag"].toString() == "error"){
            errPage.showError(mapObj["errorMsg"]);          
        }else if(mapObj["errorFlag"].toString() == "noError"){
            
            this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('cax.adjustment.entry.userconf');
            errPage.clearError(super.getSaveResultEvent()); 
            populateData(mapObj,"CONFIRM");
            this.uConfLabel.visible = true;
            this.uConfLabel.includeInLayout = true;
            this.uConfsecurityBalanceStr.visible = true;
            this.uConfsecurityBalanceStr.includeInLayout = true;
            this.securityBalanceStr.visible = false;
            this.securityBalanceStr.includeInLayout = false;    
            this.securityBalanceLabel.styleName = "FormLabelHeading";
            this.paymentDate.visible = false;
            this.paymentDate.includeInLayout = false;
            this.underSecBv.visible = false;
            this.underSecBv.includeInLayout = false;
            this.uPaymentDateConf.visible = true;
            this.uPaymentDateConf.includeInLayout = true;
            this.uUnderSecBv.visible = true;
            this.uUnderSecBv.includeInLayout = true;
            this.paymentDateLbl.styleName = "FormLabelHeading";
            this.ownershipAccountLbl.styleName = "FormLabelHeading";
            this.inventoryAccountNo.visible = false;
            this.inventoryAccountNo.includeInLayout = false;
            this.dbImg.visible = false;
            this.dbImg.includeInLayout = false;
            this.uInventoryAccountNo.visible = true;
            this.uInventoryAccountNo.includeInLayout = true;
            this.allottedInstrument.visible = true;
	  		this.allottedInstrument.includeInLayout = true;
	  		this.allotCcy.visible = false;
	  		this.allotCcy.includeInLayout = false;
	  		this.allotSecurityCode.visible = false;
	  		this.allotSecurityCode.includeInLayout = false;
	  		this.allottedInstrumentName.visible = true;
	  		this.allottedInstrumentName.includeInLayout = true;
	  		this.allottedInstrumentNameTxt.visible = false;
	  		this.allottedInstrumentNameTxt.includeInLayout = false;
            
            this.balanceCalImg.visible = false;
            this.balanceCalImg.includeInLayout = false;     
            this.taxDetail.visible = false;
            this.taxDetail.includeInLayout = false;
            this.taxButton.visible = false;  
            this.confBtn.visible = true;
            this.confBtn.includeInLayout = true;
            this.confBtn.enabled = true;
            this.submitBtn.visible = false;
            this.submitBtn.includeInLayout = false;
            this.resetBtn.visible = false;
            this.resetBtn.includeInLayout = false;
            this.confBackBtn.visible = true;
            this.confBackBtn.includeInLayout = true;
        }else {
            errPage.removeError();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred'));
        }
    }
   
  }
  
 /**
  * Method to call the commitRightsDetailsAmend Method to perform the backend amend operation on the entitlement which is amended.
  * This method set the URL for the Amend System Confirmation UI.
  * Sends the request to the server.
  * @override 
  * @see com.nri.rui.core.containers.XenosEntryModule.preAmendInit
  */
  override public function preEntryConfirm():void {
    
    this.confBtn.enabled = false;
    var reqObj :Object = new Object();
    super.getConfHttpService().url = "cax/entitlementAdjustmentDispatch.action?";  
    reqObj.method= "commitRightsDetailsEntry";
    reqObj.SCREEN_KEY = "11172";
    super.getConfHttpService().request = reqObj;
  }
  
 /**
  * Method to add the list of keys (ids of the item) to be showed in the Entry System Confirmation UI.
  * In this case the key id has the name as that of the form attribute. 
  * @override 
  * @see com.nri.rui.core.containers.XenosEntryModule.preEntryConfirmResultHandler
  */
  override public function preEntryConfirmResultHandler():Object {

    populateKeyList();  
    return keylist
  }

 /**
  * Method to populate the values of the keys added in the preEntryConfirmResultHandler() to be shown in the Entry User Confirmation UI.
  * @override 
  * @see com.nri.rui.core.containers.XenosEntryModule.postConfirmEntryResultHandler
  */ 
  override public function postConfirmEntryResultHandler(mapObj:Object):void {

    if(mapObj!=null){
            
        if( mapObj["errorFlag"].toString() == "error"){
            
            errPage.showError(mapObj["errorMsg"]);      
            
        } else if(mapObj["errorFlag"].toString() == "noError"){
            
            this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('cax.adjustment.entry.sysconf');
            errPage.clearError(super.getSaveResultEvent()); 
            populateData(mapObj,"CONFIRM");
            this.uConfLabel.visible = false;
            this.uConfLabel.includeInLayout = false;
            this.sConfLabel.visible = true;
            this.sConfLabel.includeInLayout = true;
            this.uConfsecurityBalanceStr.visible = true;
            this.uConfsecurityBalanceStr.includeInLayout = true;
            this.securityBalanceStr.visible = false;
            this.securityBalanceStr.includeInLayout = false;    
            this.securityBalanceLabel.styleName = "FormLabelHeading";
            this.balanceCalImg.visible = false;
            this.balanceCalImg.includeInLayout = false;     
            this.taxDetail.visible = false;
            this.taxDetail.includeInLayout = false;
            this.taxButton.visible = false;   
            this.confBtn.visible = false;
            this.confBtn.includeInLayout = false;
            this.submitBtn.visible = false;
            this.submitBtn.includeInLayout = false;
//            this.backBtn.visible = false;
//            this.backBtn.includeInLayout = false;
            this.confBackBtn.visible = false;
            this.confBackBtn.includeInLayout = false;
            this.resetBtn.visible = false;
            this.resetBtn.includeInLayout = false;
            this.sysConfBtn.visible = true;
            this.sysConfBtn.includeInLayout = true;         
        } else {
            errPage.removeError();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred'));
        }
    }
  }
 /**
  * Method to call the submitQuery Method to return back to summary result screen Screen.
  * This method also closes the amend Popup screen.
  * The handle for this event "OkSystemConfirm" is written in the EntitlementDetailRenderer.mxml
  * @see EntitlementDetailRenderer.mxml  - handleOkSystemConfirm.
  * @override 
  * @see com.nri.rui.core.containers.XenosEntryModule.doAmendSystemConfirm
  */
  override public function doEntrySystemConfirm(e:Event):void {
    
    this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    
  }
 /**
  * Method to call the resetRightsDetailsAmend Method to perform the reset operation on the entitlement which is amended.
  * This method set the URL for the Amend Entry UI after reset.
  * Sends the request to the server.
  * @override 
  * @see com.nri.rui.core.containers.XenosEntryModule.preAmendInit
  */
  override public function preResetEntry():void {

    var reqObj :Object = new Object();
    super.getResetHttpService().url = "cax/entitlementAdjustmentDispatch.action?";  
    reqObj.method= "resetRightsDetailsEntry";
    super.getResetHttpService().request = reqObj;
  } 
 /**
  * Method to call the resetRightsDetailsAmend Method to perform the reset operation on the entitlement which is amended.
  * This method set the URL for the Amend Entry UI after reset.
  * Sends the request to the server.
  * @override 
  * @see com.nri.rui.core.containers.XenosEntryModule.preAmendInit
  * @param screenType - <String> Objec.It indication for which screen the back button is clicked.
  *                     AMEND - Amend Screen
  *                     CONFIRM  - User Confirmation Screen. 
  */    
  private function doBack(screenType:String):void {
    switch(screenType) {
        case "ENTRY":
            this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
            this.submitBtn.enabled = true;  
        break;
        case "CONFIRM":
        
            this.parentDocument.title =this.parentApplication.xResourceManager.getKeyValue('cax.adjustment.entry');
            this.submitBtn.enabled = true;
            this.uConfLabel.visible = false;
            this.uConfLabel.includeInLayout = false;
            this.uConfsecurityBalanceStr.visible = false;
            this.uConfsecurityBalanceStr.includeInLayout = false;
            this.securityBalanceStr.visible = true;
            this.securityBalanceStr.includeInLayout = true; 
            this.securityBalanceLabel.styleName = "ReqdLabel";
            this.balanceCalImg.visible = true;
            this.balanceCalImg.includeInLayout = true;
            this.inventoryAccountNo.visible = true;
            this.inventoryAccountNo.includeInLayout = true; 
            this.dbImg.visible = true;
            this.dbImg.includeInLayout = true;
            this.ownershipAccountLbl.styleName = "ReqdLabel";
            this.uInventoryAccountNo.visible = false;
            this.uInventoryAccountNo.includeInLayout = false;     
            this.taxDetail.visible = true;
            this.taxDetail.includeInLayout = true;
            this.taxButton.visible = true;  
            this.confBtn.visible = false;
            this.confBtn.includeInLayout = false;
            this.submitBtn.visible = true;
            this.submitBtn.includeInLayout = true;
            this.resetBtn.visible = true;
            this.resetBtn.includeInLayout = true;
//            this.backBtn.visible = true;
//            this.backBtn.includeInLayout = true;
            this.confBackBtn.visible = false;
            this.confBackBtn.includeInLayout = false;
            this.stockPart.confirm.visible = false;
            this.stockPart.confirm.includeInLayout = false
            this.stockPart.entry.visible = true;
            this.stockPart.entry.includeInLayout = true;
            this.cashPart.confirm.visible = false;
            this.cashPart.confirm.includeInLayout = false;
            this.cashPart.entry.visible = true;
            this.cashPart.entry.includeInLayout = true;
            this.paymentDate.visible = true;
            this.paymentDate.includeInLayout = true;
            this.uPaymentDateConf.visible = false;
            this.uPaymentDateConf.includeInLayout = false;
            this.paymentDateLbl.styleName = "ReqdLabel";
            this.underSecBv.visible = true;
            this.underSecBv.includeInLayout = true;
            this.uUnderSecBv.visible = false;
            this.uUnderSecBv.includeInLayout = false;
            
            if(isEditableFlag == true){
            	this.allottedInstrument.visible = false;
            	this.allottedInstrument.includeInLayout = false;
            	this.allottedInstrumentName.visible = false;
            	this.allottedInstrumentName.includeInLayout = false;
            	this.allottedInstrumentNameTxt.visible = true;
            	this.allottedInstrumentNameTxt.includeInLayout = true;
            	
            	if(isIncomeFlag == true){
            		this.allotCcy.visible = true;
		  			this.allotCcy.includeInLayout = true;
		  			this.allotSecurityCode.visible = false;
		  			this.allotSecurityCode.includeInLayout = false;
            	}else{
            		this.allotCcy.visible = false;
		  			this.allotCcy.includeInLayout = false;
		  			this.allotSecurityCode.visible = true;
		  			this.allotSecurityCode.includeInLayout = true;
            	}
            }else{
            	this.allotCcy.visible = false;
	  			this.allotCcy.includeInLayout = false;
	  			this.allotSecurityCode.visible = false;
	  			this.allotSecurityCode.includeInLayout = false;
	  			this.allottedInstrument.visible = true;
	  			this.allottedInstrument.includeInLayout = true;
	  			
	  			this.allottedInstrumentName.visible = true;
            	this.allottedInstrumentName.includeInLayout = true;
            	this.allottedInstrumentNameTxt.visible = false;
            	this.allottedInstrumentNameTxt.includeInLayout = false;
            }
        break;
    }       
  }
 /**
  * This Handler method alters the states on the basis of corporate action id .
  */
  public function stateChangeHandler():void {
                       
     switch(corporateActionId) {
        case "CASH_DIVIDEND":
        case "COUPON_PAYMENT":      
            currentState = "CashRelatedEntitlement";
            this.taxDetail.visible = true;
            this.taxDetail.includeInLayout = true;
            this.taxWindow.visible = true;
            this.taxWindow.includeInLayout = true;
        break;      
        case "CAPITAL_REPAYMENT":
        	currentState = "CashRelatedEntitlement";
        break;
        case "REDEMPTION_BOND":
        case "OPTIONAL_STOCK_DIV":
        	if(XenosStringUtils.equals(stockOptionFlag,"true")) {
        		currentState = "StockRelatedEntitlement";
        	} else {
        		currentState = "CashRelatedEntitlement";    	
        	}        
        case "DIV_REINVESTMENT":
        	if(XenosStringUtils.equals(stockOptionFlag,"true")) {
        		currentState = "StockRelatedEntitlement";
        	} else {
        		currentState = "CashRelatedEntitlement";    	
        	}
            
        break;      
        case "STOCK_SPLIT":
        case "STOCK_DIVIDEND":
        case "BONUS_ISSUE":
        case "SPIN_OFF":
        case "NAME_CHANGE":
        case "REVERSE_STOCK_SPLIT":
        case "STOCK_MERGER":
        case "RIGHTS_ALLOCATION":
        case "OTHERS":
        case "RIGHTS_EXPIRY":   
            currentState = "StockRelatedEntitlement";	
        break;
       }
       
       if(XenosStringUtils.equals(currentState,"StockRelatedEntitlement")) { 		    
		    this.eventTypeLbl.visible = false;
		    this.eventTypeLbl.includeInLayout = false; 		    		
		    this.eventTypeNameGridItem.visible = false;
		    this.eventTypeNameGridItem.includeInLayout = false; 				    
       }
  }
 /**
  * Method to add the key ids in the keylist
  */
  private function populateKeyList():void {
    
    keylist.addItem("rdReferenceNo");       
    keylist.addItem("rcReferenceNo");
    keylist.addItem("subEventTypeDescription");
    keylist.addItem("conditionStatus");
    keylist.addItem("instrumentCode");      
    keylist.addItem("instrumentName");
    keylist.addItem("allottedInstrument");
    keylist.addItem("allottedInstrumentName");   
    keylist.addItem("giveUpDropDownValues.item"); 
    keylist.addItem("corporateActionId");
    keylist.addItem("securityBalanceStr");
    keylist.addItem("allottedAmountStr");
    keylist.addItem("splAmountOrQtyStr"); 
    keylist.addItem("taxFeeIdList.taxFeeIdDropdownList");   
    keylist.addItem("rateTypeDropdownList.item");
    keylist.addItem("giveUp"); 
    keylist.addItem("detailType");  
    keylist.addItem("detailTaxFeeList.taxFeeList");  
    keylist.addItem("allottedQuantityStr"); 
    keylist.addItem("fractionalShareStr");  
    keylist.addItem("cashInLieuFlagExp");
    keylist.addItem("editIndexTaxFeeNo");
    keylist.addItem("remarks");
    keylist.addItem("hiddenCashInLieuFlag");
    keylist.addItem("flagForCash");    
    keylist.addItem("eventTypeName");      
    keylist.addItem("stockOptionFlag");
    keylist.addItem("accountNo");
    keylist.addItem("editableAllotedSec"); 
    keylist.addItem("isIncome");
    keylist.addItem("paymentDate");
    keylist.addItem("availableDate"); 
    keylist.addItem("underlineSecurityBV");  
    keylist.addItem("finalizedFlagDropdownList.item");
    keylist.addItem("finalizedFlag");
    keylist.addItem("finalizedFlagDisp");  
  }
 /**
  * Method to populate data to be displayed.
  * @param mapObj - The keyList containg the key and the value.
  * @param screenType - <String> Objec.It indication for which screen the data needs to be populated.
  *                     AMEND - Amend Screen
  *                     CONFIRM  - User Confirmation Screen.
  */ 
  private function populateData(mapObj:Object,screenType:String):void {
  	
  	errPage.clearError(super.getSaveResultEvent());
    var initcol:ArrayCollection = new ArrayCollection();
    var index:int=0;
    var item:Object= null;
    //this.rdReferenceNo.text="";
    // this.detailTypeDescription.text="";
    this.rcReferenceNo.text="";
    this.inventoryAccountNo.accountNo.text="";
    this.subEventTypeDescription.text="";
    this.conditionStatus.text="";
    this.instrumentCode.text="";
    this.instrumentName.text="";
    this.allottedInstrument.text="";
    this.allottedInstrumentName.text="";    
    this.securityBalanceStr.text="";
    this.uConfsecurityBalanceStr.text = "";
    this.uInventoryAccountNo.text = "";
    this.paymentDate.text = "";
    this.underSecBv.text = "";
            
    this.rdReferenceNo = mapObj[keylist.getItemAt(0)].toString();
    // this.detailTypeDescription.text=mapObj[keylist.getItemAt(1)].toString();
    this.rcReferenceNo.text=mapObj[keylist.getItemAt(1)].toString();
    this.inventoryAccountNo.accountNo.text = mapObj[keylist.getItemAt(27)].toString();
    this.uInventoryAccountNo.text = mapObj[keylist.getItemAt(27)].toString();
    this.subEventTypeDescription.text=mapObj[keylist.getItemAt(2)].toString();
    this.conditionStatus.text=mapObj[keylist.getItemAt(3)].toString();
    this.instrumentCode.text=mapObj[keylist.getItemAt(4)].toString();
    this.instrumentName.text=mapObj[keylist.getItemAt(5)].toString();
    this.allottedInstrument.text=mapObj[keylist.getItemAt(6)].toString();
    this.allottedInstrumentName.text=mapObj[keylist.getItemAt(7)].toString();
    this.securityBalanceStr.text=mapObj[keylist.getItemAt(10)].toString();
    this.uConfsecurityBalanceStr.text = mapObj[keylist.getItemAt(10)].toString();    
    this.uEventTypeNameConf.text = mapObj[keylist.getItemAt(25)].toString(); 
    this.paymentDate.text =  mapObj[keylist.getItemAt(30)].toString();
    this.uPaymentDateConf.text =  mapObj[keylist.getItemAt(30)].toString();
    this.underSecBv.text =  mapObj[keylist.getItemAt(32)].toString();
    this.uUnderSecBv.text =  mapObj[keylist.getItemAt(32)].toString();    
        

    corporateActionId = mapObj[keylist.getItemAt(9)].toString();
    stockOptionFlag = mapObj[keylist.getItemAt(26)].toString();
    
    
    var isIncome:String = mapObj['isIncome'].toString();
    if(isIncome=='true'){    	  	
    	this.cashPart.availableGrid.includeInLayout=false;
    	this.cashPart.availableGridConf.includeInLayout=false;
    	this.stockPart.availableGrid.includeInLayout=false;
    	this.stockPart.availableGridConf.includeInLayout=false;
    }
    
    // loadng the child part based on the screen type.
    switch(screenType) {
        case "ENTRY":
        var editable:String = mapObj[keylist.getItemAt(28)].toString();
               
        editableAllotSec(mapObj,editable,isIncome);
            loadCashPart(mapObj);
            loadStockPart(mapObj);               
        break;
        case "CONFIRM":         
            loadCashPartConfirm(mapObj);
            loadStockPartConfirm(mapObj);
        break;
    }   
    //loading the tax detail part.
    loadTaxDetail(mapObj);   
    
    // calling the state change handler to load the appropriate mxml file. 
    stateChangeHandler();  
    
	 
    //For Others Event type    
   if(XenosStringUtils.equals(corporateActionId,"OTHERS")) {
	 loadOthersEventPart(mapObj,screenType);
   } 
        
  }
  
  
  private function editableAllotSec(mapObj:Object,editable:String,isIncome:String):void{
  	if(editable == 'Y'){
  		isEditableFlag = true;  		
  		this.allottedInstrument.visible = false;
  		this.allottedInstrument.includeInLayout = false;
  		this.allottedInstrumentName.visible = false;
  		this.allottedInstrumentName.includeInLayout = false;
  		this.allottedInstrumentNameTxt.visible = true;
  		this.allottedInstrumentNameTxt.includeInLayout = true;
  		this.allottedInstrumentNameTxt.text = mapObj[keylist.getItemAt(7)].toString();
  		if(isIncome == 'true'){
  			isIncomeFlag = true;
  			this.allotCcy.visible = true;
  			this.allotCcy.includeInLayout = true;
  			this.allotSecurityCode.visible = false;
  			this.allotSecurityCode.includeInLayout = false;
  			this.allotCcy.ccyText.text = mapObj[keylist.getItemAt(6)].toString();
  			
  		}else{
  			isIncomeFlag = false;
  			this.allotCcy.visible = false;
  			this.allotCcy.includeInLayout = false;
  			this.allotSecurityCode.visible = true;
  			this.allotSecurityCode.includeInLayout = true;
  			this.allotSecurityCode.instrumentId.text = mapObj[keylist.getItemAt(6)].toString();
  		}
  	}else{
  		this.allottedInstrument.visible = true;
  		this.allottedInstrument.includeInLayout = true;
  		this.allotCcy.visible = false;
  		this.allotCcy.includeInLayout = false;
  		this.allotSecurityCode.visible = false;
  		this.allotSecurityCode.includeInLayout = false;
  		this.allottedInstrument.text = mapObj[keylist.getItemAt(6)].toString();
  		this.allottedInstrumentName.visible = true;
  		this.allottedInstrumentName.includeInLayout = true;
  		this.allottedInstrumentNameTxt.visible = false;
  		this.allottedInstrumentNameTxt.includeInLayout = false;
  	}
  }
  
  
 /**
  * Method to populate others detail type
  * @param Object - The keyList containg the key and the value.
  */   
  private function loadOthersEventPart(mapObj:Object,screenType:String):void {
   	var isFlagForCash:String = mapObj[keylist.getItemAt(26)].toString();

    this.eventTypeLbl.visible = true;
    this.eventTypeLbl.includeInLayout = true;    
    this.eventTypeNameGridItem.visible = true;
    this.eventTypeNameGridItem.includeInLayout = true;

    if(XenosStringUtils.equals(screenType,"AMEND")) {
	    this.stockPart.fractionalShrCashInlieuRow.visible = false;
	    this.stockPart.fractionalShrCashInlieuRow.includeInLayout = false; 	      	             	      
	   	if(XenosStringUtils.equals(isFlagForCash,"true")) {
		    this.stockPart.allottedAmountStr.text=mapObj[keylist.getItemAt(13)].toString();
		    this.stockPart.allottedQuantityStr.enabled = false;	     
    		this.stockPart.allottedAmountStr.editable = true; 		    
	   	} else {
		    this.stockPart.allottedQuantityStr.text=mapObj[keylist.getItemAt(20)].toString();
		    this.stockPart.allottedAmountStr.enabled = false;		
    		this.stockPart.allottedQuantityStr.editable = true; 			    
	   	}
   	} else if(XenosStringUtils.equals(screenType,"CONFIRM")) {
    	this.stockPart.uConffractionalShrCashInlieuRow.visible = false;
    	this.stockPart.uConffractionalShrCashInlieuRow.includeInLayout = false; 	             	      
	   	if(XenosStringUtils.equals(isFlagForCash,"true")) {
		    this.stockPart.uConfallottedAmountStr.text=mapObj[keylist.getItemAt(13)].toString();
		    this.stockPart.uConfallottedQuantityStr.text="";	   		    
	   	} else {
		    this.stockPart.uConfallottedAmountStr.text="";
		    this.stockPart.uConfallottedQuantityStr.text=mapObj[keylist.getItemAt(20)].toString();		    	
	   	}   		
   	}
   	
   	
   	  	
  }
  
  
 /**
  * Method to populate the tax detail
  * @param Object - The keyList containg the key and the value.
  */ 
  private function loadTaxDetail(mapObj:Object):void {
    
    var initcol:ArrayCollection = new ArrayCollection();
    var item:Object= null;
    this.rate.text="";
    this.amount.text="";
    this.rateType.text ="";
    this.taxFeeId.text="";
    //Setting values of tax Fee Id.
    initcol=new ArrayCollection();
    initcol.addItem("");
    for each(item in (mapObj[keylist.getItemAt(13)] as ArrayCollection)){
        initcol.addItem(item);                
    }
    this.taxFeeId.dataProvider = initcol;       
    
    //Setting values of rate type.
    initcol=new ArrayCollection();
    initcol.addItem({label:"",value: ""});
    for each(item in (mapObj[keylist.getItemAt(14)] as ArrayCollection)){
        initcol.addItem(item);
    }
    this.rateType.dataProvider = initcol;
    
    //setting the detail tax fee list
    detailTaxFeeList=new ArrayCollection();
    for each(item in (mapObj[keylist.getItemAt(17)] as ArrayCollection)){
        item.isVisible = true;
        detailTaxFeeList.addItem(item);
    }
    if(detailTaxFeeList.length==0){ 
        taxSummary.visible=false;
        taxSummary.includeInLayout=false;
    } else { 
        taxSummary.visible=true;
        taxSummary.includeInLayout=true;
    }
    //editIndexTaxFeeNo
    this.editIndexTaxFeeNo = mapObj[keylist.getItemAt(21)];
    
    // to set the Tax Fee Requirements depending on the rate type.
    onChangeRateType();
    // calling the  method to display the proper tax buton based on the editIndexTaxFeeNo
    taxButtonDisplay();
  }
 /**
  * Method to populate data for cash related entitlements for the amend screen.
  * @param mapObj - The keyList containing the key and the value.
  * @param detailType - Detail Type RIGHTS_DETAIL' or 'NCM_RIGHTS_DETAIL'
  */ 
  private function loadCashPart(mapObj:Object):void {
    
    var initcol:ArrayCollection = new ArrayCollection();
    var index:int=0;
    var item:Object= null;
    this.cashPart.allottedAmountStr.text="";
    this.cashPart.splAmountOrQtyStr.text = "";
    this.cashPart.remarks.text="";
    this.cashPart.availableDate.text = "";
   
    this.cashPart.giveUp.visible = true;
    this.cashPart.giveUpGridLabel.visible = true;    
    
    this.cashPart.inconsistencyflag.visible = false;
    this.cashPart.inconsistencyflag.includeInLayout = false;
    this.cashPart.inconsistencyflaglbl.visible = false;
    this.cashPart.inconsistencyflaglbl.includeInLayout = false;
       
    initcol=new ArrayCollection();
    for each(item in (mapObj[keylist.getItemAt(8)] as ArrayCollection)){
        initcol.addItem(item);
        if(item.value == mapObj[keylist.getItemAt(15)].toString())
            index = (mapObj[keylist.getItemAt(8)] as ArrayCollection).getItemIndex(item);            
    }
    this.cashPart.giveUp.dataProvider = initcol;    
    this.cashPart.giveUp.selectedIndex = index; 
    
    /** Populating splAmountOrQtyStr : for cash dividend its should be visible
     *  For Coupon Payment and Redemention Bond - should be hidden.
     */ 
     switch(corporateActionId) { 
    
        case "CASH_DIVIDEND":
        case "CAPITAL_REPAYMENT":       
        case "OPTIONAL_STOCK_DIV":
        case "DIV_REINVESTMENT":
            this.cashPart.splAmountOrQtyRow.visible =true;
            this.cashPart.splAmountOrQtyRow.includeInLayout =true;
            this.cashPart.splAmountOrQtyStr.visible = true;
            this.cashPart.splAmountOrQtyLabel.visible = true;               
        break;
        case "COUPON_PAYMENT":
        case "REDEMPTION_BOND":
            this.cashPart.splAmountOrQtyRow.visible =false;
            this.cashPart.splAmountOrQtyRow.includeInLayout =false;
            this.cashPart.splAmountOrQtyStr.visible = false;
            this.cashPart.splAmountOrQtyLabel.visible = false;
        break;          
    }       
    this.cashPart.allottedAmountStr.text=mapObj[keylist.getItemAt(11)].toString();
    this.cashPart.splAmountOrQtyStr.text = mapObj[keylist.getItemAt(12)].toString();
    this.cashPart.remarks.text = mapObj[keylist.getItemAt(22)].toString();
    this.cashPart.availableDate.text = mapObj[keylist.getItemAt(31)].toString();
    this.cashPart.finalizedflag.dataProvider=mapObj['finalizedFlagDropdownList.item'];
    var indx:int=0;
    this.cashPart.finalizedflag.selectedIndex=indx;
    for each(var item:Object in mapObj['finalizedFlagDropdownList.item']){
    	if(item.value=='Y'){
    		this.cashPart.finalizedflag.selectedIndex=indx;
    		break;
    	}
    	indx++;
    }
  }
 /**
  * Method to populate data for cash related entitlements for the user and system confirmation screen.
  * @param mapObj - The keyList containing the key and the value.
  * @param detailType - Detail Type RIGHTS_DETAIL' or 'NCM_RIGHTS_DETAIL'
  */
  private function loadCashPartConfirm(mapObj:Object):void {
    
    var initcol:ArrayCollection = new ArrayCollection();
    var index:int=0;
    var item:Object= null;
    this.cashPart.uConfallottedAmountStr.text="";
    this.cashPart.uConfsplAmountOrQtyStr.text = "";
    this.cashPart.confirm.visible = true;
    this.cashPart.confirm.includeInLayout = true;
    this.cashPart.entry.visible = false;
    this.cashPart.entry.includeInLayout = false;
    
    this.cashPart.inconsistencyflagConf.visible = false;
    this.cashPart.inconsistencyflagConf.includeInLayout = false;
    this.cashPart.inconsistencyflagConflbl.visible = false;
    this.cashPart.inconsistencyflagConflbl.includeInLayout = false;
    
    this.cashPart.uConfgiveUp.visible = true;
    this.cashPart.uConfgiveUpGridLabel.visible = true;  
    for each(item in (mapObj[keylist.getItemAt(8)] as ArrayCollection)){
        if(item.value == mapObj[keylist.getItemAt(15)].toString()) {
            this.cashPart.uConfgiveUp.text = item.label;
            break;            
        }
    }       
    
    
    /** Populating splAmountOrQtyStr : for cash dividend its should be visible
     *  For Coupon Payment and Redemention Bond - should be hidden.
     */ 
    switch(corporateActionId) { 
    
        case "CASH_DIVIDEND":
        case "CAPITAL_REPAYMENT":       
        case "OPTIONAL_STOCK_DIV":
        case "DIV_REINVESTMENT":
            this.cashPart.uConfsplAmountOrQtyRow.visible =true;
            this.cashPart.uConfsplAmountOrQtyRow.includeInLayout =true;
            this.cashPart.uConfsplAmountOrQtyStr.visible = true;
            this.cashPart.uConfsplAmountOrQtyLabel.visible = true;              
        break;
        case "COUPON_PAYMENT":
        case "REDEMPTION_BOND": 
            this.cashPart.uConfsplAmountOrQtyRow.visible =false;
            this.cashPart.uConfsplAmountOrQtyRow.includeInLayout =false;
            this.cashPart.uConfsplAmountOrQtyStr.visible = false;
            this.cashPart.uConfsplAmountOrQtyLabel.visible = false; 
        break
    } 
    this.cashPart.uConfallottedAmountStr.text=mapObj[keylist.getItemAt(11)].toString();
    this.cashPart.uConfsplAmountOrQtyStr.text = mapObj[keylist.getItemAt(12)].toString();
    this.cashPart.uConfremarks.text = mapObj[keylist.getItemAt(22)].toString();
    this.cashPart.availableDateConf.text = mapObj[keylist.getItemAt(31)].toString();
    this.cashPart.finalizeflagConf.text=mapObj['finalizedFlagDisp'].toString();
  }
  
 /**
  * Method to populate data for stock related entitlements for the amend screen.
  * @param mapObj - The keyList containing the key and the value.
  * @param detailType - Detail Type RIGHTS_DETAIL' or 'NCM_RIGHTS_DETAIL'* 
  */ 
  private function loadStockPart(mapObj:Object):void {
    
    this.stockPart.cashInLieuFlagExp.text="";
    this.stockPart.allottedQuantityStr.text = "";
    this.stockPart.allottedAmountStr.text = "";
    this.stockPart.fractionalShareStr.text = "";   
    this.stockPart.splAmountOrQtyStr.text ="";
    this.stockPart.remarks.text="";
    this.stockPart.availableDate.text ="";
    
    this.stockPart.allottedAmountStr.text=mapObj[keylist.getItemAt(11)].toString();
    this.stockPart.allottedQuantityStr.text=mapObj[keylist.getItemAt(18)].toString();
    this.stockPart.splAmountOrQtyStr.text = mapObj[keylist.getItemAt(12)].toString();
    this.stockPart.remarks.text = mapObj[keylist.getItemAt(22)].toString();
    this.stockPart.fractionalShareStr.text = mapObj[keylist.getItemAt(19)].toString();
    this.stockPart.availableDate.text = mapObj[keylist.getItemAt(31)].toString();
      
    
    this.stockPart.fractionalShrCashInlieuRow.visible = true;
	this.stockPart.fractionalShrCashInlieuRow.includeInLayout = true;  
	
	this.stockPart.inconsistencyflag.visible = false;
	this.stockPart.inconsistencyflag.includeInLayout = false;
	this.stockPart.inconsistencyflaglbl.visible = false;
	this.stockPart.inconsistencyflaglbl.includeInLayout = false;
	       
    
    /** Populating cashInLieuLabel : for NAME_CHANGE its should be hidden
     *  For rest - should be visible.
     */ 
    if(!XenosStringUtils.equals(corporateActionId,"NAME_CHANGE")){
            this.stockPart.cashInLieuLabel.visible = true;
            this.stockPart.cashInLieuFlagExp.visible = true;
            this.stockPart.cashInLieuFlagExp.text=mapObj[keylist.getItemAt(20)].toString();
    } else {
        this.stockPart.cashInLieuLabel.visible = false;
    }
    
    var hiddenCashInLieuFlag :String = mapObj[keylist.getItemAt(23)].toString();
    if(XenosStringUtils.equals(hiddenCashInLieuFlag,"Y")) {
        
        this.stockPart.allottedQuantityStr.text ="";
        this.stockPart.allottedQuantityStr.editable = false;
        this.stockPart.allottedAmountStr.editable = true;
    } else {
        this.stockPart.allottedQuantityStr.editable = true;
        this.stockPart.allottedAmountStr.editable = false;
        this.stockPart.allottedAmountStr.text="";
    }
        
    /** Populating splAmountOrQtyRow : for Stock Dividend its should be visible
     *  For Stock Split - should be hidden.
     */
     switch(corporateActionId) { 
        
       case "STOCK_DIVIDEND":   
       case "BONUS_ISSUE":
       case "STOCK_MERGER":
       case "RIGHTS_ALLOCATION":
       case "RIGHTS_EXPIRY":  
           
            this.stockPart.splAmountOrQtyRow.visible =true;
            this.stockPart.splAmountOrQtyRow.includeInLayout =true;
            this.stockPart.splAmountOrQtyStr.visible = true;
            this.stockPart.splAmountOrQtyLabel.visible = true; 
      break;
      case "STOCK_SPLIT":
      case "NAME_CHANGE":
      case "SPIN_OFF":
      case "REVERSE_STOCK_SPLIT":   
      case "OTHERS":      
      
            this.stockPart.splAmountOrQtyRow.visible =false;
            this.stockPart.splAmountOrQtyRow.includeInLayout =false;
            this.stockPart.splAmountOrQtyStr.visible = false;
            this.stockPart.splAmountOrQtyLabel.visible = false;
      break;            
    } 
    this.stockPart.finalizedflag.dataProvider=mapObj['finalizedFlagDropdownList.item'];  
    var indx:int=0;
    this.stockPart.finalizedflag.selectedIndex=indx;
    for each(var item:Object in mapObj['finalizedFlagDropdownList.item']){
    	if(item.value=='Y'){
    		this.stockPart.finalizedflag.selectedIndex=indx;
    		break;
    	}
    	indx++;
    }    
        
  }

 /**
  * Method to populate data for cash related entitlements for the user and system confirmation screen.
  * @param mapObj - The keyList containing the key and the value.
  * @param detailType - Detail Type RIGHTS_DETAIL' or 'NCM_RIGHTS_DETAIL'* 
  */ 
  private function loadStockPartConfirm(mapObj:Object):void {
    
    this.stockPart.uConfcashInLieuFlagExp.text="";
    this.stockPart.uConfallottedQuantityStr.text = "";
    this.stockPart.uConfallottedAmountStr.text = "";
    this.stockPart.uConffractionalShareStr.text = "";   
    this.stockPart.uConfsplAmountOrQtyStr.text ="";
    
    this.stockPart.confirm.visible = true;
    this.stockPart.confirm.includeInLayout = true;
    this.stockPart.entry.visible = false;
    this.stockPart.entry.includeInLayout = false;
    
    this.stockPart.uConffractionalShrCashInlieuRow.visible = true;
	this.stockPart.uConffractionalShrCashInlieuRow.includeInLayout = true;   
	
	this.stockPart.inconsistencyflagConf.visible = false;
	this.stockPart.inconsistencyflagConf.includeInLayout = false;
	this.stockPart.inconsistencyflagConflbl.visible = false;
	this.stockPart.inconsistencyflagConflbl.includeInLayout = false;  
    
    this.stockPart.uConfallottedAmountStr.text=mapObj[keylist.getItemAt(11)].toString();
    this.stockPart.uConfallottedQuantityStr.text=mapObj[keylist.getItemAt(18)].toString();
    this.stockPart.uConfsplAmountOrQtyStr.text = mapObj[keylist.getItemAt(12)].toString();
    this.stockPart.uConfremarks.text = mapObj[keylist.getItemAt(22)].toString();
    this.stockPart.uConffractionalShareStr.text = mapObj[keylist.getItemAt(19)].toString();
    this.stockPart.availableDateConf.text = mapObj[keylist.getItemAt(31)].toString();
          
    
    /** Populating cashInLieuLabel : for NAME_CHANGE its should be hidden
     *  For rest - should be visible.
     */ 
    if(!XenosStringUtils.equals(corporateActionId,"NAME_CHANGE")){
            this.stockPart.uConfcashInLieuLabel.visible = true;
            this.stockPart.uConfcashInLieuFlagExp.visible = true;
            this.stockPart.uConfcashInLieuFlagExp.text=mapObj[keylist.getItemAt(20)].toString();
    } else {
        this.stockPart.uConfcashInLieuLabel.visible = false;
    }
    
    /** Populating splAmountOrQtyRow : for Stock Dividend its should be visible
     *  For Stock Split - should be hidden.
     */ 
    switch(corporateActionId) { 
        
       case "STOCK_DIVIDEND":   
       case "BONUS_ISSUE":
       case "STOCK_MERGER":
       case "RIGHTS_ALLOCATION":
       case "RIGHTS_EXPIRY":
            this.stockPart.uConfsplAmountOrQtyRow.visible =true;
            this.stockPart.uConfsplAmountOrQtyRow.includeInLayout =true;
            this.stockPart.uConfsplAmountOrQtyStr.visible = true;
            this.stockPart.uConfsplAmountOrQtyLabel.visible = true;
      break;            
      case "STOCK_SPLIT":
      case "NAME_CHANGE":
      case "SPIN_OFF":
      case "OTHERS":
      case "REVERSE_STOCK_SPLIT":
            this.stockPart.uConfsplAmountOrQtyRow.visible =false;
            this.stockPart.uConfsplAmountOrQtyRow.includeInLayout =false;
            this.stockPart.uConfsplAmountOrQtyStr.visible = false;
            this.stockPart.uConfsplAmountOrQtyLabel.visible = false;
            
            
      break;            
    } 
    this.stockPart.finalizeflagConf.text=mapObj['finalizedFlagDisp'].toString();       
  }

 /**
  * This method sets the Tax Fee Requirements depending on the rate type.
  */ 
  private function onChangeRateType():void {

    var rateType : String = this.rateType.text == null ? "": this.rateType.text ;
    switch(rateType) {

        case "PERCENT":
            this.amount.text="";
            this.amount.visible=false;
            this.amountLabel.visible=false;         
            this.rateLabel.visible=true;                        
            this.rate.visible = true;   
            this.amtCalImg.visible = false;
            break;
        case "AMOUNT" :
            this.rate.text="";
            this.amount.visible=true;
            this.amountLabel.visible=true;
            this.rateLabel.visible=false;   
            this.rate.visible = false;      
            this.amtCalImg.visible = false;     
            break;
        case "BP":
            this.amount.text="";
            this.amount.visible=false;
            this.amountLabel.visible=false;
            this.rateLabel.visible=true;    
            this.rate.visible = true;
            this.amtCalImg.visible = true;  
        break;
        case "CPS" :
            this.amount.visible=true;
            this.amountLabel.visible=true;
            this.rateLabel.visible=true;    
            this.rate.visible = true;   
            this.amtCalImg.visible = true;
        break;
        case "" :
            this.amount.visible=true;
            this.amountLabel.visible=true;
            this.rateLabel.visible=true;    
            this.rate.visible = true;   
            this.amtCalImg.visible = true;
        break;
     }
  } 
 /**
  * Method to call the addDetailTaxFee Method to add the tax details information.
  * It fills the request object with the tax information before sending the request.
  * @param methodFlag - indicating which method to be called addDetailTaxFee,cancelDetailTaxFee or updateDetailTaxFee.
  */
  private function preAddTaxFeeHandler(methodFlag:String):void {
    
    if(validateTaxFee(methodFlag)) {
        taxFeeInformation.url = "cax/entitlementAdjustmentDispatch.action?";
        var reqObject:Object = new Object();
        reqObject.amount = this.amount.text;
        reqObject.rate = this.rate.text;
        reqObject.rateType = this.rateType.text;
        reqObject.taxFeeId = this.taxFeeId.text;
        switch(methodFlag) {
            case "ADD":
                reqObject.method= "addDetailTaxFee";
            break;
            case "CANCEL":
                reqObject.method= "cancelDetailTaxFee";
            break;
            case "SAVE":
                reqObject.method= "updateDetailTaxFee";
            break;
        }
        taxFeeInformation.request = reqObject;  
        taxFeeInformation.send();
    }       
  }     
 /**
  * Method to set the detailTaxFeeList to show the summray list of the tax information added. 
  * @param event - <ResultEvent> Object.
  */ 
  private function postAddTaxFeeHandler(event:ResultEvent):void {
  	 var rs:XML = XML(event.result);
  	 
  	 if (null != event) {
  		 if(rs.child("detailTaxFeeList").length()>0) {
  		 	taxSummary.visible=true;
        	taxSummary.includeInLayout=true;
        	this.amount.text = rs.amount;
        	this.rate.text=rs.rate;
        	this.rateType.text=rs.rateType;
        	this.taxFeeId.text = rs.taxFeeId;
        	this.editIndexTaxFeeNo = rs.editIndexTaxFeeNo;
        	taxButtonDisplay();
  		 	errPage.clearError(event);
  		 	detailTaxFeeList.removeAll();
  		 	try {
			    for each ( var rec:XML in rs.detailTaxFeeList.taxFeeList) {
			    	rec.isVisible = true;
 				    detailTaxFeeList.addItem(rec);
			    }
            	detailTaxFeeList.refresh();
			}catch(e:Error){
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    }
		     onChangeRateType();
  		 }
  		 else if(rs.child("Errors").length()>0) {
		 	var errorInfoList : ArrayCollection = new ArrayCollection();
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);
		 } 
		 else {
		 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		 	detailTaxFeeList.removeAll(); 
		 	errPage.removeError(); 
		 }
  	}
  	
  }  
 /**
  * Method to call the editDetailTaxFee Method to edit the tax details.
  * It fills the request object with the index of detailTaxFeeList to be edited before sending the request.
  * @param data - Object of the detailtaxFeeList to be edited.
  */
  public function preEditFeeDetailHandler(data:Object):void {
    
        editFeeDetail.url = "cax/entitlementAdjustmentDispatch.action?";
        var reqObject:Object = new Object();
        reqObject.editIndexTaxFeeNo = this.detailTaxFeeList.getItemIndex(data);
        for each (var rec:Object in detailTaxFeeList) 
            rec.isVisible= false;
        reqObject.method= "editDetailTaxFee";
        editFeeDetail.request = reqObject;  
        editFeeDetail.send();
  }         
 
 /**
  * Method to set the detailTaxFeeList to show the summray list of the tax information after edited.
  * @param event - <ResultEvent> Object.  
  */ 
  public function postEditFeeDetailHandler(event:ResultEvent):void {
    
    if(!resultEventErrorHandler(event)) {
        
        detailTaxFeeList=new ArrayCollection();  
        var index:int=0;    
        this.amount.text = event.result.rightsDetailsActionForm.amount;
        this.rate.text= event.result.rightsDetailsActionForm.rate;
        this.rateType.text= event.result.rightsDetailsActionForm.rateType;
        this.taxFeeId.text = event.result.rightsDetailsActionForm.taxFeeId;
        this.editIndexTaxFeeNo = event.result.rightsDetailsActionForm.editIndexTaxFeeNo;
        
        //Setting values of tax Fee Id.
        var initcol:ArrayCollection = new ArrayCollection();
        if(event.result.rightsDetailsActionForm.taxFeeIdList!=null) {
            if(event.result.rightsDetailsActionForm.taxFeeIdList.taxFeeIdDropdownList is ArrayCollection){
                 initcol = event.result.rightsDetailsActionForm.taxFeeIdList.taxFeeIdDropdownList as ArrayCollection;
            } else {
                 initcol.addItem(event.result.rightsDetailsActionForm.taxFeeIdList.taxFeeIdDropdownList);
            }
            initcol.addItem("");
            for each(var item :String in initcol ){
                if(XenosStringUtils.equals(item, event.result.rightsDetailsActionForm.taxFeeId))
                    index = initcol.getItemIndex(item);           
            }
        }
        this.taxFeeId.dataProvider = initcol;
        this.taxFeeId.selectedIndex = index;
        
        // setting the detailTaxFeeList
        if(event.result.rightsDetailsActionForm.detailTaxFeeList!=null) {
            if(event.result.rightsDetailsActionForm.detailTaxFeeList.taxFeeList is ArrayCollection){
                 detailTaxFeeList = event.result.rightsDetailsActionForm.detailTaxFeeList.taxFeeList as ArrayCollection;                
            } else {
                 detailTaxFeeList.addItem(event.result.rightsDetailsActionForm.detailTaxFeeList.taxFeeList);
            }
        }
      detailTaxFeeList.refresh();
      
      // calling the  method to display the proper tax buton based on the editIndexTaxFeeNo
      taxButtonDisplay();
      
      // calling the method to set the tax fee requirement based on the rate type. 
      onChangeRateType();
    }   
  }
  /**
  * Method to call the deleteDetailTaxFee Method to edit the tax details.
  * It fills the request object with the index of detailTaxFeeList to be deleted before sending the request.
  * @param data  - Object of the detailtaxFeeList to be deleted.
  */
  public function preDeleteFeeDetailHandler(data:Object):void {
    
    deleteFeeDetail.url = "cax/entitlementAdjustmentDispatch.action?";
    var reqObject:Object = new Object();
    reqObject.editIndexTaxFeeNo = this.detailTaxFeeList.getItemIndex(data);
    reqObject.method= "deleteDetailTaxFee";
    deleteFeeDetail.request = reqObject;    
    deleteFeeDetail.send();     
  }
    
 /**
  * Method to set the detailTaxFeeList to show the summray list of the tax information after deleted.
  * @param event - <ResultEvent> Object.  
  */ 
  public function postDeleteFeeDetailHandler(event:ResultEvent):void {
    
    if(!resultEventErrorHandler(event)) {
        detailTaxFeeList=new ArrayCollection();
        
        // setting the detailTaxFeeList
        if(event.result.rightsDetailsActionForm.detailTaxFeeList!=null) {
            if(event.result.rightsDetailsActionForm.detailTaxFeeList.taxFeeList is ArrayCollection){
                 detailTaxFeeList = event.result.rightsDetailsActionForm.detailTaxFeeList.taxFeeList as ArrayCollection;                
            } else {
                 detailTaxFeeList.addItem(event.result.rightsDetailsActionForm.detailTaxFeeList.taxFeeList);
            }
        }
        for each (var rec:Object in detailTaxFeeList) { 
            rec.isVisible= true;
        }
        //Setting values of tax Fee Id.
        var initcol:ArrayCollection = new ArrayCollection();
        if(event.result.rightsDetailsActionForm.taxFeeIdList!=null) {
            if(event.result.rightsDetailsActionForm.taxFeeIdList.taxFeeIdDropdownList is ArrayCollection){
                 initcol = event.result.rightsDetailsActionForm.taxFeeIdList.taxFeeIdDropdownList as ArrayCollection;
            } else {
                 initcol.addItem(event.result.rightsDetailsActionForm.taxFeeIdList.taxFeeIdDropdownList);
            }
            initcol.addItem("");
            this.taxFeeId.dataProvider = initcol;
            this.taxFeeId.selectedIndex = initcol.length -1;
        }
    }   
  }
  
 /**
  * Method to dipaly the tax buttons ( ADD, CANCEL and SAVE) depending on the editIndexTaxFeeNo.
  */ 
  private function taxButtonDisplay():void {
    
    if(this.editIndexTaxFeeNo==-1) {
        this.buttonCancel.visible = false;
        this.buttonCancel.includeInLayout = false;
        this.buttonSave.visible = false;
        this.buttonSave.includeInLayout = false;
        this.buttonAdd.visible = true;
        this.buttonAdd.includeInLayout = true;
    } else {
        this.buttonCancel.visible = true;
        this.buttonCancel.includeInLayout = true;
        this.buttonSave.visible = true;
        this.buttonSave.includeInLayout = true;
        this.buttonAdd.visible = false;
        this.buttonAdd.includeInLayout = false;
    }
  }

 /**
  * Method to call the getCalculatedAmount method to calculate the allotted attributes for the entitlement.
  * It fills the request object with the index of detailTaxFeeList to be deleted (i.e the rowNUm)  before sending the request.
  */
  public function preCalculateHandler():void {
    if(XenosStringUtils.isBlank(this.securityBalanceStr.text)){
    	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cax.validate.secbalance.blank'));
    }else{
    	securityBalance.url = "cax/entitlementAdjustmentDispatch.action?";
	    var reqObject:Object = new Object();
	    reqObject.securityBalanceStr = this.securityBalanceStr.text;
	    reqObject.method= "getCalculatedAmount";
	    securityBalance.request = reqObject;    
	    securityBalance.send();   
    }
  }
  
  public function preBalanceHandler():void {
    if(XenosStringUtils.isBlank(this.inventoryAccountNo.accountNo.text)){
    	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cax.validate.accountno.blank'));
    }else{
	    accountBalance.url = "cax/entitlementAdjustmentDispatch.action?";
	    var reqObject:Object = new Object();
	    reqObject.accountNo = this.inventoryAccountNo.accountNo.text;
	    reqObject.method= "getSecurityBalanceForAccountNo";
	    accountBalance.request = reqObject;    
	    accountBalance.send();
    }     
  }
  
  public function postBalanceHandler(event:ResultEvent):void {
    
    if(!resultEventErrorHandler(event)) { 
        this.securityBalanceStr.text=event.result.rightsDetailsActionForm.securityBalanceStr;
    }
  }
  
    
 /**
  * Method to set the allotted attributes after the getCalculatedAmount method is called.
  * @param event - <ResultEvent> Object.  
  */ 
  public function postCalculateHandler(event:ResultEvent):void {
    
    if(!resultEventErrorHandler(event)) { 
        this.cashPart.allottedAmountStr.text=event.result.rightsDetailsActionForm.allottedAmountStr;
        this.cashPart.splAmountOrQtyStr.text = event.result.rightsDetailsActionForm.splAmountOrQtyStr;
        this.stockPart.splAmountOrQtyStr.text = event.result.rightsDetailsActionForm.splAmountOrQtyStr;
        this.stockPart.cashInLieuFlagExp.text=event.result.rightsDetailsActionForm.cashInLieuFlagExp;
        this.stockPart.allottedQuantityStr.text = event.result.rightsDetailsActionForm.allottedQuantityStr;
        this.stockPart.allottedAmountStr.text = event.result.rightsDetailsActionForm.allottedAmountStr;
        this.stockPart.fractionalShareStr.text = event.result.rightsDetailsActionForm.fractionalShareStr;
    }
  }
  
 /**
  * Method to call the getCalculatedAmount method to calculate the tax fee amount for the entitlement.
  * It fills the request object with the index of detailTaxFeeList to be deleted (i.e the rowNUm)  before sending the request.
  */
  public function preTaxAmountCalculateHandler():void {
    
    taxAmount.url = "cax/entitlementAdjustmentDispatch.action?";
    var reqObject:Object = new Object();
    reqObject.rate = this.rate.text;
    reqObject.rateType = this.rateType.text;
    reqObject.taxFeeId = this.taxFeeId.text;
    reqObject.method= "getCalculatedTaxFeeAmount";
    taxAmount.request = reqObject;  
    taxAmount.send();       
  }
    
 /**
  * Method to set the tax amount after getCalculatedTaxFeeAmount method is called.
  * @param event - <ResultEvent> Object.  
  */ 
  public function postTaxAmountCalculateHandler(event:ResultEvent):void {
    
    this.amount.text = event.result.rightsDetailsActionForm.amount;
  }

 /**
  * Method to handle errors returned by the ResultEvent.
  * @param ResultEvent - Event return the HttpRequest cntrls.
  * @return Boolean - true/false indicating if there is error in the result event.
  */ 
  private function resultEventErrorHandler(event:ResultEvent):Boolean {
    if(event.result.XenosErrors != null){
        var errorInfoList : ArrayCollection = new ArrayCollection();
        if(event.result.XenosErrors.Errors != null){
            if(event.result.XenosErrors.Errors.error is ArrayCollection){
                errorInfoList = event.result.XenosErrors.Errors.error as ArrayCollection;
            }else{
                errorInfoList.addItem(event.result.XenosErrors.Errors.error);
            }
        }
         errPage.showError(errorInfoList);
         return true;
    } else
        return false;
  }
  
 /**
  * This method populates the request parameters and bind the parameters with the HTTPService
  * @return object - Request Object filled with the data to be amended.
  */
  private function populateRequestParams():Object { 
    
    var reqObj : Object=new Object;
    reqObj.method= "submitRightsDetailsEntry";
    reqObj.SCREEN_KEY = "11171";
    reqObj.securityBalanceStr = this.securityBalanceStr.text;
    reqObj.accountNo = this.inventoryAccountNo.accountNo.text;
    reqObj.paymentDate = this.paymentDate.text;
    reqObj.underlineSecurityBV = this.underSecBv.text;
    if(isEditableFlag == true){
	    if(isIncomeFlag == true){
	    	reqObj.allottedInstrument = this.allotCcy.ccyText.text;
	    	reqObj.allottedInstrumentName = this.allottedInstrumentNameTxt.text;
	    }
	    if(isIncomeFlag == false){
	    	reqObj.allottedInstrument = this.allotSecurityCode.instrumentId.text;
	    	reqObj.allottedInstrumentName = this.allottedInstrumentNameTxt.text;
	    }
    }
    switch(this.corporateActionId) {
        
        case "CASH_DIVIDEND":
        case "CAPITAL_REPAYMENT":       
        case "OPTIONAL_STOCK_DIV":
        case "DIV_REINVESTMENT":
        case "COUPON_PAYMENT":
        case "REDEMPTION_BOND":                                     
            reqObj.allottedAmountStr = this.cashPart.allottedAmountStr.text;
            reqObj.splAmountOrQtyStr = this.cashPart.splAmountOrQtyStr.text;  
            reqObj.remarks = this.cashPart.remarks.text;    
            reqObj.giveUp = this.cashPart.giveUp.selectedItem != null ? this.cashPart.giveUp.selectedItem.value :"";
            reqObj.availableDate = this.cashPart.availableDate.text; 
            reqObj.finalizedFlag=(this.cashPart.finalizedflag.selectedItem!=null)?this.cashPart.finalizedflag.selectedItem.value:"";       
        break;
        case "STOCK_SPLIT":
        case "STOCK_DIVIDEND":
        case "BONUS_ISSUE":
        case "SPIN_OFF":
        case "NAME_CHANGE":
        case "REVERSE_STOCK_SPLIT":
        case "STOCK_MERGER":
        case "RIGHTS_ALLOCATION":
        case "OTHERS":
        case "RIGHTS_EXPIRY":
            reqObj.allottedQuantityStr = this.stockPart.allottedQuantityStr.text;
            reqObj.allottedAmountStr =  this.stockPart.allottedAmountStr.text;
            reqObj.fractionalShareStr = this.stockPart.fractionalShareStr.text; 
            reqObj.splAmountOrQtyStr =  this.stockPart.splAmountOrQtyStr.text;
            reqObj.remarks = this.stockPart.remarks.text; 
            reqObj.availableDate = this.stockPart.availableDate.text;  
            reqObj.finalizedFlag=(this.cashPart.finalizedflag.selectedItem!=null)?this.cashPart.finalizedflag.selectedItem.value:"";        
        break;
    }
    return reqObj;
  }

 /**
  * This method validates mandatory Tax Fee fields 
  * for cax rights detail amend when caxId is either CASH_DIVIDEND or COUPON_PAYMENT.
  * When this method is called when CANCEL button is clicked - no validation is required and therefore true is returned.
  * @param methodFlag - indicating for which method this validator is being called.
  * @return Boolean - True if there is no error and vice versa.
  */
  private function validateTaxFee(methodFlag : String): Boolean {  
    
    if(XenosStringUtils.equals(methodFlag,'CANCEL'))
        return true;
        
    var taxModel:Object= null; 
    switch(this.rateType.text) {
        case "PERCENT":     
            taxModel = {
                    tax:{
                         rateType:this.rateType.text,
                         taxFeeId:this.taxFeeId.text,
                         rate:this.rate.text                
                        }
                    };
        break;
        case "BP" :
            taxModel = {
                    tax:{
                         rateType:this.rateType.text,
                         taxFeeId:this.taxFeeId.text,
                         rate:this.rate.text                
                        }
                    };      
        break;
        case "CPS" :
            taxModel = {
                    tax:{
                         rateType:this.rateType.text,
                         taxFeeId:this.taxFeeId.text,  
                         rate:this.rate.text,
                         amount:this.amount.text                
                        }
                    };      
        break;
        case "AMOUNT" :
            taxModel = {
                    tax:{
                         rateType:this.rateType.text,
                         taxFeeId:this.taxFeeId.text,                      
                         amount:this.amount.text              
                        }
                    };      
        break;
        case "" :
            taxModel = {
                    tax:{
                         rateType:this.rateType.text,
                         taxFeeId:this.taxFeeId.text,
                         rate:this.rate.text,
                         amount:this.amount.text                
                        }
                    };  
        break;
    }
    var validator:AdjustmentValidator = new AdjustmentValidator();
    validator.source=taxModel;
    validator.property="tax"; 
    var validationResult:ValidationResultEvent = validator.validate();
    if(validationResult.type==ValidationResultEvent.INVALID){
         var errorMsg:String=validationResult.message;
         XenosAlert.error(errorMsg);
         return false;
    }
    return true;
  }
 /**
  * Method to set the validator to perform client side validation before sending the request to the server to perform amend operation. 
  */ 
  private function setValidator() : void {
    
    var adjustmentValidateModel : Object = {adjustmentValidate:
												  {securityBalanceStr:this.securityBalanceStr.text,
												  paymentDateStr:this.paymentDate.text,
												  accountNo:this.inventoryAccountNo.accountNo != null ? this.inventoryAccountNo.accountNo.text:""
												  }};
    super._validator = new AdjustmentValidator();
    super._validator.source=adjustmentValidateModel;
    super._validator.property="adjustmentValidate";
        
  }
  
  /**
  * This is the method to pass the Collection of data items
  * through the context to the account popup. This will be implemented as per specifdic  
  * requriment. 
  */
    private function populateInvActContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        //passing act type                
        var actTypeArray:Array = new Array(1);
            actTypeArray[0]="T|B";
            //cpTypeArray[1]="CLIENT";
        myContextList.addItem(new HiddenObject("invActTypeContext",actTypeArray));    
                  
        //passing counter party type                
        var cpTypeArray:Array = new Array(1);
            cpTypeArray[0]="INTERNAL";
            //cpTypeArray[1]="CLIENT";
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
    
        //passing account status                
        var actStatusArray:Array = new Array(1);
        actStatusArray[0]="OPEN";
        myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
        
        //passing inv prefix                
        var actInvPrefixArray:Array = new Array(1);
        actInvPrefixArray[0]="";
        myContextList.addItem(new HiddenObject("invPrefix",actInvPrefixArray));
        
        return myContextList;
    }
    
    private function onChangeSecurityCode(event:Event):void{
    	if(isIncomeFlag == true){
    		OnDataChangeUtil.onChangeSecurityCode(allottedInstrumentNameTxt,allotCcy.ccyText.text);
    	}else{
    		OnDataChangeUtil.onChangeSecurityCode(allottedInstrumentNameTxt,allotSecurityCode.instrumentId.text);
    	}
		
    }
    


    


        
                
                
            
