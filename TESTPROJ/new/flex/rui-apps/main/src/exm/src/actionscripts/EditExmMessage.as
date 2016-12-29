
// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.exm.ExmConstraints;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;


[Bindable]
public var resultObj:XML;
[Bindable]
private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);

[Bindable]
public var messagePkStr:String;	
[Bindable]
public var messageTypeStr:String;
[Bindable]
public var qIdStr:String;	
[Bindable]
public var modeStr:String;	
public var o:Object = {};


 
private var keylist:ArrayCollection = new ArrayCollection();

private function loadInit():void{	
	parseUrlString(); 

    super.setXenosEntryControl(new XenosEntry());
      
    if(this.modeStr == 'edit'){
        this.dispatchEvent(new Event('amendEntryInit'));                
    }else{
        XenosAlert.error("Invalid Mode for Loading the module : [" + modeStr + "]" );
    }
}

public function parseUrlString():void {
    try {
        // Remove everything before the question mark, including
        // the question mark.
        var myPattern:RegExp = /.*\?/; 
        var s:String = this.loaderInfo.url.toString();
        //XenosAlert.info("URL" + s);
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
            if (tempA[0] == "messagePk") {
                o.messagePk = tempA[1]; //+"="+tempA[2];
            } 
            messagePkStr = o.messagePk; 
            if (tempA[0] == "messageType") {
                o.messageType = tempA[1];
            } 
            messageTypeStr = o.messageType;
            if (tempA[0] == "qId") {
                o.qId = tempA[1];
            } 
            qIdStr = o.qId;
            messageTypeStr = o.messageType;
            if (tempA[0] == "mode") {
                o.mode = tempA[1];
            } 
            modeStr = o.mode;
        } 
        
    } catch (e:Error) {
        trace(e);
    }
   
}

override public function preAmendInit():void{     
        
    super.getInitHttpService().url = "exm/exmMessageEditDispatchAction.action?rnd="+Math.random();
    var reqObject:Object = new Object();
    reqObject.method="viewEditMessage";    
    reqObject.messagePk = this.messagePkStr;
    reqObject.messageType = this.messageTypeStr;
    reqObject.SCREEN_KEY = 11136;
    super.getInitHttpService().request = reqObject;
}
override public function preAmendResultInit():Object{
    //addCommonKeys();    
    keylist = new ArrayCollection();   
    
    keylist.addItem("messagePk");
    keylist.addItem("messageType");
    keylist.addItem("xmlMessageStr");
    keylist.addItem("userRemarks");
    keylist.addItem("lastEditedBy");
    
    return keylist;
}
override public function postAmendResultInit(mapObj:Object): void{
    commonAmendInit(mapObj);

    app.submitButtonInstance = submit;
}
private function commonAmendInit(mapObj:Object):void{

    if(mapObj!=null){    		
    	   		
    	 errPage.clearError(super.getInitResultEvent());		    	 		    	 
    	 resultObj = XML(mapObj[keylist.getItemAt(2)].toString());
    	 displayXml();
         displayValue();
         displayFor(ExmConstraints.AMEND_PAGE);
         
         lblUsrRemarks.text = mapObj[keylist.getItemAt(3)].toString()
         txtLastUser.text = mapObj[keylist.getItemAt(4)].toString()

      	 app.submitButtonInstance = uConfSubmit;        
    	   		
	}else{
	    XenosAlert.info("Unable to load the page.");
	}
}

override public function preAmend():void {
    
    if(EditableTRD01==1){
    validateTRD01();
    }
    populateModifiedValue(); //get the latest Account and Security
    
    super.getSaveHttpService().url = "exm/exmMessageEditDispatchAction.action?rnd="+Math.random();  
         
    var reqObj : Object = new Object();       
    reqObj['method'] = "replaceMessage";
    reqObj['accountCode'] = this.accountCode;
    reqObj['accPos'] = this.accPos;
    reqObj['securityCode'] = this.securityCode;
    reqObj['secPos'] = this.secPos;
    reqObj['principalAmount'] = this.principalAmount;
    reqObj['quantity'] = this.quantity;
    reqObj['inputPrice'] = this.inputPrice;
    reqObj['SCREEN_KEY'] = 11137;
    super.getSaveHttpService().request = reqObj; 
}

override public function preAmendResultHandler():Object{
	return null;
}

override public function postAmendResultHandler(mapObj:Object) : void {
    if(mapObj!=null){    		
    	if(mapObj["errorFlag"].toString() == "error"){		    		
    		
    		errPage.showError(mapObj["errorMsg"]);
    		changeState(ExmConstraints.AMEND_PAGE);    		
    		
    	}else if(mapObj["errorFlag"].toString() == "noError"){    		
        	 errPage.clearError(super.getInitResultEvent());
        	 changeState(ExmConstraints.AMEND_USER_CONF_PAGE);		    	 		    	 
    	}else{
    		errPage.removeError();
    		XenosAlert.info("Data Not Found");
    	}    		
	}
}
override public function preAmendConfirm():void
{
    var reqObj :Object = new Object();
    super.getConfHttpService().url = "exm/exmMessageEditDispatchAction.action?rnd="+Math.random();
    reqObj.method= "confirmEdit";
    reqObj['SCREEN_KEY'] = 11138;
    super.getConfHttpService().request = reqObj;
}
override public function preConfirmAmendResultHandler():Object
{
    return preAmendResultInit();
}
override public function postConfirmAmendResultHandler(mapObj:Object):void
{
    if(mapObj!=null){    		
    	if(mapObj["errorFlag"].toString() == "error"){
    		errPage.showError(mapObj["errorMsg"]);
    		changeState(ExmConstraints.AMEND_PAGE);
    	}else if(mapObj["errorFlag"].toString() == "noError"){    		
        	 errPage.clearError(super.getInitResultEvent());
        	 changeState(ExmConstraints.AMEND_SYS_CONF_PAGE);		    	 		    	 
    	}else{
    		errPage.removeError();
    		XenosAlert.info("Data Not Found");
    	}    		
	}
}

private function changeState(dest:String):void{
    displayFor(dest);
    
    if(XenosStringUtils.equals(dest, ExmConstraints.AMEND_PAGE)){        
        
        this.submit.includeInLayout = true;
        this.submit.visible = true;
        
        this.back.includeInLayout = false;
        this.back.visible = false;
        
        this.uConfSubmit.includeInLayout = false;
        this.uConfSubmit.visible = false;
        
        this.sConfSubmit.includeInLayout = false;
        this.sConfSubmit.visible = false;
        
        this.uConfLabel.includeInLayout = false;
        this.uConfLabel.visible = false;
        
        this.sConfLabel.includeInLayout = false;
        this.sConfLabel.visible = false;
        
        app.submitButtonInstance = submit;        
        
    }else if(XenosStringUtils.equals(dest, ExmConstraints.AMEND_USER_CONF_PAGE)){
        this.submit.includeInLayout = false;
        this.submit.visible = false;
        
        this.back.includeInLayout = true;
        this.back.visible = true;
        
        this.uConfSubmit.includeInLayout = true;
        this.uConfSubmit.visible = true;
        
        this.sConfSubmit.includeInLayout = false;
        this.sConfSubmit.visible = false;
        
        this.uConfLabel.includeInLayout = true;
        this.uConfLabel.visible = true;
        
        this.sConfLabel.includeInLayout = false;
        this.sConfLabel.visible = false;
        
        app.submitButtonInstance = uConfSubmit;        

    }else if(XenosStringUtils.equals(dest, ExmConstraints.AMEND_SYS_CONF_PAGE)){
        this.submit.includeInLayout = false;
        this.submit.visible = false; 
        
        this.back.includeInLayout = false;
        this.back.visible = false;
        
        this.uConfSubmit.includeInLayout = false;
        this.uConfSubmit.visible = false;
        
        this.sConfSubmit.includeInLayout = true;
        this.sConfSubmit.visible = true;
        
        this.uConfLabel.includeInLayout = false;
        this.uConfLabel.visible = false;
        
        this.sConfLabel.includeInLayout = true;
        this.sConfLabel.visible = true;
        
        app.submitButtonInstance = sConfSubmit;
    }    
}

private function doBack():void{    
    changeState(ExmConstraints.AMEND_PAGE);   
} 

override public function doAmendSystemConfirm(e:Event):void {
    this.parentDocument.owner.setRefreshAfterOpns(true);
    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
}