// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.swp.validator.CashFlowResetEntryValidator

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.containers.TitleWindow;
import mx.events.CloseEvent;
      
[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
[Bindable]private var mode : String = "ENTRY";
[Bindable]private var cashFlowPkStr : String = "";

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
	if(this.mode == 'ENTRY'){
	    this.dispatchEvent(new Event('entryInit'));	    
	    vstack.selectedChild = qry;
	} else if(this.mode == 'AMEND'){
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
	            if (tempA[0] == "modeOfOperation") {	                
	                mode = tempA[1];	               
	            }else if(tempA[0] == "cashflowPk"){
	                this.cashFlowPkStr = tempA[1];
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
    super.getInitHttpService().url = "swp/cashflowDispatch.action?method=loadEntry&mode=entry&menuType=Y&rnd=" + rndNo;
}
            
override public function preAmendInit():void
{
    var rndNo:Number= Math.random(); 
    super.getInitHttpService().url = "swp/cashflowAmendDispatch.action?";
    var reqObject:Object = new Object();
    reqObject.rnd = rndNo;
    reqObject.method= "doView";
    reqObject.modeOfOperation = this.mode;
    reqObject.cashflowPk = this.cashFlowPkStr;
    super.getInitHttpService().request = reqObject;
}
            
override public function preCancelInit():void
{                
    this.back.includeInLayout = false;
    this.back.visible = false;
    changeCurrentState();                           
    var rndNo:Number= Math.random(); 
    super.getInitHttpService().url = "swp/cashflowCancelDispatch.action?";
    var reqObject:Object = new Object();
    reqObject.rnd = rndNo;
    reqObject.method= "doView";
    reqObject.modeOfOperation = this.mode;
    reqObject.cashflowPk = this.cashFlowPkStr;
    super.getInitHttpService().request = reqObject;
}      
        
private function addCommonKeys():void
{          
    keylist = new ArrayCollection();
    
    keylist.addItem("cashflowObj.streamReferenceNo");//0
    keylist.addItem("cashflowObj.cashflowType");//1
    keylist.addItem("cashflowObj.valueDateStr");//2
    keylist.addItem("cashflowObj.ccyCode");//3
    keylist.addItem("cashflowObj.accrualStartDateStr");//4
    keylist.addItem("cashflowObj.accrualEndDateStr");//5
    keylist.addItem("cashflowObj.dayCountFraction");//6
    keylist.addItem("cashflowObj.cashflowRate");//7    
    keylist.addItem("cashflowObj.resetRateStr");//8
    keylist.addItem("cashflowObj.resetDateStr");//9
    keylist.addItem("cashflowObj.cashflowAmountStr");//10
    keylist.addItem("spread");//11
    
}
        
override public function preEntryResultInit():Object
{
    addCommonKeys(); 
    return keylist;
}

override public function preAmendResultInit():Object
{
    addCommonKeys(); 
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
    
    app.submitButtonInstance = submit;

    streamReferenceNo.text = mapObj[keylist.getItemAt(0)].toString();
    cashFlowType.text = mapObj[keylist.getItemAt(1)].toString();
    valueDate.text = mapObj[keylist.getItemAt(2)].toString();
    paymentCurrency.text = mapObj[keylist.getItemAt(3)].toString();
    accrualStartDate.text = mapObj[keylist.getItemAt(4)].toString();
    accrualEndDate.text = mapObj[keylist.getItemAt(5)].toString();
    dayCountFraction.text = mapObj[keylist.getItemAt(6)].toString();
    cashFlowRate.text = mapObj[keylist.getItemAt(7)].toString();
    resetRate.text = mapObj[keylist.getItemAt(8)].toString();
    resetDate.text = mapObj[keylist.getItemAt(9)].toString();
    spread.text = mapObj[keylist.getItemAt(11)].toString();
}

override public function postEntryResultInit(mapObj:Object): void
{
    app.submitButtonInstance = submit;
    commonInit(mapObj);
    this.streamReferenceNo.text = mapObj[keylist.getItemAt(0)] != null ? mapObj[keylist.getItemAt(0)].toString() : "";
    this.cashFlowType.text = mapObj[keylist.getItemAt(1)] != null ? mapObj[keylist.getItemAt(1)].toString() : "";
    this.valueDate.text = mapObj[keylist.getItemAt(2)] != null ? mapObj[keylist.getItemAt(2)].toString() : "";
    this.paymentCurrency.text = mapObj[keylist.getItemAt(3)] != null ? mapObj[keylist.getItemAt(3)].toString() : "";
    this.accrualStartDate.text = mapObj[keylist.getItemAt(4)] != null ? mapObj[keylist.getItemAt(4)].toString() : "";
    this.accrualEndDate.text = mapObj[keylist.getItemAt(5)] != null ? mapObj[keylist.getItemAt(5)].toString() : "";
    this.dayCountFraction.text = mapObj[keylist.getItemAt(6)] != null ? mapObj[keylist.getItemAt(6)].toString() : "";
    this.cashFlowRate.text = mapObj[keylist.getItemAt(7)] != null ? mapObj[keylist.getItemAt(7)].toString() : "";
}

override public function postAmendResultInit(mapObj:Object): void
{
    app.submitButtonInstance = submit;
    commonInit(mapObj);            
}

private function commonResultPart(mapObj:Object):void
{
	this.uConfStreamReferenceNo.text = mapObj[keylist.getItemAt(0)].toString();
	this.uConfCashFlowType.text = mapObj[keylist.getItemAt(1)].toString();
	this.uConfValueDate.text = mapObj[keylist.getItemAt(2)].toString();
	this.uConfPaymentCurrency.text = mapObj[keylist.getItemAt(3)].toString();
	this.uConfAccrualStartDate.text = mapObj[keylist.getItemAt(4)].toString();
	this.uConfAccrualEndDate.text = mapObj[keylist.getItemAt(5)].toString();
    this.uConfDayCountFraction.text = mapObj[keylist.getItemAt(6)].toString();
    this.uConfCashFlowRate.text = mapObj[keylist.getItemAt(7)].toString();
    this.uConfResetRate.text = mapObj[keylist.getItemAt(8)].toString();
    this.uConfResetDate.text = mapObj[keylist.getItemAt(9)].toString();
    this.uConfCashflowAmount.text = mapObj[keylist.getItemAt(10)].toString();
    this.uConfSpread.text = mapObj[keylist.getItemAt(11)].toString();    
}

override public function postCancelResultInit(mapObj:Object): void
{              
    commonResultPart(mapObj);
    uConfLabel.text=this.parentApplication.xResourceManager.getKeyValue('swp.cashflowreset.label.cancel');
    uConfSubmit.includeInLayout = false;
    uConfSubmit.visible = false;
    cancelSubmit.visible = true;
    cancelSubmit.includeInLayout = true;
    app.submitButtonInstance = cancelSubmit;
}

private function addCommonResultKeys():void
{
    keylist = new ArrayCollection();
    
    keylist.addItem("cashflowObj.streamReferenceNo");
    keylist.addItem("cashflowObj.cashflowType");
    keylist.addItem("cashflowObj.valueDateStr");
    keylist.addItem("cashflowObj.ccyCode");
    keylist.addItem("cashflowObj.accrualStartDateStr");
    keylist.addItem("cashflowObj.accrualEndDateStr");    
    keylist.addItem("cashflowObj.dayCountFractionStr");
    keylist.addItem("cashflowObj.cashflowRateStr");
    keylist.addItem("cashflowObj.resetRateStr");
    keylist.addItem("cashflowObj.resetDateStr");    
    keylist.addItem("cashflowObj.cashflowAmountStr");
    keylist.addItem("spread");    
} 
        
private function commonResult(mapObj:Object):void
{  
	if(mapObj!=null){           
	    if(mapObj["errorFlag"].toString() == "error"){	        
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
        cashflowResetEntry:{
             resetRate:this.resetRate.text,             
             resetDate:this.resetDate.text             
        }
       }; 
     super._validator = new CashFlowResetEntryValidator();
     super._validator.source = validateModel ;
     super._validator.property = "cashflowResetEntry";        
}
 
override public function preEntry():void
{
	setValidator();
	super.getSaveHttpService().url = "swp/cashflowDispatch.action?";  
	super.getSaveHttpService().request  = populateRequestParams();
} 
         
override public function preAmend():void
{
    setValidator();
    super.getSaveHttpService().url = "swp/cashflowAmendDispatch.action?";  
    super.getSaveHttpService().request  = populateRequestParams();
}
          
override public function preCancel():void
{
    setValidator();            
    super._validator = null;
    super.getSaveHttpService().url = "swp/cashflowCancelDispatch.action?"; 
    var reqObj:Object = new Object();
    reqObj.method="submitCancel";
    reqObj.mode = this.mode;
    super.getSaveHttpService().request = reqObj;
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
	if(submitUserConfResult(mapObj)){
	    uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('swp.cashflow.label.canceluserconfirm');
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
    uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('swp.cashflow.label.amenduserconfirm');
}
   
override public function preEntryConfirm():void
{
    var reqObj :Object = new Object();
    super.getConfHttpService().url = "swp/cashflowDispatch.action?";  
    reqObj.method= "confirm";
    super.getConfHttpService().request  =reqObj;
}

override public function preAmendConfirm():void
{
    var reqObj :Object = new Object();
    super.getConfHttpService().url = "swp/cashflowAmendDispatch.action?";  
    reqObj.method= "confirm";
    super.getConfHttpService().request  =reqObj;
}

override public function preCancelConfirm():void
{            
    var reqObj :Object = new Object();
    super.getConfHttpService().url = "swp/cashflowCancelDispatch.action?";  
    reqObj.method= "confirm";
    super.getConfHttpService().request  =reqObj;
}

override public function postConfirmEntryResultHandler(mapObj:Object):void
{
    submitUserConfResult(mapObj);
}

override public function postConfirmAmendResultHandler(mapObj:Object):void
{
    if(submitUserConfResult(mapObj))
        sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('swp.cashflow.label.amendsystemconfirm');
}

override public function postConfirmCancelResultHandler(mapObj:Object):void
{
    if(submitUserConfResult(mapObj)){
        sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('swp.cashflow.label.cancelsystemconfirm');
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
    
    reqObj['cashflowObj.resetDateStr'] = this.resetDate.text;
    reqObj['cashflowObj.resetRateStr'] = this.resetRate.text;
    
    return reqObj;
}
    
override public function preResetEntry():void
{      
    var rndNo:Number= Math.random();
    super.getResetHttpService().url = "swp/cashflowDispatch.action?method=reset&rnd=" + rndNo; 
}
   
override public function preResetAmend():void
{      
    var rndNo:Number= Math.random();
    super.getResetHttpService().url = "swp/cashflowAmendDispatch.action?method=resetAmend&rnd=" + rndNo; 
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

private function setCashflowRate():void
{
	var tempResetRate:Number = parseFloat(this.resetRate.text);
	var tempSpread:Number  = 0;
	if(!XenosStringUtils.equals(this.spread.text,XenosStringUtils.EMPTY_STR)){
		tempSpread  = parseFloat(this.spread.text);
	}
    var cashFlowRate:Number = tempResetRate + tempSpread;
    this.cashFlowRate.text = cashFlowRate.toString();
}             