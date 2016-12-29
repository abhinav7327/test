

// ActionScript file for Recycle Operation

import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;
import mx.messaging.messages.HTTPRequestMessage;

[Bindable]
 private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     
[Bindable]
private var mode : String = "entry";
[Bindable]
private var selectedItemArray:Array; 
[Bindable]
public var confResult:ArrayCollection = new ArrayCollection();

private var keylist:ArrayCollection = new ArrayCollection();

public function loadAll():void{         
     parseUrlString();         
     super.setXenosEntryControl(new XenosEntry());
      
      if(this.mode == 'entry'){
             this.dispatchEvent(new Event('entrySave'));                
      }else{
          XenosAlert.error("Invalid Mode for Loading the module : [" + mode + "]" );
      } 
                         
}
           
/**
 * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
 * 
 */ 
public function parseUrlString():void {
    try {                    
        var myPattern:RegExp = /.*\?/; 
        var s:String = this.loaderInfo.url.toString();
        
        s = s.replace(myPattern, "");
        
        var params:Array = s.split(Globals.AND_SIGN); 
         
        var keyStr:String;
        var valueStr:String;
        var paramObj:Object = params;                
        
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

override public function preEntry():void{                               
    var rndNo:Number = Math.random();         
    super.getSaveHttpService().url = "exm/ExmMessageRestoreDispatchAction.action?rnd="+rndNo;              
    super.getSaveHttpService().method = HTTPRequestMessage.POST_METHOD;
    super.getSaveHttpService().request = populateRequestParams();            
}

/**
 * This method will populate the request parameters for the
 * submitQuery call and bind the parameters with the HTTPService
 * object.
 */
private function populateRequestParams():Object {
    
    var reqObj : Object = new Object();
    
    reqObj.method = "restoreMessage";
    reqObj['SCREEN_KEY']="11135";                
    var messagePkArray:Array = new Array();
    for(var index:int=0; index<this.parentDocument.owner.selectedMessageRecords.length; index++ ){
        messagePkArray[index] = this.parentDocument.owner.selectedMessageRecords[index].messagePk;
    }
    if(messagePkArray.length <= 0){
        messagePkArray[0] = '';
    }
    reqObj.messagePkArray = messagePkArray;
 
    return reqObj;
}
override public function preEntryResultHandler():Object
{
    addCommonResultKeys();
    return keylist;
}
private function addCommonResultKeys():void{
    keylist = new ArrayCollection();
    keylist.addItem("selectedMessageList.row");         
}
override public function postEntryResultHandler(mapObj:Object):void
{
    commonResult(mapObj);
}
private function commonResult(mapObj:Object):void {         
    if(mapObj!=null){           
        if(mapObj["errorFlag"].toString() == "error"){                  
            if(mode != "DELETE"){
              errPage.showError(mapObj["errorMsg"]);
              uConfSubmit.enabled = false;                      
            }else{
                XenosAlert.error(mapObj["errorMsg"] + "Error......");
            }
        }else if(mapObj["errorFlag"].toString() == "noError"){          
             errPage.clearError(super.getSaveResultEvent());                                 
             confResult = mapObj[keylist.getItemAt(0)];              
             app.submitButtonInstance = uConfSubmit;    
             uConfSubmit.enabled = true;                        
        }else{
            errPage.removeError();
            XenosAlert.info("Data Not Found");
        }           
    }
}

override public function preEntryConfirm():void
{           
    uConfSubmit.enabled = false;
    var reqObj :Object = new Object();  
    super.getConfHttpService().url = "exm/ExmMessageRestoreDispatchAction.action?rnd="+Math.random();  
    super.getConfHttpService().method = HTTPRequestMessage.POST_METHOD;
    reqObj.method= "confirmRestoreMessage";
    reqObj['SCREEN_KEY']="11136";
    super.getConfHttpService().request = reqObj;
}
override public function preEntryConfirmResultHandler():Object
{
    keylist = new ArrayCollection();
    keylist.addItem("selectedMessageList.row");
    return keylist;
}


override public function postConfirmEntryResultHandler(mapObj:Object):void
{
    submitUserConfResult(mapObj);
}       

private function submitUserConfResult(mapObj:Object) : Boolean
{       
    if(mapObj!=null){                   
        if(mapObj["errorFlag"].toString() == "error"){              
            uConfSubmit.enabled = true;
            errPage.showError(mapObj["errorMsg"]);
        }else if(mapObj["errorFlag"].toString() == "noError"){
            
            errPage.clearError(super.getConfResultEvent());             
            confResult = mapObj[keylist.getItemAt(0)];              
            uConfLabel.includeInLayout = false;
            uConfLabel.visible = false;
            uConfSubmit.includeInLayout = false;
            uConfSubmit.visible = false;
            sConfLabel.includeInLayout = true;
            sConfLabel.visible = true;
            sConfSubmit.includeInLayout = true;
            sConfSubmit.visible = true; 
            app.submitButtonInstance = sConfSubmit;
            return true;        
            
        }else{
            errPage.removeError();
            XenosAlert.info("Error Occurred");
        }           
    }
    return false;
}

override public function doEntrySystemConfirm(e:Event):void {
     super.preEntrySystemConfirm();          
     uConfLabel.includeInLayout = true;
     uConfLabel.visible = true;
     uConfSubmit.includeInLayout = true;
     uConfSubmit.visible = true;
     sConfLabel.includeInLayout = false;
     sConfLabel.visible = false;
     sConfSubmit.includeInLayout = false;
     sConfSubmit.visible = false;
     this.parentDocument.owner.setRefreshAfterOpns(true);
     this.parentDocument.owner.dispatchEvent(new Event("querySubmitRefresh"));
     this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
     super.postEntrySystemConfirm();
    
}