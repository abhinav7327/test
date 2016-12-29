// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.containers.TitleWindow;
import mx.events.CloseEvent;
import mx.formatters.NumberBase;

            
      
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     [Bindable]public var cxlMessage:String="will be cancelled";
     
            [Bindable]private var mode : String = "entry";
            [Bindable]private var exchangeRatePkStr : String = "";
            private var keylist:ArrayCollection = new ArrayCollection();
            [Bindable]private var selectedItemArray:Array; 
            [Bindable]private var confResult:ArrayCollection = new ArrayCollection();
            [Bindable]private var SelectedExerciseRefrenceNo:ArrayCollection = new ArrayCollection();
      private function changeCurrentState():void{
                //hdbox1.selectedChild = this.rslt;
                //currentState = "result";
                vstack.selectedChild = rslt;
     }

               public function loadAll():void{
               parseUrlString();
               super.setXenosEntryControl(new XenosEntry());
               //XenosAlert.info("mode : "+mode);
               if(this.mode == 'entry'){
                 this.dispatchEvent(new Event('entrySave'));
                //hdbox1.selectedChild = this.qry;
                 //this.currentState="entryState";
                 //vstack.selectedChild = rslt;
               } else if(this.mode == 'amend'){
                 this.dispatchEvent(new Event('amendEntrySave'));
                //hdbox1.selectedChild = this.qry;
                 //this.currentState="entryState";
                 //vstack.selectedChild = rslt;
               } else { 
                 this.dispatchEvent(new Event('cancelEntrySave'));
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
                                //XenosAlert.info("movArray param = " + tempA[1]);
                                mode = tempA[1];
                               // Alert.show("Mode :: " + mode);
                            }else if(tempA[0] == "selectedItems"){
                                //XenosAlert.info("selectedItems in :: " + tempA[1]);  
                                this.selectedItemArray = (tempA[1] as String).split(",");
                            } 
                        }                       
                    }else{
                        mode = "entry";
                    }                 

                } catch (e:Error) {
                    trace(e);
                }
               // XenosAlert.info("selectedItems :: " + SummaryPopup(this.parent.parent).dataObj); 
               // XenosAlert.info("selectedItems :: " + selectedItemArray);         
            }
            
            /* override public function preEntryInit():void{                
                var rndNo:Number= Math.random(); 
                super.getInitHttpService().url = "ref/exchangeRateDispatch.action?method=initialExecute&&mode=entry&&menuType=Y&rnd=" + rndNo;
            }
             override public function preAmendInit():void{     
                initLabel.text = "Exchange Rate Amend"          
                var rndNo:Number= Math.random(); 
                super.getInitHttpService().url = "ref/exchangeRateAmendDispatch.action?";
                var reqObject:Object = new Object();
                reqObject.rnd = rndNo;
                reqObject.method= "doView";
                reqObject.actionType=this.mode;
                reqObject.exchangeRatePk = this.exchangeRatePkStr;
                super.getInitHttpService().request = reqObject;
            } */
            /* override public function preCancelInit():void{  
                //XenosAlert.info("preCancelInit");             
                this.back.includeInLayout = false;
                this.back.visible = false;
                changeCurrentState();                           
                var rndNo:Number= Math.random(); 
                super.getInitHttpService().url = "ref/exchangeRateCancelDispatch.action?";
                var reqObject:Object = new Object();
                reqObject.rnd = rndNo;
                reqObject.method= "doView";
                reqObject.actionType=this.mode;
                reqObject.exchangeRatePk = this.exchangeRatePkStr;
                super.getInitHttpService().request = reqObject;
            }  */
            
       
        
        /* private function addCommonKeys():void{           
            keylist = new ArrayCollection();
            keylist.addItem("exchangeRateTypeList.exchangeRateTypeList");
            keylist.addItem("calculationTypeList.item");
            keylist.addItem("exchangeRatePage.baseDateStr");
            /* keylist.addItem("dataSource");
            keylist.addItem("dataSourceList.item");
            keylist.addItem("inputPriceFormatList.item");
            keylist.addItem("priceTypeList.item");  
        } */
        
        /* override public function preEntryResultInit():Object{
            addCommonKeys(); 
            return keylist;
        }
        
         override public function preAmendResultInit():Object{
            addCommonKeys(); 
            keylist.addItem("exchangeRatePage.exchangeRateType");
            keylist.addItem("exchangeRatePage.baseDateStr");
            keylist.addItem("exchangeRatePage.calculationType");
            keylist.addItem("exchangeRatePage.againstCurrency");
            keylist.addItem("exchangeRatePage.exchangeRateStr");     
            return keylist;
        } */
        /* override public function preCancelResultInit():Object{
            addCommonResultKeys();          
            return keylist;
        }  */
        
        /**
         * Method to Format and validate numbers(B,M,T)
         */
        /*  private function numberHandler(numVal:XenosNumberValidator):void{
            //The source textinput control
            var source:Object=numVal.source; 
                    
            var vResult:ValidationResultEvent;
            var tmpStr:String = source.text; 
            if(XenosStringUtils.isBlank(source.text)){
                return;
            }
            else{
                vResult = numVal.validate();
                
                if (vResult.type==ValidationResultEvent.VALID) {
                    source.text=numberFormatter.format(source.text);            
                }else{
                    source.text = tmpStr;           
                }
                
                if(vResult != null && vResult.type ==ValidationResultEvent.INVALID){
                 var errorMsg:String=vResult.message;
                 XenosAlert.error(errorMsg);
                }else{
                    var digitsAfterDecimalArray:Array = rate.text.split(".");
                    var digitsAfterDecimal:String = digitsAfterDecimalArray[1];
                    if(Number(digitsAfterDecimal) > 99999999){
                        source.text = tmpStr;
                        XenosAlert.error("8 digits are allowed after decimal point");
                    }
                }
             }
            
         } */
        /* private function commonInit(mapObj:Object):void{
            
            
        } */
        
        /* override public function postEntryResultInit(mapObj:Object): void{
            app.submitButtonInstance = submit;
            commonInit(mapObj);
        } */
        
         /* override public function postAmendResultInit(mapObj:Object): void{
            
        } */
        private function commonResultPart(mapObj:Object):void{
                 //XenosAlert.info("Data :: " + mapObj[keylist.getItemAt(0)]);
                /*  this.uConfExchangeRateType.text = mapObj[keylist.getItemAt(0)].toString();
                 this.uConfBaseDate.text = mapObj[keylist.getItemAt(1)].toString();
                 this.uConfCalculationType.text = mapObj[keylist.getItemAt(2)].toString();
                 this.uConfAgainstCcy.text = mapObj[keylist.getItemAt(3)].toString();
                 this.uConfRate.text = mapObj[keylist.getItemAt(4)].toString(); */
        }
       /*  override public function postCancelResultInit(mapObj:Object): void{
            //XenosAlert.info("postCancelResultInit");  
            commonResultPart(mapObj);
            uConfLabel.text="Exchange Rate Cancel";
            uConfSubmit.includeInLayout = false;
            uConfSubmit.visible = false;
            cancelSubmit.visible = true;
            cancelSubmit.includeInLayout = true;
            app.submitButtonInstance = cancelSubmit;
        } */
        private function addCommonResultKeys():void{
            keylist = new ArrayCollection();
            keylist.addItem("SelectedExerciseList.SelectedExercise");
        } 
        
         private function commonResult(mapObj:Object):void{
            
            //XenosAlert.info("commonResult ");
	        softWarning.dataProvider = null;
	        softWarning.visible = false;
	        softWarning.includeInLayout = false;
            if(mapObj!=null){           
                if(mapObj["errorFlag"].toString() == "error"){
                    //result = mapObj["errorMsg"] .toString();
                    if(mode != "DELETE"){
                      errPage.showError(mapObj["errorMsg"]);                        
                    }else{
                        XenosAlert.error(mapObj["errorMsg"] + "Error......");
                    }
                    uConfSubmit.enabled=false;
                }else if(mapObj["errorFlag"].toString() == "noError"){
                    
                 errPage.clearError(super.getSaveResultEvent());
                 confResult = mapObj[keylist.getItemAt(0)] as ArrayCollection; 
                
                var arr:ArrayCollection = new ArrayCollection;                         
                var numBase:NumberBase = new NumberBase();
				for(var indx:int = 0; indx < confResult.length; indx++){
                    var calculatedTakeUpCost:Number = Number(numBase.parseNumberString(String(confResult.getItemAt(indx).calculatedTakeUpCost)));
                    if (!XenosStringUtils.isBlank(String(confResult.getItemAt(indx).inputtedTakeUpCost))) {
	                    var inputtedTakeUpCost:Number = Number(numBase.parseNumberString(String(confResult.getItemAt(indx).inputtedTakeUpCost)));
						if (calculatedTakeUpCost != inputtedTakeUpCost) {
							arr.addItem("[" + (indx + 1) + "] - Entered Take Up Cost [" + inputtedTakeUpCost + 
                            "] does not match with calculated one [" + calculatedTakeUpCost + "]");
						}
                    }
				}
               if (arr.length > 0) {
                    softWarning.dataProvider = arr;
                    softWarning.rowCount = arr.length;
                    softWarning.maxHeight = 200;
                    softWarning.visible = true;
                    softWarning.includeInLayout = true;
               }
                 //commonResultPart(mapObj);
                 app.submitButtonInstance = uConfSubmit;    
                }else{
                    errPage.removeError();
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cax.data.not.found'));
                }           
            }
        } 
        
       
        
          private function setValidator():void{
        
           /* var validateModel:Object={
                            exchangeRateEntry:{
                                 
                                 baseDate:this.baseDate.text,
                                 exchangeRateType:this.exchangeratetype.selectedItem != null ? this.exchangeratetype.selectedItem : "",
                                 calculationType:this.calculationtype.selectedItem != null ? this.calculationtype.selectedItem.value : "",
                                 againstCcy:this.againstccy.ccyText.text,
                                 rate: this.rate.text
                                        
                            }
                           }; 
             super._validator = new ExchangeRateEntryValidator();
             super._validator.source = validateModel ;
             super._validator.property = "exchangeRateEntry";  */
        }  
          override public function preEntry():void{
            setValidator();
            //XenosAlert.info("preEntry ");
            super.getSaveHttpService().url = "cax/rightsExcerciseEntryDispatch.action?modeOfOperation=entry";  
            //super.getSaveHttpService().method = "POST";
            super.getSaveHttpService().request  =populateRequestParams();
         } 
         
          override public function preAmend():void{
            setValidator();
            super.getSaveHttpService().url = "cax/rightsExcerciseAmendDispatch.action?modeOfOperation=amend";  
            super.getSaveHttpService().method = "POST";
            super.getSaveHttpService().request  =populateRequestParams();
         } 
         override public function preCancel():void{
            //setValidator();
            //XenosAlert.info("preCancel");
            super._validator = null;
            super.getSaveHttpService().url = "cax/rightsExcerciseCancelDispatch.action?modeOfOperation=cancel"; 
            var reqObj:Object = new Object();
            super.getSaveHttpService().method = "POST";
            reqObj.method="cancelSubmitRightsExercise";
            //reqObj.mode=this.mode;
            var rightsExercisePkArray:Array = new Array();
            for(var index:int=0; index<selectedItemArray.length; index++ ){
            	var indexArray:Array = String(selectedItemArray[index]).split("|");
                rightsExercisePkArray.push(this.parentDocument.owner.queryResult[indexArray[1]].rightsExercisePk);
            } 
            reqObj.rightsExercisePkArray = rightsExercisePkArray;
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
        
        override public function preCancelResultHandler():Object
        {
            keylist = new ArrayCollection();
            keylist.addItem("SelectedExerciseRefrenceNoList.SelectedExerciseRefrenceNo");
            return keylist;
        }
        
        override public function postCancelResultHandler(mapObj:Object):void
        {
            //XenosAlert.info("postCancelResultHandler");
            if(submitUserConfResult(mapObj)){
                uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('cax.rights.exercise.cancel')+ ' - ' + this.parentApplication.xResourceManager.getKeyValue('cax.user.confirmation1');
                SelectedExerciseRefrenceNo = mapObj[keylist.getItemAt(0)] as ArrayCollection;
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
            uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('cax.rights.exercise.amend')+ ' - ' + this.parentApplication.xResourceManager.getKeyValue('cax.user.confirmation1');
        }
         
         
        
        override public function preEntryConfirm():void
        {
            var reqObj :Object = new Object();
            super.getConfHttpService().url = "cax/rightsExcerciseEntryDispatch.action?";  
            reqObj.method= "commitExercise";
            super.getConfHttpService().request  =reqObj;
        }
        
        override public function preAmendConfirm():void
        {
            var reqObj :Object = new Object();
            super.getConfHttpService().url = "cax/rightsExcerciseAmendDispatch.action?";  
            reqObj.method= "commitExercise";
            super.getConfHttpService().request  =reqObj;
        }
        
        override public function preCancelConfirm():void
        {
            //XenosAlert.info("preCancelConfirm");
            var reqObj :Object = new Object();
            super.getConfHttpService().url = "cax/rightsExcerciseCancelDispatch.action?";  
            reqObj.method= "cancelConfirmRightsExercise";
            super.getConfHttpService().request  =reqObj;
        }
        
        override public function preEntryConfirmResultHandler():Object
        {
            keylist = new ArrayCollection();
            keylist.addItem("SelectedExerciseList.SelectedExercise");
            return keylist;
        }
        
        override public function preConfirmAmendResultHandler():Object
        {
            keylist = new ArrayCollection();
            keylist.addItem("SelectedExerciseList.SelectedExercise");
            return keylist;
        }
        
        override public function postConfirmEntryResultHandler(mapObj:Object):void
        {
            submitUserConfResult(mapObj);
        }
        
        override public function postConfirmAmendResultHandler(mapObj:Object):void
        {
            if(submitUserConfResult(mapObj))
                sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('cax.rights.exercise.amend')+ ' - ' + this.parentApplication.xResourceManager.getKeyValue('cax.system.confirmation1');
        }
        override public function postConfirmCancelResultHandler(mapObj:Object):void
        {
            if(submitUserConfResult(mapObj)){
                sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('cax.rights.exercise.cancel')+ ' - ' + this.parentApplication.xResourceManager.getKeyValue('cax.system.confirmation1');
                cxlMessage="cancelled";
                continueLabel.visible=false;
                continueLabel.includeInLayout=false;
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
        
         private function submitUserConfResult(mapObj:Object):Boolean{
        //var mapObj:Object = mkt.userConfResultEvent(event);
        if(mapObj!=null){    
            //XenosAlert.info("object status : "+mapObj["errorFlag"].toString());       
            if(mapObj["errorFlag"].toString() == "error"){
                XenosAlert.error(mapObj["errorMsg"].toString());
                
            }else if(mapObj["errorFlag"].toString() == "noError"){
                if(mode!="cancel")
                  errPage.clearError(super.getConfResultEvent());
                //this.back.includeInLayout = false;
                //this.back.visible = false;
               confResult = mapObj[keylist.getItemAt(0)] as ArrayCollection;
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
    
      /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
     private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        
        reqObj.method = "confirmExercise";
        //reqObj.modeOfOperation = this.mode;
        var rowNumArray:Array = new Array();
        
        for(var index:int=0; index<selectedItemArray.length; index++ ){
        	var indexArray:Array = String(selectedItemArray[index]).split("|");
        	rowNumArray.push(indexArray[0]);
            reqObj['resultView['+ indexArray[0] + '].exercisingQuantityStr'] = this.parentDocument.owner.queryResult[indexArray[1]].exercisingQuantityStr;
            reqObj['resultView['+ indexArray[0] + '].inputtedTakeUpCost'] = this.parentDocument.owner.queryResult[indexArray[1]].totalSubscriptionCostStr;
            reqObj['resultView['+ indexArray[0] + '].availableRightsStr'] = this.parentDocument.owner.queryResult[indexArray[1]].availableRightsStr;
            reqObj['resultView['+ indexArray[0] + '].availableDateStr'] = this.parentDocument.owner.queryResult[indexArray[1]].availableDateStr;
            
            reqObj['resultView['+ indexArray[0] + '].exerciseFinalizeFlag'] = this.parentDocument.owner.queryResult[indexArray[1]].exerciseFinalizeFlag;
            reqObj['resultView['+ indexArray[0] + '].expiryQuantityStr'] = this.parentDocument.owner.queryResult[indexArray[1]].expiryQuantityStr;
            reqObj['resultView['+ indexArray[0] + '].paymentDateCashStr'] = this.parentDocument.owner.queryResult[indexArray[1]].paymentDateCashStr;
            reqObj['resultView['+ indexArray[0] + '].paymentDateStr'] = this.parentDocument.owner.queryResult[indexArray[1]].paymentDateStr;
			reqObj['resultView['+ indexArray[0] + '].exerciseDateStr'] = this.parentDocument.owner.queryResult[indexArray[1]].exerciseDateStr;
        } 
		reqObj.rowNoArray = rowNumArray;
        return reqObj;
    }
    
   
   
     override public function doEntrySystemConfirm(e:Event):void
    {
              super.preEntrySystemConfirm();
             //this.dispatchEvent(new Event('entryReset'));
             //this.back.includeInLayout = true;
             //this.back.visible = true;
             uConfLabel.includeInLayout = true;
             uConfLabel.visible = true;
             uConfSubmit.includeInLayout = true;
             uConfSubmit.visible = true;
             sConfLabel.includeInLayout = false;
             sConfLabel.visible = false;
             sConfSubmit.includeInLayout = false;
             sConfSubmit.visible = false;
             this.parentDocument.owner.dispatchEvent(new Event("amendSubmit"));
             this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
             super.postEntrySystemConfirm();
        
    } 
    
    override public function doAmendSystemConfirm(e:Event):void
    {
        //this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
        
        this.parentDocument.owner.dispatchEvent(new Event("amendSubmit"));
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }
    override public function doCancelSystemConfirm(e:Event):void
    {
        //this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
        
        this.parentDocument.owner.dispatchEvent(new Event("cancelSubmit"));
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    } 
  
  private function doBack():void{
                //hdbox1.selectedChild = this.qry;
                 //this.currentState="entryState";
                 /* app.submitButtonInstance = submit;
                 vstack.selectedChild = qry;     */
  }         
        