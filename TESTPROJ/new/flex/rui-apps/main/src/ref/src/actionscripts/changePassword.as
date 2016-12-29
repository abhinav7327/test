
 // ActionScript file for change password

 
 import com.nri.rui.core.controls.XenosAlert;
 
 import flash.events.IEventDispatcher;
 
 import mx.controls.Alert;
 import mx.events.CloseEvent;
 import mx.events.ResourceEvent;
 import mx.resources.ResourceBundle;
 import mx.rpc.events.ResultEvent;
 

    
    private function initPageStart():void {  
        var reqObj:Object = new Object();
        reqObj.method = "initialExecute";
        reqObj.rnd = Math.random();   
        initPasswdChngScreen.request = reqObj;                     
        initPasswdChngScreen.send();       
     } 
     
     
     private function loadInitialData(event:ResultEvent):void {
       
       errPage.clearError(event); //clears the errors if any
       userId.text = event.result.employeePasswordChangeActionForm.userId;
       
     }
     
     private function requestValidate():void {
        var reqObj:Object = new Object();
        reqObj.method = "doConfirm";
        reqObj.userId = this.userId.text;
        reqObj.currentPassword = this.currentPassword.text;
        reqObj.newPassword = this.newPassword.text;
        reqObj.confirmedPassword = this.confirmedPassword.text;
        reqObj.rnd = Math.random();
        validateChngdPasswd.request = reqObj;
        validateChngdPasswd.send(); 
        
     }
     
     private function askConfirmation(event:ResultEvent):void {
        if (null != event) {            
                if(null == event.result.XenosErrors){ 
                    errPage.clearError(event); //clears the errors if any
                    XenosAlert.confirm("Your password is going to be changed. " + 
                    "After that you will be returned to login screen " + 
                    "to re-login with the new password.", checkConfirmation); 
                } else { // Must be error
                    errPage.displayError(event);    
                }
        }
     }
     
     private function checkConfirmation(event:CloseEvent):void {
        if(event.detail == Alert.YES){
            var reqObj:Object = new Object();
            reqObj.method = "doSave";
            reqObj.rnd = Math.random();
            commitChngdPasswd.request = reqObj;
            commitChngdPasswd.send(); 
        }
            
     }
     
     private function errorInSave(event:ResultEvent):void{
        if (null != event) {            
                if(event.result.XenosErrors!=null){ 
                        errPage.displayError(event);    
                }
        }
        
     }
     
      
   
