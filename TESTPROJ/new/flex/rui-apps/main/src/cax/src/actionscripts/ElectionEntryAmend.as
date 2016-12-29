
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.containers.SummaryPopup;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.controls.XenosEntry;
 import com.nri.rui.core.startup.XenosApplication;
 
 import flash.events.Event;
 
 import mx.collections.ArrayCollection;
 import mx.events.CloseEvent;
 import mx.events.ResourceEvent;
 import mx.resources.ResourceBundle;
 
 [Bindable]private var confResult:ArrayCollection = new ArrayCollection();
 [Bindable]private var mode : String = "amend";
 [Bindable]private var selectedItemArray:Array; 
 private var keylist:ArrayCollection = new ArrayCollection();
 [Bindable]
 private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);

    public function loadAll():void{
       parseUrlString();
       super.setXenosEntryControl(new XenosEntry());
       this.dispatchEvent(new Event('amendEntrySave'));
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
                        //XenosAlert.info("movArray param = " + tempA[1]);
                        mode = tempA[1];
                       // Alert.show("Mode :: " + mode);
                    }else if(tempA[0] == "selectedItems"){
                        //XenosAlert.info("selectedItems in :: " + tempA[1]);  
                        this.selectedItemArray = (tempA[1] as String).split(",");
                    } 
                }                       
            }else{
                mode = "amend";
            }                 

        } catch (e:Error) {
            trace(e);
        }
       
    }

    override public function preAmend():void{
        super.getSaveHttpService().url = "cax/optCashStockDivElectionEntryDispatch.action?";  
        super.getSaveHttpService().method = "POST";
        super.getSaveHttpService().request  =populateRequestParams();
    } 
    
      /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
     private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        
        reqObj.method = "confirmElection";
        //reqObj.modeOfOperation = this.mode;
        reqObj.rowNoArray = selectedItemArray;
         for(var index:int=0; index<selectedItemArray.length; index++ ){
            reqObj['resultView['+ selectedItemArray[index] + '].cashElectionStr'] = this.parentDocument.owner.queryResult[selectedItemArray[index]].cashElectionStr;
            reqObj['resultView['+ selectedItemArray[index] + '].stockElectionStr'] = this.parentDocument.owner.queryResult[selectedItemArray[index]].stockElectionStr;
        } 

        return reqObj;
    }
    
    private function addCommonResultKeys():void{
        keylist = new ArrayCollection();
        keylist.addItem("SelectedElectionsList.SelectedElection");
    } 
    override public function preAmendResultHandler():Object
    {
        addCommonResultKeys();
        return keylist;
    }
    override public function preAmendConfirm():void
    {
        var reqObj :Object = new Object();
        super.getConfHttpService().url = "cax/optCashStockDivElectionEntryDispatch.action?";  
        reqObj.method= "commitElection";
        super.getConfHttpService().request  =reqObj;
    }
    override public function postAmendResultHandler(mapObj:Object):void
    {
        commonResult(mapObj);
        //app.submitButtonInstance = uConfSubmit;
        //uConfLabel.text = "Rights Exercise Amend - User Confirmation";
    }
    private function commonResult(mapObj:Object):void{
            
        if(mapObj!=null){           
            if(mapObj["errorFlag"].toString() == "error"){
                //result = mapObj["errorMsg"] .toString();
                if(mode != "DELETE"){
                  errPage.showError(mapObj["errorMsg"]);                        
                }/* else{
                  XenosAlert.error(mapObj["errorMsg"] + "Error......");
                } */
            }else if(mapObj["errorFlag"].toString() == "noError"){
                
             errPage.clearError(super.getSaveResultEvent());
             confResult = mapObj[keylist.getItemAt(0)] as ArrayCollection;                          
             
             app.submitButtonInstance = uConfSubmit;    
            }else{
                errPage.removeError();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cax.data.not.found'));
            }           
        }
    } 
    
    override public function postConfirmAmendResultHandler(mapObj:Object):void
    {
        if(submitUserConfResult(mapObj))
            sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('cax.election.entry.amend')+ ' - '+ this.parentApplication.xResourceManager.getKeyValue('cax.system.confirmation1');
    }
    private function submitUserConfResult(mapObj:Object):Boolean{
        if(mapObj!=null){    
            if(mapObj["errorFlag"].toString() == "error"){
                //XenosAlert.error(mapObj["errorMsg"].toString());
                errPage.showError(mapObj["errorMsg"]);
            }else if(mapObj["errorFlag"].toString() == "noError"){
                if(mode!="cancel")
                  errPage.clearError(super.getConfResultEvent());
              
               uConfSubmit.enabled = true;  
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
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred'));
            }           
        }
        return false;
    } 
    
    override public function doAmendSystemConfirm(e:Event):void
    {
        this.parentDocument.owner.dispatchEvent(new Event("amendSubmit"));
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }