// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;

import mx.events.CloseEvent;

    [Bindable] private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
    public function initializeCancel(viewMode:String):void {
        super.setXenosEntryControl(new XenosEntry());
            if(viewMode=='DELETE_CONFIRM'){
                 uCancelConfSubmit.visible = true;
                 uCancelConfSubmit.includeInLayout = true;   
                 cnclCntrlBtn.visible = true;
                 cnclCntrlBtn.includeInLayout = true;   
                 app.submitButtonInstance = uCancelConfSubmit;
                 uConfLabel.includeInLayout=true;
                 uConfLabel.visible=true; 
                 sConfLabel.includeInLayout=false;
                 sConfLabel.visible=false; 
                     
        }        
  }
        
        
    override public function preCancelConfirm():void
        {
            super._validator = null;
            var reqObj :Object = new Object();
            super.getConfHttpService().url = "ref/cpStandingEntryDispatch.action?";  
            reqObj.method= "commit";
            reqObj.SCREEN_KEY= 819;
            super.getConfHttpService().request  =reqObj;
           
        }           
        
        
    override public function postConfirmCancelResultHandler(mapObj:Object):void
        {
            submitUserConfResult(mapObj);
            this.parentDocument.title ="System Confirmation - Counterparty Settlement Standing Cancel";
            uCancelConfSubmit.visible = false;
            uCancelConfSubmit.includeInLayout = false;
        }
        
        
    private function submitUserConfResult(mapObj:Object):void{
        if(mapObj!=null){    
            //XenosAlert.info("object status : "+mapObj["errorFlag"].toString());       
            if(mapObj["errorFlag"].toString() == "error"){
                XenosAlert.error(mapObj["errorMsg"].toString());
            }else if(mapObj["errorFlag"].toString() == "noError"){
               sConfSubmit.includeInLayout = true;
               sConfSubmit.visible = true;   
               cnclCntrlBtn.visible = true;
               cnclCntrlBtn.includeInLayout = true; 
               app.submitButtonInstance = sConfSubmit;
               uConfLabel.includeInLayout=false;
               uConfLabel.visible=false; 
               sConfLabel.includeInLayout=true;
               sConfLabel.visible=true;    
            }else{
                errPage.removeError();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.erroroccurred'));
            }           
        }
    }       
    
    // Fire when the window is closed    
    override public function doCancelSystemConfirm(e:Event):void
    {
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }   
    
    
       
        
            