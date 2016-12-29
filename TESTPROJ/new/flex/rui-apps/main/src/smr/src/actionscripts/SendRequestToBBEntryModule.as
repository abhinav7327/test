
 
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.smr.validator.SendRequestToBBValidator;

import mx.collections.ArrayCollection;
import mx.utils.StringUtil;

[Bindable]
private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);

[Bindable]private var mode : String = "entry";
[Bindable]private var rs:XML = new XML();

private var keylist:ArrayCollection = new ArrayCollection();
private var secTypes:ArrayCollection = new ArrayCollection();
private var secCodeTypes:ArrayCollection = new ArrayCollection();

[Bindable] private var tickerConfTxt:String = "";
[Bindable] private var secTypeConfTxt:String = "";
[Bindable] private var secCodeTypeConfTxt:String = "";
[Bindable] private var secCodeConfTxt:String = "";

[Bindable] private var backState:Boolean = true;
[Bindable] private var uConfSubmitState:Boolean;
[Bindable] private var cancelSubmitState:Boolean = false;
[Bindable] private var uCancelConfSubmitState:Boolean = false;
[Bindable] private var sConfSubmitState:Boolean = false;

private function changeCurrentState():void{
    vstack.selectedChild = confirmView;        
}

public function loadAll():void{
    parseUrlString();
    super.setXenosEntryControl(new XenosEntry());
    //XenosAlert.info("mode : "+mode);
    if(this.mode == 'entry'){
        this.dispatchEvent(new Event('entryInit'));
        this.ticker.setFocus();
    
        vstack.selectedChild = entryView;
    } else {
        XenosAlert.error("Undefined Mode!");
    }                    
}

/**
 * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
 * 
 */ 
public function parseUrlString():void {
    try {
        // Remove everything before the question mark, including
        // the question mark.
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
                if (tempA[0] == "mode") {                        
                    mode = tempA[1];
                } 
            }                        
        }else{
            mode = "entry";
        }                 

    } catch (e:Error) {
        trace(e);
    }               
}

override public function preEntryInit():void{                        
    var reqObject:Object = new Object();
    reqObject.rnd = Math.random();    
    //reqObject.SCREEN_KEY = 249;
    
    super.getInitHttpService().url = "smr/sendRequestDispatch.action?method=initialExecute&mode=entry";
    super.getInitHttpService().request = reqObject;
}

private function addCommonKeys():void{            
    keylist = new ArrayCollection();      
    keylist.addItem("securityTypes.item");   
    keylist.addItem("securityCodeTypes.item");
}
        
override public function preEntryResultInit():Object{
    addCommonKeys(); 
    return keylist;
}

private function commonInit(mapObj:Object):void{
        
    var index:int = 0;
    
    this.ticker.text = XenosStringUtils.EMPTY_STR;
    this.secCode.text = XenosStringUtils.EMPTY_STR;

    errPage.clearError(super.getInitResultEvent());
    
    for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
        secTypes.addItem(item);
    }
    this.secType.dataProvider = secTypes;
    
    for each(var item:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
        secCodeTypes.addItem(item);
    }    
    this.secCodeType.dataProvider = secCodeTypes;
    
}

override public function postEntryResultInit(mapObj:Object): void{
    app.submitButtonInstance = submit;
    ticker.setFocus();
    commonInit(mapObj);
}

override public function preEntry():void{
	setValidator();
	super.getSaveHttpService().url = "smr/sendRequestDispatch.action?";  
	super.getSaveHttpService().request = populateRequestParams();
	super.getSaveHttpService().method="POST";
}

/**
 * This method will populate the request parameters for the
 * submitQuery call and bind the parameters with the HTTPService
 * object.
 */
private function populateRequestParams():Object {
    
    var reqObj : Object = new Object();
    reqObj.method = "submitRequestEntry";
	reqObj['request.ticker']= this.ticker.text;
	reqObj['request.securityCodeType'] = (this.secCodeType.selectedItem != null ? StringUtil.trim(this.secCodeType.selectedItem.value) : "");
	reqObj['request.securityCode'] = this.secCode.text;
	reqObj['request.bbProductKey'] = (this.secType.selectedItem != null ? StringUtil.trim(this.secType.selectedItem.value) : "");
    return reqObj;
}

override public function preEntryResultHandler():Object
{
     addCommonResultKeys();
     return keylist;
}

private function addCommonResultKeys():void{
    keylist = new ArrayCollection();
    keylist.addItem("request.ticker");
    keylist.addItem("request.bbProductKey");
    keylist.addItem("request.codeType");
    keylist.addItem("request.securityCode");
    
}

override public function postEntryResultHandler(mapObj:Object):void
{    
    commonResult(mapObj);
}

private function commonResult(mapObj:Object):void{
	
	if (mapObj != null) {    		
		if (mapObj["errorFlag"].toString() == "error"){
			if (mode != "CANCEL") {
			  	errPage.showError(mapObj["errorMsg"]);		    			
			} else {
				XenosAlert.error(mapObj["errorMsg"]);
			}
		} else if(mapObj["errorFlag"].toString() == "noError") {
		 	errPage.clearError(super.getSaveResultEvent());			    			
	     	commonResultPart(mapObj);
		 	changeCurrentState();
			
		} else {
			errPage.removeError();
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.datanotfound'));
		}    		
	}
}

private function commonResultPart(mapObj:Object):void {
	tickerConfTxt = mapObj['request.ticker'].toString();
	secCodeTypeConfTxt = mapObj['request.codeType'].toString();
	secCodeConfTxt = mapObj['request.securityCode'].toString();
	var value:String = mapObj['request.bbProductKey'].toString();
    for each (var item:Object in secTypes){
        if (item['value'] == value) {
        	secTypeConfTxt = item['label'].toString();
        }
    }
	uConfSubmitState = true;
}

override public function preResetEntry():void
{        
    var reqObject:Object = new Object();
    reqObject.method = "reset";        
    super.getResetHttpService().url = "smr/sendRequestDispatch.action?rnd=" + Math.random(); 
    super.getResetHttpService().request = reqObject;
}

private function setValidator():void{
    
  var validateModel:Object={
                    sendReq:{
                           ticker:this.ticker.text,
                           secType:this.secType.selectedItem == null ? "" : this.secType.selectedItem.value,
                           secCodeType:this.secCodeType.selectedItem == null ? "" : this.secCodeType.selectedItem.value,
                           secCode:this.secCode.text                    
                    }
                   };
     super._validator = new SendRequestToBBValidator();
     super._validator.source = validateModel ;
     if(this.mode == "entry"){
         super._validator.property = "sendReq";
     }else if(this.mode == "amend"){
         //TODO
     }
}

override public function preEntryConfirm():void
{
    var reqObject:Object = new Object();
    reqObject.method = "confirmRequestEntry";
    //reqObject['SCREEN_KEY']=605;
    super.getConfHttpService().url = "smr/sendRequestDispatch.action?";
    super.getConfHttpService().request = reqObject;    
}

private function submitUserConfResult(mapObj:Object):Boolean{

	if (mapObj != null) {    

		if (mapObj["errorFlag"].toString() == "error") {
			XenosAlert.error(mapObj["errorMsg"].toString());
		} else if(mapObj["errorFlag"].toString() == "noError") {
			if(mode!="CANCEL")
		 		errPage.clearError(super.getConfResultEvent());
			backState = false;
	   		uConfSubmit.enabled = true;	
       		uConfLabel.includeInLayout = false;
       		uConfLabel.visible = false;
       		uConfSubmitState = false;
       		sConfLabel.includeInLayout = true;
       		sConfLabel.visible = true;
       		sConfSubmitState = true;         
	   		return true;
		} else {
			errPage.removeError();
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.erroroccurred'));
		}    		
	}
	return false;
}

override public function doEntrySystemConfirm(e:Event):void {
	super.preEntrySystemConfirm();
	this.dispatchEvent(new Event('entryReset'));
	backState = true;
	uConfLabel.includeInLayout = true;
	uConfLabel.visible = true;
	uConfSubmitState = true;
	sConfLabel.includeInLayout = false;
	sConfLabel.visible = false;
	sConfSubmitState = false;
	vstack.selectedChild = entryView;	
	super.postEntrySystemConfirm();
}

override public function postConfirmEntryResultHandler(mapObj:Object):void
{
	submitUserConfResult(mapObj);
}


private function doBack():void {
  	 vstack.selectedChild = entryView;	
} 