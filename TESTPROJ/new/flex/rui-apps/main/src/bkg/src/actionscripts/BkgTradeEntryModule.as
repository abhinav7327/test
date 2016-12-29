        // ActionScript file for BkgTradeEntryModule
        import com.nri.rui.bkg.validators.BkgTradeEntryValidator;
        import com.nri.rui.core.Globals;
        import com.nri.rui.core.controls.XenosAlert;
        import com.nri.rui.core.controls.XenosEntry;
        import com.nri.rui.core.startup.XenosApplication;
        import com.nri.rui.core.utils.DateUtils;
        import com.nri.rui.core.utils.HiddenObject;
        import com.nri.rui.core.utils.OnDataChangeUtil;
        import com.nri.rui.core.utils.XenosStringUtils;
        
        import flash.events.Event;
        import flash.events.FocusEvent;
        import flash.events.MouseEvent;
        
        import mx.collections.ArrayCollection;
        import mx.events.CloseEvent;
        import mx.events.FlexEvent;
        import mx.events.ResourceEvent;
        import mx.events.ValidationResultEvent;
        import mx.resources.ResourceBundle;
        import mx.rpc.events.ResultEvent;
        import mx.utils.StringUtil;
                    
              
             [Bindable]
             private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     
            [Bindable]private var mode : String = "entry";
            [Bindable]private var bankingTradePkStr : String = "";
             var manualInstrAmnt:Boolean = false;
            [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
            [Bindable]private var trdTypeDP:ArrayCollection = new ArrayCollection();
            private var keylist:ArrayCollection = new ArrayCollection();
            private var currencyCodeStr:String = XenosStringUtils.EMPTY_STR;
            private var startDateStr:String = XenosStringUtils.EMPTY_STR;
            private var maturityDateStr:String = XenosStringUtils.EMPTY_STR;
            private var principalAmountStr:String = XenosStringUtils.EMPTY_STR;
            private var interestRateStr:String = XenosStringUtils.EMPTY_STR;
            private var interestAmtStr:String = XenosStringUtils.EMPTY_STR;
            var isDifIntrAmt:String = XenosStringUtils.EMPTY_STR;
      
              private function changeCurrentState():void{
                        vstack.selectedChild = rslt;
             }           
            
          
        /**
         * Load the Entry/Amend/Cancel according to 
         * the operational mode (e.g. Entry/Amend/Cancel)
         */  
           public function loadAll():void{
               parseUrlString();
               super.setXenosEntryControl(new XenosEntry());
               fundAccPopUp.accountNo.addEventListener(FlexEvent.VALUE_COMMIT, onChangeFundAccountNo);
		       counterPartyAccPopUp.accountNo.addEventListener(FlexEvent.VALUE_COMMIT, onChangeCPAccountNo);
		       currencyCode.imgCcy.addEventListener(MouseEvent.CLICK,ccyImgClickHandler);
		       currencyCode.ccyText.addEventListener(FocusEvent.FOCUS_OUT,resetCalculatedFieldsForCcy);
               if(this.mode == 'entry'){
                 this.dispatchEvent(new Event('entryInit'));
                 vstack.selectedChild = qry;
               } else if(this.mode == 'amend'){
                 this.dispatchEvent(new Event('amendEntryInit'));
                 vstack.selectedChild = qry;
               } else { 
                 this.dispatchEvent(new Event('cancelEntryInit'));
               }
           }
           
            /**
             * Extracts the parameters and set them to some variables for 
             * query criteria from the Module Loader Info.
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
                            }else if(tempA[0] == "bkgTrdPk"){
                                this.bankingTradePkStr = tempA[1];
                            }
                        }                       
                    }else{
                        mode = "entry";
                    }                 
                } catch (e:Error) {
                    trace(e);
                }               
            }
            
            /**
            * This method fires the dispatchaction to initialize the
            * Banking Trade Entry Screen (InitEntry-SEQ-1)
            */
            override public function preEntryInit():void{               
                var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "bkg/depoLoanEntryDispatch.action?";
            	var reqObject:Object = new Object();
            	reqObject.rnd = rndNo;
            	reqObject.method= "initialExecute";
		  		reqObject.mode="entry";
		  		reqObject.menuType = "Y";
		  		reqObject.SCREEN_KEY = "340";
		  		super.getInitHttpService().request = reqObject;
            }
            
            /**
            * This method fires the dispatchaction to initialize the
            * Banking Trade Amend Screen (InitAmend-SEQ-1)
            */
            override public function preAmendInit():void{     
                initLabel.text = this.parentApplication.xResourceManager.getKeyValue('bkg.amendment.label1');          
                var rndNo:Number= Math.random(); 
                super.getInitHttpService().url = "bkg/bkgTrdAmendDetailsDispatch.action?";
                var reqObject:Object = new Object();
                reqObject.rnd = rndNo;
                reqObject.method= "bkgTrdDetailsAmendQueryExecute";
                reqObject.mode=this.mode;
                reqObject.bankingTradePk = this.bankingTradePkStr;
		  		reqObject.SCREEN_KEY = "353";
                super.getInitHttpService().request = reqObject;
            }
            
            /**
            * This method fires the dispatchaction to initialize the
            * Banking Trade Cancel Screen (InitCancel-SEQ-1)
            */
            override public function preCancelInit():void{              
                this.back.includeInLayout = false;
                this.back.visible = false;
                changeCurrentState();                           
                var rndNo:Number= Math.random(); 
                super.getInitHttpService().url = "bkg/bkgTrdCancelDetailsDispatch.action?";
                var reqObject:Object = new Object();
                reqObject.rnd = rndNo;
                reqObject.method= "bkgTrdDetailsCancelQueryExecute";
                reqObject.mode=this.mode;
                reqObject.bankingTradePk = this.bankingTradePkStr;
		  		reqObject.SCREEN_KEY = "352";
                super.getInitHttpService().request = reqObject;
            }
        
            /**
            * This method is pre-result handler for the Banking Trade Entry
            * Screen. It generates the list of keys which will be populated 
            * during the initialization of the Banking trade Entry screen. 
            * (InitEntry-SEQ-2)
            */
            override public function preEntryResultInit():Object{
                addCommonKeys(); 
                return keylist;
            }
            
            /**
            * This method is pre-result handler for the Banking Trade Amend
            * Screen. It generates the list of keys which will be populated 
            * during the initialization of the Banking trade Amend screen. 
            * (InitAmend-SEQ-2)
            */
            override public function preAmendResultInit():Object{
                addCommonKeys(); 
                keylist.addItem("bkgTrdData.tradeType");
                keylist.addItem("bkgTrdData.takenPlacedFlag");
                keylist.addItem("bkgTrdData.accountNo");
                keylist.addItem("bkgTrdData.inventoryAccountNo");
                keylist.addItem("bkgTrdData.currencyCode");
                keylist.addItem("bkgTrdData.tradeTime");
                keylist.addItem("bkgTrdData.maturityDate");
                keylist.addItem("bkgTrdData.principalAmount");  
                keylist.addItem("bkgTrdData.interestRate");
                keylist.addItem("bkgTrdData.accruedDays");
                keylist.addItem("bkgTrdData.interestAmount");
                keylist.addItem("bkgTrdData.netAmount");
                keylist.addItem("bkgTrdData.remarks");
                keylist.addItem("bkgTrdData.referenceNo");
                return keylist;
            }
            
            /**
            * This method is pre-result handler for the Banking Trade Cancel
            * Screen. It generates the list of keys which will be populated 
            * during the initialization of the Banking trade Cancel screen. 
            * (InitCancel-SEQ-2)
            */
            override public function preCancelResultInit():Object{
                addCommonResultKes();           
                return keylist;
            }
            
            
            /**
            * This method populates the elements of the Banking
            * Trade Entry screen(mxml)
            * from the map obtained from preEntryResultInit() (InitEntry-SEQ-3)
            */
            override public function postEntryResultInit(mapObj:Object): void{
                app.submitButtonInstance = submit;
                commonInit(mapObj);
            }
            
            /**
            * This method populates the elements of the Banking
            * Trade Amend screen(mxml)
            * from the map obtained from preAmendResultInit() (InitAmend-SEQ-3)
            */
            override public function postAmendResultInit(mapObj:Object): void{
                app.submitButtonInstance = submit;
                commonInit(mapObj);
                var index:int=0;
                this.refNo.visible = true;
                this.refNo.includeInLayout = true;
                this.referenceNo.text = mapObj[keylist.getItemAt(16)].toString();
                var trdType:ArrayCollection = new ArrayCollection();
                if(mapObj[keylist.getItemAt(0)]!=null){
                    if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
                        for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
                            trdType.addItem(item);
                            if(item.value == mapObj[keylist.getItemAt(3)].toString()){
                                index = (mapObj[keylist.getItemAt(0)] as ArrayCollection).getItemIndex(item);
                            }
                        }
                    }else{
                        trdType.addItem(mapObj[keylist.getItemAt(0)]);
                        index = 1;
                    }
                }
                this.tradeType.dataProvider = trdType;
                this.tradeType.selectedIndex = index;
                
                this.takenplaced.text = "PLACED";
                this.counterPartyAccPopUp.accountNo.text = mapObj[keylist.getItemAt(5)] != null ? mapObj[keylist.getItemAt(5)].toString() : "";
                this.fundAccPopUp.accountNo.text = mapObj[keylist.getItemAt(6)] != null ? mapObj[keylist.getItemAt(6)].toString() : "";
                this.currencyCode.ccyText.text = mapObj[keylist.getItemAt(7)] != null ? mapObj[keylist.getItemAt(7)].toString() : "";
                this.tradeTime.text = mapObj[keylist.getItemAt(8)] != null ? mapObj[keylist.getItemAt(8)].toString() : "";
                this.maturityDate.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(9)].toString());
                this.principalAmount.text = mapObj[keylist.getItemAt(10)] != null ? mapObj[keylist.getItemAt(10)].toString() : "";
                this.interestRate.text = mapObj[keylist.getItemAt(11)] != null ? mapObj[keylist.getItemAt(11)].toString() : "";
                this.accruedDays.text = mapObj[keylist.getItemAt(12)] != null ? mapObj[keylist.getItemAt(12)].toString() : "";
                this.interestAmount.text = mapObj[keylist.getItemAt(13)] != null ? mapObj[keylist.getItemAt(13)].toString() : "";
                this.netAmount.text = mapObj[keylist.getItemAt(14)] != null ? mapObj[keylist.getItemAt(14)].toString() : "";
                this.remarks.text = mapObj[keylist.getItemAt(15)] != null ? mapObj[keylist.getItemAt(15)].toString() : "";
                
                this.takenplaced.editable = false;
                this.accruedDays.editable = false;
               // this.interestAmount.editable = false;
                this.netAmount.editable = false;
                
                //take initial values
                this.currencyCodeStr = mapObj[keylist.getItemAt(7)].toString();
                this.maturityDateStr = mapObj[keylist.getItemAt(9)].toString();
                this.principalAmountStr = mapObj[keylist.getItemAt(11)].toString();
                this.interestRateStr = mapObj[keylist.getItemAt(11)].toString();
                this.interestAmtStr = mapObj[keylist.getItemAt(13)].toString();
            }
            
            /**
            * This method populates the elements of the Banking
            * Trade Cancel screen(mxml)
            * from the map obtained from preCancelResultInit() (InitCancel-SEQ-3)
            */
            override public function postCancelResultInit(mapObj:Object): void{
                    
                commonResultPart(mapObj);
                uConfLabel.text= this.parentApplication.xResourceManager.getKeyValue('bkg.cancel.label');
                uConfSubmit.includeInLayout = false;
                uConfSubmit.visible = false;
                cancelSubmit.visible = true;
                cancelSubmit.includeInLayout = true;
                app.submitButtonInstance = cancelSubmit;
            }
            
            override public function preEntry():void{
                setValidator();
                super.getSaveHttpService().url = "bkg/depoLoanEntryDispatch.action?";  
                super.getSaveHttpService().request  =populateRequestParams();
             }
             
             override public function preAmend():void{
                setValidator();
                super.getSaveHttpService().url = "bkg/bkgTrdAmendDetailsDispatch.action?";  
                var reqObj:Object = populateRequestParams();
                reqObj.method = "bkgTrdDetailsAmendConfirm";
                super.getSaveHttpService().request = reqObj;
             } 
             override public function preCancel():void{
                super._validator = null;
                super.getSaveHttpService().url = "bkg/bkgTrdCancelDetailsDispatch.action?"; 
                var reqObj:Object = new Object();
			 	reqObj.SCREEN_KEY="352";
                reqObj.method="bkgTrdDetailsCancelConfirm";
                reqObj.mode=this.mode;
                super.getSaveHttpService().request = reqObj;
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
                submitCxlConfResult(mapObj);
            } 
            
            private function submitCxlConfResult(mapObj:Object):void{
	            if(mapObj!=null){    
	                if(mapObj["errorFlag"].toString() == "error"){
	                    usrConfErrPage.showError(mapObj["errorMsg"]);
	                    cancelSubmit.enabled = true;
	                    app.submitButtonInstance = cancelSubmit;
	                }else if(mapObj["errorFlag"].toString() == "noError"){
	                    uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('bkg.cxl.userconf.label');
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
	                    app.submitButtonInstance = uCancelConfSubmit;
	                    usrConfErrPage.clearError(super.getConfResultEvent());
	                    commonResultPart(mapObj);
	                }else{
	                    errPage.removeError();
	                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred'));
	                }           
	            }
	        }
            
            override public function postEntryResultHandler(mapObj:Object):void
            {
                commonResult(mapObj);
            }
            
            override public function postAmendResultHandler(mapObj:Object):void
            {
                commonResult(mapObj);
                //app.submitButtonInstance = uConfSubmit;
            }
             
             
            
            override public function preEntryConfirm():void
            {
                var reqObj :Object = new Object();
                super.getConfHttpService().url = "bkg/depoLoanEntryDispatch.action?";  
				reqObj.SCREEN_KEY= "11086";
                reqObj.method= "commit";
                super.getConfHttpService().request = reqObj;
            }
            
            override public function preAmendConfirm():void
            {
                var reqObj :Object = new Object();
                super.getConfHttpService().url = "bkg/bkgTrdAmendDetailsDispatch.action?";  
				reqObj.SCREEN_KEY= "355";
                reqObj.method= "commitAmendment";
                super.getConfHttpService().request = reqObj;
            }
            
            override public function preCancelConfirm():void
            {
                var reqObj :Object = new Object();
                super.getConfHttpService().url = "bkg/bkgTrdCancelDetailsDispatch.action?";  
				reqObj.SCREEN_KEY= "356";  
                reqObj.method= "commitCancel";
                super.getConfHttpService().request = reqObj;
            }
            
            override public function postConfirmEntryResultHandler(mapObj:Object):void
            {
                submitUserConfResult(mapObj);
            }
            override public function postConfirmAmendResultHandler(mapObj:Object):void
            {
                submitUserConfResult(mapObj);
            }
            override public function postConfirmCancelResultHandler(mapObj:Object):void
            {
                submitUserConfResult(mapObj);
            }
            
            override public function preResetEntry():void
           {
               var rndNo:Number= Math.random();
                super.getResetHttpService().url = "bkg/depoLoanEntryDispatch.action?method=initialExecute&rnd=" + rndNo; 
           }
           override public function preResetAmend():void
           {
               var rndNo:Number= Math.random();
                super.getResetHttpService().url = "bkg/bkgTrdAmendDetailsDispatch.action?method=resetAmendment&rnd=" + rndNo; 
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
                     this.uConfFundCode.text = "";
                     this.uConfTradeType.text = "";
                     
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
            
            
            /**
            * This method adds the common keys to a list
            * which will be populated for both entry and amend
            */
            private function addCommonKeys():void{          
                keylist = new ArrayCollection();
                keylist.addItem("scrndisdata.tradeTypeList.tradeType");
                keylist.addItem("bkgTrdData.tradeDate");
                keylist.addItem("bkgTrdData.startDate");
            }
            
            private function commonInit(mapObj:Object):void{
                var initcol:ArrayCollection = new ArrayCollection();
                trdTypeDP = new ArrayCollection();
                errPage.clearError(super.getInitResultEvent());
                this.fundAccPopUp.accountNo.text = "";
                this.fundAccName.text = "";
                this.counterPartyAccPopUp.accountNo.text = "";
                this.cpAccName.text = "";
                this.refNo.visible = false;
                this.refNo.includeInLayout = false;
                
                errPage.clearError(super.getInitResultEvent());
                
                /* Populating Trade type drop down*/
                
                //trdTypeDP.addItem(" ");
                var index:int = 0; //default index for trade type
                if(mapObj[keylist.getItemAt(0)]!=null){
                    if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
                        for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
                            trdTypeDP.addItem(item);
                        }
                    }else{
                        trdTypeDP.addItem(mapObj[keylist.getItemAt(0)]);
                    }
                }
                this.tradeType.dataProvider = trdTypeDP;
                this.tradeType.selectedIndex = index;
                
                if(mapObj[keylist.getItemAt(1)]!=null){
                  this.tradeDate.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(1)].toString());          
                }
                this.tradeTime.text = "";
                if(mapObj[keylist.getItemAt(2)]!=null){
                  this.startDate.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(2)].toString());
                  this.startDateStr = mapObj[keylist.getItemAt(2)].toString();
                }
                
                this.currencyCode.ccyText.text = "";
                this.maturityDate.selectedDate = null;
                this.principalAmount.text = "";
                this.interestRate.text = "";
                this.accruedDays.text = "";
                this.interestAmount.text = "";
                this.netAmount.text = "";
                this.remarks.text = "";
            }
            
            
            
            
            private function commonResultPart(mapObj:Object):void{
                     this.uConfFundCode.text = mapObj[keylist.getItemAt(0)].toString();
                     this.uConfFundName.text = mapObj["bkgTrdData.fundName"].toString();
                     this.uConfFundAccNo.text = mapObj[keylist.getItemAt(1)].toString();
                     this.uConfTradeType.text = mapObj[keylist.getItemAt(2)].toString();
                     this.uConfRefNo.text = mapObj[keylist.getItemAt(3)].toString();
                     this.uConfCounterPartyAccNo.text = mapObj[keylist.getItemAt(4)].toString();
                     this.uConfCurrencyCode.text = mapObj[keylist.getItemAt(5)].toString();
                     if(XenosStringUtils.isBlank(mapObj[keylist.getItemAt(7)])){
                        this.uConfTradeDateTime.text = mapObj[keylist.getItemAt(6)].toString();
                     }else{
                        this.uConfTradeDateTime.text = mapObj[keylist.getItemAt(6)].toString()+"|"+mapObj[keylist.getItemAt(7)].toString();
                     }
                     this.uConfStatus.text = mapObj[keylist.getItemAt(8)].toString();
                     this.uConfStartLegStartDate.text = mapObj[keylist.getItemAt(9)].toString();
                     this.uConfStartMaturityDate.text = mapObj[keylist.getItemAt(10)].toString();
                     this.uConfPrincipalAmount.text = mapObj[keylist.getItemAt(11)].toString();
                     this.uConfStartNetAmount.text = mapObj[keylist.getItemAt(12)].toString();
                     this.uConfInterestRate.text = mapObj[keylist.getItemAt(13)].toString();
                     this.uConfAccIntCalcType.text = mapObj[keylist.getItemAt(14)].toString();
                     this.uConfCancelRefNo.text = mapObj[keylist.getItemAt(15)].toString();
                     this.uConfRemarks.text = mapObj[keylist.getItemAt(16)].toString();
                     this.uConfInterestAmount.text = mapObj[keylist.getItemAt(17)].toString();
                     this.uConfEndNetAmount.text = mapObj[keylist.getItemAt(12)].toString();
                     this.uConfAccruedDays.text = mapObj[keylist.getItemAt(18)].toString();
                     this.uConfEndMaturityDate.text = mapObj[keylist.getItemAt(10)].toString();
                     this.uConfEndLegStartDate.text = mapObj[keylist.getItemAt(9)].toString();
                     /* For Entry Screen */
                     this.accruedDays.text = mapObj[keylist.getItemAt(18)].toString();;
                     this.interestAmount.text = mapObj[keylist.getItemAt(17)].toString();
                     this.netAmount.text = mapObj[keylist.getItemAt(12)].toString();
                     isDifIntrAmt = mapObj[keylist.getItemAt(19)].toString();
                     this.uConfFundAccName.text = mapObj[keylist.getItemAt(20)].toString();
                     this.uConfCounterPartyAccName.text = mapObj[keylist.getItemAt(21)].toString();
                     softWarn.showWarning(mapObj["softWarning"]);
            }
            
            
            private function addCommonResultKes():void{
                keylist = new ArrayCollection();
                keylist.addItem("bkgTrdData.fundCode");
                keylist.addItem("bkgTrdData.inventoryAccountNo");
                keylist.addItem("bkgTrdData.tradeType");
                keylist.addItem("bkgTrdData.referenceNo");
                keylist.addItem("bkgTrdData.accountNo");
                keylist.addItem("bkgTrdData.currencyCode");
                keylist.addItem("bkgTrdData.tradeDate");
                keylist.addItem("bkgTrdData.tradeTime");
                keylist.addItem("bkgTrdData.status");
                keylist.addItem("bkgTrdData.startDate");
                keylist.addItem("bkgTrdData.maturityDate");
                keylist.addItem("bkgTrdData.principalAmount");
                keylist.addItem("bkgTrdData.netAmount");
                keylist.addItem("bkgTrdData.interestRate");
                keylist.addItem("bkgTrdData.accIntCalcType");
                keylist.addItem("bkgTrdData.cancelReferenceNo");
                keylist.addItem("bkgTrdData.remarks");
                keylist.addItem("bkgTrdData.interestAmount");
                keylist.addItem("bkgTrdData.accruedDays");
                keylist.addItem("bkgTrdData.manualInstrAmnt");
                keylist.addItem("bkgTrdData.accountName");
                keylist.addItem("bkgTrdData.cpAccountName");
                keylist.addItem("bkgTrdData.fundName");
                }
            
            private function commonResult(mapObj:Object):void{
                if(mapObj!=null){  
                    if(mapObj["errorFlag"].toString() == "error"){
                        errPage.showError(mapObj["errorMsg"]);
                        app.submitButtonInstance = submit;
                    }else if(mapObj["errorFlag"].toString() == "noError"){
                     usrConfErrPage.clearError(super.getSaveResultEvent());  
                     errPage.clearError(super.getSaveResultEvent());                            
                     commonResultPart(mapObj);
                     changeCurrentState();
                     app.submitButtonInstance = uConfSubmit;    
                    }else{
                        errPage.removeError();
                        XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                    }           
                }
            }
        
       
        
        private function setValidator():void{
        
          var validateModel:Object={
                            bankingTradeEntry:{
                                tradeType:this.tradeType.selectedItem != null ? this.tradeType.selectedItem : "",
                                counterPartyAccountNo:this.counterPartyAccPopUp.accountNo != null ? this.counterPartyAccPopUp.accountNo.text : "",
                                fundAccountNo:this.fundAccPopUp.accountNo != null ? this.fundAccPopUp.accountNo.text : "",
                                currencyCode:this.currencyCode.ccyText != null ? this.currencyCode.ccyText.text : "",
                                tradeDate:this.tradeDate.selectedDate != null ? StringUtil.trim(this.tradeDate.text): "",
                                startDate:this.startDate.selectedDate != null ? StringUtil.trim(this.startDate.text): "",
                                maturityDate:this.maturityDate.selectedDate != null ? StringUtil.trim(this.maturityDate.text): "",
                                principalAmount:StringUtil.trim(this.principalAmount.text) != null ? StringUtil.trim(this.principalAmount.text) : "",
                                interestRate:StringUtil.trim(this.interestRate.text)!= null ? StringUtil.trim(this.interestRate.text) : ""
                            }
                           }; 
             super._validator = new BkgTradeEntryValidator();
             super._validator.source = validateModel ;
             super._validator.property = "bankingTradeEntry";
        }
         
        override public function preEntryConfirmResultHandler():Object{
            addCommonResultKes();
            return keylist;
        }
        
        override public function preConfirmAmendResultHandler():Object{
            addCommonResultKes();
            return keylist;
        }
        
        override public function preCancelResultHandler():Object{
            addCommonResultKes();
            return keylist;
        }
        
        override public function preConfirmCancelResultHandler():Object{
            addCommonResultKes();
            return keylist;
        }
        
        private function submitUserConfResult(mapObj:Object):void{
            if(mapObj!=null){    
                if(mapObj["errorFlag"].toString() == "error"){
                    usrConfErrPage.showError(mapObj["errorMsg"]);
                    if(mode=="cancel"){
                    	uCancelConfSubmit.enabled = true;
                    	app.submitButtonInstance = uCancelConfSubmit;
                    }else{
                    	uConfSubmit.enabled = true;
                    	app.submitButtonInstance = uConfSubmit;
                    }
                }else if(mapObj["errorFlag"].toString() == "noError"){
                    if(mode!="cancel"){
                      errPage.clearError(super.getConfResultEvent());
                      this.back.includeInLayout = false;
	                   this.back.visible = false;
	                   uConfSubmit.enabled = true;  
	                   uConfSubmit.includeInLayout = false;
	                   uConfSubmit.visible = false;
                    } else if(mode=="cancel"){
                    	sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('bkg.cxl.systemconf.label');
		                cancelSubmit.visible = false;
		                cancelSubmit.includeInLayout = false;
		                uCancelConfSubmit.visible = false;
		                uCancelConfSubmit.includeInLayout = false;
                    }
                    sConfLabel.includeInLayout = true;
		            sConfLabel.visible = true;
                    uConfLabel.includeInLayout = false;
		            uConfLabel.visible = false;
                    sConfSubmit.includeInLayout = true;
	                sConfSubmit.visible = true;   
	                app.submitButtonInstance = sConfSubmit;
                    usrConfErrPage.clearError(super.getConfResultEvent());
                    commonResultPart(mapObj);
                }else{
                    errPage.removeError();
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred'));
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
        
        reqObj.method= "confirm";
        
    	if(this.mode == 'amend'){
    		reqObj['SCREEN_KEY'] = "354";
    	} else if(this.mode == 'entry'){
    		reqObj['SCREEN_KEY'] = "11085";
    	}
    	
        reqObj['bkgTrdData.inventoryAccountNo'] = this.fundAccPopUp.accountNo.text;
        reqObj['bkgTrdData.accountName'] = this.fundAccName.text;
        reqObj['bkgTrdData.accountNo'] = this.counterPartyAccPopUp.accountNo.text;
        reqObj['bkgTrdData.cpAccountName'] = this.cpAccName.text;
        reqObj['bkgTrdData.tradeType'] = this.tradeType.selectedItem != null ? this.tradeType.selectedItem : "";
        reqObj['bkgTrdData.takenPlacedFlag'] = this.takenplaced.text;
        reqObj['bkgTrdData.currencyCode'] = this.currencyCode.ccyText.text;
        reqObj['bkgTrdData.tradeDate'] = this.tradeDate.text;
        reqObj['bkgTrdData.tradeTime'] = this.tradeTime.text;
        reqObj['bkgTrdData.startDate'] = this.startDate.text;
        reqObj['bkgTrdData.maturityDate'] = this.maturityDate.text;
        reqObj['bkgTrdData.principalAmount'] = this.principalAmount.text;
        reqObj['bkgTrdData.interestRate'] = this.interestRate.text;
        reqObj['bkgTrdData.accruedDays'] = this.accruedDays.text;
        reqObj['bkgTrdData.interestAmount'] = this.interestAmount.text;
        reqObj['bkgTrdData.netAmount'] = this.netAmount.text;
        reqObj['bkgTrdData.remarks'] = this.remarks.text;
        reqObj['bkgTrdData.manualInstrAmnt'] = this.manualInstrAmnt;
        
        return reqObj;
    }
    
   
      private function doBack():void{
         app.submitButtonInstance = submit;
         vstack.selectedChild = qry;
      } 
      
      
      /**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populateActContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        //passing act type                
        var actTypeArray:Array = new Array(1);
            actTypeArray[0]="T|S|B";
            //cpTypeArray[1]="CLIENT";
        myContextList.addItem(new HiddenObject("invActTypeContext",actTypeArray));    
                  
        var cpTypeArray:Array = new Array(1);
            cpTypeArray[0]="BROKER|BANK/CUSTODIAN";
            //cpTypeArray[1]="CLIENT";
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
    
        //passing account status                
        var actStatusArray:Array = new Array(1);
        actStatusArray[0]="TRADING|BOTH";
        myContextList.addItem(new HiddenObject("actContext",actStatusArray));
        return myContextList;
    }   
    
    
    /**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
        private function populateInvActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var actTypeArray:Array = new Array(1);
                actTypeArray[0]="T|S|B";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("invActTypeContext",actTypeArray));    
                      
            //passing counter party type                
            var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="INTERNAL";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="TRADING|BOTH";
            myContextList.addItem(new HiddenObject("actContext",actStatusArray));
            return myContextList;
        }
        
        private function validateTime(timeStr:String):void{
            
        }   
        
        private function calculateNetAmount():void{
        	this.calcNetAmount.setFocus();
            var req : Object = new Object();
            var rndNo:Number = Math.random(); 
            req = populateRequestParams();
            calcNetAmountRequest.request = req;
            var bkgTrdModel:Object={
                            bankingTradeEntry:{
                                tradeType:this.tradeType.selectedItem != null ? this.tradeType.selectedItem : "",
                                counterPartyAccountNo:this.counterPartyAccPopUp.accountNo != null ? this.counterPartyAccPopUp.accountNo.text : "",
                                fundAccountNo:this.fundAccPopUp.accountNo != null ? this.fundAccPopUp.accountNo.text : "",
                                currencyCode:this.currencyCode.ccyText != null ? this.currencyCode.ccyText.text : "",
                                tradeDate:this.tradeDate.selectedDate != null ? StringUtil.trim(this.tradeDate.text): "",
                                startDate:this.startDate.selectedDate != null ? StringUtil.trim(this.startDate.text): "",
                                maturityDate:this.maturityDate.selectedDate != null ? StringUtil.trim(this.maturityDate.text): "",
                                principalAmount:StringUtil.trim(this.principalAmount.text) != null ? StringUtil.trim(this.principalAmount.text) : "",
                                interestRate:StringUtil.trim(this.interestRate.text)!= null ? StringUtil.trim(this.interestRate.text) : ""
                            }
                           };
                           
            var bkgTrdEntryValidator:BkgTradeEntryValidator = new BkgTradeEntryValidator();
            bkgTrdEntryValidator.source = bkgTrdModel;
            bkgTrdEntryValidator.property = "bankingTradeEntry";
            var validationResult:ValidationResultEvent = bkgTrdEntryValidator.validate();
            
            if(validationResult.type==ValidationResultEvent.INVALID){
                var errorMsg:String = validationResult.message;
                XenosAlert.error(errorMsg);
            }else{
                calcNetAmountRequest.url = "bkg/depoLoanEntryDispatch.action?method=calculate&rnd=" + rndNo;                    
                calcNetAmountRequest.send(); 
            }               
        }
        
        private function netAmountCalcResHandler(event:ResultEvent):void{
            if(event != null){
                if(event.result != null){
                    if(event.result.depoLoanEntryActionForm != null){
                        if(event.result.depoLoanEntryActionForm.bkgTrdData != null){
                        	errPage.removeError();
                            this.fundAccPopUp.accountNo.text = event.result.depoLoanEntryActionForm.bkgTrdData.inventoryAccountNo;
                            this.counterPartyAccPopUp.accountNo.text = event.result.depoLoanEntryActionForm.bkgTrdData.accountNo;
                            this.takenplaced.text = "PLACED";
                            this.currencyCode.ccyText.text = event.result.depoLoanEntryActionForm.bkgTrdData.currencyCode;
                            this.tradeDate.text = event.result.depoLoanEntryActionForm.bkgTrdData.tradeDate;
                            this.tradeTime.text = event.result.depoLoanEntryActionForm.bkgTrdData.tradeTime;
                            this.startDate.text = event.result.depoLoanEntryActionForm.bkgTrdData.startDate;
                            this.maturityDate.text = event.result.depoLoanEntryActionForm.bkgTrdData.maturityDate;
                            this.principalAmount.text = event.result.depoLoanEntryActionForm.bkgTrdData.principalAmount;
                            this.interestRate.text = event.result.depoLoanEntryActionForm.bkgTrdData.interestRate;
                            this.accruedDays.text = event.result.depoLoanEntryActionForm.bkgTrdData.accruedDays;
                            this.interestAmount.text = event.result.depoLoanEntryActionForm.bkgTrdData.interestAmount;
                            this.netAmount.text = event.result.depoLoanEntryActionForm.bkgTrdData.netAmount;
                            this.remarks.text = event.result.depoLoanEntryActionForm.bkgTrdData.remarks;
                            this.referenceNo.text = event.result.depoLoanEntryActionForm.bkgTrdData.referenceNo;
                            /* Populating Trade type drop down*/
                            var index:int = -1;
                            if(trdTypeDP != null){
                                if(trdTypeDP is ArrayCollection){
                                    for each(var itm:Object in (trdTypeDP as ArrayCollection)){
                                        if(event.result.depoLoanEntryActionForm.bkgTrdData.tradeType == itm.toString()){
                                            index = (trdTypeDP as ArrayCollection).getItemIndex(itm);
                                        }
                                    }
                                }else{
                                    index = 1;
                                }
                            }                           
                            this.tradeType.dataProvider = trdTypeDP;
                            this.tradeType.selectedIndex = index;
                            this.manualInstrAmnt = false;
                            
                            //Set initial values
                            this.currencyCodeStr = event.result.depoLoanEntryActionForm.bkgTrdData.currencyCode;
                            this.startDateStr = event.result.depoLoanEntryActionForm.bkgTrdData.startDate;
			                this.maturityDateStr = event.result.depoLoanEntryActionForm.bkgTrdData.maturityDate;
			                this.principalAmountStr = event.result.depoLoanEntryActionForm.bkgTrdData.principalAmount;
			                this.interestRateStr = event.result.depoLoanEntryActionForm.bkgTrdData.interestRate;
			                this.interestAmtStr = event.result.depoLoanEntryActionForm.bkgTrdData.interestAmount;
                        }
                    }else if(event.result.XenosErrors != null){
                        var errorInfoList : ArrayCollection = new ArrayCollection();
                        if(event.result.XenosErrors.Errors != null){
                            if(event.result.XenosErrors.Errors.error is ArrayCollection){
                                errorInfoList = event.result.XenosErrors.Errors.error as ArrayCollection;
                            }else{
                                errorInfoList.addItem(event.result.XenosErrors.Errors.error);
                            }
                        }
                        errPage.showError(errorInfoList);
                    }
                }else{
                    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                }
            }else{
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            }
        }
        
        
        private function resetCalculatedFieldsForCcy(event:FocusEvent):void{
        	if(!XenosStringUtils.equals(this.currencyCode.ccyText.text,currencyCodeStr)){
        		this.accruedDays.text = "";
	            this.interestAmount.text = "";
	            this.netAmount.text = "";
        	}
        }
        private function resetCalculatedFieldsForStartDate():void{
        	if(!XenosStringUtils.equals(this.startDate.text,startDateStr)){
        		this.accruedDays.text = "";
	            this.interestAmount.text = "";
	            this.netAmount.text = "";
        	}
        }
        private function resetCalculatedFieldsForMaturityDate():void{
        	if(!XenosStringUtils.equals(this.maturityDate.text,maturityDateStr)){
        		this.accruedDays.text = "";
	            this.interestAmount.text = "";
	            this.netAmount.text = "";
        	}
        }
        private function resetCalculatedFieldsPrincipalAmt():void{
        	var principalAmtInitWOComma:String = clearComma(StringUtil.trim(principalAmountStr));
	   		var principalAmtCurrentWOComma:String = clearComma(StringUtil.trim(principalAmount.text));
		   	var principalAmtInit:Number = new Number(principalAmtInitWOComma);
		   	var principalAmtCurrent:Number = new Number(principalAmtCurrentWOComma);
		   	if(principalAmtInit != principalAmtCurrent){
		   		this.accruedDays.text = "";
	            this.interestAmount.text = "";
	            this.netAmount.text = "";
		   	}
        }
        private function resetCalculatedFieldsInterestRate():void{
        	var interestRateInitWOComma:String = clearComma(StringUtil.trim(interestRateStr));
	   		var interestRateCurrentWOComma:String = clearComma(StringUtil.trim(interestRate.text));
		   	var interestRateInit:Number = new Number(interestRateInitWOComma);
		   	var interestRateCurrent:Number = new Number(interestRateCurrentWOComma);
		   	if(interestRateInit != interestRateCurrent){
		   		this.accruedDays.text = "";
	            this.interestAmount.text = "";
	            this.netAmount.text = "";
		   	}
        }
        private function clearNetAmountForInterestAmt():void{
        	var interestAmountInitWOComma:String = clearComma(StringUtil.trim(interestAmtStr));
	   		var interestAmountCurrentWOComma:String = clearComma(StringUtil.trim(interestAmount.text));
		   	var interestAmountInit:Number = new Number(interestAmountInitWOComma);
		   	var interestAmountCurrent:Number = new Number(interestAmountCurrentWOComma);
		   	if(interestAmountInit != interestAmountCurrent){
		   		this.netAmount.text="";
		   	}
        }
        
        /**
	   * This method takes string as argument. If any comma (,) is present
	   * in the argument string, removes that/those comma/s and returns 
	   * the argument string without comma/s.
	   * */
	   private function clearComma(str:String):String{
        	var retStr:String = '';
        	var strArr:Array = new Array();
        	if(str != null){
        		if(str.indexOf(',') != -1){
	        		strArr = str.split(',');
	        	}
        	}
        	if(strArr.length > 0){
        		for(var i:int = 0; i < strArr.length; i++){
        			retStr = retStr + strArr[i];
        		}
        	}else{
        		retStr = str;
        	}
        	return retStr;
        }
        
        
        private function doSave():void{
            if(uConfSubmit.enabled == true){
                this.mode == 'entry' ?  this.dispatchEvent(new Event('entryConf')) :  this.dispatchEvent(new Event('amendEntryConf'));
            }
            uConfSubmit.enabled = false;
        }
        
        private function onChangeFundAccountNo(event:Event):void{
    		OnDataChangeUtil.onChangeFundAccountNo(fundAccName,fundAccPopUp.accountNo.text);
	    }
	    
	     private function onChangeCPAccountNo(event:Event):void{
    		OnDataChangeUtil.onChangeAccountNo(cpAccName,counterPartyAccPopUp.accountNo.text);
	    } 
	    
	    private function setFocusOnParent(event:Event):void{
        (TextInput(event.currentTarget)).setFocus();
        (TextInput(event.currentTarget)).removeEventListener(FlexEvent.VALUE_COMMIT,setFocusOnParent);
       }
       
       private function ccyImgClickHandler(event:MouseEvent):void{
         currencyCode.ccyText.addEventListener(FlexEvent.VALUE_COMMIT,setFocusOnParent);
       }
	    