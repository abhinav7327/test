// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.ref.validators.ExchangeRateEntryValidator;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.containers.TitleWindow;
import mx.events.CloseEvent;

            
      
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     
            [Bindable]private var mode : String = "entry";
            [Bindable]private var exchangeRatePkStr : String = "";
            private var keylist:ArrayCollection = new ArrayCollection();
            private var arrCalculationTypeList:ArrayCollection = new ArrayCollection();
            private var arrExchangeRateTypeBaseCcyList:ArrayCollection = new ArrayCollection();
      
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
                 this.dispatchEvent(new Event('entryInit'));
                //hdbox1.selectedChild = this.qry;
                 //this.currentState="entryState";
                 vstack.selectedChild = qry;
               } else if(this.mode == 'AMEND'){
                 this.dispatchEvent(new Event('amendEntryInit'));
                //hdbox1.selectedChild = this.qry;
                 //this.currentState="entryState";
                 vstack.selectedChild = qry;
               } else { 
                 this.dispatchEvent(new Event('cancelEntryInit'));
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
                            }else if(tempA[0] == "exchangeRatePk"){
                                this.exchangeRatePkStr = tempA[1];
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
            }
            override public function preCancelInit():void{  
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
            } 
            
       
        
        private function addCommonKeys():void{          
            keylist = new ArrayCollection();
            keylist.addItem("exchangeRateTypeList.exchangeRateTypeList");
            keylist.addItem("calculationTypeList.item");
            keylist.addItem("exchangeRatePage.baseDateStr");
            
            keylist.addItem("exchangeRateTypeBaseCcyList.item");
            
            /* keylist.addItem("dataSource");
            keylist.addItem("dataSourceList.item");
            keylist.addItem("inputPriceFormatList.item");
            keylist.addItem("priceTypeList.item"); */   
        }
        
        override public function preEntryResultInit():Object{
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
        }
        override public function preCancelResultInit():Object{
            addCommonResultKeys();          
            return keylist;
        } 
        
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
                        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.exchangerate.msg.error.digitlimit'));
                    }
                }
             }
            
         } */
        private function commonInit(mapObj:Object):void{
            //this.security.instrumentId.text = "";
                //this.txtMarket.text= "";
            //this.remarks.text = "";
            //this.inputPrice.text = "";
            //this.executionMarket.text = "";
            errPage.clearError(super.getInitResultEvent());
            this.againstccy.ccyText.text = "";
            this.rate.text = "";
            this.exchangeratetype.dataProvider = mapObj[keylist.getItemAt(0)] as ArrayCollection; 
            var initcol:ArrayCollection = new ArrayCollection();
            this.calculationtype.dataProvider = initcol;
            
            arrCalculationTypeList = mapObj[keylist.getItemAt(1)] as ArrayCollection; //make a local copy
            arrExchangeRateTypeBaseCcyList = mapObj[keylist.getItemAt(3)] as ArrayCollection; //make a local copy
            this.calculationtype.enabled = false ;
            this.baseDate.text = mapObj[keylist.getItemAt(2)]
                /* if(mapObj[keylist.getItemAt(0)]!=null){
                  this.baseDate.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(0)].toString());       
                        
                }
                dataSource.dataProvider=mapObj[keylist.getItemAt(2)] as ArrayCollection; 
                
                var index:int=0;
                for each(var item:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
                    if(item.value == mapObj[keylist.getItemAt(1)].toString()){
                        index = (mapObj[keylist.getItemAt(2)] as ArrayCollection).getItemIndex(item);
                    }
                }
                dataSource.selectedIndex = index;
                var initcol:ArrayCollection = new ArrayCollection();
                
                initcol.addItem({label:" ", value: " "});
                index=-1;
                for each(var item:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
                    initcol.addItem(item);
                    if(mode == "amend"){
                        if(item.value == mapObj[keylist.getItemAt(6)].toString()){
                        index = (mapObj[keylist.getItemAt(3)] as ArrayCollection).getItemIndex(item);
                      }
                    }
                }
                inputPriceFormat.dataProvider = initcol;
                inputPriceFormat.selectedIndex = index !=-1 ? index+1 : 0;
                
                initcol=new ArrayCollection();
                initcol.addItem({label:" ", value: " "});
                index=-1;
                for each(var item:Object in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
                    initcol.addItem(item);
                    if(mode == "amend"){
                        //XenosAlert.info("priceType : "+mapObj[keylist.getItemAt(7)].toString());
                        if(item.value == mapObj[keylist.getItemAt(7)].toString()){
                        index = (mapObj[keylist.getItemAt(4)] as ArrayCollection).getItemIndex(item);
                      }
                    }
                }
                priceType.dataProvider = initcol;
                priceType.selectedIndex =index !=-1 ? index+1 : 0; */
            
        }
        
        override public function postEntryResultInit(mapObj:Object): void{
            app.submitButtonInstance = submit;
            commonInit(mapObj);
        }
        
         override public function postAmendResultInit(mapObj:Object): void{
            app.submitButtonInstance = submit;
            commonInit(mapObj);
            this.exchangeratetype.selectedItem = mapObj[keylist.getItemAt(4)] != null ? mapObj[keylist.getItemAt(4)].toString() : "";
            this.baseDate.text = mapObj[keylist.getItemAt(5)] != null ? mapObj[keylist.getItemAt(5)].toString() : "";
            this.againstccy.ccyText.text = mapObj[keylist.getItemAt(7)] != null ? mapObj[keylist.getItemAt(7)].toString() : "";
            this.rate.text = mapObj[keylist.getItemAt(8)] != null ? mapObj[keylist.getItemAt(8)].toString() : "";
            
            populateCalculationType();
            var calculationtypeList:ArrayCollection = calculationtype.dataProvider as ArrayCollection;
            var indx:int = 0; 
            for(indx = 0; indx < calculationtypeList.length; indx++){
                if(calculationtypeList.getItemAt(indx).value == mapObj[keylist.getItemAt(6)].toString())
                    break;
            }
            this.calculationtype.selectedIndex = indx>=calculationtypeList.length ? 0 : indx;
            
            /*
            this.security.instrumentPopup.visible = false;
            this.security.instrumentId.editable = false;
            this.security.instrumentId.enabled = false;
            this.priceType.editable = false;
            this.priceType.enabled = false;
            this.dataSource.editable = false;
            this.dataSource.enabled = false;
            this.baseDate.editable = false;
            this.baseDate.enabled = false;
            this.baseDate.dropdown.visible=false; */
        }
        private function commonResultPart(mapObj:Object):void{
                 //XenosAlert.info("Data :: " + mapObj[keylist.getItemAt(0)]);
                 this.uConfExchangeRateType.text = mapObj[keylist.getItemAt(0)].toString();
                 this.uConfBaseDate.text = mapObj[keylist.getItemAt(1)].toString();
                 this.uConfCalculationType.text = mapObj[keylist.getItemAt(2)].toString();
                 this.uConfAgainstCcy.text = mapObj[keylist.getItemAt(3)].toString();
                 this.uConfRate.text = mapObj[keylist.getItemAt(4)].toString();
        }
        override public function postCancelResultInit(mapObj:Object): void{
            //XenosAlert.info("postCancelResultInit");  
            commonResultPart(mapObj);
            uConfLabel.text=this.parentApplication.xResourceManager.getKeyValue('ref.exchangerate.label.exchangeratecancel');
            uConfSubmit.includeInLayout = false;
            uConfSubmit.visible = false;
            cancelSubmit.visible = true;
            cancelSubmit.includeInLayout = true;
            app.submitButtonInstance = cancelSubmit;
        }
        private function addCommonResultKeys():void{
            keylist = new ArrayCollection();
            keylist.addItem("exchangeRatePage.exchangeRateTypeStr");
            keylist.addItem("exchangeRatePage.baseDateStr");
            keylist.addItem("exchangeRatePage.calculationTypeDisp");
            keylist.addItem("exchangeRatePage.againstCurrency");
            keylist.addItem("exchangeRatePage.exchangeRateStr");
        } 
        
         private function commonResult(mapObj:Object):void{
            
            //XenosAlert.info("commonResult ");
            if(mapObj!=null){           
                if(mapObj["errorFlag"].toString() == "error"){
                    //result = mapObj["errorMsg"] .toString();
                    if(mode != "DELETE"){
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
        
       
        
         private function setValidator():void{
        
           var validateModel:Object={
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
             super._validator.property = "exchangeRateEntry"; 
        } 
          override public function preEntry():void{
            setValidator();
            //XenosAlert.info("preEntry ");
            super.getSaveHttpService().url = "ref/exchangeRateDispatch.action?";  
            super.getSaveHttpService().request  =populateRequestParams();
         } 
         
          override public function preAmend():void{
            setValidator();
            super.getSaveHttpService().url = "ref/exchangeRateAmendDispatch.action?";  
            super.getSaveHttpService().request  =populateRequestParams();
         } 
         override public function preCancel():void{
            setValidator();
            //XenosAlert.info("preCancel");
            super._validator = null;
            super.getSaveHttpService().url = "ref/exchangeRateCancelDispatch.action?"; 
             var reqObj:Object = new Object();
             reqObj.method="submitExchangeRateCancel";
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
            //XenosAlert.info("postCancelResultHandler");
            if(submitUserConfResult(mapObj)){
                uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('ref.exchangerate.label.canceluserconfirm');
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
            uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('ref.exchangerate.label.amenduserconfirm');
        }
         
         
        
        override public function preEntryConfirm():void
        {
            var reqObj :Object = new Object();
            super.getConfHttpService().url = "ref/exchangeRateDispatch.action?";  
            reqObj.method= "confirm";
            super.getConfHttpService().request  =reqObj;
        }
        
        override public function preAmendConfirm():void
        {
            var reqObj :Object = new Object();
            super.getConfHttpService().url = "ref/exchangeRateAmendDispatch.action?";  
            reqObj.method= "confirm";
            super.getConfHttpService().request  =reqObj;
        }
        
        override public function preCancelConfirm():void
        {
            //XenosAlert.info("preCancelConfirm");
            var reqObj :Object = new Object();
            super.getConfHttpService().url = "ref/exchangeRateCancelDispatch.action?";  
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
                sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('ref.exchangerate.label.amendsystemconfirm');
        }
        override public function postConfirmCancelResultHandler(mapObj:Object):void
        {
            if(submitUserConfResult(mapObj)){
                sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('ref.exchangerate.label.cancelsystemconfirm');
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
                if(mode!="DELETE")
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
     private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        
        reqObj.method= "submit";
        
        reqObj['exchangeRatePage.exchangeRateTypeStr'] = this.exchangeratetype.selectedItem != null ? this.exchangeratetype.selectedItem : "";
        
        reqObj['exchangeRatePage.baseDateStr'] = this.baseDate.text;
        
        reqObj['exchangeRatePage.calculationTypeStr'] = this.calculationtype.selectedItem != null ? this.calculationtype.selectedItem.value : "";
        
        reqObj['exchangeRatePage.againstCurrency'] = this.againstccy.ccyText.text;
        
        reqObj['exchangeRatePage.exchangeRateStr'] = this.rate.text;
        
        //calculate base ccy
        var sExchangeRateTypeValue:String = this.exchangeratetype.selectedItem.toString();
        for each(var itemERTBC:Object in arrExchangeRateTypeBaseCcyList){
            if(itemERTBC.label == sExchangeRateTypeValue){
            	reqObj['exchangeRatePage.baseCurrency'] = itemERTBC.value;
            	break;
         	}
        }
        
        /* reqObj.dataSource = this.dataSource.selectedItem != null ? this.dataSource.selectedItem.value : "";
        
        reqObj.priceType = this.priceType.selectedItem != null ? this.priceType.selectedItem.value : "";
        
        reqObj.inputPriceStr = this.inputPrice.text;
        
        reqObj.inputPriceFormatStr = this.inputPriceFormat.selectedItem != null ? this.inputPriceFormat.selectedItem.value : "";
        
        reqObj.remarks = this.remarks.text; */

        return reqObj;
    }
    
   override public function preResetEntry():void
   {
      
               var rndNo:Number= Math.random();
                super.getResetHttpService().url = "ref/exchangeRateDispatch.action?method=reset&rnd=" + rndNo; 
   }
   override public function preResetAmend():void
   {
      
               var rndNo:Number= Math.random();
                super.getResetHttpService().url = "ref/exchangeRateAmendDispatch.action?method=resetAmend&rnd=" + rndNo; 
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
             /* this.uConfBaseDate.text = "";
             this.uConfDataSource.text = "";
             this.uConfInputPrice.text = "";
             this.uConfInputPriceFormat.text = "";
             this.uConfPriceType.text = "";
             this.uConfSecurity.text = "";
             this.uConfMarket.text = "";
             this.uConfRemarks.text = ""; */
             this.againstccy.ccyText.text = "";
             this.rate.text = "";  
            
             //hdbox1.selectedChild = this.qry;
            // this.currentState="entryState";
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
  
  private function doBack():void{
                //hdbox1.selectedChild = this.qry;
                 //this.currentState="entryState";
                 app.submitButtonInstance = submit;
                 vstack.selectedChild = qry;    
  } 
          
	public function populateCalculationType():void{
  		var sAgainstCcy:String = this.againstccy.ccyText.text;
    	var sExchangeRateType:String = this.exchangeratetype.selectedItem.toString();
    	var initcol:ArrayCollection = new ArrayCollection();
                
        initcol.addItem({label:" ", value: " "});                  
  		if(null != sExchangeRateType && !XenosStringUtils.isBlank(sAgainstCcy) ){
  			this.calculationtype.enabled =true;
  			for each( var itemCalculationType:Object in arrCalculationTypeList ){
	  			//set against
	  			for each(var item:Object in arrExchangeRateTypeBaseCcyList){
                    //initcol.addItem(item);
                    if(item.label == sExchangeRateType){
                    	var itemCalculationTypeLabel:String = itemCalculationType.label;
                    	itemCalculationTypeLabel = itemCalculationTypeLabel.replace("BaseCcy",item.value);
                    	itemCalculationTypeLabel = itemCalculationTypeLabel.replace("AgainstCcy",sAgainstCcy);
                    	initcol.addItem({label:itemCalculationTypeLabel, value: itemCalculationType.value});
                    	break;
                    }
	         	}
	    	}
  		}else{
  			this.calculationtype.enabled = false;
  		}
  		this.calculationtype.dataProvider = initcol;
  	}
        