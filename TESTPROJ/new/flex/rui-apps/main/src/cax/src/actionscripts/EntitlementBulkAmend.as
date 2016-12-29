

import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.utils.*;

import mx.collections.ArrayCollection;
import mx.core.UIComponent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

/**
 * Array List to hold the item to be displayed.
 */
 private var keylist:ArrayCollection = new ArrayCollection();
[Bindable]
public var summaryResult:ArrayCollection= new ArrayCollection();
[Bindable]
public var selectedSummaryResult:ArrayCollection= new ArrayCollection();

private var selectedResults:ArrayCollection=new ArrayCollection(); 
//For check box
[Bindable]
public var selectAllBind:Boolean=false;
[Bindable]
public var caEventRefNo:String=null;
[Bindable]
public var eventType:String=null;
[Bindable]
public var secCode:String=null;
[Bindable]
public var allotSecCode:String=null;
[Bindable]
public var exDate:String=null;
[Bindable]
public var paymentDate:String=null;
[Bindable]
public var entryPk:String;
[Bindable]
public var securityCode:String=null;
[Bindable]
public var securityName:String=null;
[Bindable]
public var IntruPk:String=null;
[Bindable]
public var allottedSecurityCode:String=null;
[Bindable]
public var allotedSecurityName:String=null;
[Bindable]
public var allotedIntruPk:String=null;
[Bindable]
public var errorArray:ArrayCollection = null;
public var rowNum : ArrayCollection=new ArrayCollection();
[Bindable]
public var selectedRdArray : Array = new Array();
private var tempArray : Array = new Array();
private var rowNumArray : Array = new Array();
private var originalRowNumArrColl:ArrayCollection = new ArrayCollection();
private var n : int =0;
[Bindable]
public var allotQntyVar:Boolean=true;
[Bindable]
public var allotSecVar:Boolean=true;
[Bindable]
public var bookValAllotSecVar:Boolean=true;
[Bindable]
public var bookValUnderSecVar:Boolean=true;
[Bindable]
public var currentBookValVar:Boolean=true;
[Bindable]
public var fracShareVar:Boolean=true;
[Bindable]
public var grosAmntVar:Boolean=true;
[Bindable]
public var netAmntVar:Boolean=true;
[Bindable]
public var priceAllotSecVar:Boolean=true;
[Bindable]
public var priceUnderSecVar:Boolean=true;
[Bindable]
public var secBalVar:Boolean=true;
[Bindable]
public var taxAmntVar:Boolean=true;
[Bindable]
public var availableDtVar:Boolean=true;
[Bindable]public var finalizedFlagDropdownList:ArrayCollection=new ArrayCollection();
public var rowIndex:Array = new Array();
public var lmOfficeId:String="";
public var fundCategory:String="";


    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    *
    */
    private function loadAll():void {
    parseUrlString();    
    super.setXenosEntryControl(new XenosEntry());
    this.dispatchEvent(new Event('amendEntryInit'));
    }
    
    /**
    * This method will be called for parsing URL to retrieve the ca Event Pk.
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
        var params:Array = s.split("&");
         // Print the params that are in the Array.
        var keyStr:String;
        var valueStr:String;
        var paramObj:Object = params;

        // Set the values of the salutation.
        for (var i:int = 0; i < params.length; i++) {
            var tempA:Array = params[i].split("=");
            if (tempA[0] == "conditionPk") {
                entryPk = tempA[1];
            }
            else if (tempA[0] == "lmOfficeId") {
                    lmOfficeId = tempA[1];
            } else if (tempA[0] == "fundCategory") {
                    fundCategory = tempA[1];
            }
    	}
        //XenosAlert.info("condition pk "+entryPk);

    	} catch (e:Error) {
        trace(e);
    	}

	}
	/**
	 * 
	 * 
	 */
    override public function preAmendInit():void { 
	    super.getInitHttpService().url = "cax/entitlementBulkAmendDispatch.action?";
	    var reqObject:Object = new Object();
	    reqObject.method= "doSubmitEntry";
	    reqObject.SCREEN_KEY = "11167";
	    reqObject.conditionPk = this.entryPk;
	    reqObject['lmOfficeId'] = lmOfficeId;
	    reqObject['fundCategory'] = fundCategory;      
	    super.getInitHttpService().request = reqObject;
  	}
	  	
 /**
  * 
  * 
  */
  override public function preAmendResultInit():Object {
    populateKeyList();  
    return keylist;
  }
 
  /**
  * Method to populate the values of the keys added in the preAmendResultInit() to be shown in the Amend Entry UI.
  * @override 
  * @see com.nri.rui.core.containers.XenosEntryModule.postAmendResultInit
  */ 
  override public function postAmendResultInit(mapObj:Object): void {   
    populateData(mapObj,"AMEND"); 
    detailAmend.selectedChild = amend;  
  }

/**	
 * 
 */
  override public function preAmend():void {

    	super.getSaveHttpService().url = "cax/entitlementBulkAmendDispatch.action?";  
    	super.getSaveHttpService().method = "POST";
    	super.getSaveHttpService().request = populateRequestParams();
  }	
  
  /**
  * Method to add the list of keys (ids of the item) to be showed in the Amend User Confirmation UI.
  * In this case the key id has the name as that of the form attribute. 
  * @override 
  * @see com.nri.rui.core.containers.XenosEntryModule.preAmendResultHandler
  */
  override public function preAmendResultHandler():Object {
    populateKeyList();  
    return keylist
  }
  
   /**
  * Method to populate the values of the keys added in the preAmendResultHandler() to be shown in the Amend User Confirmation UI.
  * @override 
  * @see com.nri.rui.core.containers.XenosEntryModule.postAmendResultHandler
  */ 
  override public function postAmendResultHandler(mapObj:Object):void {

    if(mapObj!=null){    
        if( mapObj["errorFlag"].toString() == "error"){
            errPage.showError(mapObj["errorMsg"]);          
        }else if(mapObj["errorFlag"].toString() == "noError"){
            
            errPage.clearError(super.getSaveResultEvent()); 
            detailAmend.selectedChild = confirm;
            populateData(mapObj,"CONFIRM");
            
            
            
            
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
  * @see com.nri.rui.core.containers.XenosEntryModule.preAmendConfirm
  */
  override public function preAmendConfirm():void {
    
    var reqObj :Object = new Object();
    super.getConfHttpService().url = "cax/entitlementBulkAmendDispatch.action?";  
    super.getConfHttpService().method = "POST";
    reqObj.method= "doCommitEntry";
    reqObj.SCREEN_KEY = "11169";
    super.getConfHttpService().request = reqObj;
  }
  
   /**
  * Method to add the list of keys (ids of the item) to be showed in the Amend System Confirmation UI.
  * In this case the key id has the name as that of the form attribute. 
  * @override 
  * @see com.nri.rui.core.containers.XenosEntryModule.preConfirmAmendResultHandler
  */
  override public function preConfirmAmendResultHandler():Object {

    populateKeyList();  
    return keylist
  }
  
   /**
  * Method to populate the values of the keys added in the preAmendResultHandler() to be shown in the Amend User Confirmation UI.
  * @override 
  * @see com.nri.rui.core.containers.XenosEntryModule.postConfirmAmendResultHandler
  */ 
  override public function postConfirmAmendResultHandler(mapObj:Object):void {

    if(mapObj!=null){
            
        if( mapObj["errorFlag"].toString() == "error"){
            
            errPage2.showError(mapObj["errorMsg"]);      
            
        } else if(mapObj["errorFlag"].toString() == "noError"){
            
            errPage2.clearError(super.getSaveResultEvent()); 
            populateData(mapObj,"CONFIRM");
            hb.visible = true;
            hb.includeInLayout = true;
            sysconfBtn.visible = true;
            sysconfBtn.includeInLayout = true;
            ok.visible = false;
            ok.includeInLayout = false;
            back.visible = false;
            back.includeInLayout = false;
            this.confirmHeader.text = this.parentApplication.xResourceManager.getKeyValue('cax.sysconf.label');
            
                 
        } else {
            errPage.removeError();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred'));
        }
    }
  }
  
  
  /**
  * Method to call the resetRightsDetailsAmend Method to perform the reset operation on the entitlement which is amended.
  * This method set the URL for the Amend Entry UI after reset.
  * Sends the request to the server.
  * @override 
  * @see com.nri.rui.core.containers.XenosEntryModule.preAmendInit
  */
  override public function preResetAmend():void {

    var reqObj :Object = new Object();
    super.getResetHttpService().url = "cax/entitlementBulkAmendDispatch.action?";  
    reqObj.method= "doReset";
    super.getResetHttpService().request = reqObj;
  }
  
  
  /**
  * Method to populate data to be displayed.
  * @param mapObj - The keyList containg the key and the value.
  * 
  */ 
  private function populateData(mapObj:Object,screenName:String):void {
    
    this.caEventRefNo = mapObj[keylist.getItemAt(0)].toString();
    this.eventType = mapObj[keylist.getItemAt(1)].toString();
    if(mapObj[keylist.getItemAt(3)] != null){
    	this.secCode = mapObj[keylist.getItemAt(2)].toString() + "(" + mapObj[keylist.getItemAt(3)].toString() + ")";
    }else{
    	this.secCode = mapObj[keylist.getItemAt(2)].toString();
    }
    if(mapObj[keylist.getItemAt(5)] != null){
    	this.allotSecCode = mapObj[keylist.getItemAt(4)].toString() + "(" + mapObj[keylist.getItemAt(5)].toString() + ")";
    }else{
    	this.allotSecCode = mapObj[keylist.getItemAt(4)].toString();
    }
    this.paymentDate = mapObj[keylist.getItemAt(6)].toString();
    this.exDate = mapObj[keylist.getItemAt(7)].toString();
    
    this.priceAllot.text = "";
    this.priceUnder.text = "";
    
    if(screenName == "AMEND"){
    	errPage.clearError(super.getSaveResultEvent());
    	selectedResults.removeAll();
    	summaryResult.removeAll();
	    var rec:XML= new XML;
	    //check the selected records
	    selectAllBind = false;
	    if(mapObj[keylist.getItemAt(8)] != null) {    
		    for each(rec in mapObj[keylist.getItemAt(8)]){
				summaryResult.addItem(rec);
			}	     
		 }
		 if(summaryResult.length == 0){
		        XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		        summaryResult.removeAll(); // clear previous data if any as there is no result now.
		        errPage.removeError(); //clears the errors if any
		 }
		 resetSellection(summaryResult);
		finalizedFlagDropdownList=mapObj['entitlementPage.entitlementPageItem.finalizedFlagDropdownList.item'];
    }
	 if(screenName == "CONFIRM"){
	 	selectedSummaryResult.removeAll();
	 	 var rec1:XML= new XML;
	 	selectAllBind = false;
	    if(mapObj[keylist.getItemAt(10)] != null) {
		    for each(rec1 in mapObj[keylist.getItemAt(10)]){
				selectedSummaryResult.addItem(rec1);
			}	     
		 }
	 }
	 
	  if(mapObj[keylist.getItemAt(9)]!=null){
		 	editableCol((mapObj[keylist.getItemAt(9)] as ArrayCollection).getItemAt(0));
		 }
	 
  }
  
  /**
  * Method to add the key ids in the keylist
  */
  private function populateKeyList():void {
    
    keylist.addItem("caEventRefNo");       
    keylist.addItem("eventType");
    keylist.addItem("securityCode");
    keylist.addItem("securityName");
    keylist.addItem("allottedSecurityCode");
    keylist.addItem("allottedSecurityName"); 
    keylist.addItem("paymentDate"); 
    keylist.addItem("exDate"); 
    keylist.addItem("entitlementPage.entitlementPageItem");
    keylist.addItem("bulkAmendScreenLayout"); 
    keylist.addItem("selectedEntitlementPage.selectedEntitlementPageItem");    
    keylist.addItem("entitlementPage.entitlementPageItem.finalizedFlagDropdownList.item");    
  }
  
  /**
  * This method populates the request parameters and bind the parameters with the HTTPService
  * @return object - Request Object filled with the data to be amended.
  */
  private function populateRequestParams():Object { 
    
    var reqObj : Object=new Object;
    reqObj.method= "doConfirmEntry";
    reqObj.SCREEN_KEY = "11168";
    reqObj['bulkRowNoArray'] = selectedResults.toArray();
    for each(var rec:Object in this.summaryResult){
    	reqObj['entitlementPageInfo['+summaryResult.getItemIndex(rec)+'].allottedInstrument'] = rec.allottedInstrument;
    	reqObj['entitlementPageInfo['+summaryResult.getItemIndex(rec)+'].securityBalance'] = rec.securityBalance;
    	reqObj['entitlementPageInfo['+summaryResult.getItemIndex(rec)+'].allottedQuantity'] = rec.allottedQuantity;
    	reqObj['entitlementPageInfo['+summaryResult.getItemIndex(rec)+'].fractionalShare'] = rec.fractionalShare;
    	reqObj['entitlementPageInfo['+summaryResult.getItemIndex(rec)+'].grossAmount'] = rec.grossAmount;
    	reqObj['entitlementPageInfo['+summaryResult.getItemIndex(rec)+'].taxAmount'] = rec.taxAmount;
    	reqObj['entitlementPageInfo['+summaryResult.getItemIndex(rec)+'].netAmount'] = rec.netAmount;
    	reqObj['entitlementPageInfo['+summaryResult.getItemIndex(rec)+'].underlineSecurityPrice'] = rec.underlineSecurityPrice;
    	reqObj['entitlementPageInfo['+summaryResult.getItemIndex(rec)+'].allottedSecurityPrice'] = rec.allottedSecurityPrice;
    	reqObj['entitlementPageInfo['+summaryResult.getItemIndex(rec)+'].underlineSecurityBookValue'] = rec.underlineSecurityBookValue;
    	reqObj['entitlementPageInfo['+summaryResult.getItemIndex(rec)+'].allottedSecurityBookValue'] = rec.allottedSecurityBookValue;
    	reqObj['entitlementPageInfo['+summaryResult.getItemIndex(rec)+'].paymentDateStr'] = rec.paymentDateStr;
    	reqObj['entitlementPageInfo['+summaryResult.getItemIndex(rec)+'].availableDateStr'] = rec.availableDateStr;
    	reqObj['entitlementPageInfo['+summaryResult.getItemIndex(rec)+'].finalizedFlag'] = rec.finalizedFlag;
	}
    
    
    return reqObj;
  }
  
 
  	
  	private function submitAmend():void{
  		if(selectedResults.length == 0){
  			XenosAlert.info("Please select at least one record for Entitlement Amend");
  		} else{
  			if(setValidator()){
  			this.dispatchEvent(new Event('amendEntrySave'));
  			}
  		}
  	}
  	
  	private function doBack():void{
  		errPage.clearError(super.getSaveResultEvent());
  		errPage2.clearError(super.getSaveResultEvent()); 
  		selectedSummaryResult.removeAll();
        detailAmend.selectedChild = amend;
  	}
  	
  	
  	
    
    public function checkSelectToModify(item:Object):void {
        var i:Number;
        //var tempArray:Array = new Array();
        if(item.selected == true){
            selectedResults.addItem(item.rightsDetailPk);
    	}else { //needs to pop
    		for(i=0; i<selectedResults.length; i++){
    			if(selectedResults[i].rightsDetailPk != item.rightsDetailPk){
    			    selectedResults.removeItemAt(i);
    			}
    		}        		
    	}    
    	setIfAllSelected();    	    	
    }	
  	
  	    private function resetSellection(summaryResult:ArrayCollection):void{
    	for(var i:int=0;i<summaryResult.length;i++){
    		summaryResult[i].selected = false;
    		summaryResult[i].rowNum = i;
    	}
    }
    
    
    
    public function setIfAllSelected() : void {
    	if(isAllSelected()){
    		selectAllBind=true;
    	} else {
    		selectAllBind=false;
    	}
    }
    
    
    public function isAllSelected(): Boolean {
    	var i:Number = 0;
    	if(summaryResult == null){
    	 return false;
    	}
    	for(i=0; i<summaryResult.length; i++){
    		if(summaryResult[i].selected == false) {
        		return false;
        	}
    	}
    	if(i == summaryResult.length) {
    		return true;
         }else {
    		return false;
    	}
    }
    
       
// This as file contains code specific to the Check Box Selections.    
    
    public function selectAllRecords(flag:Boolean): void {
    	var i:Number = 0;
    	selectedResults.removeAll();
    	for(i=0; i<summaryResult.length; i++){
    		var obj:XML=summaryResult[i];
            obj.selected = flag;
            summaryResult[i]=obj;
            addOrRemove(summaryResult[i]);
    	}
    }
    
    public function addOrRemove(item:Object):void {
    	var i:Number;
        var tempArray:Array = new Array();
        if(item.selected == true){ 
            selectedResults.addItem(item.rightsDetailPk);
           
    	}else { //needs to pop
    		for(i=0; i<selectedResults.length; i++){
    			if(selectedResults[i].rightsDetailPk != item.rightsDetailPk){
    			    selectedResults.removeItemAt(i);
    			}
    		}     
    	}		
    }
  	
 /**
  * The method for maintain the editable fields for layout
  * 
  */
  private function editableCol(layout:Object):void {
			 	 if(XenosStringUtils.equals(layout.allottedQuantity,'N')){
			 	 	allotQntyVar = false;
			 	 }else{
			 	 	allotQntyVar = true;
			 	 }
			 	 if(XenosStringUtils.equals(layout.allottedSecurity,'N')){
			 	 	allotSecVar = false;
			 	 }else{
			 	 	allotSecVar = true;
			 	 }
			 	 if(XenosStringUtils.equals(layout.bookValue,'N')){
			 	 	bookValAllotSecVar = false;
			 	 	bookValUnderSecVar = false
			 	 	currentBookValVar = false;
			 	 }else{
			 	 	bookValAllotSecVar = true;
			 	 	bookValUnderSecVar = true;
			 	 	currentBookValVar = true;
			 	 }
			 	 if(XenosStringUtils.equals(layout.fractionalShare,'N')){
			 	 	fracShareVar = false;
			 	 }else{
			 	 	fracShareVar = true;
			 	 }
			 	 if(XenosStringUtils.equals(layout.grossAmount,'N')){
			 	 	grosAmntVar = false;
			 	 	netAmntVar = false;
			 	 }else{
			 	 	grosAmntVar = true;
			 	 	netAmntVar = true;
			 	 }
			 	 if(XenosStringUtils.equals(layout.price,'N')){
			 	 	priceAllotSecVar = false;
			 	 	priceUnderSecVar = false;
			 	 }else{
			 	 	priceAllotSecVar = true;
			 	 	priceUnderSecVar = true;
			 	 }
			 	 if(XenosStringUtils.equals(layout.securityBalance,'N')){
			 	 	secBalVar = false;
			 	 }else{
			 	 	secBalVar = true;
			 	 }
			 	 if(XenosStringUtils.equals(layout.taxAmount,'N')){
			 	 	taxAmntVar = false;
			 	 }else{
			 	 	taxAmntVar = true;
			 	 }
			 	 if(XenosStringUtils.equals(layout.availableDate,'N')){
			 	 	availableDtVar = false;
			 	 }else{
			 	 	availableDtVar = true;
			 	 }
  }
  
   	
  /**
  * Method to set the validator to perform client side validation before sending the request to the server to perform amend operation. 
  */ 
  private function setValidator():Boolean {  	
  	
    for each(var record:Object in this.summaryResult){
    	if(record.selected == true){
    		if(XenosStringUtils.isBlank(record.securityBalance) && (secBalVar == true)){
    			XenosAlert.error("Security Balance can not be blank");
    			return false;
    			
    		}
    		if(XenosStringUtils.isBlank(record.allottedInstrument) && (allotSecVar == true)){
    			XenosAlert.error("Alloted Security can not be blank");
    			return false;
    		}
    		if(XenosStringUtils.isBlank(record.allottedQuantity) && (allotQntyVar == true)){
    			XenosAlert.error("Alloted Quantity can not be blank");
    			return false;
    		}    		
    		if(XenosStringUtils.isBlank(record.grossAmount) && (grosAmntVar == true)){
    			XenosAlert.error("Gross Amount can not be blank");
    			return false;
    		}    		
   		    if(!XenosStringUtils.isBlank(record.underlineSecurityPrice) && (priceUnderSecVar == true)) {   		    
	   		    if((XenosStringUtils.isBlank(record.allottedSecurityPrice) && (priceAllotSecVar == true))
	   		       ||(XenosStringUtils.isBlank(record.allottedSecurityBookValue) && (bookValAllotSecVar == true))
	   		       ||(XenosStringUtils.isBlank(record.underlineSecurityBookValue) && (bookValUnderSecVar == true))){
	    			XenosAlert.error("Price and Book Value needs to be specified for both Underlying and Allotted Security.");
	    			return false;	
	   		      }   		    	
    		}
    		if(!XenosStringUtils.isBlank(record.allottedSecurityPrice) && (priceAllotSecVar == true)) {   		    
	   		    if((XenosStringUtils.isBlank(record.underlineSecurityPrice) && (priceUnderSecVar == true))
	   		       ||(XenosStringUtils.isBlank(record.allottedSecurityBookValue) && (bookValAllotSecVar == true))
	   		       ||(XenosStringUtils.isBlank(record.underlineSecurityBookValue) && (bookValUnderSecVar == true))){
	    			XenosAlert.error("Price and Book Value needs to be specified for both Underlying and Allotted Security.");
	    			return false;	
	   		      }   		    	
    		}
    		if(!XenosStringUtils.isBlank(record.allottedSecurityBookValue) && (bookValAllotSecVar == true)) {   		    
	   		    if((XenosStringUtils.isBlank(record.underlineSecurityPrice) && (priceUnderSecVar == true))
	   		       ||(XenosStringUtils.isBlank(record.allottedSecurityPrice) && (priceAllotSecVar == true))
	   		       ||(XenosStringUtils.isBlank(record.underlineSecurityBookValue) && (bookValUnderSecVar == true))){
	    			XenosAlert.error("Price and Book Value needs to be specified for both Underlying and Allotted Security.");
	    			return false;	
	   		      }   		    	
    		}
    		
    	}
    } return true;
        
  } 
  
  /**
   *Method for calculate book value of underlying security 
   *
   */  
  public function calculateUnderSecBookVal(data:Object):void{
	var reqObj:Object = new Object();
	var rowNo:int = summaryResult.getItemIndex(data);
	rowIndex.push(rowNo);
	if(XenosStringUtils.isBlank(data.allottedSecurityBookValue)){
		XenosAlert.error("Allotted Security book value should be calculated/entered before calculating the Underline Security Book Value");
	}else{
		reqObj.method = "getUnderlineSecurityBookValue";
		reqObj['rightsDetailPk'] = data.rightsDetailPk;
		reqObj['entitlementPageInfo['+rowNo+'].allottedSecurityBookValue'] = data.allottedSecurityBookValue;
		reqObj['entitlementPageInfo['+rowNo+'].currentBookValue'] = data.currentBookValue;
		reqObj.rnd = Math.random()+"";
		calculationBookValRequest.request = reqObj;
		calculationBookValRequest.send();
	}
	
  }

   /**
   *Method for calculate book value of underlying security 
   *
   */  
  public function calculateAllotSecBookVal(data:Object):void{
  	var rowNo:int = summaryResult.getItemIndex(data);
    rowIndex.push(rowNo);
    var reqObj:Object = new Object();
	if(XenosStringUtils.isBlank(data.allottedSecurityPrice)){
		XenosAlert.error("Allotted Security price should be entered before calculating the Alloted Security Book Value");
	}
	else if(XenosStringUtils.isBlank(data.underlineSecurityPrice)){
		XenosAlert.error("Underlying Security price should be entered before calculating the Alloted Security Book Value");
	}
	else if(XenosStringUtils.isBlank(data.currentBookValue)){
		XenosAlert.error("Current book value must be entered before calculating the Alloted Security Book Value");
	}else{
		reqObj.method = "getAllottedSecurityBookValue";
		reqObj['rightsDetailPk'] = data.rightsDetailPk;
		reqObj['entitlementPageInfo['+rowNo+'].allottedSecurityPrice'] = data.allottedSecurityPrice;
		reqObj['entitlementPageInfo['+rowNo+'].underlineSecurityPrice'] = data.underlineSecurityPrice;
    	reqObj['entitlementPageInfo['+rowNo+'].currentBookValue'] = data.currentBookValue;
  		reqObj['entitlementPageInfo['+rowNo+'].allottedInstrumentPK'] = data.allottedInstrumentPK;
		reqObj.rnd = Math.random()+"";
		calculationBookValRequest.request = reqObj;
		calculationBookValRequest.send();
	}
	
  }
    
  /**
   *Method for calculate book value of underlying security 
   *
   */  
  public function calculateGrossAmntOrAllotQnty(data:Object):void{
	var reqObj:Object = new Object();
	var rowNo:int = summaryResult.getItemIndex(data);
	rowIndex.push(rowNo);
		reqObj.method = "getAllottedAmountOrQuantity";
		reqObj['rightsDetailPk'] = data.rightsDetailPk;
		reqObj['entitlementPageInfo['+rowNo+'].allottedInstrumentPK'] = data.allottedInstrumentPK;
		reqObj['entitlementPageInfo['+rowNo+'].securityBalance'] = data.securityBalance;
		reqObj.rnd = Math.random()+"";
		calculationAmountOrQuantity.request = reqObj;
		calculationAmountOrQuantity.send();
  }
  
  /**
   *Method for calculate book value of underlying security 
   *
   */  
  public function calculateNetAmount(data:Object):void{
	var reqObj:Object = new Object();
	var rowNo:int = summaryResult.getItemIndex(data);
	rowIndex.push(rowNo);
	if(XenosStringUtils.isBlank(data.grossAmount)){
		XenosAlert.error("Gross amount should be entered before calculating the Net Amount");
	}else{
		reqObj.method = "getNetAmount";
		reqObj['rightsDetailPk'] = data.rightsDetailPk;
		reqObj['entitlementPageInfo['+rowNo+'].allottedInstrumentPK'] = data.allottedInstrumentPK;
		reqObj['entitlementPageInfo['+rowNo+'].taxAmount'] = data.taxAmount;
		reqObj['entitlementPageInfo['+rowNo+'].grossAmount'] = data.grossAmount;
		reqObj.rnd = Math.random()+"";
		calculationNetAmount.request = reqObj;
		calculationNetAmount.send();
	}
  }

 /**
  * Method to set the book value after calculation method is called.
  * @param event - <ResultEvent> Object.  
  */ 
  public function loadCalculatedBookVal(event:ResultEvent):void {
    
    if(event != null){
		if(event.result != null){
			if(event.result.entitlementActionForm != null){
				var summaryResultNew:ArrayCollection = new ArrayCollection();
				errPage.clearError(super.getInitResultEvent());
				if(event.result.entitlementActionForm.entitlementPage != null){
					if(event.result.entitlementActionForm.entitlementPage.entitlementPageItem != null){
    					if(event.result.entitlementActionForm.entitlementPage.entitlementPageItem is ArrayCollection){
	    					summaryResultNew = event.result.entitlementActionForm.entitlementPage.entitlementPageItem as ArrayCollection;
	    				}else{
	    					summaryResultNew.addItem(event.result.entitlementActionForm.entitlementPage.entitlementPageItem);
	    				}
	    				for each(var i:int in this.rowIndex){
	    					if((summaryResultNew.getItemAt(i)).allottedSecurityBookValue != null){
	    						(summaryResult.getItemAt(i)).allottedSecurityBookValue = (summaryResultNew.getItemAt(i)).allottedSecurityBookValue;
	    					}
	    					if((summaryResultNew.getItemAt(i)).underlineSecurityBookValue != null){
	    						(summaryResult.getItemAt(i)).underlineSecurityBookValue = (summaryResultNew.getItemAt(i)).underlineSecurityBookValue;
	    					}
	    				}
	    				summaryResult.refresh();
    				}
				}
			}else if(event.result.XenosErrors != null){
				errPage.clearError(super.getInitResultEvent());
				if(event.result.XenosErrors.Errors != null){
					if(event.result.XenosErrors.Errors.error != null){
						var errorInfoList : ArrayCollection = new ArrayCollection();
						if(event.result.XenosErrors.Errors.error is ArrayCollection){
	    					errorInfoList = event.result.XenosErrors.Errors.error as ArrayCollection;
	    				}else{
	    					errorInfoList.addItem(event.result.XenosErrors.Errors.error);
	    				}
					}
				}
				errPage.showError(errorInfoList);
			}else{
				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			}
		}else{
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		}
	}else{
		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	}
  }
  
 /**
  * Method to set the Amount or Quantity after calculateGrossAmnt method is called.
  * @param event - <ResultEvent> Object.  
  */ 
  public function loadGrossAmntOrQnty(event:ResultEvent):void {
    
    if(event != null){
		if(event.result != null){
			if(event.result.entitlementActionForm != null){
				var summaryResultNew:ArrayCollection = new ArrayCollection();
				errPage.clearError(super.getInitResultEvent());
				if(event.result.entitlementActionForm.entitlementPage != null){
					if(event.result.entitlementActionForm.entitlementPage.entitlementPageItem != null){
    					if(event.result.entitlementActionForm.entitlementPage.entitlementPageItem is ArrayCollection){
	    					summaryResultNew = event.result.entitlementActionForm.entitlementPage.entitlementPageItem as ArrayCollection;
	    				}else{
	    					summaryResultNew.addItem(event.result.entitlementActionForm.entitlementPage.entitlementPageItem);
	    				}
	    				for each(var i:int in this.rowIndex){
	    					if((summaryResultNew.getItemAt(i)).grossAmount != null){
	    						(summaryResult.getItemAt(i)).grossAmount = (summaryResultNew.getItemAt(i)).grossAmount;
	    					}
	    					if((summaryResultNew.getItemAt(i)).allottedQuantity != null){
	    						(summaryResult.getItemAt(i)).allottedQuantity = (summaryResultNew.getItemAt(i)).allottedQuantity;
	    					}
	    				}
	    					
	    				
	    				summaryResult.refresh();
    				}
				}
			}else if(event.result.XenosErrors != null){
				errPage.clearError(super.getInitResultEvent());
				if(event.result.XenosErrors.Errors != null){
					if(event.result.XenosErrors.Errors.error != null){
						var errorInfoList : ArrayCollection = new ArrayCollection();
						if(event.result.XenosErrors.Errors.error is ArrayCollection){
	    					errorInfoList = event.result.XenosErrors.Errors.error as ArrayCollection;
	    				}else{
	    					errorInfoList.addItem(event.result.XenosErrors.Errors.error);
	    				}
					}
				}
				errPage.showError(errorInfoList);
			}else{
				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			}
		}else{
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		}
	}else{
		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	}
  }
  
  /**
  * Method to set the Net Amount after calculation method is called.
  * @param event - <ResultEvent> Object.  
  */ 
  public function loadNetAmount(event:ResultEvent):void {
    
    if(event != null){
		if(event.result != null){
			if(event.result.entitlementActionForm != null){
				var summaryResultNew:ArrayCollection = new ArrayCollection();
				errPage.clearError(super.getInitResultEvent());
				if(event.result.entitlementActionForm.entitlementPage != null){
					if(event.result.entitlementActionForm.entitlementPage.entitlementPageItem != null){
    					if(event.result.entitlementActionForm.entitlementPage.entitlementPageItem is ArrayCollection){
	    					summaryResultNew = event.result.entitlementActionForm.entitlementPage.entitlementPageItem as ArrayCollection;
	    				}else{
	    					summaryResultNew.addItem(event.result.entitlementActionForm.entitlementPage.entitlementPageItem);
	    				}
	    				for each(var i:int in this.rowIndex){
	    					if((summaryResultNew.getItemAt(i)).netAmount != null){
	    						(summaryResult.getItemAt(i)).netAmount = (summaryResultNew.getItemAt(i)).netAmount;
	    					}
	    					
	    				}
	    				summaryResult.refresh();
    				}
				}
			}else if(event.result.XenosErrors != null){
				errPage.clearError(super.getInitResultEvent());
				if(event.result.XenosErrors.Errors != null){
					if(event.result.XenosErrors.Errors.error != null){
						var errorInfoList : ArrayCollection = new ArrayCollection();
						if(event.result.XenosErrors.Errors.error is ArrayCollection){
	    					errorInfoList = event.result.XenosErrors.Errors.error as ArrayCollection;
	    				}else{
	    					errorInfoList.addItem(event.result.XenosErrors.Errors.error);
	    				}
					}
				}
				errPage.showError(errorInfoList);
			}else{
				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			}
		}else{
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		}
	}else{
		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	}
  }
  
  /**
   * Initial state to remove the Popup after System confirmation
   */
   private function initialState():void{
    errPageOk.removeError();
    errPage2.removeError();
    errPageConf.removeError();
    // to call the submit query of ca event again.
    this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));    
    PopUpManager.removePopUp(UIComponent(this.parent.parent));
  }
  
  
  
  
 /**
  * Copy function for Underlying Security
  */ 
  private function copyUnderSecPrice():void {
   
    for(var i:int = 0; i < summaryResult.length; i++) {
            summaryResult[i].underlineSecurityPrice = this.priceUnder.text;
    }
    summaryResult.refresh();
  }
  
 /**
  * Copy function for Alloted Security
  */ 
  private function copyAllotSecPrice():void {
   
    for(var i:int = 0; i < summaryResult.length; i++) {
            summaryResult[i].allottedSecurityPrice = this.priceAllot.text;
    }
    summaryResult.refresh();
  }
    
    
   
    
    
    
    

