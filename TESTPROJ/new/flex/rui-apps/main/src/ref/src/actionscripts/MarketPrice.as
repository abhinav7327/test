// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.ref.validators.MarketPriceEntryValidator;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;
            
      
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     
            [Bindable]private var mode : String = "entry";
            [Bindable]private var marketPricePkStr : String = "";
            [Bindable]public var remarkStr : String = "";
            private var keylist:ArrayCollection = new ArrayCollection();
      
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
                 this.baseDate.setFocus();
                //hdbox1.selectedChild = this.qry;
                 //this.currentState="entryState";
                 vstack.selectedChild = qry;
               } else if(this.mode == 'amend'){
                 this.dispatchEvent(new Event('amendEntryInit'));
                 this.baseDate.setFocus();
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
                            }else if(tempA[0] == "mktPricePk"){
                                this.marketPricePkStr = tempA[1];
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
                super.getInitHttpService().url = "ref/marketPriceDispatchAction.action?method=initialExecute&&mode=entry&&menuType=Y&rnd=" + rndNo;
            }
            override public function preAmendInit():void{     
                initLabel.text = "Market Price Amend"           
                var rndNo:Number= Math.random(); 
                super.getInitHttpService().url = "ref/marketPriceAmendDispatchAction.action?";
                var reqObject:Object = new Object();
                reqObject.rnd = rndNo;
                reqObject.method= "amendMarketPrice";
                reqObject.mode=this.mode;
                reqObject.marketPricePk = this.marketPricePkStr;
                super.getInitHttpService().request = reqObject;
            }
            override public function preCancelInit():void{              
                this.back.includeInLayout = false;
                this.back.visible = false;
                changeCurrentState();                           
                var rndNo:Number= Math.random(); 
                super.getInitHttpService().url = "ref/marketPriceCancelDispatchAction.action?";
                var reqObject:Object = new Object();
                reqObject.rnd = rndNo;
                reqObject.method= "viewMarketPriceDetails";
                reqObject.mode=this.mode;
                reqObject.marketPricePk = this.marketPricePkStr;
                super.getInitHttpService().request = reqObject;
            }
            
       
        
        private function addCommonKeys():void{          
            keylist = new ArrayCollection();
            keylist.addItem("baseDate");
            keylist.addItem("dataSource");
            keylist.addItem("dataSourceList.item");
            keylist.addItem("inputPriceFormatList.item");
            keylist.addItem("priceTypeList.item");  
        }
        
        override public function preEntryResultInit():Object{
            addCommonKeys(); 
            return keylist;
        }
        
        override public function preAmendResultInit():Object{
            addCommonKeys(); 
            keylist.addItem("inputPriceStr");
            keylist.addItem("inputPriceFormatStr");
            keylist.addItem("priceType");
            keylist.addItem("securityCode");
            keylist.addItem("marketId");
            keylist.addItem("remarks"); 
            return keylist;
        }
        override public function preCancelResultInit():Object{
            addCommonResultKes();           
            return keylist;
        }
                
        private function commonInit(mapObj:Object):void{
            this.security.instrumentId.text = "";
                //this.txtMarket.text= "";
            this.remarks.text = "";
            this.inputPrice.text = "";
            this.executionMarket.text = "";
            errPage.clearError(super.getInitResultEvent());
            
                if(mapObj[keylist.getItemAt(0)]!=null){
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
                priceType.selectedIndex =index !=-1 ? index+1 : 0;
            
        }
        
        override public function postEntryResultInit(mapObj:Object): void{
            app.submitButtonInstance = submit;
            commonInit(mapObj);
        }
        
        override public function postAmendResultInit(mapObj:Object): void{
            app.submitButtonInstance = submit;
            commonInit(mapObj);
            this.inputPrice.text = mapObj[keylist.getItemAt(5)].toString();
            this.security.instrumentId.text = mapObj[keylist.getItemAt(8)].toString();
            this.executionMarket.itemCombo.text = mapObj[keylist.getItemAt(9)].toString();
            this.remarks.text = mapObj[keylist.getItemAt(10)] != null ? mapObj[keylist.getItemAt(10)].toString() : "";
            
            this.security.instrumentPopup.visible = false;
            this.security.instrumentId.editable = false;
            this.security.instrumentId.enabled = false;
            this.priceType.editable = false;
            this.priceType.enabled = false;
            this.dataSource.editable = false;
            this.dataSource.enabled = false;
            this.baseDate.editable = false;
            this.baseDate.enabled = false;
            this.baseDate.dropdown.visible=false;
        }
        private function commonResultPart(mapObj:Object):void{
                 this.uConfBaseDate.text = mapObj[keylist.getItemAt(0)].toString();
                 this.uConfDataSource.text = mapObj[keylist.getItemAt(1)].toString();
                 this.uConfInputPrice.text = mapObj[keylist.getItemAt(2)].toString();
                 this.uConfInputPriceFormat.text = mapObj[keylist.getItemAt(3)].toString();
                 this.uConfPriceType.text = mapObj[keylist.getItemAt(4)].toString();
                 this.uConfSecurity.text = mapObj[keylist.getItemAt(5)].toString();
                 this.uConfMarket.text = mapObj[keylist.getItemAt(6)].toString();
                 this.uConfRemarks.text = mapObj[keylist.getItemAt(7)].toString();
                 this.uConfPrice.text = mapObj[keylist.getItemAt(8)].toString();
                 this.uConfSecurityName.text = mapObj[keylist.getItemAt(9)].toString();
                 remarkStr = this.uConfRemarks.text;
        }
        override public function postCancelResultInit(mapObj:Object): void{
                
            commonResultPart(mapObj);
            //uConfLabel.text="Market Price Cancel";
            uConfSubmit.includeInLayout = false;
            uConfSubmit.visible = false;
            cancelSubmit.visible = true;
            cancelSubmit.includeInLayout = true;
            app.submitButtonInstance = cancelSubmit;
        }
        private function addCommonResultKes():void{
            keylist = new ArrayCollection();
            keylist.addItem("baseDate");
            keylist.addItem("dataSource");
            keylist.addItem("inputPriceStr");
            keylist.addItem("inputPriceFormatStr");
            keylist.addItem("priceType");
            keylist.addItem("securityCode");
            keylist.addItem("marketId");
            keylist.addItem("remarks");
            keylist.addItem("priceStrExp");
            keylist.addItem("instrumentShortName");
        }
        
        private function commonResult(mapObj:Object):void{
            
            //XenosAlert.info("commonResult ");
            if(mapObj!=null){           
                if(mapObj["errorFlag"].toString() == "error"){
                    //result = mapObj["errorMsg"] .toString();
                    if(mode != "cancel"){
                      errPage.showError(mapObj["errorMsg"]);
                      errPage.visible=true;
                      uConfErrPage.visible=false;                        
                    }else{
                        XenosAlert.error(mapObj["errorMsg"]);
                    }
                }else if(mapObj["errorFlag"].toString() == "noError"){
                  errPage.includeInLayout=false;  
                  uConfErrPage.includeInLayout=false;
                  uConfErrPage.visible=false;
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
                            marketPriceEntry:{
                                 
                                 baseDate:this.baseDate.text,                                 
                                 securityCode:this.security.instrumentId.text,
                                 dataSource:this.dataSource.selectedItem != null ? this.dataSource.selectedItem.value : "",
                                 priceType:this.priceType.selectedItem != null ? this.priceType.selectedItem.value : "",
                                 inputPriceStr:this.inputPrice.text,
                                 inputPriceFormatStr: this.inputPriceFormat.selectedItem != null ? this.inputPriceFormat.selectedItem.value : ""
                                        
                            }
                           }; 
             super._validator = new MarketPriceEntryValidator();
             super._validator.source = validateModel ;
             super._validator.property = "marketPriceEntry";
        }
         override public function preEntry():void{
            setValidator();
            //XenosAlert.info("preEntry ");
            super.getSaveHttpService().url = "ref/marketPriceDispatchAction.action?";  
            super.getSaveHttpService().request  =populateRequestParams();
         }
         
         override public function preAmend():void{
            setValidator();
            super.getSaveHttpService().url = "ref/marketPriceAmendDispatchAction.action?";  
            super.getSaveHttpService().request  =populateRequestParams();
         } 
         override public function preCancel():void{
            //setValidator();
            super._validator = null;
            super.getSaveHttpService().url = "ref/marketPriceCancelDispatchAction.action?"; 
             var reqObj:Object = new Object();
             reqObj.method="submitMarketPriceCancel";
             reqObj.mode=this.mode;
            super.getSaveHttpService().request  =reqObj;
         }
         
         
        override public function preEntryResultHandler():Object
        {
             addCommonResultKes();
             return keylist;
        }
        
        override public function preAmendResultHandler():Object
        {
            addCommonResultKes();
            return keylist;
        } 
        
        override public function postCancelResultHandler(mapObj:Object):void
        {
            submitUserConfResult(mapObj);
           if(mapObj["errorFlag"].toString() == "noError") {  
	            this.parentDocument.title =this.parentApplication.xResourceManager.getKeyValue('ref.marketprice.title.canceluserconfirm');
	            uConfLabel.includeInLayout = true;
	            uConfLabel.visible = true;
	            cancelSubmit.visible = false;
	            cancelSubmit.includeInLayout = false;
	            uCancelConfSubmit.visible = true;
	            uCancelConfSubmit.includeInLayout = true;
	            sConfSubmit.includeInLayout = false;
	            sConfSubmit.visible = false;
	            sConfLabel.includeInLayout = false;
	            sConfLabel.visible = false;
	            app.submitButtonInstance = uCancelConfSubmit;
            }
        } 
        
        override public function postEntryResultHandler(mapObj:Object):void
        {
            commonResult(mapObj);
            uConfLabel.includeInLayout = true;
            uConfLabel.visible = true;
            uConfImg.includeInLayout =false;
            uConfImg.visible =false;
            usrCnfMessage.text =this.parentApplication.xResourceManager.getKeyValue('ref.marketprice.title.entryuserconfirm');
        }
        
        override public function postAmendResultHandler(mapObj:Object):void
        {
            commonResult(mapObj);
            if(mapObj["errorFlag"].toString() == "noError") {
            	this.parentDocument.title =this.parentApplication.xResourceManager.getKeyValue('ref.marketprice.title.amenduserconfirm');
            }
            app.submitButtonInstance = uConfSubmit;
        }
         
         
        
        override public function preEntryConfirm():void
        {
            var reqObj :Object = new Object();
            super.getConfHttpService().url = "ref/marketPriceDispatchAction.action?";  
            reqObj.method= "confirmEntry";
            super.getConfHttpService().request  =reqObj;
        }
        
        override public function preAmendConfirm():void
        {
            var reqObj :Object = new Object();
            super.getConfHttpService().url = "ref/marketPriceAmendDispatchAction.action?";  
            reqObj.method= "confirmEntry";
            super.getConfHttpService().request  =reqObj;
        }
        
        override public function preCancelConfirm():void
        {
            var reqObj :Object = new Object();
            super.getConfHttpService().url = "ref/marketPriceCancelDispatchAction.action?";  
            reqObj.method= "confirmCancel";
            super.getConfHttpService().request  =reqObj;
        }
        
        override public function postConfirmEntryResultHandler(mapObj:Object):void
        {
            submitUserConfResult(mapObj);
            uConfLabel.includeInLayout = true;
            uConfLabel.visible = true;
            uConfImg.includeInLayout =false;
            uConfImg.visible =false;
            if(mapObj["errorFlag"].toString() == "noError") {
	            usrCnfMessage.text =this.parentApplication.xResourceManager.getKeyValue('ref.marketprice.title.entrysystemconfirm');
            }
        }
        override public function postConfirmAmendResultHandler(mapObj:Object):void
        {
            submitUserConfResult(mapObj);
            if(mapObj["errorFlag"].toString() == "noError") {
            this.parentDocument.title =this.parentApplication.xResourceManager.getKeyValue('ref.marketprice.title.amendsystemconfirm');
            }
        }
        override public function postConfirmCancelResultHandler(mapObj:Object):void
        {
            submitUserConfResult(mapObj);
            if(mapObj["errorFlag"].toString() == "noError") {
	         this.parentDocument.title =this.parentApplication.xResourceManager.getKeyValue('ref.marketprice.title.cancelsystemconfirm');
	         cancelSubmit.visible = false;
	         cancelSubmit.includeInLayout = false;
	         uCancelConfSubmit.visible = false;
	         uCancelConfSubmit.includeInLayout = false;
	         uConfLabel.includeInLayout = false;
	         uConfLabel.visible = false;
            }
        }
        
        private function submitUserConfResult(mapObj:Object):void{
        //var mapObj:Object = mkt.userConfResultEvent(event);
        if(mapObj!=null){    
            //XenosAlert.info("object status : "+mapObj["errorFlag"].toString());       
            if(mapObj["errorFlag"].toString() == "error"){
                //XenosAlert.error(mapObj["errorMsg"].toString());
                uConfErrPage.showError(mapObj["errorMsg"]);
                uConfErrPage.visible=true;
            }else if(mapObj["errorFlag"].toString() == "noError"){
                if(mode!="cancel")
                  errPage.clearError(super.getConfResultEvent());
                  uConfErrPage.includeInLayout=false;
                  uConfErrPage.visible=false;
                  errPage.includeInLayout=false;
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
               app.submitButtonInstance = sConfSubmit;       
                
            }else{
                errPage.removeError();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.erroroccurred'));
            }           
        }
    }
    
      /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        
        reqObj.method= "processEntry";
        
        reqObj.baseDate = this.baseDate.text;
        
        reqObj.marketId =  executionMarket.itemCombo != null ? executionMarket.itemCombo.text : "" ;
        
        reqObj.securityCode = this.security.instrumentId.text;
        
        reqObj.dataSource = this.dataSource.selectedItem != null ? this.dataSource.selectedItem.value : "";
        
        reqObj.priceType = this.priceType.selectedItem != null ? this.priceType.selectedItem.value : "";
        
        reqObj.inputPriceStr = this.inputPrice.text;
        
        reqObj.inputPriceFormatStr = this.inputPriceFormat.selectedItem != null ? this.inputPriceFormat.selectedItem.value : "";
        
        reqObj.remarks = this.remarks.text;

        return reqObj;
    }
    
   override public function preResetEntry():void
   {
      
               var rndNo:Number= Math.random();
                super.getResetHttpService().url = "ref/marketPriceDispatchAction.action?method=reset&rnd=" + rndNo; 
   }
   override public function preResetAmend():void
   {
      
               var rndNo:Number= Math.random();
                super.getResetHttpService().url = "ref/marketPriceAmendDispatchAction.action?method=resetAmend&rnd=" + rndNo; 
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
             this.uConfBaseDate.text = "";
             this.uConfDataSource.text = "";
             this.uConfInputPrice.text = "";
             this.uConfInputPriceFormat.text = "";
             this.uConfPriceType.text = "";
             this.uConfSecurity.text = "";
             this.uConfMarket.text = "";
             this.uConfRemarks.text = "";
               
            
             //hdbox1.selectedChild = this.qry;
            // this.currentState="entryState";
             vstack.selectedChild = qry;    
             super.postEntrySystemConfirm();
        
    }
    
    override public function doAmendSystemConfirm(e:Event):void
    {
        //this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }
    override public function doCancelSystemConfirm(e:Event):void
    {
        //this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }
  
  private function doBack():void{
                //hdbox1.selectedChild = this.qry;
                 //this.currentState="entryState";
                
                 if(mode=="amend"){
                 	this.parentDocument.title =this.parentApplication.xResourceManager.getKeyValue('ref.marketamend.title.renderer.amend');
                 
                 }
                
                 vstack.selectedChild = qry;
                 app.submitButtonInstance = submit; 
  }     
  

    

        