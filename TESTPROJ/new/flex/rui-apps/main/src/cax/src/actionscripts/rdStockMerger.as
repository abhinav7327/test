




import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.XenosStringUtils;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;
import mx.rpc.events.ResultEvent;


[Bindable]private var stockmergerinfoLabel:String="";
[Bindable]private var eventRefNoLabel:String="";
[Bindable]private var fundAccountLabel:String="";
[Bindable]private var securityCodeLabel:String="";
[Bindable]private var securityNameLabel:String="";
[Bindable]private var securityBalanceLabel:String="";
[Bindable]private var allottedQuantityLabel:String="";
[Bindable]private var allottedAmountLabel:String="";
[Bindable]private var fractionalShareLabel:String="";
[Bindable]private var cashInLieuFlagLabel:String="";
[Bindable]private var remarksLabel:String="";
[Bindable]private var detailReferenceNoLabel:String="";
[Bindable]private var screenMode:String="ENTRY";
[Bindable]private var availableDateLabel:String="";
[Bindable]private var paymentDateLabel:String="";
[Bindable]private var finalizedFlagLabel:String="";
[Bindable]private var finalizedFlagValues:ArrayCollection=new ArrayCollection();
/**
 * Array List to hold the item to be displayed.
 */
 private var keylist:ArrayCollection = new ArrayCollection();
 /**
  * To store the Rights Condition PK passed in the URL. 
  */
 [Bindable]private var rightsConditionPk : String = "";
 /**
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
 [Bindable]private var stockMergerInfoList:ArrayCollection = new ArrayCollection();
 [Bindable]private var detailReferenceNoVisibleFlag:Boolean=false;
 /**
  * This method is called at the time of loading the main page of the entitlement amend screen.
  * called at EntitlementAmend.mxml - creationComplete="loadAll()
  * This method calls the parseUrlString method to parse the URL
  * It fires the Event amendEntryInit to call the method doAmendInit.
  * 
  * @see com.nri.rui.core.containers.XenosEntryModule.doAmendInit 
  */
  public function loadAll():void {
  	loadTitleText();
    parseUrlString();    
    super.setXenosEntryControl(new XenosEntry());
    this.dispatchEvent(new Event('entryInit'));
  }

public function loadTitleText():void{
	stockmergerinfoLabel=this.parentApplication.xResourceManager.getKeyValue('cax.adjustment.entry.stockmergerinfo');
	eventRefNoLabel=this.parentApplication.xResourceManager.getKeyValue('cax.entitlement.label.eventRefNo');
	fundAccountLabel=this.parentApplication.xResourceManager.getKeyValue('cax.entitlement.label.fundAccount');
	securityCodeLabel=this.parentApplication.xResourceManager.getKeyValue('cax.entitlement.label.securityCode');
	securityNameLabel=this.parentApplication.xResourceManager.getKeyValue('cax.entitlement.label.securityName');
	securityBalanceLabel=this.parentApplication.xResourceManager.getKeyValue('cax.entitlement.label.securityBalance');
	allottedQuantityLabel=this.parentApplication.xResourceManager.getKeyValue('cax.entitlement.label.allottedQuantity');
	allottedAmountLabel=this.parentApplication.xResourceManager.getKeyValue('cax.entitlement.label.allottedAmount');
	fractionalShareLabel=this.parentApplication.xResourceManager.getKeyValue('cax.entitlement.label.fractionalShare');
	cashInLieuFlagLabel=this.parentApplication.xResourceManager.getKeyValue('cax.entitlement.label.cashInLieuFlag');
	remarksLabel=this.parentApplication.xResourceManager.getKeyValue('cax.entitlement.label.remarks');
	detailReferenceNoLabel=this.parentApplication.xResourceManager.getKeyValue('cax.label.reference.no');
	availableDateLabel=this.parentApplication.xResourceManager.getKeyValue('cax.rightsdetail.label.availabledate');
	paymentDateLabel=this.parentApplication.xResourceManager.getKeyValue('cax.rightsdetail.label.paymentdate');
	finalizedFlagLabel=this.parentApplication.xResourceManager.getKeyValue('cax.rightsdetail.label.finalizedflag');
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
    keylist.addItem("Errors.error");
    return keylist;
  }
  
 /**
  * Method to populate the values of the keys added in the preAmendResultInit() to be shown in the Amend Entry UI.
  * @override 
  * @see com.nri.rui.core.containers.XenosEntryModule.postAmendResultInit
  */ 
  override public function postEntryResultInit(mapObj:Object): void {   
    populateData(mapObj,"ENTRY");  
    resetAvailableDate(); 
  }
  
 /**
  * Method to call the submitRightsDetailsAmend Method to view the details of the entitlement amended.
  * This method set the URL for the Amend Confirmation UI.
  * Populates the request object with the values modified and send the request to the server.
  * @override 
  * @see com.nri.rui.core.containers.XenosEntryModule.preAmendInit
  */
  override public function preEntry():void {
  
	super.getSaveHttpService().url = "cax/entitlementAdjustmentDispatch.action?";  
	super.getSaveHttpService().method="POST";
	super.getSaveHttpService().request = populateRequestParams();
    
  }
  
  private function validateEntry():Boolean{  	
  
 	var index:int=0;
 	var errorMsg:String=""; 	
 	for each(var item:Object in stockMergerInfoList){
 		if(XenosStringUtils.isBlank(this.inventoryAccountNo[index].accountNo.text)){
 			errorMsg+="- Fund Account No. in Stock Merger Info. #"+(index+1)+" cannot be empty.\n";
 		}
 		if(XenosStringUtils.isBlank(this.securityBalanceStr[index].text)){
 			errorMsg+="- Security Balance in Stock Merger Info. #"+(index+1)+" cannot be empty.\n";
 		}
 		
 		if(XenosStringUtils.isBlank(this.paymentDate[index].text)){
 			errorMsg+="- Payment Date in Stock Merger Info. #"+(index+1)+" cannot be empty.\n";
 		}
 		else{
	 		if(!DateUtils.isValidDate(this.paymentDate[index].text)){
	 			errorMsg+="- Payment Date in Stock Merger Info. #"+(index+1)+" is invalid.\n";
	 		}
	 	}
 		if(!XenosStringUtils.isBlank(this.availableDate[index].text)){
	 		if(!DateUtils.isValidDate(this.availableDate[index].text)){
	 			errorMsg+="- Available Date in Stock Merger Info. #"+(index+1)+" is invalid.\n";
	 		}
	 	}
 		 index++; 		 
 	}
 	
 	if(XenosStringUtils.isBlank(errorMsg)){ 		
 		return true;
 	}
 	else{
 		XenosAlert.error(errorMsg);
 		return false;
 	}
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
            screenMode='CONFIRM';
            populateData(mapObj,"CONFIRM");
            this.uConfLabel.visible = true;
            this.uConfLabel.includeInLayout = true;
          
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
           	
           	this.detailReferenceNoVisibleFlag=true;
           	
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
            this.confBackBtn.visible=false;
            this.confBackBtn.includeInLayout=false;
            this.confBtn.visible = false;
            this.confBtn.includeInLayout = false;
            this.submitBtn.visible = true;
            this.submitBtn.includeInLayout = true;
            this.resetBtn.visible = true;
            this.resetBtn.includeInLayout = true;
            screenMode='ENTRY';
//            this.backBtn.visible = true;
//            this.backBtn.includeInLayout = true;
           
        break;
    }        
  }
 
 /**
  * Method to add the key ids in the keylist
  */
  private function populateKeyList():void {
    keylist=new ArrayCollection();
    //keylist.addItem("rdReferenceNo");
    keylist.addItem("rcReferenceNo");
    keylist.addItem("corporateActionId");
    keylist.addItem("conditionStatus");    
    keylist.addItem("allottedInstrument");
    keylist.addItem("allottedInstrumentName");  
    keylist.addItem("hiddenCashInLieuFlag");
    keylist.addItem("stockEntryArray.rightsDetailStockPart"); 
    keylist.addItem("finalizedFlagDropdownList.item");
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
    
    this.rcReferenceNo.text="";
    this.subEventTypeDescription.text="";
    this.conditionStatus.text="";
    this.allottedInstrument.text="";
    this.allottedInstrumentName.text="";
   
    stockMergerInfoList=mapObj['stockEntryArray.rightsDetailStockPart'];
    stockMergerInfoList.refresh();   
  
    this.rcReferenceNo.text=mapObj['rcReferenceNo'].toString();
    this.subEventTypeDescription.text=mapObj['corporateActionId'].toString();
    this.conditionStatus.text=mapObj['conditionStatus'].toString();
    this.allottedInstrument.text=mapObj['allottedInstrument'].toString();
    this.allottedInstrumentName.text=mapObj['allottedInstrumentName'].toString();
    finalizedFlagValues=mapObj['finalizedFlagDropdownList.item'];
    //this.rdReferenceNo==mapObj['rdReferenceNo'].toString();
    
    populateStockMergerInfo();
   /*  // loadng the child part based on the screen type.
    switch(screenType) {
        case "ENTRY":
        var editable:String = mapObj[keylist.getItemAt(28)].toString();
        var isIncome:String = mapObj[keylist.getItemAt(29)].toString();
        
        editableAllotSec(mapObj,editable,isIncome);
            loadCashPart(mapObj);
            loadStockPart(mapObj);               
        break;
        case "CONFIRM":         
            loadCashPartConfirm(mapObj);
            loadStockPartConfirm(mapObj);
        break;
    }    */

  
  }
 
   
  public function preBalanceHandler(obj:Object):void {
  	var index:int=stockMergerInfoList.getItemIndex(obj);
    if(XenosStringUtils.isBlank(this.inventoryAccountNo[index].accountNo.text)){
    	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cax.validate.accountno.blank'));
    }else{
	    accountBalance.url = "cax/entitlementAdjustmentDispatch.action?";
	    var reqObject:Object = saveRequestParams();	    
	    reqObject.index=index;
	    reqObject.method= "getSecurityBalanceForAccountNo";
	    accountBalance.request = reqObject;    
	    accountBalance.send();
    }     
  }
  
  public function postBalanceHandler(event:ResultEvent):void {
    var rs:XML=XML(event.result);
    if(!resultEventErrorHandler(rs)) { 
    	stockMergerInfoList.removeAll();
    	for each(var item:Object in rs.stockEntryArray.rightsDetailStockPart){
    		stockMergerInfoList.addItem(item);
    	}    
    	//stockMergerInfoList.refresh(); 
    	populateStockMergerInfo();
    }
  }

/**
  * Method to call the getCalculatedAmount method to calculate the allotted attributes for the entitlement.
  * It fills the request object with the index of detailTaxFeeList to be deleted (i.e the rowNUm)  before sending the request.
  */
  public function preCalculateHandler(obj:Object):void {
  	var index:int=stockMergerInfoList.getItemIndex(obj);
  	
    if(XenosStringUtils.isBlank(this.securityBalanceStr[index].text)){
    	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cax.validate.secbalance.blank'));
    }else{
    	securityBalance.url = "cax/entitlementAdjustmentDispatch.action?";
	    var reqObject:Object = saveRequestParams();	
	    reqObject.index=index;  
	    reqObject.method= "getCalculatedAmount";
	    securityBalance.request = reqObject;    
	    securityBalance.send();   
    }
  }
  
    
 /**
  * Method to set the allotted attributes after the getCalculatedAmount method is called.
  * @param event - <ResultEvent> Object.  
  */ 
  public function postCalculateHandler(event:ResultEvent):void {
    
   var rs:XML=XML(event.result);
    if(!resultEventErrorHandler(rs)) { 
    	stockMergerInfoList.removeAll();
    	
    	for each(var item:Object in rs.stockEntryArray.rightsDetailStockPart){
    		stockMergerInfoList.addItem(item);    		
    	}    
    	//stockMergerInfoList.refresh(); 
    	populateStockMergerInfo();
    }
  }
  
 	
 /**
  * Method to handle errors returned by the ResultEvent.
  * @param ResultEvent - Event return the HttpRequest cntrls.
  * @return Boolean - true/false indicating if there is error in the result event.
  */ 
  private function resultEventErrorHandler(rs:XML):Boolean {
  	if(rs!=null){  		
			if(rs.child("Errors").length()>0) {
				var errorInfoList : ArrayCollection = new ArrayCollection();                		 	
			 	for each ( var error:XML in rs.Errors.error ) {
	 			   errorInfoList.addItem(error.toString());
				}
			 	errPage.showError(errorInfoList);
			 			
         		return true;
         		
			}
  	}
  	else{
  		return true;
  	}
  	
  	errPage.removeError();
    return false;  	
  }
  
 /**
  * This method populates the request parameters and bind the parameters with the HTTPService
  * @return object - Request Object filled with the data to be amended.
  */
  private function populateRequestParams():Object { 
    
    var reqObj : Object=saveRequestParams();
    reqObj.method= "submitRightsDetailsEntry";
    reqObj.SCREEN_KEY = "11171";
   
    return reqObj;
  }
/**
  * This method populates the request parameters.
  * @return object - Request Object filled with the data to be amended.
  */
 private function saveRequestParams():Object { 
 	var reqObject : Object=new Object;
 	var index:int=0;
 	for each(var item:Object in stockMergerInfoList){
 		 reqObject['stockEntryArray['+index+'].accountNo'] = this.inventoryAccountNo[index].accountNo.text;
 		 reqObject['stockEntryArray['+index+'].securityBalanceStr'] = this.securityBalanceStr[index].text;
 		 reqObject['stockEntryArray['+index+'].allottedQuantityStr'] = this.allottedQuantityStr[index].text;
 		 reqObject['stockEntryArray['+index+'].allottedAmountStr'] = this.allottedAmountStr[index].text;
 		 reqObject['stockEntryArray['+index+'].fractionalShareStr'] = this.fractionalShareStr[index].text;
 		 reqObject['stockEntryArray['+index+'].remarks'] = this.remarks[index].text;
 		 reqObject['stockEntryArray['+index+'].availableDate']=this.availableDate[index].text;
 		 reqObject['stockEntryArray['+index+'].paymentDate']=this.paymentDate[index].text; 
 		 reqObject['stockEntryArray['+index+'].finalizedFlag']=(this.finalizedflag[index].selectedItem!=null)?this.finalizedflag[index].selectedItem.value:""; 		 
 		 index++; 		 
 	}
 	
 	return reqObject;
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
      
     /**
     *  Method to set fund account no. and allotted qty.str
     **/
	private function populateStockMergerInfo() : void {
		var index:int=0;
		for each(var item:Object in stockMergerInfoList){
			inventoryAccountNo[index].accountNo.text=item.accountNo ;
			paymentDate[index].text=(XML(item).child("paymentDate").length()>0)?item.paymentDate:"";
			availableDate[index].text=(XML(item).child("availableDate").length()>0)?item.availableDate:"";
			
			var indx:int=0; 
			finalizedflag[index].selectedIndex=indx;  
		    for each(var obj:Object in finalizedFlagValues){
		    	if(obj['value'].toString()==item['finalizedFlag'].toString()){	
		    		finalizedflag[index].selectedIndex=indx;	    		
		    		break;
		    	}
		    	indx++;
		    }
		    
			
			if(XenosStringUtils.equals(item.hiddenCashInLieuFlag,"Y")) {	        
		       allottedQuantityStr[index].text ="";
		       allottedQuantityStr[index].editable = false;
		       allottedAmountStr[index].editable = true;
		    } else {
		       allottedQuantityStr[index].editable = true;
		       allottedAmountStr[index].editable = false;
		       allottedAmountStr[index].text="";
		    }
		    index++; 
		}
		
		//stockMergerInfoList.refresh();
	} 

    private function doSubmit():void{
		if(validateEntry()){
			this.dispatchEvent(new Event('entrySave'))
		}		
    }
                
    private function resetAvailableDate():void{
    	var index:int=0;
		for each(var item:Object in stockMergerInfoList){
			paymentDate[index].text="";
			availableDate[index].text="";
			index++;
		}
    }      
            
