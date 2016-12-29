// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.swp.validator.MarketValueEntryValidator;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.containers.TitleWindow;
import mx.events.CloseEvent;
import mx.rpc.events.ResultEvent;
      
[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
[Bindable]private var mode : String = "ENTRY";
[Bindable]private var marketValuePkStr : String = "";
[Bindable]public var marketValueEntryList:ArrayCollection = new ArrayCollection();
[Bindable]public var marketValueEntryConfirmList:ArrayCollection = new ArrayCollection();
[Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();

private var keylist:ArrayCollection = new ArrayCollection();
private var arrCalculationTypeList:ArrayCollection = new ArrayCollection();
private var arrExchangeRateTypeBaseCcyList:ArrayCollection = new ArrayCollection();
      
private function changeCurrentState():void
{   
    vstack.selectedChild = rslt;
}
    
public function loadAll():void
{
    parseUrlString();
    super.setXenosEntryControl(new XenosEntry());
    
    if(this.mode == 'ENTRY')
    {
        this.dispatchEvent(new Event('entryInit'));     
        vstack.selectedChild = qry;
    }else if(this.mode == 'AMEND')
    {
        this.dispatchEvent(new Event('amendEntryInit'));        
        vstack.selectedChild = qry;
    } else { 
        this.dispatchEvent(new Event('cancelEntryInit'));
    }
}
           
/**
 * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
 * 
 */
public function parseUrlString():void
{
    try {
        // Remove everything before the question mark, including the question mark.
        var myPattern:RegExp = /.*\?/; 
        var s:String = this.loaderInfo.url.toString();
        //XenosAlert.info("Load Url : "+ this.loaderInfo.url.toString());
        s = s.replace(myPattern, "");
        // Create an Array of name=value Strings.
        var params:Array = s.split(Globals.AND_SIGN); 
         // Print the params that are in the Array.
        var keyStr:String;
        var valueStr:String;
        var paramObj:Object = params;
      
        // Set the values of the salutation.
        if(params != null){
            for (var i:int = 0; i < params.length; i++) {
                var tempA:Array = params[i].split("=");  
                if (tempA[0] == "modeOfOperation"){                
                    mode = tempA[1];               
                }else if(tempA[0] == "marketValuePk"){
                    this.marketValuePkStr = tempA[1];
                } 
            }                       
        }else{
            mode = "ENTRY";
        }                 
    
    } catch (e:Error) {
        trace(e);
    }
}
            
override public function preEntryInit():void
{               
    var rndNo:Number= Math.random(); 
    super.getInitHttpService().url = "swp/marketValueDispatchAction.action?method=loadEntry&mode=entry&&menuType=Y&rnd=" + rndNo;
}
             
override public function preAmendInit():void
{     
    initLabel.text = "Swap Market Value Amend";          
    var rndNo:Number= Math.random(); 
    super.getInitHttpService().url = "swp/marketValueAmendDispatchAction.action?";
    var reqObject:Object = new Object();
    reqObject.rnd = rndNo;
    reqObject.method= "doView";
    reqObject.modeOfOperation = this.mode;  
    reqObject.marketValuePkStr = this.marketValuePkStr;
    reqObject.SCREEN_KEY = "99992";
    super.getInitHttpService().request = reqObject; 
}
            
override public function preCancelInit():void
{
    this.back.includeInLayout = false;
    this.back.visible = false;
    changeCurrentState();                              
    var rndNo:Number= Math.random(); 
    super.getInitHttpService().url = "swp/marketValueCancelDispatchAction.action?";
    var reqObject:Object = new Object();
    reqObject.rnd = rndNo;
    reqObject.method= "doView";
    reqObject.modeOfOperation = this.mode;
    reqObject.marketValuePkStr = this.marketValuePkStr;
    reqObject.SCREEN_KEY = "99993"; 
    super.getInitHttpService().request = reqObject;
}
        
private function addCommonKeys():void
{          
    keylist = new ArrayCollection();
    
    keylist.addItem("marketValueObj.contractReferenceNo");
    keylist.addItem("marketValueObj.marketValueStr");
    keylist.addItem("marketValueObj.ccyCode");
    keylist.addItem("marketValueObj.baseDateStr");
    
}
        
override public function preEntryResultInit():Object
{
    addCommonKeys(); 
    return keylist;
}
        
override public function preAmendResultInit():Object
{
    addCommonKeys();
    keylist.addItem("marketValueObj.contractReferenceNo");
    keylist.addItem("marketValueObj.marketValueStr");
    keylist.addItem("marketValueObj.ccyCode");
    keylist.addItem("marketValueObj.baseDateStr"); 
    return keylist;
}
        
override public function preCancelResultInit():Object
{
    addCommonResultKeys();          
    return keylist;
}
        
private function commonInit(mapObj:Object):void
{
    errPage.clearError(super.getInitResultEvent());
    
    this.contractReferenceNo.referenceNo.text = XenosStringUtils.EMPTY_STR;
    this.currency.ccyText.text = XenosStringUtils.EMPTY_STR;
    this.marketValue.text = XenosStringUtils.EMPTY_STR;
    this.baseDate.text = XenosStringUtils.EMPTY_STR;
}
        
override public function postEntryResultInit(mapObj:Object): void
{
	marketValueEntryConfirmList.removeAll();
    app.submitButtonInstance = submit;
    commonInit(mapObj);
}
        
override public function postAmendResultInit(mapObj:Object): void
{
    app.submitButtonInstance = submit;
    commonInit(mapObj);
    this.contractReferenceNo.referenceNo.text = mapObj[keylist.getItemAt(0)] != null ? mapObj[keylist.getItemAt(0)].toString() : "";
    this.marketValue.text = mapObj[keylist.getItemAt(1)] != null ? mapObj[keylist.getItemAt(1)].toString() : "";
    this.currency.ccyText.text = mapObj[keylist.getItemAt(2)] != null ? mapObj[keylist.getItemAt(2)].toString() : "";
    this.baseDate.text = mapObj[keylist.getItemAt(3)] != null ? mapObj[keylist.getItemAt(3)].toString() : "";    
}
        
private function commonResultPart(mapObj:Object):void
{
	var i:int = 4;
	marketValueEntryConfirmList.removeAll();
    var item:Object = new Object();    
    if(mapObj[keylist.getItemAt(i)]!=null){
        if(mapObj[keylist.getItemAt(i)] is ArrayCollection){
            for each(item in (mapObj[keylist.getItemAt(i)] as ArrayCollection)){
                marketValueEntryConfirmList.addItem(item);
            }
        }else{
            marketValueEntryConfirmList.addItem(mapObj[keylist.getItemAt(i)]);
        }
    }        
}
        
override public function postCancelResultInit(mapObj:Object): void
{      
    commonResultPart(mapObj);
    uConfLabel.text=this.parentApplication.xResourceManager.getKeyValue('swp.swpmarketvaluecancel.label.title');
    uConfSubmit.includeInLayout = false;
    uConfSubmit.visible = false;
    cancelSubmit.visible = true;
    cancelSubmit.includeInLayout = true;
    app.submitButtonInstance = cancelSubmit;
}
        
private function addCommonResultKeys():void
{
    keylist = new ArrayCollection();
    keylist.addItem("marketValueObj.contractReferenceNo");
    keylist.addItem("marketValueObj.marketValueStr");
    keylist.addItem("marketValueObj.ccyCode");
    keylist.addItem("marketValueObj.baseDateStr");
    keylist.addItem("marketValueList.marketValueList");
}
        
private function commonResult(mapObj:Object):void
{  
    if(mapObj!=null){           
        if(mapObj["errorFlag"].toString() == "error"){
            //result = mapObj["errorMsg"] .toString();
            if(mode != "CANCEL"){
              errPage.showError(mapObj["errorMsg"]);                        
            }else{
                XenosAlert.error(mapObj["errorMsg"] + "Error......");
            }
        }else if(mapObj["errorFlag"].toString() == "noError"){
            
         errPage.clearError(super.getSaveResultEvent());                            
         commonResultPart(mapObj);
         changeCurrentState();
         app.submitButtonInstance = uConfSubmit;    
        }else{
            errPage.removeError();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.datanotfound'));
        }           
    }
}
        
private function setValidator():void
{	
    var validateModel:Object={
        marketValueEntry:{
        	 contractReferenceNo: this.contractReferenceNo.referenceNo.text,                          
             baseDate:this.baseDate.text,
             marketValue:this.marketValue.text,
             currency:this.currency.ccyText.text
        }
       }; 
     super._validator = new MarketValueEntryValidator();
     super._validator.source = validateModel ;
     super._validator.property = "marketValueEntry"; 
}
         
override public function preEntry():void
{   
    //setValidator();
    super.getSaveHttpService().url = "swp/marketValueDispatchAction.action?";  
    super.getSaveHttpService().request = populateRequestParams();
}
         
override public function preAmend():void
{
    setValidator();
    super.getSaveHttpService().url = "swp/marketValueAmendDispatchAction.action?";  
    super.getSaveHttpService().request  =populateRequestParams();
}
          
override public function preCancel():void
{
    setValidator();    
    super._validator = null;
    super.getSaveHttpService().url = "swp/marketValueCancelDispatchAction.action?"; 
    var reqObj:Object = new Object();
    reqObj.method="submitCancel";
    reqObj.mode=this.mode;
    super.getSaveHttpService().request  =reqObj;
}
         
override public function preEntryResultHandler():Object
{   
    addCommonResultKeys();
    return keylist;
}
        
override public function preAmendResultHandler():Object
{
    addCommonResultKeys();
    return keylist;
}
        
override public function postCancelResultHandler(mapObj:Object):void
{   
    if(submitUserConfResult(mapObj))
    {
        uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('swp.swpmarketvaluecancel.label.userconfirm');
        uConfLabel.includeInLayout = true;
        uConfLabel.visible = true;
        cancelSubmit.visible = false;
        cancelSubmit.includeInLayout = false;
        uCancelConfSubmit.visible = true;
        uCancelConfSubmit.includeInLayout = true;
        app.submitButtonInstance = uCancelConfSubmit;
        sConfSubmit.includeInLayout = false;
        sConfSubmit.visible = false;
        sConfLabel.includeInLayout = false;
        sConfLabel.visible = false;
    }
}
        
override public function postEntryResultHandler(mapObj:Object):void
{   
    commonResult(mapObj);
}
        
override public function postAmendResultHandler(mapObj:Object):void
{
    commonResult(mapObj);
    app.submitButtonInstance = uConfSubmit;
    uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('swp.swpmarketvalueamend.label.userconfirm');
}
        
override public function preEntryConfirm():void
{
    var reqObj :Object = new Object();
    super.getConfHttpService().url = "swp/marketValueDispatchAction.action?";  
    reqObj.method= "confirm";   
    super.getConfHttpService().request = reqObj;
}
        
override public function preAmendConfirm():void
{
    var reqObj :Object = new Object();
    super.getConfHttpService().url = "swp/marketValueAmendDispatchAction.action?";  
    reqObj.method= "confirm";
    super.getConfHttpService().request = reqObj;
}
        
override public function preCancelConfirm():void
{
    var reqObj :Object = new Object();
    super.getConfHttpService().url = "swp/marketValueCancelDispatchAction.action?";  
    reqObj.method= "confirm";
    super.getConfHttpService().request = reqObj;
}
        
override public function postConfirmEntryResultHandler(mapObj:Object):void
{
    submitUserConfResult(mapObj);
}
        
override public function postConfirmAmendResultHandler(mapObj:Object):void
{
    if(submitUserConfResult(mapObj))
        sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('swp.swpmarketvalueamend.label.systemconfirm');
}

override public function postConfirmCancelResultHandler(mapObj:Object):void
{
    if(submitUserConfResult(mapObj))
    {
        sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('swp.swpmarketvaluecancel.label.systemconfirm');
        if(this.mode != "ENTRY") {
          var titleWinInstance:TitleWindow = TitleWindow(this.parent.parent);
          titleWinInstance.showCloseButton = false;
          titleWinInstance.invalidateDisplayList();
        }
        cancelSubmit.visible = false;
        cancelSubmit.includeInLayout = false;
        uCancelConfSubmit.visible = false;
        uCancelConfSubmit.includeInLayout = false;
        uConfLabel.includeInLayout = false;
        uConfLabel.visible = false;
    }
}
        
private function submitUserConfResult(mapObj:Object):Boolean
{
    if(mapObj!=null){
        if(mapObj["errorFlag"].toString() == "error"){
            XenosAlert.error(mapObj["errorMsg"].toString());        
        }else if(mapObj["errorFlag"].toString() == "noError"){
            if(mode!="CANCEL")
              errPage.clearError(super.getConfResultEvent());
           this.back.includeInLayout = false;
           this.back.visible = false;
           uConfSubmit.enabled = true;  
           uConfLabel.includeInLayout = false;
           uConfLabel.visible = false;
           uConfSubmit.includeInLayout = false;
           uConfSubmit.visible = false;
           sConfLabel.includeInLayout = true;
           sConfLabel.visible = true;
           sConfSubmit.includeInLayout = true;
           sConfSubmit.visible = true; 
           sysConfMessage.includeInLayout=true;   
           sysConfMessage.visible=true;
           app.submitButtonInstance = sConfSubmit;
           return true;
        }else{
        	XenosAlert.info("55");
            errPage.removeError();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.erroroccurred'));
        }           
    }
    return false;
}
    
/**
* This method will populate the request parameters for the
* submitQuery call and bind the parameters with the HTTPService
* object.
*/
private function populateRequestParams():Object
{
    var reqObj : Object = new Object();
    reqObj.method= "submit";
    
    if(this.mode == 'AMEND'){
        reqObj['SCREEN_KEY'] = "99993";
    } else if(this.mode == 'ENTRY'){
        reqObj['SCREEN_KEY'] = "99991";
    }
    
    reqObj['marketValueObj.contractReferenceNo'] = this.contractReferenceNo.referenceNo.text;
    reqObj['marketValueObj.ccyCode'] = this.currency.ccyText.text;
    reqObj['marketValueObj.marketValueStr'] = this.marketValue.text;
    reqObj['marketValueObj.baseDateStr'] = this.baseDate.text;
    
    return reqObj;
}
    
override public function preResetEntry():void
{
    marketValueEntryList.removeAll(); 
    var rndNo:Number= Math.random();
    super.getResetHttpService().url = "swp/marketValueDispatchAction.action?method=reset&rnd=" + rndNo; 
}
   
override public function preResetAmend():void
{  
    var rndNo:Number= Math.random();
    super.getResetHttpService().url = "swp/marketValueAmendDispatchAction.action?method=resetAmend&rnd=" + rndNo; 
}
   
override public function doEntrySystemConfirm(e:Event):void
{
    super.preEntrySystemConfirm();
    this.dispatchEvent(new Event('entryReset'));
    this.back.includeInLayout = true;
    this.back.visible = true;
    uConfLabel.includeInLayout = true;
    uConfLabel.visible = true;
    uConfSubmit.includeInLayout = true;
    uConfSubmit.visible = true;
    sConfLabel.includeInLayout = false;
    sConfLabel.visible = false;
    sConfSubmit.includeInLayout = false;
    sConfSubmit.visible = false;
    sysConfMessage.includeInLayout=false;   
    sysConfMessage.visible=false;
    vstack.selectedChild = qry;    
    super.postEntrySystemConfirm();
}
    
override public function doAmendSystemConfirm(e:Event):void
{
    this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
}

override public function doCancelSystemConfirm(e:Event):void
{
    this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
}
  
private function doBack():void
{
    app.submitButtonInstance = submit;
    vstack.selectedChild = qry;
}

private function addMultipleMarketValues():void
{
	
	var errorFlag:Boolean = false;
    var errorStr:String = "";
    
    // Validate all the fields for empty or NULL check before adding to the list
    if(XenosStringUtils.isBlank(contractReferenceNo.referenceNo.text)){
    	errorFlag = true;
    	errorStr += this.parentApplication.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validator.entry.contractReferenceNoMissing') + '\n';
    }
    
    if(XenosStringUtils.isBlank(currency.ccyText.text)){
        errorFlag = true;
        errorStr += this.parentApplication.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validator.entry.currencyMissing') + '\n';
    }
    
    if(XenosStringUtils.isBlank(marketValue.text)){
        errorFlag = true;
        errorStr += this.parentApplication.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validator.entry.marketValueMissing') + '\n';
    }
    
    if(XenosStringUtils.isBlank(baseDate.text)){
        errorFlag = true;
        errorStr += this.parentApplication.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validator.entry.baseDateMissing') + '\n';
    }
    
    /*
    // Validate the base date for illegal date format
    if(DateUtils.isValidDate(StringUtil.trim(baseDate.text))){
        errorFlag = true;
        errorStr += this.parentApplication.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validator.illegalDateFormat')+' '+baseDate.text + '\n';
    }    
    */
        
    // Validate duplicate entry
    var item:Object = new Object();
    for each(item in marketValueEntryList as ArrayCollection){
        if((item.contractReferenceNo == contractReferenceNo.referenceNo.text)
        && (item.baseDateStr == baseDate.text) 
        && (item.ccyCode == currency.ccyText.text)){
        	errorFlag = true;
        	errorStr += this.parentApplication.xResourceManager.getKeyValue('swp.swpmarketvaluequery.validator.entry.duplicateMarketValueEntry') + '\n';            
        }
    }
        
    if(errorFlag){
        XenosAlert.error(errorStr);
        return;
    }
	
	var reqObj:Object=new Object();
	reqObj['marketValueObj.contractReferenceNo'] = this.contractReferenceNo.referenceNo.text;
    reqObj['marketValueObj.ccyCode'] = this.currency.ccyText.text;
    reqObj['marketValueObj.marketValueStr'] = this.marketValue.text;
    reqObj['marketValueObj.baseDateStr'] = this.baseDate.text;
    
    addMarketValueService.request = reqObj;
    addMarketValueService.send();
}

private function addMarketValueResult(event:ResultEvent):void
{	
	var rs:XML = XML(event.result);
	if (null != event) {
		if(rs.child("Errors").length()>0) {
            var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list              
            for each ( var error:XML in rs.Errors.error ) {
               errorInfoList.addItem(error.toString());
               trace(error.toString());                
            }
            errPage.showError(errorInfoList);//Display the error
         }else{
         	errPage.clearError(event);
         	try {
         		marketValueEntryList.removeAll();
         		for each ( var rec:XML in rs.marketValueList.marketValueList) {
         			marketValueEntryList.addItem(rec);
         		}
         		marketValueEntryList.refresh();
         		clearValues();
         		
         	}catch(e:Error){
         		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
         	}
         	
         }
	}       
}

public function deleteMarketValueListedEntry(data:Object):void
{
	var reqObj:Object=new Object();
	reqObj['rowNo'] = marketValueEntryList.getItemIndex(data);
	deleteMarketValueService.request = reqObj;
	deleteMarketValueService.send();
}


public function deleteMarketValueResult(event:ResultEvent):void
{	
   var rs:XML = XML(event.result);
    if (null != event) {
        if(rs.child("Errors").length()>0) {
            var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list              
            for each ( var error:XML in rs.Errors.error ) {
               errorInfoList.addItem(error.toString());
               trace(error.toString());                
            }
            errPage.showError(errorInfoList);//Display the error
         }else{
            errPage.clearError(event);           
            
            try {
            	marketValueEntryList.removeAll();
                for each ( var rec:XML in rs.marketValueList.marketValueList) {
                    marketValueEntryList.addItem(rec);
                }
                marketValueEntryList.refresh();                
                
            }catch(e:Error){
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            }
            
         }
    }  
}

public function clearValues():void
{
	this.contractReferenceNo.referenceNo.text = XenosStringUtils.EMPTY_STR;
    this.currency.ccyText.text = XenosStringUtils.EMPTY_STR;
    this.marketValue.text = XenosStringUtils.EMPTY_STR;
    this.baseDate.text = XenosStringUtils.EMPTY_STR;
}

/**
  * This is the method to pass the Collection of data items
  * through the context to the contract reference number popup. 
  * This will be implemented as per specific requriment. 
  */
private function populateContractRefNoContext():ArrayCollection
{
    //pass the context data to the popup
    var myContextList:ArrayCollection = new ArrayCollection();
    
    //passing status                
    var statusArray:Array = new Array(1);
    statusArray[0]="NORMAL";
    myContextList.addItem(new HiddenObject("Status",statusArray));
    
    //passing fund code                
    /* var fundCodeArray:Array = new Array(1);
    fundCodeArray[0]="APXJAP";
    myContextList.addItem(new HiddenObject("FundCode",fundCodeArray)); */

    return myContextList;    
}
