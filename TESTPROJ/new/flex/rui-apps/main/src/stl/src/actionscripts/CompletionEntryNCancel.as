





import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.containers.TitleWindow;
import mx.events.CloseEvent;
import mx.events.ResourceEvent;
import mx.resources.ResourceBundle;

            
      
    [Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]private var mode : String = "ADD";
    private var keylist:ArrayCollection = new ArrayCollection();
    [Bindable]private var selectedItemArray:Array; 
    [Bindable]private var confResult:ArrayCollection = new ArrayCollection();
    [Bindable]private var eligibleSubEventTypeList:ArrayCollection = new ArrayCollection();
    private var recvPk:String = XenosStringUtils.EMPTY_STR;
    
    private function changeCurrentState():void{
        if (mode == 'ADD' || mode == 'CAX_RECEIVE_NOTICE') {
            vstack.selectedChild = rsltEnt;
        } else {
            vstack.selectedChild = rslt;
        }
    }
     
    /**
    * At the time of loading the module if the module specific Resource is not loaded then load them
    * 
    */ 
    public function loadResourceBundle():void {
        if (mode == 'ADD' || mode == 'CAX_RECEIVE_NOTICE') {
            vstack.selectedChild = rsltEnt;
        } else {
            vstack.selectedChild = rslt;
        }
    }
    
    private function errorHandler(event:ResourceEvent):void{
        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.loadrefresourcebundle') + event.errorText);
    }
    
    public function loadAll():void{
        parseUrlString();
        super.setXenosEntryControl(new XenosEntry());
        if (mode == 'DELETE' || mode == 'CXL_CAX_RECEIVE_NOTICE') {
            this.vstack.selectedChild = rslt;
            this.dispatchEvent(new Event('cancelEntrySave'));
        } else if (mode == 'ADD' || mode == 'CAX_RECEIVE_NOTICE'){
            this.vstack.selectedChild = rsltEnt;
            this.dispatchEvent(new Event('entrySave'));
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
                    } else if(tempA[0] == "selectedItems"){
                        this.selectedItemArray = (tempA[1] as String).split(",");
                    } else if(tempA[0] == "recvPk"){
                        this.recvPk = tempA[1];
                    } 
                }                        
            } else {
                mode = "ADD";
            }                 

        } catch (e:Error) {
            trace(e);
        }
    }
    
    private function setValidator():void{
    
    }  
        
    override public function preEntry():void {
        setValidator();
        if(this.mode == 'CAX_RECEIVE_NOTICE' ){
            super.getSaveHttpService().url = "stl/stlCompletionDetailsCAReceiveNotice.action?"; 
        }else{
            super.getSaveHttpService().url = "stl/stlCompletionDetails.action?"; 
        }
        var reqObj:Object = new Object();
        reqObj.method = "submitCompletion";
 
        var completionTypeArray:Array = new Array();
        var stlDateArray:Array = new Array();
        var stlInfoPkArray:Array = new Array();
        
        for(var index:int=0; index < this.parentDocument.owner.queryResult.length; index++ ) {
            completionTypeArray.push(this.parentDocument.owner.queryResult[index].completionTp);
            stlDateArray.push(this.parentDocument.owner.queryResult[index].settlementDateStr);
            stlInfoPkArray.push(this.parentDocument.owner.queryResult[index].settlementInfoPk);
        } 

        reqObj.completionTypeArray = completionTypeArray;
        reqObj.stlDateArray = stlDateArray;
        reqObj.stlInfoPkArray = stlInfoPkArray;
        reqObj.SCREEN_KEY = 777;
        super.getSaveHttpService().request = reqObj;
         super.getSaveHttpService().method = "POST";
    } 
                  
    override public function preCancel():void {
        super._validator = null;
        super.getSaveHttpService().url = "stl/stlCompletionDetailsCancel.action?"; 
        var reqObj:Object = new Object();
        reqObj.method = "submitCancel";
        
        if(this.mode == "CXL_CAX_RECEIVE_NOTICE"){
            super.getSaveHttpService().url = "stl/stlCompletionDetailsCancelCAReceiveNotice.action?"; 
            reqObj.recvPk = this.recvPk;
            reqObj.path = "CANCEL_RECV_NOTICE";
            
        }else{            
            var detailHistoryPkArray:Array = new Array();
            
            for(var index:int=0; index < selectedItemArray.length; index++ ) {
                detailHistoryPkArray.push(this.parentDocument.owner.queryResult[selectedItemArray[index]].detailHistoryPk);
            } 
            reqObj.detailHistPkArray = detailHistoryPkArray;
        }
            
        reqObj.SCREEN_KEY = 815;
        super.getSaveHttpService().request = reqObj;
        super.getSaveHttpService().method = "POST";
     }         
         
    override public function preEntryResultHandler():Object {
        keylist = new ArrayCollection();
        keylist.addItem("selectedCandidates.selectedCandidate");
        keylist.addItem("candidateCompletionTypes");
        keylist.addItem("candidateStlDates");
        return keylist;
    }
        
    override public function preCancelResultHandler():Object {
        keylist = new ArrayCollection();
        keylist.addItem("selectedCandidates.selectedCandidate");
        return keylist;
    }
        
    override public function postCancelResultHandler(mapObj:Object):void {
        if(submitUserResult(mapObj)){
            cancelConfSubmit.visible = false;
            cancelConfSubmit.includeInLayout = false;
            
            cancelSubmit.enabled = true;
            cancelSubmit.visible = true;
            cancelSubmit.includeInLayout = true;
            
            confResult = mapObj[keylist.getItemAt(0)] as ArrayCollection;
            app.submitButtonInstance = cancelSubmit;
          }
    } 
        
    override public function postEntryResultHandler(mapObj:Object):void {
        if(submitUserResult(mapObj)) {            
            entryConfSubmit.visible = false;
            entryConfSubmit.includeInLayout = false;
            
            entrySubmit.enabled = true;
            entrySubmit.visible = true;
            entrySubmit.includeInLayout = true;
            
            confResult = mapObj[keylist.getItemAt(0)] as ArrayCollection;
            var compTypeArray:ArrayCollection = mapObj[keylist.getItemAt(1)] as ArrayCollection;
            var stlDates:ArrayCollection = mapObj[keylist.getItemAt(2)] as ArrayCollection;
            
            var i:int = 0;
            for each (var item:Object in confResult) {
                item["completionTp"] = compTypeArray[i].toString();
                item["settlementDateStr"] = stlDates[i].toString();
                i++;
            }
            app.submitButtonInstance = entrySubmit;
        }
        
    }
                
    override public function preEntryConfirm():void {
        this.entrySubmit.enabled = false;
        var reqObj :Object = new Object();
        if(this.mode == 'CAX_RECEIVE_NOTICE' ){
            super.getConfHttpService().url = "stl/stlCompletionDetailsCAReceiveNotice.action?"; 
         }else{
           super.getConfHttpService().url = "stl/stlCompletionDetails.action?";  
         }
        reqObj.method= "submitConfirm";
        reqObj.SCREEN_KEY = 778;        
        super.getConfHttpService().request = reqObj;
        super.getConfHttpService().method = "POST";        
    }
        
    override public function preCancelConfirm():void {
        this.cancelSubmit.enabled = false;
        var reqObj :Object = new Object();
        if(this.mode == "CXL_CAX_RECEIVE_NOTICE"){
            super.getConfHttpService().url = "stl/stlCompletionDetailsCancelCAReceiveNotice.action?";  
        }else{
            super.getConfHttpService().url = "stl/stlCompletionDetailsCancel.action?";  
        }
        
        reqObj.method= "submitConfirm";
        reqObj.SCREEN_KEY = 816;        
        super.getConfHttpService().request = reqObj;
        super.getConfHttpService().method = "POST";
    }
        
    override public function preEntryConfirmResultHandler():Object {
        keylist = new ArrayCollection();
        keylist.addItem("selectedCandidates.selectedCandidate");
        keylist.addItem("candidateCompletionTypes");
        keylist.addItem("candidateStlDates");
        return keylist;
    }
        
    override public function postConfirmEntryResultHandler(mapObj:Object):void {
        if(confirmUserResult(mapObj)){
            this.parentDocument.owner.sPopup.title = this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.entry.systemconfirmation');
            if(this.mode == "ADD" || mode == 'CAX_RECEIVE_NOTICE') {
                var titleWinInstance:TitleWindow = TitleWindow(this.parent.parent);
                titleWinInstance.showCloseButton = false;
                titleWinInstance.invalidateDisplayList();
            }
            
            confLabelEntHbox.visible = true;
            confLabelEntHbox.includeInLayout = true;
            confLabelEnt.text = this.parentApplication.xResourceManager.getKeyValue('inf.label.confirm.txn');
            
            confResult = mapObj[keylist.getItemAt(0)] as ArrayCollection;
            var compTypeArray:ArrayCollection = mapObj[keylist.getItemAt(1)] as ArrayCollection;
            var stlDates:ArrayCollection = mapObj[keylist.getItemAt(2)] as ArrayCollection;
            
            var i:int = 0;
            for each (var item:Object in confResult) {
                item["completionTp"] = compTypeArray[i].toString();
                item["settlementDateStr"] = stlDates[i].toString();
                i++;
            }

            entrySubmit.enabled = false;
            entrySubmit.visible = false;
            entrySubmit.includeInLayout = false;

            entryConfSubmit.visible = true;
            entryConfSubmit.enabled = true;
            entryConfSubmit.includeInLayout = true;
            app.submitButtonInstance = entryConfSubmit;
        }
    }
        
    override public function preConfirmCancelResultHandler():Object {
        keylist = new ArrayCollection();
        keylist.addItem("selectedCandidates.selectedCandidate");
        return keylist;
    }
        
    override public function postConfirmCancelResultHandler(mapObj:Object):void {
        if(confirmUserResult(mapObj)) {
            if(this.mode == "CXL_CAX_RECEIVE_NOTICE")
                this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.cancel.systemconfirmation');
            else
                this.parentDocument.owner.sPopup.title = this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.cancel.systemconfirmation');
            if(this.mode != "ADD") {
                   var titleWinInstance:TitleWindow = TitleWindow(this.parent.parent);
                   titleWinInstance.showCloseButton = false;
                   titleWinInstance.invalidateDisplayList();
            }
            
            confLabelHbox.visible = true;
            confLabelHbox.includeInLayout = true;
            confLabel.text = this.parentApplication.xResourceManager.getKeyValue('inf.label.confirm.txn');
            
            confResult = mapObj[keylist.getItemAt(0)] as ArrayCollection;

            cancelSubmit.enabled = false;
            cancelSubmit.visible = false;
            cancelSubmit.includeInLayout = false;

            cancelConfSubmit.visible = true;
            cancelConfSubmit.enabled = true;
            cancelConfSubmit.includeInLayout = true;
            app.submitButtonInstance = cancelConfSubmit;
        }
    } 
        
    private function submitUserResult(mapObj:Object):Boolean{
        if(mapObj!=null) {    
            if(mapObj["errorFlag"].toString() == "error") {
                if(this.mode == "CXL_CAX_RECEIVE_NOTICE")
                    this.parentDocument.owner.errPage2.showError(mapObj["errorMsg"]);
                else
                this.parentDocument.owner.errPageQueryRes.showError(mapObj["errorMsg"]);
                this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
                
            } else if(mapObj["errorFlag"].toString() == "noError") {
                return true;
            } else {
                errPage.removeError();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred')+mapObj["errorFlag"].toString());
            }            
        }
        return false;
    } 
    
    private function confirmUserResult(mapObj:Object):Boolean{
        if(mapObj!=null) {    
            if(mapObj["errorFlag"].toString() == "error") {
                if(mode == "ADD" || mode == 'CAX_RECEIVE_NOTICE') {
                    errPageEnt.showError(mapObj["errorMsg"]);  
                    this.entrySubmit.enabled = true;                  
                } else if(mode == "DELETE" || mode == 'CXL_CAX_RECEIVE_NOTICE') {
                    errPage.showError(mapObj["errorMsg"]);
                    cancelSubmit.enabled = true;
                }
            } else if(mapObj["errorFlag"].toString() == "noError") {
                return true;
            } else {
                errPage.removeError();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred')+ mapObj["errorFlag"].toString());
            }           
        }
        return false;
    } 

    /**
      * This method will populate the request parameters for the submitQuery 
      * call and bind the parameters with the HTTPService object.
      */
     private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        
        reqObj.method = "submitCompletion";
//        reqObj.rowNoArray = selectedItemArray;

        return reqObj;
    }
    
    override public function doEntrySystemConfirm(e:Event):void {
            this.parentDocument.owner.dispatchEvent(new Event("querySubmit"));
            this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
         super.postEntrySystemConfirm();        
    } 
    
    override public function doCancelSystemConfirm(e:Event):void {
        if(this.mode != "CXL_CAX_RECEIVE_NOTICE"){
        this.parentDocument.owner.selectAllBind = false;    
        this.parentDocument.owner.dispatchEvent(new Event("cancelSubmit"));
        }
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }
    private function getDisplayAccountNo(item:Object, column:DataGridColumn):String {
        return item.displayAccountNo;
    }
    private function getInstrumentCode(item:Object, column:DataGridColumn):String {
        return item.instrumentCode;
    }
    private function getOurBank(item:Object, column:DataGridColumn):String {
        return item.ourBank;
    }
    