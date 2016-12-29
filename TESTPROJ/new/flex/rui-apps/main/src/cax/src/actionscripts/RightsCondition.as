



import com.nri.rui.cax.validator.RightsConditionEntryValidator;
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.*;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;
import mx.rpc.events.ResultEvent;
            
/**
 * RightsCondition - Action Script for Ca Event Entry/Amend/Cancel UI.
 * @author joyeetag
 * @version 
 */ 
      
[Bindable]
private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
[Bindable]private var mode : String;
[Bindable]private var rightsConditionPk : String ;
//required for amend and cancel request object set.     
[Bindable]private var subEventTypeStr : String ;  
//required for amend and cancel request object set.     
[Bindable]private var conditionStatusStr : String ;                                
[Bindable]private var referenceNo : String;
[Bindable]private var eventType : String = "";    
[Bindable]private var subEventTypeListAmd : ArrayCollection = new ArrayCollection() ;      
[Bindable]private var subEventTypeDescrpStr : String = "" ;                       
[Bindable]private var initialStateFlag:Boolean = false;
[Bindable]private var reqObj : Object = new Object();
[Bindable]private var rs : XML = new XML();            
[Bindable]private var keylist:ArrayCollection = new ArrayCollection(); 
			
//XGA-408
private var defaultPerShare:String = '1';

    
     /**
      * This method is called at the time of loading the main page of the event entry screen.
      * called at RightsConditionEntry.mxml - creationComplete="loadAll()
      * This method calls the parseUrlString method to parse the URL
      * It fires the Event amendEntryInit to call the method doAmendInit.
      * 
      * @see com.nri.rui.core.containers.XenosEntryModule.doAmendInit 
      */
      public function loadAll():void {
      	loadTitleText();
          parseUrlString();
          super.setXenosEntryControl(new XenosEntry());
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
      
      public function loadTitleText():void{
      	stockMergerCnf2.instrumentcodelbl=this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.instrumentcode');
		stockMergerCnf2.securitynamelbl=this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.securityname');
		stockMergerCnf2.persharelbl=this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.pershare');
		stockMergerCnf2.allotmentquantitylbl=this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.allotmentquantity');
		stockMergerCnf2.ccycashdividendlbl=this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.ccycashdividend');
		stockMergerCnf2.allotmentamountlbl=this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.allotmentamount');
		stockMergerCnf2.persharecashdividendlbl=this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.persharecashdividend');
		stockMergerCnf2.payOutcurrencylbl=this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.payoutccy');
		stockMergerCnf2.payoutpricelbl=this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.payoutprice');
      }
           
    /**
     * Extracts the parameters and set them to some variables for query criteria from 
     * the Module Loader Info.
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
                    if (tempA[0] == "rightsConditionPk") {                        
                        this.rightsConditionPk = tempA[1];
                    } else if(tempA[0] == "mode") {
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
            
        /**
         * The Pre method for Initial Screen Loading of Event Entry action.
         * @override 
         * @see com.nri.rui.core.containers.XenosEntryModule.preEntryInit
         */
        override public function preEntryInit():void {              
            var rndNo:Number= Math.random(); 
            var reqObject:Object = new Object();
            reqObject.SCREEN_KEY = 414;
            super.getInitHttpService().url = "cax/rightsEventEntryConditionDispatch.action?method=initialExecute&&mode=entry&&menuType=Y&rnd=" + rndNo;
            super.getInitHttpService().request = reqObject;  
            
        }
        
        /**
         * The Pre method for Initial Screen Loading of Event Amend action.
         * @override 
         * @see com.nri.rui.core.containers.XenosEntryModule.preAmendInit
         */              
        override public function preAmendInit():void{ 
            this.initLabel.visible = false;
            this.initLabel.includeInLayout= false;          
            var rndNo:Number= Math.random(); 
            super.getInitHttpService().url = "cax/RightsConditionDetailsAmendViewDispatch.action?";
            var reqObject:Object = new Object();
            reqObject.rnd = rndNo;
            reqObject.method= "detailsViewForAmend";
            reqObject.mode=this.mode;
            reqObject.rightsConditionPk = this.rightsConditionPk;
            reqObject.SCREEN_KEY = 419;
            super.getInitHttpService().request = reqObject;         
            loadAmendCxlInitialState(true);         
        }   
        
        /**
         * The Pre method for Initial Screen Loading of Event Cancel action.
         * @override 
         * @see com.nri.rui.core.containers.XenosEntryModule.preCancelInit
         */         
        override public function preCancelInit():void{              
            this.back.includeInLayout = false;
            this.back.visible = false;                          
            var rndNo:Number= Math.random(); 
            super.getInitHttpService().url = "cax/RightsConditionDetailsCancelViewDispatch.action?";
            var reqObject:Object = new Object();
            reqObject.rnd = rndNo;
            reqObject.method= "detailsViewForCancel";
            reqObject.mode=this.mode;
            reqObject.rightsConditionPk = this.rightsConditionPk;    
            reqObject.SCREEN_KEY = 420;           
            super.getInitHttpService().request = reqObject;
            loadAmendCxlInitialState(true);                 
        }        
            
            
       /**
        * Pre method on the handeler of Reset button. 
        * @override 
        * @see com.nri.rui.core.containers.XenosEntryModule.preResetEntry
        */
       override public function preResetEntry():void {
          
            var rndNo:Number= Math.random();
            super.getResetHttpService().url = "cax/rightsEventEntryConditionDispatch.action?method=resetRightsConditionEntry";
            eventType = "";
            currentState = "";
            initialStateFlag = true;
             
       }    
       /**
        * Pre method on the handeler of Reset button on amend operation. 
        * @override 
        * @see com.nri.rui.core.containers.XenosEntryModule.preResetEntry
        */     
        override public function preResetAmend():void {
            //super.getResetHttpService().url = "cax/RightsConditionDetailsAmendViewDispatch.action?method=resetRightsConditionAmend";
            this.initLabel.visible = false;
            this.initLabel.includeInLayout= false;          
            var rndNo:Number= Math.random(); 
            super.getResetHttpService().url = "cax/RightsConditionDetailsAmendViewDispatch.action?";
            var reqObject:Object = new Object();
            reqObject.rnd = rndNo;
            reqObject.method= "detailsViewForAmend";
            reqObject.mode=this.mode;
            reqObject.rightsConditionPk = this.rightsConditionPk;
            reqObject.SCREEN_KEY = 419;
            super.getResetHttpService().request = reqObject;
            loadAmendCxlInitialState(true); 
        }              
            
        /**
         * Prepares the Keylist that maps to the ActionForm attribute names to fetch the element's value
         * to show.
         * 
         */
        private function addCommonKeys():void{          
            keylist = new ArrayCollection();
            keylist.addItem("eventTypeDropdownList.item");
            keylist.addItem("subEventType");
            keylist.addItem("corporateActionId");               
            keylist.addItem("eventTypeStatusDropdownList.item");
            keylist.addItem("processingFrequencyDropdownList.item"); 
            keylist.addItem("processingFrequency");                 
            keylist.addItem("processStartDateStr");             
            keylist.addItem("processEndDateStr");
            keylist.addItem("instrumentCode");     
            keylist.addItem("allottedInstrument");              
            keylist.addItem("remarks");
            keylist.addItem("description");
            keylist.addItem("conditionStatus");
            keylist.addItem("subEventTypeDescription");
            keylist.addItem("exDateStr");
            keylist.addItem("warrantExpiryDateStr");
            keylist.addItem("externalReferenceNo");
            keylist.addItem("recordDateStr");               
            keylist.addItem("bookClosingDateStr");
            keylist.addItem("allotmentQuantityStr");
            keylist.addItem("perShareStr");
            keylist.addItem("paymentDateStr");              
            keylist.addItem("allotmentQuantitySplStr");
            keylist.addItem("splPerShareStr");
            keylist.addItem("faceValueStr");
            keylist.addItem("payOutPriceStr");
            keylist.addItem("bookClosingDateStr");                  
            keylist.addItem("allottedCurrency");
            keylist.addItem("allotmentAmountStr");
            keylist.addItem("splAllotementAmountStr");
            keylist.addItem("announcementDate");
            keylist.addItem("dueBillEndDateStr");           
            keylist.addItem("protectExpirationDate");
            keylist.addItem("creditDateStr");
            keylist.addItem("dividendNo");
            keylist.addItem("warrantNo");
            keylist.addItem("finantialYearEndDateStr");                 
            keylist.addItem("blockVoucherQuantityStr");
            keylist.addItem("deadLineDateStr");
            keylist.addItem("rightsExpiryDateStr");
            keylist.addItem("couponDateStr");
            keylist.addItem("couponRateStr");                                               
            keylist.addItem("originalRecordDateStr");
            keylist.addItem("previousFactorStr");
            keylist.addItem("currentFactorStr");
            keylist.addItem("rateOfNominalStr");
            keylist.addItem("redemptionCurrency");                  
            keylist.addItem("subscriptionCcy");
            keylist.addItem("subsCostPerShareStr");
            //tax fee
            keylist.addItem("taxFeeIdList.taxFeeIdDropdownList");
            keylist.addItem("rateTypeDropdownList.item");                                       
            //others
            keylist.addItem("freeOutParentSecurityList.item");
            // condition Reference No. after entry is done to display   
            keylist.addItem("conditionRefrenceNo"); 
            keylist.addItem("allotedCcyName"); 
            keylist.addItem("instrumentName");  
            keylist.addItem("allotedInstrumentName"); 
            keylist.addItem("payOutCcy");   
            keylist.addItem("couponDateTipsIndex"); 
            keylist.addItem("issueDateTipsIndex");
            keylist.addItem("redemptionCurrencyName"); 
            keylist.addItem("redemptionDateTipsIndex");
            keylist.addItem("redemptionPriceStr");   
            keylist.addItem("exerciseDateStr"); 
            keylist.addItem("eventTypeName");
            keylist.addItem("freeOutParentSecurity");
            keylist.addItem("redemptionDateStr");
            keylist.addItem("stockEntryList");  
            keylist.addItem("stockEntryList.stockEntryList");   
            keylist.addItem("subEventTypeList.item");   
            keylist.addItem("conditionTaxFeeList.conditionTaxFeeList");  
            keylist.addItem("paymentDateTakeUpStr"); 
            keylist.addItem("rightsPaymentDateStr");
            keylist.addItem("allottedRightsInstrument");
            keylist.addItem("allottedRightsQuantityStr");
            keylist.addItem("perShareRightsStr");
            keylist.addItem("allottedRightsInstrumentName");
        }
        
        /**
         * Pre Result Handler of User Confirmation Screen
         * @return Keylist object containing the Xml Element Name
         * @override 
         * @see com.nri.rui.core.containers.XenosEntryModule.preEntryResultInit
         */
        override public function preEntryResultInit():Object {
            addCommonKeys(); 
            return keylist;
        }
        /**
         * Pre Result Handler of User Confirmation Screen of amend operation
         * @return keyList object containing the Xml Element Name
         * @override 
         * @see com.nri.rui.core.containers.XenosEntryModule.preAmendResultInit
         */
        override public function preAmendResultInit():Object {          
            addCommonKeys(); 
            return keylist;
        }   
        /**
         * Pre Result Handler of User Confirmation Screen of cancel operation
         * @return keyList object containing the Xml Element Name
         * @override 
         * @see com.nri.rui.core.containers.XenosEntryModule.preCancelResultInit
         * 
         */        
        override public function preCancelResultInit():Object{
            addCommonKeys();            
            return keylist;
        }                                     
        
        /**
         * Post Result Handler of User Confirmation Screen
         * @param mapObj The Object containing the result of submit operation.
         * @override 
         * @see com.nri.rui.core.containers.XenosEntryModule.postEntryResultInit
         */
        override public function postEntryResultInit(mapObj:Object): void {
            commonInit(mapObj);
            if(initialStateFlag == true && !(XenosStringUtils.equals(mode,"amend"))) {
                loadInitialState();
            }   
            this.ConditionRefNoId.visible=false;
            this.ConditionRefNoId.includeInLayout=false;    
            this.subEventTypeLblforAmend.visible=false;
            this.subEventTypeLblforAmend.includeInLayout=false;             
        } 
        
        /**
         * Post Result Handler of User Confirmation Screen of amend operation
         * @param mapObj The Object containing the result of user conf submit operation.
         * @override 
         * @see com.nri.rui.core.containers.XenosEntryModule.postAmendResultInit
         * 
         */           
        override public function postAmendResultInit(mapObj:Object): void{
            eventType = mapObj[keylist.getItemAt(2)].toString();   
            loadAmendCxlInitialState(false);                            
            changeState();
            commonInit(mapObj);
            commonAmendInitializationPart(mapObj);
            
            //Amend specific enable disable
            this.ConditionRefNoId.visible=true;
            this.ConditionRefNoId.includeInLayout=true;
            this.subEventTypeLblforAmend.visible=true;
            this.subEventTypeLblforAmend.includeInLayout=true;    
            this.subEventTypeEntry.visible=false;
            this.subEventTypeEntry.includeInLayout=false;               
        }  
        
        /**
         * Post Result Handler of User Confirmation Screen of cancel operation
         * @param mapObj The Object containing the result of user conf submit operation.
         * @override 
         * @see com.nri.rui.core.containers.XenosEntryModule.postCancelResultInit
         * 
         */                  
        override public function postCancelResultInit(mapObj:Object): void{         
            eventType = mapObj[keylist.getItemAt(2)].toString(); 
            loadAmendCxlInitialState(false);                                                    
            commonResultPart(mapObj);
            changeStateToConf();
            //Cancel Specific disable enable                        
            uConfSubmit.includeInLayout = false;
            uConfSubmit.visible = false;
            cancelSubmit.visible = true;
            cancelSubmit.includeInLayout = true;
            uConfLabel.includeInLayout = false;
            uConfLabel.visible = false;
            uConfImg.includeInLayout =false;
            uConfImg.visible =false;    
            usrCnfMessage.visible = false;
            usrCnfMessage.includeInLayout = false;              
        }
        
       /**
        * Initialization of all text fields and dropdowns for entry initial screen.
        * @param mapObj The Object containing the result of user conf submit operation
        * 
        */
       private function commonInit(mapObj:Object):void {
            errPage.clearError(super.getInitResultEvent());
            
            var initcol:ArrayCollection = new ArrayCollection();
            var index:int=0;
            
            //text field initialization
            textFieldInitilize();
            
            
                                                            
                //initialize free out parent security           
            
                index = 0;
                initcol = new ArrayCollection();                
                initcol.addItem({label:" ", value: " "});                       
                for each(var itemOthr:Object in (mapObj[keylist.getItemAt(51)] as ArrayCollection)){
                    initcol.addItem(itemOthr);
                    if(XenosStringUtils.equals(eventType,"OTHERS")) {
                        if(XenosStringUtils.equals(mode,"amend")) {
                            if(mapObj[keylist.getItemAt(64)].toString() != "") {
                                if(itemOthr.value == mapObj[keylist.getItemAt(64)].toString()){
                                    index = (mapObj[keylist.getItemAt(51)] as ArrayCollection).getItemIndex(itemOthr);
                                }
                             }
                        }
                    }                               
                }           
                this.others1.freeOutParentSecurity.dataProvider = initcol;  
                if(XenosStringUtils.equals(mode,"amend")) {
                    this.others1.freeOutParentSecurity.selectedIndex = index+1; 
                } 
                                        
                //initialize subevent type
                initcol = new ArrayCollection();
                index=0;            
                
                for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
                    initcol.addItem(item);                                                                  
                }               
                subEventTypeEntry.dataProvider = initcol;
                
                //initialize processing freq
                index=0;
                processingFrequency.dataProvider=mapObj[keylist.getItemAt(4)] as ArrayCollection; 
                for each(var item1:Object in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
                    if(item1.value == mapObj[keylist.getItemAt(5)].toString()){
                        index = (mapObj[keylist.getItemAt(4)] as ArrayCollection).getItemIndex(item1);
                    }
                }
                processingFrequency.selectedIndex = index;
                // initialize event type Status
                initcol = new ArrayCollection();                
                initcol.addItem({label:" ", value: " "});
                index=0;
                for each(var item2:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
                    initcol.addItem(item2);
                    if(XenosStringUtils.equals(mode,"amend")){
                        if(item2.value == mapObj[keylist.getItemAt(12)].toString()){                            
                            index = (mapObj[keylist.getItemAt(3)] as ArrayCollection).getItemIndex(item2);                      
                      }
                    }                   
                }
                conditionStatusEntry.dataProvider = initcol;    
                if(XenosStringUtils.equals(mode,"amend")){  
                    conditionStatusEntry.selectedIndex = index+1;           
                }  
                
            
            
        } 
       
     /**
      * All text fields are initialised here. Required for Entry and Reset.
      *  
      */
     private function textFieldInitilize():void {
        
                //initialize text fields common part
                this.remarks.text= "";
                this.description.text = "";
                this.externalReferenceNo.text = "";
                this.processEndDateStr.text = "";
                this.processStartDateStr.text ="";
                this.rate.text ="";         
                
                // for Cash dividend
                this.cash1.security.instrumentId.text = "";
                this.cash1.allttedCcy.ccyText.text = "";  
                this.cash1.exDateStr.text ="";
                this.cash1.recordDateStr.text ="";
                this.cash1.bookClosingDateStr.text ="";
                this.cash1.paymentDateStr.text ="";
                this.cash1.allotmentAmountStr.text ="";
                this.cash1.perShareStr.text ="";
                this.cash1.splAllotementAmountStr.text ="";
                this.cash1.splPerShareStr.text ="";
                this.cash1.announcementDate.text ="";
                this.cash1.creditDateStr.text ="";
                this.cash1.dividendNo.text ="";
                this.cash1.warrantNo.text ="";
                this.cash1.blockVoucherQuantityStr.text ="";
                this.cash1.finantialYearEndDateStr.text ="";   
                this.cash1.protectExpirationDate.text = "";
                
                //for stock Dividend            
                this.stock1.security.instrumentId.text = "";
                this.stock1.allottedSecurity.instrumentId.text= "";
                this.stock1.exDateStr.text ="";
                this.stock1.recordDateStr.text ="";
                this.stock1.bookClosingDateStr.text ="";
                this.stock1.dueBillEndDateStr.text= "";
                this.stock1.paymentDateStr.text ="";
                this.stock1.allotmentQuantityStr.text ="";
                this.stock1.perShareStr.text ="";
                this.stock1.allotmentQuantitySplStr.text ="";
                this.stock1.splPerShareStr.text ="";
                this.stock1.announcementDate.text ="";
                this.stock1.creditDateStr.text ="";
                this.stock1.dividendNo.text ="";
                this.stock1.blockVoucherQuantityStr.text ="";
                this.stock1.finantialYearEndDateStr.text ="";           
                this.stock1.faceValueStr.text ="";
                this.stock1.payOutCcy.ccyText.text="";
                this.stock1.payOutPriceStr.text ="";
                
                //for similar Events(stocksplit,ReverseStockSplit,Namechange,ShareEx,Spin off)          
                this.someEventsCommon1.security.instrumentId.text = "";
                this.someEventsCommon1.allottedSecurity.instrumentId.text= "";
                this.someEventsCommon1.exDateStr.text ="";
                this.someEventsCommon1.recordDateStr.text ="";
                this.someEventsCommon1.bookClosingDateStr.text ="";
                this.someEventsCommon1.dueBillEndDateStr.text= "";
                this.someEventsCommon1.paymentDateStr.text ="";
                this.someEventsCommon1.allotmentQuantityStr.text ="";
                this.someEventsCommon1.perShareStr.text ="";
                this.someEventsCommon1.announcementDate.text =""; 
                this.someEventsCommon1.protectExpirationDate.text ="";      
                this.someEventsCommon1.payOutCcy.ccyText.text="";
                this.someEventsCommon1.payOutPriceStr.text ="";  
                
                // for Cash Stock Optional Event
                this.cashStockOption1.security.instrumentId.text = "";
                this.cashStockOption1.allttedCcy.ccyText.text = "";  
                this.cashStockOption1.exDateStr.text ="";
                this.cashStockOption1.recordDateStr.text ="";
                this.cashStockOption1.bookClosingDateStr.text ="";
                this.cashStockOption1.paymentDateStr.text ="";
                this.cashStockOption1.allotmentAmountStr.text ="";
                this.cashStockOption1.perShareStr.text ="";
                this.cashStockOption1.splAllotementAmountStr.text ="";
                this.cashStockOption1.splPerShareStr.text ="";
                this.cashStockOption1.deadLineDateStr.text ="";
                this.cashStockOption1.rightsExpiryDateStr.text ="";                 
                    
                // for Coupon Payment Event
                this.couponPayment1.security.instrumentId.text = "";
                this.couponPayment1.allttedCcy.ccyText.text = "";  
                this.couponPayment1.recordDateStr.text ="";
                this.couponPayment1.paymentDateStr.text ="";
                this.couponPayment1.allotmentAmountStr.text ="";
                this.couponPayment1.perShareStr.text ="";
                this.couponPayment1.couponDateStr.text ="";
                this.couponPayment1.couponRateStr.text="";
                this.couponPayment1.creditDateStr.text="";
                this.couponPayment1.currentFactorStr.text="";
                this.couponPayment1.originalRecordDateStr.text="";
                this.couponPayment1.previousFactorStr.text =""; 
                
                // for Rights Allocation and Rights Expiry
                this.rtAllocationExpiry1.security.instrumentId.text = "";
                this.rtAllocationExpiry1.exDateStr.text ="";
                // XGA-201
                this.rtAllocationExpiry1.allottedRightsSecurity.instrumentId.text = "";
                this.rtAllocationExpiry1.allotmentRightsQuantityStr.text = "";
                this.rtAllocationExpiry1.recordDateStr.text ="";
                this.rtAllocationExpiry1.perShareRightsStr.text = "";
                this.rtAllocationExpiry1.rightsPaymentDateStr.text = "";
                this.rtAllocationExpiry1.creditDateStr.text ="";
                
                this.rtAllocationExpiryEnd1.deadLineDateStr.text ="";
                this.rtAllocationExpiryEnd1.rightsExpiryDateStr.text ="";
                this.rtAllocationExpiryEnd1.allottedSecurity.instrumentId.text = "";  
                this.rtAllocationExpiryEnd1.allotmentQuantityStr.text ="";
                this.rtAllocationExpiryEnd1.perShareStr.text ="";
                this.rtAllocationExpiryEnd1.paymentDateTakeUpStr.text="";
                this.rtAllocationExpiryEnd1.paymentDateStrForRightsExpiry.text="";
                this.rtAllocationExpiryEnd1.subscriptionCcy.ccyText.text ="";
                this.rtAllocationExpiryEnd1.subsCostPerShareStr.text ="";
                  
                
                // for Redemption Bond
                this.redemptionBond1.security.instrumentId.text = "";
                this.redemptionBond1.redemptionCurrency.ccyText.text = "";  
                this.redemptionBond1.redemptionDateStr.text ="";
                this.redemptionBond1.creditDateStr.text ="";
                this.redemptionBond1.paymentDateStr.text ="";
                this.redemptionBond1.redemptionPriceStr.text ="";
                this.redemptionBond1.rateOfNominalStr.text =""; 
                
                //for Others            
                this.others1.security.instrumentId.text = "";
                this.others1.allottedInstrument.instrumentId.text= "";
                this.others1.exDateStr.text ="";
                this.others1.recordDateStr.text ="";
                this.others1.exerciseDateStr.text ="";
                this.others1.rightsExpiryDateStr.text= "";
                this.others1.paymentDateStr.text ="";
                this.others1.allotmentQuantityStr.text ="";
                this.others1.perShareStr.text ="";
                this.others1.deadLineDateStr.text ="";          
                this.others1.payOutPriceStr.text ="";   
                this.others1.eventTypeName.text="";  
                
                //for Stock Merger          
                this.stockMerger1.allottedInstrument.instrumentId.text = "";
                this.stockMerger2.security.instrumentId.text= "";
                this.stockMerger1.exDateStr.text ="";
                this.stockMerger1.recordDateStr.text ="";
                this.stockMerger1.announcementDate.text ="";
                this.stockMerger1.protectExpirationDate.text= "";
                this.stockMerger1.paymentDateStr.text ="";
                this.stockMerger2.allotmentQuantityStr.text ="";
                this.stockMerger2.perShareStr.text ="";
                this.stockMerger2.ccyCashDividend.ccyText.text ="";         
                this.stockMerger2.payOutPriceStr.text ="";  
                this.stockMerger2.payOutCcy.ccyText.text="";        
                this.stockMerger2.allottedAmountStr.text ="";   
                this.stockMerger2.addedStockSummaryResult.removeAll();                      
                //for amend mode
                this.stockMerger2.MergerMode = mode;        
        
     }
          
        
     /**
      * Pre Hook Implementation:Event fired on click of Submit Button
      * @override 
      * @see com.nri.rui.core.containers.XenosEntryModule.preEntry
      */
     override public function preEntry():void {         
            setValidator();
           	var reqObject:Object = populateRequestParams();
            reqObject.SCREEN_KEY = 415;
            super.getSaveHttpService().url = "cax/rightsEventEntryConditionDispatch.action?method=submitRightsConditionEntry";
            super.getSaveHttpService().request  = reqObject;
     }  
      
     /**
      * Pre Amend Hook Implementation:Event fired on click of Submit Button
      * @override 
      * @see com.nri.rui.core.containers.XenosEntryModule.preAmend 
      */     
     override public function preAmend():void{
        setValidator();
       	var reqObject:Object = populateRequestParams();
        reqObject.SCREEN_KEY = 415;        
        super.getSaveHttpService().url = "cax/RightsConditionAmendDispatch.action?method=submitRightsConditionAmend";  
        super.getSaveHttpService().request  = reqObject;
     }  
     
     /**
      * Pre Cancel Hook Implementation:Event fired on click of Submit Button
      * @override 
      * @see com.nri.rui.core.containers.XenosEntryModule.preCancel 
      */     
     override public function preCancel():void{     
        super.getSaveHttpService().url = "cax/RightsConditionCancelDispatch.action?method=SubmitRightsConditionCancel";
         var reqObj:Object = new Object();
         reqObj.mode=this.mode;                 
         reqObj.rightsConditionPk = this.rightsConditionPk;
         reqObj.SCREEN_KEY = 421;  
        super.getSaveHttpService().request  =reqObj;
     }        
     
    /**
     * Pre Hook Implementation:Event Handler on click of Submit Button
     * @return  Keylist the list containing the Xml element names
     * @override 
     * @see com.nri.rui.core.containers.XenosEntryModule.preEntryResultHandler 
     */
    override public function preEntryResultHandler():Object {
         addCommonKeys();
         return keylist;
    }         
         
    /**
     * Post Hook Implementation:Event Handler on click of Submit Button
     * @param mapObj
     * 
     */
    override public function postEntryResultHandler(mapObj:Object):void {         
        commonResult(mapObj);       
        uConfLabel.includeInLayout = true;
        uConfLabel.visible = true;
        uConfImg.includeInLayout =false;
        uConfImg.visible =false;
        usrCnfMessage.text = this.parentApplication.xResourceManager.getKeyValue('cax.ca.event.entry.usr.confirm');
        this.ConditionRefNoConfId.visible=false;
        this.ConditionRefNoConfId.includeInLayout=false;            
    }
    
    /**
     * Pre Amend Hook Implementation:Event Handler on click of Submit Button
     * @return  Keylist the list containing the Xml element names
     * @override 
     * @see com.nri.rui.core.containers.XenosEntryModule.preAmendResultHandler 
     * 
     */
    override public function preAmendResultHandler():Object {
         addCommonKeys();
         return keylist;
    }         
         
    /**
     * Post Hook Implementation:Event Handler on click of Submit Button
     * @param mapObj The object containing all the result values with the as a name and value pair.
     * where names corresponds to the XML element names(keylist values)
     * @override 
     * @see com.nri.rui.core.containers.XenosEntryModule.postAmendResultHandler 
     */
    override public function postAmendResultHandler(mapObj:Object):void {         
        commonResult(mapObj);       
        uConfLabel.includeInLayout = true;
        uConfLabel.visible = true;
        uConfImg.includeInLayout =false;
        uConfImg.visible =false;
        usrCnfMessage.text = this.parentApplication.xResourceManager.getKeyValue('cax.ca.event.amend.usr.confirm');
        this.ConditionRefNoConfId.visible=true;
        this.ConditionRefNoConfId.includeInLayout=true;         
    }   
    /**
     * Post Cancel Hook Implementation:Event Handler on click of Submit Button
     * @param mapObj The object containing all the result values with the as a name and value pair.
     * where names corresponds to the XML element names(keylist values)
     * @override 
     * @see com.nri.rui.core.containers.XenosEntryModule.postCancelResultHandler 
     * 
     */
    override public function postCancelResultHandler(mapObj:Object):void {        
        
        submitUserConfResult(mapObj);
            
        this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('cax.ca.event.cancel.usr.confirm');
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
        usrCnfMessage.visible = true;
        usrCnfMessage.includeInLayout = true;                   
        this.ConditionRefNoConfId.visible=true;
        this.ConditionRefNoConfId.includeInLayout=true;         
    }   
             
    
    
    /**
     * Pre Hook Implementation:Event fired on click of Confirm Button
     * 
     */
    override public function preEntryConfirm():void {
        var reqObj :Object = new Object();
        super.getConfHttpService().url = "cax/rightsEventEntryConditionDispatch.action?";  
        reqObj.method= "commitRightsConditionConfirm";
        reqObj.SCREEN_KEY = 416; 
        super.getConfHttpService().request  =reqObj;
    }  
     
    /**
     * Pre Hook Implementation:Event Handler on click of Confirm Button
     * @return  Keylist the list containing the Xml element names
     * @override 
     * @see com.nri.rui.core.containers.XenosEntryModule.preEntryConfirmResultHandler 
     * 
     */
    override public function preEntryConfirmResultHandler():Object {
         addCommonKeys();
         return keylist;
    }    
     
     
    /**
     * Post hook implementaion:Event Handler on click of Confirm Button
     * @param mapObj The object containing all the result values with the as a name and value pair.
     * where names corresponds to the XML element names(keylist values)
     * @override 
     * @see com.nri.rui.core.containers.XenosEntryModule.postConfirmEntryResultHandler 
     * 
     */
    override public function postConfirmEntryResultHandler(mapObj:Object):void {
        submitUserConfResult(mapObj);       
    } 
    
    /**
     * Pre Amend Hook Implementation:Event fired on click of Confirm Button
     * @override 
     * @see com.nri.rui.core.containers.XenosEntryModule.preAmendConfirm 
     */
    override public function preAmendConfirm():void {
        var reqObj :Object = new Object();
        super.getConfHttpService().url = "cax/RightsConditionAmendDispatch.action?";  
        reqObj.method= "commitRightsConditionAmend";
        reqObj.SCREEN_KEY = 416; 
        super.getConfHttpService().request  =reqObj;
    }  
     
    /**
     * Pre Hook Implementation:Event Handler on click of Confirm Button
     * @return  Keylist the list containing the Xml element names
     * @override 
     * @see com.nri.rui.core.containers.XenosEntryModule.preConfirmAmendResultHandler  
     * 
     */
    override public function preConfirmAmendResultHandler():Object {
         addCommonKeys();
         return keylist;
    }    
     
     
    /**
     * Post Amend hook implementaion:Event Handler on click of Confirm Button
     * @param mapObj The object containing all the result values with the as a name and value pair.
     * where names corresponds to the XML element names(keylist values)
     * @override 
     * @see com.nri.rui.core.containers.XenosEntryModule.postConfirmAmendResultHandler 
     * 
     */
    override public function postConfirmAmendResultHandler(mapObj:Object):void {
        submitUserConfResult(mapObj);
    }   
    
    /**
     * Pre Hook Implementation:Event fired on click of Confirm Button
     * 
     */
    override public function preCancelConfirm():void {
        var reqObj :Object = new Object();
        super.getConfHttpService().url = "cax/RightsConditionCancelDispatch.action?";  
        reqObj.method= "ConfirmRightsConditionCancel";
        reqObj.SCREEN_KEY=422;
        super.getConfHttpService().request  =reqObj;
    }  
     
    /**
     * Pre Cancel Hook Implementation:Event Handler on click of Confirm Button
     * @return  Keylist the list containing the Xml element names
     * @override 
     * @see com.nri.rui.core.containers.XenosEntryModule.preConfirmCancelResultHandler  
     */
    override public function preConfirmCancelResultHandler():Object {
         addCommonKeys();
         return keylist;
    }    
     
     
    /**
     * Post Cancel hook implementaion:Event Handler on click of Confirm Button
     * @param mapObj The object containing all the result values with the as a name and value pair.
     * where names corresponds to the XML element names(keylist values)
     * @override 
     * @see com.nri.rui.core.containers.XenosEntryModule.postConfirmCancelResultHandler 
     * 
     */
    override public function postConfirmCancelResultHandler(mapObj:Object):void {
        submitUserConfResult(mapObj);               
        
        
    }   
          
         
    /**
     * Event Handler on click of Confirm Button.
     *  
     * @param mapObj The object containing all the result values with the as a name and value pair.
     * where names corresponds to the XML element names(keylist values)
     * 
     */
    private function submitUserConfResult(mapObj:Object):void {
    if(mapObj!=null){                       
        if(mapObj["errorFlag"].toString() == "error"){          
            errConf.removeError();          
            errConf.showError(mapObj["errorMsg"]);
        }else if(mapObj["errorFlag"].toString() == "noError"){
            if(mode!="cancel")
              errConf.clearError(super.getConfResultEvent());
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
           // reference No to display.
           if(XenosStringUtils.equals(mode,"entry") || XenosStringUtils.equals(mode,"amend") ) {
                referenceNo = mapObj[keylist.getItemAt(52)].toString();                     
           }
           if(XenosStringUtils.equals(mode,"cancel")) {
                txnMessage.text = this.parentApplication.xResourceManager.getKeyValue('cax.transaction.completed')+' '+this.parentApplication.xResourceManager.getKeyValue('cax.corporate.action.event')+'['+referenceNo+'] '+this.parentApplication.xResourceManager.getKeyValue('cax.label.cancelled');
           }
           if(XenosStringUtils.equals(mode,"entry")){
                uConfLabel.includeInLayout = true;
                uConfLabel.visible = true;
                uConfImg.includeInLayout =false;
                uConfImg.visible =false;
                usrCnfMessage.text = this.parentApplication.xResourceManager.getKeyValue('cax.ca.event.entry')+' - ' + this.parentApplication.xResourceManager.getKeyValue('cax.system.confirmation1');
                this.ConditionRefNoConfId.visible=false;
                this.ConditionRefNoConfId.includeInLayout=false;                        
            
           } else if(XenosStringUtils.equals(mode,"amend")) {
                uConfLabel.includeInLayout = true;
                uConfLabel.visible = true;
                uConfImg.includeInLayout =false;
                uConfImg.visible =false;
                usrCnfMessage.text = this.parentApplication.xResourceManager.getKeyValue('cax.ca.event.amend')+' - ' + this.parentApplication.xResourceManager.getKeyValue('cax.system.confirmation1');
                this.ConditionRefNoConfId.visible=true;
                this.ConditionRefNoConfId.includeInLayout=true;         
            
           } else if(XenosStringUtils.equals(mode,"cancel")) {
                this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('cax.ca.event.cancel')+' - ' + this.parentApplication.xResourceManager.getKeyValue('cax.system.confirmation1');     
                cancelSubmit.visible = false;
                cancelSubmit.includeInLayout = false;
                uCancelConfSubmit.visible = false;
                uCancelConfSubmit.includeInLayout = false;
                uConfLabel.includeInLayout = false;
                uConfLabel.visible = false;     
                this.ConditionRefNoConfId.visible=true;
                this.ConditionRefNoConfId.includeInLayout=true;             
           }
           
                                           
        }else{
            errConf.removeError();
        }           
    }
}
     
    /**
     * Event of clicking on the Ok button of the Event Entry/Amemd/Cancel operation
     * @param e Event Event fired 
     * @override 
     * @see com.nri.rui.core.containers.XenosEntryModule.doEntrySystemConfirm
     */
    override public function doEntrySystemConfirm(e:Event):void {
        
        super.preEntrySystemConfirm();
        initialStateFlag = true;
        this.dispatchEvent(new Event('entryInit'));
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
        loadInitialState();
        vstack.selectedChild = qry;                     
        super.postEntrySystemConfirm();     
    }        
    
    
   /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {                   
        
        //Common Fields
        if(XenosStringUtils.equals(mode,"amend")) {          
            reqObj.corporateActionId = this.eventType;   
            reqObj.rightsConditionPk = this.rightsConditionPk;  
            reqObj.subEventType = this.subEventTypeStr;             
            reqObj.conditionRefrenceNo = this.conditionReferenceNo.text;
        } else {
            reqObj.subEventType = this.subEventTypeEntry.selectedItem != null ? this.subEventTypeEntry.selectedItem.value : "";
        } 
        
        reqObj.conditionStatus =  this.conditionStatusEntry.selectedItem != null ? this.conditionStatusEntry.selectedItem.value : "";       
        reqObj.processingFrequency = this.processingFrequency.selectedItem != null ? this.processingFrequency.selectedItem.value : "";
        
        // Processing Freq wise Start date and end date Population
        var processingFreq:String = this.processingFrequency.selectedItem.value;
        if(XenosStringUtils.equals(processingFreq,"DAILY")) {
            reqObj.processStartDateStr = this.processStartDateStr.text;
            reqObj.processEndDateStr   = this.processEndDateStr.text;               
        } else if(XenosStringUtils.equals(processingFreq,"TRIGGER")) {
            reqObj.processStartDateStr = this.processStartDateStr.text;
            reqObj.processEndDateStr   = "";                        
        } else if(XenosStringUtils.equals(processingFreq,"MANUAL")) {
            reqObj.processStartDateStr = "";
            reqObj.processEndDateStr   = "";
        }
    
        reqObj.description = this.description.text;
        reqObj.externalReferenceNo = this.externalReferenceNo.text;    
        reqObj.remarks = this.remarks.text;     
        
        changeEventTypeToPopulateReqParam();

        return reqObj;
    }
    
    /**
     * Depending upon the event type correct request param is forked.
     * @param eventType the Event type
     * 
     */
    private function changeEventTypeToPopulateReqParam() : void {
        switch (eventType) {       
            case "CASH_DIVIDEND" :
            case "CAPITAL_REPAYMENT" :
                return populateCashDivRequestParam();
                 break;             
            case "STOCK_DIVIDEND" :
                return populateStockDivRequestParam();
                break;                              
            case "BONUS_ISSUE" :
                return populateStockDivRequestParam();
                 break;
            case "NAME_CHANGE" :
                return populateSimilarEventsRequestParam();
                 break;
            case "SPIN_OFF" :
                return populateSimilarEventsRequestParam(); 
                 break; 
            case "STOCK_SPLIT" :
                return populateSimilarEventsRequestParam();
                 break;
            case "REVERSE_STOCK_SPLIT" :
                return populateSimilarEventsRequestParam(); 
                 break;            
            case "OPTIONAL_STOCK_DIV" :
                return populateCashStockOptionRequestParam();               
                break;
            case "DIV_REINVESTMENT" :
                return populateCashStockOptionRequestParam();               
                break;                                              
            case "COUPON_PAYMENT" :
                return populateCouponPaymentRequestParam();
                break;
            /*case "RIGHTS_EXPIRY" :
                return populateRightsAllocationExpiryRequestParam();
                break;*/
            case "RIGHTS_ALLOCATION" :
                return populateRightsAllocationExpiryRequestParam();
                break;   
            case "REDEMPTION_BOND" :
                return populateRedemptionBondRequestParam();     
                break;     
            case "OTHERS" :
                return populateOthersRequestParam();
                break;                                            
                        
          case "STOCK_MERGER" :
                return populateStockMergerRequestParam();             
                break; 
            default :
                break;
    
        }   
    }    
    
    /**
     * Populating request param for Cash dividend. 
     * 
     */
    private function populateCashDivRequestParam():void {
        // Cash dividend    
        reqObj.splPerShareStr = this.cash1.splPerShareStr.text;     
        reqObj.announcementDate = this.cash1.announcementDate.text;     
        reqObj.creditDateStr = this.cash1.creditDateStr.text;   
        if(this.cash1.dividendNo.text  != "") {     
            reqObj.dividendNo = this.cash1.dividendNo.text;  
        }   
        reqObj.warrantNo = this.cash1.warrantNo.text;       
        reqObj.blockVoucherQuantityStr = this.cash1.blockVoucherQuantityStr.text;
        reqObj.finantialYearEndDateStr = this.cash1.finantialYearEndDateStr.text;                               
        reqObj.instrumentCode =  this.cash1.security.instrumentId.text ;        
        reqObj.exDateStr = this.cash1.exDateStr.text;       
        reqObj.recordDateStr = this.cash1.recordDateStr.text;       
        reqObj.bookClosingDateStr = this.cash1.bookClosingDateStr.text;     
        reqObj.paymentDateStr = this.cash1.paymentDateStr.text;     
        reqObj.allottedCurrency = this.cash1.allttedCcy.ccyText.text;       
        reqObj.allotmentAmountStr = this.cash1.allotmentAmountStr.text;
        reqObj.perShareStr = this.cash1.perShareStr.text;
        reqObj.splAllotementAmountStr =  this.cash1.splAllotementAmountStr.text ;       
        reqObj.splPerShareStr = this.cash1.splPerShareStr.text;   
        reqObj.protectExpirationDate = this.cash1.protectExpirationDate.text;           
    }
    
    /**
     * Populating request param for Stock dividend. 
     * 
     */
    private function populateStockDivRequestParam():void {      
        // Stock dividend       
        reqObj.splPerShareStr = this.stock1.splPerShareStr.text;        
        reqObj.announcementDate = this.stock1.announcementDate.text;        
        reqObj.creditDateStr = this.stock1.creditDateStr.text;   
        if(this.stock1.dividendNo.text  != "") {    
            reqObj.dividendNo = this.stock1.dividendNo.text;  
        }                       
        reqObj.blockVoucherQuantityStr = this.stock1.blockVoucherQuantityStr.text;
        reqObj.finantialYearEndDateStr = this.stock1.finantialYearEndDateStr.text;                              
        reqObj.instrumentCode =  this.stock1.security.instrumentId.text ;       
        reqObj.exDateStr = this.stock1.exDateStr.text;      
        reqObj.recordDateStr = this.stock1.recordDateStr.text;      
        reqObj.bookClosingDateStr = this.stock1.bookClosingDateStr.text;        
        reqObj.paymentDateStr = this.stock1.paymentDateStr.text;        
        reqObj.allottedInstrument = this.stock1.allottedSecurity.instrumentId.text;     
        reqObj.allotmentQuantityStr = this.stock1.allotmentQuantityStr.text;
        reqObj.perShareStr = this.stock1.perShareStr.text;
        reqObj.allotmentQuantitySplStr =  this.stock1.allotmentQuantitySplStr.text ;        
        reqObj.splPerShareStr = this.stock1.splPerShareStr.text;        
        reqObj.dueBillEndDateStr = this.stock1.dueBillEndDateStr.text;      
        reqObj.faceValueStr = this.stock1.faceValueStr.text;        
        reqObj.payOutCcy = this.stock1.payOutCcy.ccyText.text;      
        reqObj.payOutPriceStr = this.stock1.payOutPriceStr.text;        
        reqObj.protectExpirationDate= this.stock1.protectExpirationDate.text;   
    }    
   
    /**
     * Populating request param for Stock Split,ReverseStock Split,Share Exchange,Spin Off, NameChange etc. 
     * 
     */
    private function populateSimilarEventsRequestParam():void {     
        // Stock Split,ReverseStock Split,Share Exchange,Spin Off, NameChange etc           
        reqObj.announcementDate = this.someEventsCommon1.announcementDate.text;                                     
        reqObj.instrumentCode =  this.someEventsCommon1.security.instrumentId.text ;        
        reqObj.exDateStr = this.someEventsCommon1.exDateStr.text;       
        reqObj.recordDateStr = this.someEventsCommon1.recordDateStr.text;       
        reqObj.bookClosingDateStr = this.someEventsCommon1.bookClosingDateStr.text;     
        reqObj.paymentDateStr = this.someEventsCommon1.paymentDateStr.text;     
        reqObj.allottedInstrument = this.someEventsCommon1.allottedSecurity.instrumentId.text;      
        reqObj.allotmentQuantityStr = this.someEventsCommon1.allotmentQuantityStr.text;
        reqObj.perShareStr = this.someEventsCommon1.perShareStr.text;   
        reqObj.dueBillEndDateStr = this.someEventsCommon1.dueBillEndDateStr.text;           
        reqObj.payOutCcy = this.someEventsCommon1.payOutCcy.ccyText.text;       
        reqObj.payOutPriceStr = this.someEventsCommon1.payOutPriceStr.text;
        reqObj.protectExpirationDate= this.someEventsCommon1.protectExpirationDate.text;            
    }    
    
    /**
     * Populating request param for Cash Stock Option for optional 
     * Stock Dividend and Dividend Reinvestment . 
     * 
     */
    private function populateCashStockOptionRequestParam():void {
        // Cash Stock Option for optional Stock Dividend and Dividend Reinvestment      
        reqObj.splPerShareStr = this.cashStockOption1.splPerShareStr.text;                                              
        reqObj.instrumentCode =  this.cashStockOption1.security.instrumentId.text ;     
        reqObj.exDateStr = this.cashStockOption1.exDateStr.text;        
        reqObj.recordDateStr = this.cashStockOption1.recordDateStr.text;        
        reqObj.bookClosingDateStr = this.cashStockOption1.bookClosingDateStr.text;      
        reqObj.paymentDateStr = this.cashStockOption1.paymentDateStr.text;      
        reqObj.allottedCurrency = this.cashStockOption1.allttedCcy.ccyText.text;        
        reqObj.allotmentAmountStr = this.cashStockOption1.allotmentAmountStr.text;
        reqObj.perShareStr = this.cashStockOption1.perShareStr.text;
        reqObj.splAllotementAmountStr =  this.cashStockOption1.splAllotementAmountStr.text ;        
        reqObj.splPerShareStr = this.cashStockOption1.splPerShareStr.text;   
        reqObj.deadLineDateStr =  this.cashStockOption1.deadLineDateStr.text ;      
        reqObj.rightsExpiryDateStr = this.cashStockOption1.rightsExpiryDateStr.text;                            
    }    
    /**
     * Populating request param for Coupon Payment . 
     * 
     */
    private function populateCouponPaymentRequestParam():void {
        // Coupon Payment                                               
        reqObj.instrumentCode =  this.couponPayment1.security.instrumentId.text ;           
        reqObj.recordDateStr = this.couponPayment1.recordDateStr.text;              
        reqObj.paymentDateStr = this.couponPayment1.paymentDateStr.text;        
        reqObj.allottedCurrency = this.couponPayment1.allttedCcy.ccyText.text;      
        reqObj.allotmentAmountStr = this.couponPayment1.allotmentAmountStr.text;
        reqObj.perShareStr = this.couponPayment1.perShareStr.text;  
        reqObj.couponDateStr = this.couponPayment1.couponDateStr.text;   
        reqObj.couponRateStr = this.couponPayment1.couponRateStr.text;  
        reqObj.creditDateStr = this.couponPayment1.creditDateStr.text;  
        reqObj.currentFactorStr = this.couponPayment1.currentFactorStr.text;  
        reqObj.originalRecordDateStr = this.couponPayment1.originalRecordDateStr.text;  
        reqObj.previousFactorStr = this.couponPayment1.previousFactorStr.text;                                                  
    }  
    /**
     * Populating request param for Rights Allocation and Rights Expiry  
     * 
     */
    private function populateRightsAllocationExpiryRequestParam():void {    
        // Rights Allocation and Rights Expiry          
        reqObj.instrumentCode = this.rtAllocationExpiry1.security.instrumentId.text; 
        reqObj.exDateStr=   this.rtAllocationExpiry1.exDateStr.text ;
        reqObj.allottedRightsInstrument = this.rtAllocationExpiry1.allottedRightsSecurity.instrumentId.text;
        reqObj.allottedRightsQuantityStr = this.rtAllocationExpiry1.allotmentRightsQuantityStr.text;
        reqObj.recordDateStr = this.rtAllocationExpiry1.recordDateStr.text;
        reqObj.perShareRightsStr = this.rtAllocationExpiry1.perShareRightsStr.text;
        reqObj.rightsPaymentDateStr = this.rtAllocationExpiry1.rightsPaymentDateStr.text;
        reqObj.creditDateStr =  this.rtAllocationExpiry1.creditDateStr.text ;
        
        reqObj.deadLineDateStr = this.rtAllocationExpiryEnd1.deadLineDateStr.text;
        reqObj.rightsExpiryDateStr = this.rtAllocationExpiryEnd1.rightsExpiryDateStr.text; 
        reqObj.allottedInstrument = this.rtAllocationExpiryEnd1.allottedSecurity.instrumentId.text;  
        reqObj.allotmentQuantityStr =   this.rtAllocationExpiryEnd1.allotmentQuantityStr.text ;
        reqObj.perShareStr = this.rtAllocationExpiryEnd1.perShareStr.text;
        reqObj.paymentDateTakeUpStr = this.rtAllocationExpiryEnd1.paymentDateTakeUpStr.text;//For Rights Expiry
        reqObj.paymentDateStr = this.rtAllocationExpiryEnd1.paymentDateStrForRightsExpiry.text;
        reqObj.subscriptionCcy =    this.rtAllocationExpiryEnd1.subscriptionCcy.ccyText.text;
		reqObj.subsCostPerShareStr =    this.rtAllocationExpiryEnd1.subsCostPerShareStr.text;
                         
    }     
    /**
     * Populating request param for Redemption of bond  
     * 
     */
    private function populateRedemptionBondRequestParam():void {    
        // Redemption of bond           
        reqObj.instrumentCode = this.redemptionBond1.security.instrumentId.text;
        reqObj.redemptionCurrency = this.redemptionBond1.redemptionCurrency.ccyText.text;  
        reqObj.redemptionDateStr =  this.redemptionBond1.redemptionDateStr.text;
        reqObj.creditDateStr =  this.redemptionBond1.creditDateStr.text;
        reqObj.paymentDateStr = this.redemptionBond1.paymentDateStr.text;
        reqObj.redemptionPriceStr = this.redemptionBond1.redemptionPriceStr.text;
        reqObj.rateOfNominalStr =   this.redemptionBond1.rateOfNominalStr.text;
        reqObj.recordDateStr = this.redemptionBond1.recordDateStr.text;             
    }    
      
    /**
     * Populating request param for Others. 
     * 
     */
    private function populateOthersRequestParam():void {    
        // Others   
        reqObj.eventTypeName = this.others1.eventTypeName.text;
        reqObj.instrumentCode = this.others1.security.instrumentId.text  ;
        reqObj.allottedInstrument = this.others1.allottedInstrument.instrumentId.text ;
        reqObj.exDateStr = this.others1.exDateStr.text ;
        reqObj.recordDateStr = this.others1.recordDateStr.text ;
        reqObj.exerciseDateStr = this.others1.exerciseDateStr.text ;
        reqObj.rightsExpiryDateStr = this.others1.rightsExpiryDateStr.text ;
        reqObj.paymentDateStr = this.others1.paymentDateStr.text ;
        reqObj.allotmentQuantityStr = this.others1.allotmentQuantityStr.text ;
        reqObj.perShareStr = this.others1.perShareStr.text ;
        reqObj.deadLineDateStr = this.others1.deadLineDateStr.text ;        
        reqObj.payOutPriceStr = this.others1.payOutPriceStr.text ; 
        reqObj.freeOutParentSecurity = this.others1.freeOutParentSecurity.selectedItem != null ? this.others1.freeOutParentSecurity.selectedItem.value : "";                
    }   
    
    /**
     * Populating request param for Stock Merger. 
     * 
     */
    private function populateStockMergerRequestParam():void {       
        //Stock Merger      
        reqObj.allottedInstrument = this.stockMerger1.allottedInstrument.instrumentId.text ;
        reqObj.bookClosingDateStr = this.stockMerger1.bookClosingDateStr.text ;
        reqObj.recordDateStr = this.stockMerger1.recordDateStr.text ;
        reqObj.announcementDate = this.stockMerger1.announcementDate.text ;
        reqObj.protectExpirationDate = this.stockMerger1.protectExpirationDate.text ;
        reqObj.paymentDateStr = this.stockMerger1.paymentDateStr.text ;
        reqObj.exDateStr = this.stockMerger1.exDateStr.text ;   
                                
    }    
       
      
    
    /**
     * 
     * The validator before Submission of event Entry/Amend.
     */
    private function setValidator():void{       

                           
        var validateModel:Object = new Object();

        
         if(XenosStringUtils.equals(currentState,"stockDividend")) {
                validateModel = { caEventEntry : {
                                             mode:this.mode,    
                                             eventType:this.eventType,                           
                                             conditionStatus:this.conditionStatusEntry.selectedItem != null ? this.conditionStatusEntry.selectedItem.value : "",                                 
                                             processingFrequency:this.processingFrequency.selectedItem != null ? this.processingFrequency.selectedItem.value : "",
                                             processStartDateStr:this.processStartDateStr.text,
                                             processEndDateStr:this.processEndDateStr.text,                 
                                             instrumentCode:this.stock1.security.instrumentId.text,                                 
                                             exDateStr:this.stock1.exDateStr.text,  
                                             allottedInst:this.stock1.allottedSecurity.instrumentId.text,
                                             recordDateStr:this.stock1.recordDateStr.text,     
                                             paymentDateStr:this.stock1.paymentDateStr.text,
                                             allottedQtyAmt:this.stock1.allotmentQuantityStr.text,
                                             perShareStr:this.stock1.perShareStr.text,  
                                                                          
                                             announceDateStock:this.stock1.announcementDate.text,
                                             expirationDateStock:this.stock1.protectExpirationDate.text,     
                                             creditDateStock:this.stock1.creditDateStr.text,
                                             financialEndDateStock:this.stock1.finantialYearEndDateStr.text,
                                             specialAllotmentQty:this.stock1.allotmentQuantitySplStr.text,
                                             specialPerShare:this.stock1.splPerShareStr.text,
                                             payOutCcyStock:this.stock1.payOutCcy.ccyText.text,
                                             payOutPriceStock:this.stock1.payOutPriceStr.text,
                                             bookClosingDate:this.stock1.bookClosingDateStr.text    
                                            }
                                        };
        } else if(XenosStringUtils.equals(currentState,"cashDividend")) {
                validateModel = { caEventEntry : {
                                             mode:this.mode,                
                                             eventType:this.eventType,                           
                                             conditionStatus:this.conditionStatusEntry.selectedItem != null ? this.conditionStatusEntry.selectedItem.value : "",                                
                                             processingFrequency:this.processingFrequency.selectedItem != null ? this.processingFrequency.selectedItem.value : "",
                                             processStartDateStr:this.processStartDateStr.text,
                                             processEndDateStr:this.processEndDateStr.text,                 
                                             instrumentCode:this.cash1.security.instrumentId.text,                                
                                             exDateStr:this.cash1.exDateStr.text,  
                                             allottedInst:this.cash1.allttedCcy.ccyText.text,
                                             paymentDateStr:this.cash1.paymentDateStr.text,     
                                             recordDateStr:this.cash1.recordDateStr.text,
                                             allottedQtyAmt:this.cash1.allotmentAmountStr.text,
                                             perShareStr:this.cash1.perShareStr.text,                                            
                                             announceDate:this.cash1.announcementDate.text,
                                             expirationDate:this.cash1.protectExpirationDate.text,     
                                             creditDate:this.cash1.creditDateStr.text,
                                             financialEndDate:this.cash1.finantialYearEndDateStr.text,
                                             specialAllotmentAmt:this.cash1.splAllotementAmountStr.text,
                                             specialPerShareCash:this.cash1.splPerShareStr.text,
                                             bookClosingDate:this.cash1.bookClosingDateStr.text                                                                                                                          
                                        }
                            };          
        }else if(XenosStringUtils.equals(currentState,"couponPayment")) {
                validateModel = { caEventEntry : {
                                             mode:this.mode,                        
                                             eventType:this.eventType,                           
                                             conditionStatus:this.conditionStatusEntry.selectedItem != null ? this.conditionStatusEntry.selectedItem.value : "",                                 
                                             processingFrequency:this.processingFrequency.selectedItem != null ? this.processingFrequency.selectedItem.value : "",
                                             processStartDateStr:this.processStartDateStr.text,
                                             processEndDateStr:this.processEndDateStr.text,                 
                                             instrumentCode:this.couponPayment1.security.instrumentId.text,                                 
                                             allottedInst:this.couponPayment1.allttedCcy.ccyText.text,
                                             paymentDateStr:this.couponPayment1.paymentDateStr.text,     
                                             recordDateStr:this.couponPayment1.recordDateStr.text,                                                                                                                                                              
                                             creditDateCoupon:this.couponPayment1.creditDateStr.text,
                                             couponRate:this.couponPayment1.couponRateStr.text,
                                             prevFactor:this.couponPayment1.previousFactorStr.text,
                                             currFactpr:this.couponPayment1.currentFactorStr.text,
                                             couponDate:this.couponPayment1.couponDateStr.text,
                                             originalRecordDt:this.couponPayment1.originalRecordDateStr.text                                                                                     
                                            }
                                        };          
        }else if(XenosStringUtils.equals(currentState,"capRedRevSplStSplShareEx")) {
                validateModel = { caEventEntry : {
                                             mode:this.mode,                        
                                             eventType:this.eventType,                           
                                             conditionStatus:this.conditionStatusEntry.selectedItem != null ? this.conditionStatusEntry.selectedItem.value : "",                              
                                             processingFrequency:this.processingFrequency.selectedItem != null ? this.processingFrequency.selectedItem.value : "",
                                             processStartDateStr:this.processStartDateStr.text,
                                             processEndDateStr:this.processEndDateStr.text,                 
                                             instrumentCode:this.someEventsCommon1.security.instrumentId.text,                                 
                                             exDateStr:this.someEventsCommon1.exDateStr.text,  
                                             allottedInst:this.someEventsCommon1.allottedSecurity.instrumentId.text,
                                             paymentDateStr:this.someEventsCommon1.paymentDateStr.text,     
                                             recordDateStr:this.someEventsCommon1.recordDateStr.text,
                                             allottedQtyAmt:this.someEventsCommon1.allotmentQuantityStr.text,
                                             perShareStr:this.someEventsCommon1.perShareStr.text,                                                                            
                                             announceDateCapRd:this.someEventsCommon1.announcementDate.text,
                                             expirationDateCapRd:this.someEventsCommon1.protectExpirationDate.text,
                                             payOutPriceCommon:this.someEventsCommon1.payOutPriceStr.text,
                                             payOutCcyCommon:this.someEventsCommon1.payOutCcy.ccyText.text,
                                             bookClosingDate:this.someEventsCommon1.bookClosingDateStr.text                                                
                                               
                                            }
                                        };          
        } else if(XenosStringUtils.equals(currentState,"redemptionBond")) {
                validateModel = { caEventEntry : {
                                             mode:this.mode,                        
                                             eventType:this.eventType,                           
                                             conditionStatus:this.conditionStatusEntry.selectedItem != null ? this.conditionStatusEntry.selectedItem.value : "",                                
                                             processingFrequency:this.processingFrequency.selectedItem != null ? this.processingFrequency.selectedItem.value : "",
                                             processStartDateStr:this.processStartDateStr.text,
                                             processEndDateStr:this.processEndDateStr.text,                 
                                             instrumentCode:this.redemptionBond1.security.instrumentId.text,                                 
                                             redemptionDateRedmp:this.redemptionBond1.redemptionDateStr.text,  
                                             redemptionCcyRedmp:this.redemptionBond1.redemptionCurrency.ccyText.text,
                                             paymentDateStr:this.redemptionBond1.paymentDateStr.text, 
                                             recordDateStr:this.redemptionBond1.recordDateStr.text,    
                                             rateOfNominalRedmp:this.redemptionBond1.rateOfNominalStr.text,
                                             redemptionPriceRights:this.redemptionBond1.redemptionPriceStr.text,
                                             creditDateRedmp:this.redemptionBond1.creditDateStr.text
                                            }
                                        };          
        }else if(XenosStringUtils.equals(currentState,"stockMerger")) {
                validateModel = { caEventEntry : {  
                                             mode:this.mode,                        
                                             eventType:this.eventType,                           
                                             conditionStatus:this.conditionStatusEntry.selectedItem != null ? this.conditionStatusEntry.selectedItem.value : "",                                 
                                             processingFrequency:this.processingFrequency.selectedItem != null ? this.processingFrequency.selectedItem.value : "",
                                             processStartDateStr:this.processStartDateStr.text,
                                             processEndDateStr:this.processEndDateStr.text,                         
                                             instrumentCode:this.stockMerger2.security.instrumentId.text,                                                                 
                                             exDateStr:this.stockMerger1.exDateStr.text,  
                                             allottedInst:this.stockMerger1.allottedInstrument.instrumentId.text,
                                             recordDateStr:this.stockMerger1.recordDateStr.text,     
                                             paymentDateStr:this.stockMerger1.paymentDateStr.text,
                                             stockInfoList:this.stockMerger2.addedStockSummaryResult,                                            
                                             announceDateMerger:this.stockMerger1.announcementDate.text,
                                             bookClosingDate:this.stockMerger1.bookClosingDateStr.text,
                                             expirationDateMerger:this.stockMerger1.protectExpirationDate.text                                           
                                            }
                                        };          
        }else if(XenosStringUtils.equals(currentState,"cashStockOption")) {
                validateModel = { caEventEntry : {
                                             mode:this.mode,                        
                                             eventType:this.eventType,                           
                                             conditionStatus:this.conditionStatusEntry.selectedItem != null ? this.conditionStatusEntry.selectedItem.value : "",                                
                                             processingFrequency:this.processingFrequency.selectedItem != null ? this.processingFrequency.selectedItem.value : "",
                                             processStartDateStr:this.processStartDateStr.text,
                                             processEndDateStr:this.processEndDateStr.text,                 
                                             instrumentCode:this.cashStockOption1.security.instrumentId.text,                                 
                                             exDateStr:this.cashStockOption1.exDateStr.text,  
                                             allottedInst:this.cashStockOption1.allttedCcy.ccyText.text,
                                             paymentDateStr:this.cashStockOption1.paymentDateStr.text,     
                                             recordDateStr:this.cashStockOption1.recordDateStr.text,
                                             allottedQtyAmt:this.cashStockOption1.allotmentAmountStr.text,
                                             perShareStr:this.cashStockOption1.perShareStr.text,                                                                              
                                             deadlineDateCashStock:this.cashStockOption1.deadLineDateStr.text,
                                             rightsExpiryDateCashStock:this.cashStockOption1.rightsExpiryDateStr.text,
                                             bookClosingDate:this.cashStockOption1.bookClosingDateStr.text
                                            }
                                        };          
        }else if(XenosStringUtils.equals(currentState,"rightsAllocationExpiry")) {
                validateModel = { caEventEntry : {
                                             mode:this.mode,                        
                                             eventType:this.eventType,                           
                                             conditionStatus:this.conditionStatusEntry.selectedItem != null ? this.conditionStatusEntry.selectedItem.value : "",                                 
                                             processingFrequency:this.processingFrequency.selectedItem != null ? this.processingFrequency.selectedItem.value : "",
                                             processStartDateStr:this.processStartDateStr.text,
                                             processEndDateStr:this.processEndDateStr.text,                 
                                             instrumentCode:this.rtAllocationExpiry1.security.instrumentId.text,                                 
                                             exDateStr:this.rtAllocationExpiry1.exDateStr.text,  
                                             allottedRightsInst:this.rtAllocationExpiry1.allottedRightsSecurity.instrumentId.text,
                                             allottedRightsQtyAmt:this.rtAllocationExpiry1.allotmentRightsQuantityStr.text,
                                             recordDateStr:this.rtAllocationExpiry1.recordDateStr.text,
                                             perShareRightsStr:this.rtAllocationExpiry1.perShareRightsStr.text,
                                             rightsPaymentDateStr:this.rtAllocationExpiry1.rightsPaymentDateStr.text,     
                                             creditDateRights:this.rtAllocationExpiry1.creditDateStr.text,
                                             deadlineDateRights:this.rtAllocationExpiryEnd1.deadLineDateStr.text,
                                             rightsExpiryDateRights:this.rtAllocationExpiryEnd1.rightsExpiryDateStr.text,
                                             allottedInst:this.rtAllocationExpiryEnd1.allottedSecurity.instrumentId.text,
                                             allottedQtyAmt:this.rtAllocationExpiryEnd1.allotmentQuantityStr.text,
                                             perShareStr:this.rtAllocationExpiryEnd1.perShareStr.text,
                                             paymentDateTakeUpStr:this.rtAllocationExpiryEnd1.paymentDateTakeUpStr.text,
                                             paymentDateStr:this.rtAllocationExpiryEnd1.paymentDateStrForRightsExpiry.text,
                                             takeUpCcyRights:this.rtAllocationExpiryEnd1.subscriptionCcy.ccyText.text,
                                             takeUpCostRights:this.rtAllocationExpiryEnd1.subsCostPerShareStr.text                                                                                                                                                             
                                         }
                                    };          
        }else if(XenosStringUtils.equals(currentState,"others")) {
                validateModel = { caEventEntry : {
                                             mode:this.mode,                        
                                             eventType:this.eventType,                           
                                             conditionStatus:this.conditionStatusEntry.selectedItem != null ? this.conditionStatusEntry.selectedItem.value : "",                                
                                             processingFrequency:this.processingFrequency.selectedItem != null ? this.processingFrequency.selectedItem.value : "",
                                             processStartDateStr:this.processStartDateStr.text,
                                             processEndDateStr:this.processEndDateStr.text,                 
                                             eventTypeNameOthers:this.others1.eventTypeName.text,                           
                                             instrumentCode:this.others1.security.instrumentId.text,                                 
                                             allottedInst:this.others1.allottedInstrument.instrumentId.text,  
                                             allottedQtyAmt:this.others1.allotmentQuantityStr.text,    
                                             recordDateStr:this.others1.recordDateStr.text,
                                             exDateStr:this.others1.exDateStr.text,  
                                             perShareStr:this.others1.perShareStr.text,
                                             excerciseDateOthers:this.others1.exerciseDateStr.text,
                                             rightsExpiryDateOthers:this.others1.rightsExpiryDateStr.text,     
                                             deadLineDateOthrs:this.others1.deadLineDateStr.text                                                                                           
                                            }
                                        };          
        }

         super._validator = new RightsConditionEntryValidator();
         super._validator.source = validateModel ;
         super._validator.property = "caEventEntry";
    }  
      

    /**
     * Result after submission.leads to user confirmation screen.
     * @param mapObj
     * 
     */
    private function commonResult(mapObj:Object):void {
                
        if(mapObj!=null){                       
            if(mapObj["errorFlag"].toString() == "error"){
                //result = mapObj["errorMsg"] .toString();              
                if(mode != "cancel"){
                  errPage.showError(mapObj["errorMsg"]);                        
                }else{
                    XenosAlert.error(mapObj["errorMsg"]);
                }
            }else if(mapObj["errorFlag"].toString() == "noError"){              
             errPage.clearError(super.getSaveResultEvent());                            
             commonResultPart(mapObj);            
             changeStateToConf();                           
            }else{
                errPage.removeError();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cax.data.not.found'));
            }           
        }
    }     
        
    /**
     * Result handler for providing data to the confirmation module.
     * @param mapObj
     * 
     */
    private function commonResultPart(mapObj:Object):void {
        if(XenosStringUtils.equals(mode,"amend") || XenosStringUtils.equals(mode,"cancel")) {
            ConditionRefNoConfId.visible = true;
            ConditionRefNoConfId.includeInLayout = true;
            this.conditionReferenceNoConf.text = mapObj[keylist.getItemAt(52)].toString();
            this.referenceNo = mapObj[keylist.getItemAt(52)].toString(); 
        } else {
            ConditionRefNoConfId.visible = false;
            ConditionRefNoConfId.includeInLayout = false;           
        }
    
         this.subEventTypeConf.text = mapObj[keylist.getItemAt(13)].toString();
         this.conditionStatusConf.text = mapObj[keylist.getItemAt(12)].toString();
         this.processingFrequencyConf.text = mapObj[keylist.getItemAt(5)].toString();
         
         // Procesing Frequency wise Start date End date Population
         var processingFreq:String = mapObj[keylist.getItemAt(5)].toString();
         if(XenosStringUtils.equals(processingFreq,"DAILY")) {
             this.processStartDateConf.text = mapObj[keylist.getItemAt(6)].toString();
             this.processEndDateConf.text = mapObj[keylist.getItemAt(7)].toString();            
         } else if(XenosStringUtils.equals(processingFreq,"TRIGGER")) {
            this.processStartDateConf.text = mapObj[keylist.getItemAt(6)].toString();  
            this.processEndDateConf.text   = "";                
         } else if(XenosStringUtils.equals(processingFreq,"MANUAL")) {
            this.processStartDateConf.text = "";
            this.processEndDateConf.text   = "";
        }        
         

         this.extReferenceNoConf.text = mapObj[keylist.getItemAt(16)].toString();
         this.descriptionConf.text = mapObj[keylist.getItemAt(11)].toString();
         this.remarksConf.text = mapObj[keylist.getItemAt(10)].toString();   
         
         //tax fee list         
        var initcol:ArrayCollection = new ArrayCollection();
        for each(var itemTax:Object in (mapObj[keylist.getItemAt(69)] as ArrayCollection)){
            initcol.addItem(itemTax);                                                                   
        }               
        this.taxFeeSummaryConfResult = initcol;                  
         
         //Cash dividend Conf Part
         this.cash2.securityConf.text = mapObj[keylist.getItemAt(8)].toString();                      
         this.cash2.exDateConf.text = mapObj[keylist.getItemAt(14)].toString();
         this.cash2.recordDateConf.text = mapObj[keylist.getItemAt(17)].toString();
         this.cash2.bookclosingConf.text = mapObj[keylist.getItemAt(18)].toString();
         this.cash2.paymentDateConf.text = mapObj[keylist.getItemAt(21)].toString();
         this.cash2.allottedSecConf.text = mapObj[keylist.getItemAt(27)].toString();
         this.cash2.allotmentAmtConf.text = mapObj[keylist.getItemAt(28)].toString();
         this.cash2.perShareConf.text = mapObj[keylist.getItemAt(20)].toString();
         this.cash2.splAllotAmountConf.text = mapObj[keylist.getItemAt(29)].toString();    
         this.cash2.splPerShareConf.text = mapObj[keylist.getItemAt(23)].toString();                 
         this.cash2.announcementDtConf.text = mapObj[keylist.getItemAt(30)].toString();
         this.cash2.protectExpirationConf.text = mapObj[keylist.getItemAt(32)].toString();
         this.cash2.creditDateConf.text = mapObj[keylist.getItemAt(33)].toString();
         this.cash2.dividendNoConf.text = mapObj[keylist.getItemAt(34)].toString();
         this.cash2.warranNoConf.text = mapObj[keylist.getItemAt(35)].toString();                         
         this.cash2.financialEndDateConf.text = mapObj[keylist.getItemAt(36)].toString();
         this.cash2.blockVoucherQtyConf.text = mapObj[keylist.getItemAt(37)].toString();                                
         this.cash2.allotedCcyName.text = mapObj[keylist.getItemAt(53)].toString();  
         this.cash2.instrumentName.text = mapObj[keylist.getItemAt(54)].toString();  
         
         
         //Stock dividend Conf Part
         this.stock2.securityConf.text = mapObj[keylist.getItemAt(8)].toString();                      
         this.stock2.exDateConf.text = mapObj[keylist.getItemAt(14)].toString();
         this.stock2.recordDateConf.text = mapObj[keylist.getItemAt(17)].toString();
         this.stock2.bookclosingConf.text = mapObj[keylist.getItemAt(18)].toString();
         this.stock2.paymentDateConf.text = mapObj[keylist.getItemAt(21)].toString();
         this.stock2.allottedSecConf.text = mapObj[keylist.getItemAt(9)].toString();
         this.stock2.allotmentQuantityConf.text = mapObj[keylist.getItemAt(19)].toString();
         this.stock2.perShareConf.text = mapObj[keylist.getItemAt(20)].toString();
         this.stock2.allotmentQuantitySplConf.text = mapObj[keylist.getItemAt(22)].toString();    
         this.stock2.splPerShareConf.text = mapObj[keylist.getItemAt(23)].toString();                    
         this.stock2.announcementDtConf.text = mapObj[keylist.getItemAt(30)].toString();
         this.stock2.dueBillEndDateConf.text =  mapObj[keylist.getItemAt(31)].toString();        
         this.stock2.protectExpirationConf.text = mapObj[keylist.getItemAt(32)].toString();
         this.stock2.creditDateConf.text = mapObj[keylist.getItemAt(33)].toString();
         this.stock2.dividendNoConf.text = mapObj[keylist.getItemAt(34)].toString();                                 
         this.stock2.financialEndDateConf.text = mapObj[keylist.getItemAt(36)].toString();
         this.stock2.blockVoucherQtyConf.text = mapObj[keylist.getItemAt(37)].toString();                               
         this.stock2.allotedInstName.text = mapObj[keylist.getItemAt(55)].toString();  
         this.stock2.instrumentNameConf.text = mapObj[keylist.getItemAt(54)].toString(); 
         this.stock2.payOutCcyConf.text =  mapObj[keylist.getItemAt(56)].toString();         
         this.stock2.payOutPriceConf.text = mapObj[keylist.getItemAt(25)].toString();  
         this.stock2.faceValueConf.text = mapObj[keylist.getItemAt(24)].toString();  
         
         //Similar Events Conf Part
         this.someEventsCommon2.securityConf.text = mapObj[keylist.getItemAt(8)].toString();                      
         this.someEventsCommon2.exDateConf.text = mapObj[keylist.getItemAt(14)].toString();
         this.someEventsCommon2.recordDateConf.text = mapObj[keylist.getItemAt(17)].toString();
         this.someEventsCommon2.bookclosingConf.text = mapObj[keylist.getItemAt(18)].toString();
         this.someEventsCommon2.paymentDateConf.text = mapObj[keylist.getItemAt(21)].toString();
         this.someEventsCommon2.allottedSecConf.text = mapObj[keylist.getItemAt(9)].toString();
         this.someEventsCommon2.allotmentQuantityConf.text = mapObj[keylist.getItemAt(19)].toString();
         this.someEventsCommon2.perShareConf.text = mapObj[keylist.getItemAt(20)].toString();            
         this.someEventsCommon2.announcementDtConf.text = mapObj[keylist.getItemAt(30)].toString();
         this.someEventsCommon2.protectExpirationConf.text = mapObj[keylist.getItemAt(32)].toString();                              
         this.someEventsCommon2.allotedInstName.text = mapObj[keylist.getItemAt(55)].toString();  
         this.someEventsCommon2.instrumentNameConf.text = mapObj[keylist.getItemAt(54)].toString(); 
         this.someEventsCommon2.payOutCcyConf.text =  mapObj[keylist.getItemAt(56)].toString();      
         this.someEventsCommon2.payOutPriceConf.text = mapObj[keylist.getItemAt(25)].toString();  
         this.someEventsCommon2.dueBillEndDateConf.text = mapObj[keylist.getItemAt(31)].toString();     
         
         //Cash Stock Option Conf Part
         this.cashStockOption2.securityConf.text = mapObj[keylist.getItemAt(8)].toString();                      
         this.cashStockOption2.exDateConf.text = mapObj[keylist.getItemAt(14)].toString();
         this.cashStockOption2.recordDateConf.text = mapObj[keylist.getItemAt(17)].toString();
         this.cashStockOption2.bookclosingConf.text = mapObj[keylist.getItemAt(18)].toString();
         this.cashStockOption2.paymentDateConf.text = mapObj[keylist.getItemAt(21)].toString();         
         this.cashStockOption2.allottedSecConf.text = mapObj[keylist.getItemAt(27)].toString();
         this.cashStockOption2.allotmentAmtConf.text = mapObj[keylist.getItemAt(28)].toString();
         this.cashStockOption2.perShareConf.text = mapObj[keylist.getItemAt(20)].toString();
         this.cashStockOption2.splAllotAmountConf.text = mapObj[keylist.getItemAt(29)].toString();
         this.cashStockOption2.splPerShareConf.text = mapObj[keylist.getItemAt(23)].toString();                                                 
         this.cashStockOption2.allotedCcyName.text = mapObj[keylist.getItemAt(53)].toString();  
         this.cashStockOption2.instrumentName.text = mapObj[keylist.getItemAt(54)].toString();      
         this.cashStockOption2.deadLineDateConf.text = mapObj[keylist.getItemAt(38)].toString();  
         this.cashStockOption2.rightsExpiryDateConf.text = mapObj[keylist.getItemAt(39)].toString(); 
         
         //Coupon Payment Conf Part
         this.couponPayment2.securityConf.text = mapObj[keylist.getItemAt(8)].toString();                      
         this.couponPayment2.recordDateConf.text = mapObj[keylist.getItemAt(17)].toString();
         this.couponPayment2.paymentDateConf.text = mapObj[keylist.getItemAt(21)].toString();
         this.couponPayment2.allottedSecConf.text = mapObj[keylist.getItemAt(27)].toString();
         this.couponPayment2.allotmentAmtConf.text = mapObj[keylist.getItemAt(28)].toString();
         this.couponPayment2.perShareConf.text = mapObj[keylist.getItemAt(20)].toString();                                                  
         this.couponPayment2.allotedCcyName.text = mapObj[keylist.getItemAt(53)].toString();  
         this.couponPayment2.instrumentName.text = mapObj[keylist.getItemAt(54)].toString();                
         this.couponPayment2.couponDateConf.text=  mapObj[keylist.getItemAt(40)].toString();  
         this.couponPayment2.couponRateConf.text=  mapObj[keylist.getItemAt(41)].toString(); 
         this.couponPayment2.creditDateConf.text=  mapObj[keylist.getItemAt(33)].toString(); 
         this.couponPayment2.currentFactorConf.text=  mapObj[keylist.getItemAt(44)].toString(); 
         this.couponPayment2.originalRecordDateConf.text= mapObj[keylist.getItemAt(42)].toString();  
         this.couponPayment2.previousFactorConf.text= mapObj[keylist.getItemAt(43)].toString(); 
         this.couponPayment2.couponDateTipsIndexConf.text=mapObj[keylist.getItemAt(57)].toString(); 
         this.couponPayment2.issueDateTipsIndexConf.text= mapObj[keylist.getItemAt(58)].toString(); 
         
         // XGA-201
         //Rights Allocation/Expiry Conf Part
         this.rtAllocationExpiry2.securityConf.text = mapObj[keylist.getItemAt(8)].toString();                      
         this.rtAllocationExpiry2.exDateConf.text = mapObj[keylist.getItemAt(14)].toString();
         this.rtAllocationExpiry2.allottedRightsSecConf.text = mapObj[keylist.getItemAt(72)].toString();
         this.rtAllocationExpiry2.allotmentRightsQuantityConf.text = mapObj[keylist.getItemAt(73)].toString();
         this.rtAllocationExpiry2.recordDateConf.text = mapObj[keylist.getItemAt(17)].toString();
         this.rtAllocationExpiry2.perShareRightsConf.text = mapObj[keylist.getItemAt(74)].toString();
         this.rtAllocationExpiry2.rightsPaymentDateConf.text = mapObj[keylist.getItemAt(71)].toString();
         this.rtAllocationExpiry2.creditDateConf.text=  mapObj[keylist.getItemAt(33)].toString();
         
         this.rtAllocationExpiryEnd2.deadLineDateConf.text=  mapObj[keylist.getItemAt(38)].toString();
         this.rtAllocationExpiryEnd2.rightsExpiryDateConf.text=  mapObj[keylist.getItemAt(39)].toString();
         //this.rtAllocationExpiry2.paymentDateConf.text = mapObj[keylist.getItemAt(21)].toString();
         this.rtAllocationExpiryEnd2.allottedSecConf.text = mapObj[keylist.getItemAt(9)].toString();
         this.rtAllocationExpiryEnd2.allotmentQuantityConf.text = mapObj[keylist.getItemAt(19)].toString();
         this.rtAllocationExpiryEnd2.perShareConf.text = mapObj[keylist.getItemAt(20)].toString();                                                 
         this.rtAllocationExpiryEnd2.paymentDateTakeUpUsrConf.text = mapObj[keylist.getItemAt(70)].toString();
         this.rtAllocationExpiryEnd2.paymentDateConfRightsExpiry.text = mapObj[keylist.getItemAt(21)].toString();
         this.rtAllocationExpiryEnd2.subscriptionCcyConf.text= mapObj[keylist.getItemAt(47)].toString();
         this.rtAllocationExpiryEnd2.subsCostPerShareConf.text= mapObj[keylist.getItemAt(48)].toString();
         this.rtAllocationExpiry2.instrumentNameConf.text = mapObj[keylist.getItemAt(54)].toString();
         this.rtAllocationExpiry2.allotedRightsInstName.text = mapObj[keylist.getItemAt(75)].toString();
         this.rtAllocationExpiryEnd2.allotedInstName.text = mapObj[keylist.getItemAt(55)].toString();
          
                        
                      
          
         //Bond Redemption
         this.redemptionBond2.securityConf.text = mapObj[keylist.getItemAt(8)].toString();                      
         this.redemptionBond2.paymentDateConf.text = mapObj[keylist.getItemAt(21)].toString();
         this.redemptionBond2.redemptionCurrencyConf.text = mapObj[keylist.getItemAt(46)].toString();
         this.redemptionBond2.redemptionPriceConf.text = mapObj[keylist.getItemAt(61)].toString();
         this.redemptionBond2.redemptionDateTipsIndex.text = mapObj[keylist.getItemAt(60)].toString();                                                  
         this.redemptionBond2.issueDateTipsIndex.text = mapObj[keylist.getItemAt(58)].toString();  
         this.redemptionBond2.redemptionCurrencyName.text = mapObj[keylist.getItemAt(59)].toString();               
         this.redemptionBond2.creditDateConf.text=  mapObj[keylist.getItemAt(33)].toString();             
         this.redemptionBond2.rateOfNominalConf.text=  mapObj[keylist.getItemAt(45)].toString(); 
         this.redemptionBond2.redemptionDateConf.text=  mapObj[keylist.getItemAt(65)].toString(); 
         this.redemptionBond2.instrumentNameConf.text = mapObj[keylist.getItemAt(54)].toString();
         this.redemptionBond2.recordDateConf.text = mapObj[keylist.getItemAt(17)].toString();                                                    
                
         //Others
         this.others2.securityConf.text = mapObj[keylist.getItemAt(8)].toString();                      
         this.others2.exDateConf.text = mapObj[keylist.getItemAt(14)].toString();
         this.others2.recordDateConf.text = mapObj[keylist.getItemAt(17)].toString();
         this.others2.deadLineDateConf.text = mapObj[keylist.getItemAt(38)].toString();
         this.others2.paymentDateConf.text = mapObj[keylist.getItemAt(21)].toString();
         this.others2.allottedInstrumentConf.text = mapObj[keylist.getItemAt(9)].toString();
         this.others2.allotmentQuantityConf.text = mapObj[keylist.getItemAt(19)].toString();
         this.others2.perShareConf.text = mapObj[keylist.getItemAt(20)].toString();          
         this.others2.rightsExpiryDateConf.text = mapObj[keylist.getItemAt(39)].toString();
         this.others2.exerciseDateConf.text = mapObj[keylist.getItemAt(62)].toString();                             
         this.others2.allotedInstNameConf.text = mapObj[keylist.getItemAt(55)].toString();  
         this.others2.instrumentNameConf.text = mapObj[keylist.getItemAt(54)].toString();        
         this.others2.payOutPriceConf.text = mapObj[keylist.getItemAt(25)].toString();  
         this.others2.eventTypeNameConf.text = mapObj[keylist.getItemAt(63)].toString();
         //Free out parent Security Label value determination        
         var freeOutStr:String = ""; 
         freeOutStr = mapObj[keylist.getItemAt(64)].toString();
         if(XenosStringUtils.equals(freeOutStr,"N")) {
            freeOutStr = "NO"; 
         } if(XenosStringUtils.equals(freeOutStr,"Y")) {
            freeOutStr = "YES";
         }
         this.others2.freeOutParentSecurityConf.text = freeOutStr;
         
         //Stock Merger                   
         this.stockMergerCnf1.exDateStrConf.text = mapObj[keylist.getItemAt(14)].toString();
         this.stockMergerCnf1.recordDateStrConf.text = mapObj[keylist.getItemAt(17)].toString();
         this.stockMergerCnf1.announcementDtConf.text = mapObj[keylist.getItemAt(30)].toString();
         this.stockMergerCnf1.paymentDateConf.text = mapObj[keylist.getItemAt(21)].toString();
         this.stockMergerCnf1.protectExpirationConf.text = mapObj[keylist.getItemAt(32)].toString();                            
         this.stockMergerCnf1.allotedInstName.text = mapObj[keylist.getItemAt(55)].toString();      
         this.stockMergerCnf1.bookclosingConf.text = mapObj[keylist.getItemAt(18)].toString(); 
         this.stockMergerCnf1.allottedSecConf.text = mapObj[keylist.getItemAt(9)].toString(); 
         //stock entry list to show at the confirmation page                 
         var stockEntryList:XML = new XML(mapObj[keylist.getItemAt(66)].toString());    
         this.stockMergerCnf2.dataProvider = stockEntryList;                                         
         
    }   
    
    /**
     * Common initialization part of Amend operation, after clicking the amend link from 
     * RightsConditionQueryResult screen.
     * @param mapObj
     * 
     */
    private function commonAmendInitializationPart(mapObj:Object):void {
         var processingFreq:String = mapObj[keylist.getItemAt(5)].toString();
         //to chnage processing freq related attributes 
         changeProcessingFrequencyValues(processingFreq);
         
         this.processStartDateStr.text = mapObj[keylist.getItemAt(6)].toString();
         this.processEndDateStr.text = mapObj[keylist.getItemAt(7)].toString();
         this.externalReferenceNo.text = mapObj[keylist.getItemAt(16)].toString();
         this.description.text = mapObj[keylist.getItemAt(11)].toString();
         this.remarks.text = mapObj[keylist.getItemAt(10)].toString();       
         this.conditionReferenceNo.text = mapObj[keylist.getItemAt(52)].toString();
         this.subEventTypeStr = mapObj[keylist.getItemAt(1)].toString();       
         this.subEventTypeLblforAmend.text =  mapObj[keylist.getItemAt(13)].toString(); 
         
        // For TAX FEE INFO BLOCK
         if(XenosStringUtils.equals(eventType,"CASH_DIVIDEND") ||
            XenosStringUtils.equals(eventType,"COUPON_PAYMENT")) {
                this.taxMode = this.mode;
                this.addedTaxFeeSummaryResult.removeAll();
                try {
                    var rec:XML = new XML(); 
                    //Initilizing tax fee list type
                    var initcol:ArrayCollection = new ArrayCollection();                
                    initcol.addItem(" "); 
                    for each(var itemAmdTax:Object in (mapObj[keylist.getItemAt(49)] as ArrayCollection)){
                        initcol.addItem(itemAmdTax);                                                                    
                    }                                                           
                    this.taxFeeId.dataProvider = initcol;                               
                    this.taxFeeList = initcol;
                    
                    //Initilizing rate type
                    initcol = new ArrayCollection();                
                    initcol.addItem({label:" ", value: " "}); 
                    for each(var itemAmdRate:Object in (mapObj[keylist.getItemAt(50)] as ArrayCollection)){
                        initcol.addItem(itemAmdRate);                                                                   
                    }                                                                       
                    this.rateType.dataProvider = initcol;
                    this.rateTypeList = initcol;
                    
                    //Initilizing tax fee entry summary list                    
                    for each(var itemTaxFee:Object in (mapObj[keylist.getItemAt(69)] as ArrayCollection)){
                        addedTaxFeeSummaryResult.addItem(itemTaxFee);                                                                   
                    }           
                    addedTaxFeeSummaryResult.refresh();
                    this.taxFeeEntrySummary.visible = true;
                    this.taxFeeEntrySummary.includeInLayout = true;                                                                             

                }catch(e:Error){
                    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                }
            }                
         
         
         //Cash dividend Conf Part
         this.cash1.security.instrumentId.text = mapObj[keylist.getItemAt(8)].toString();                      
         this.cash1.exDateStr.text = mapObj[keylist.getItemAt(14)].toString();
         this.cash1.recordDateStr.text = mapObj[keylist.getItemAt(17)].toString();
         this.cash1.bookClosingDateStr.text = mapObj[keylist.getItemAt(18)].toString();
         this.cash1.paymentDateStr.text = mapObj[keylist.getItemAt(21)].toString();
         this.cash1.allttedCcy.ccyText.text = mapObj[keylist.getItemAt(27)].toString();
         this.cash1.allotmentAmountStr.text = mapObj[keylist.getItemAt(28)].toString();
         this.cash1.perShareStr.text = mapObj[keylist.getItemAt(20)].toString();
         this.cash1.splAllotementAmountStr.text = mapObj[keylist.getItemAt(29)].toString();    
         this.cash1.splPerShareStr.text = mapObj[keylist.getItemAt(23)].toString();                  
         this.cash1.announcementDate.text = mapObj[keylist.getItemAt(30)].toString();
         this.cash1.protectExpirationDate.text = mapObj[keylist.getItemAt(32)].toString();
         this.cash1.creditDateStr.text = mapObj[keylist.getItemAt(33)].toString();
         this.cash1.dividendNo.text = mapObj[keylist.getItemAt(34)].toString();
         this.cash1.warrantNo.text = mapObj[keylist.getItemAt(35)].toString();                         
         this.cash1.finantialYearEndDateStr.text = mapObj[keylist.getItemAt(36)].toString();
         this.cash1.blockVoucherQuantityStr.text = mapObj[keylist.getItemAt(37)].toString();                                
         
         //Stock dividend Conf Part
         this.stock1.security.instrumentId.text = mapObj[keylist.getItemAt(8)].toString();                      
         this.stock1.exDateStr.text = mapObj[keylist.getItemAt(14)].toString();
         this.stock1.recordDateStr.text = mapObj[keylist.getItemAt(17)].toString();
         this.stock1.bookClosingDateStr.text = mapObj[keylist.getItemAt(18)].toString();
         this.stock1.paymentDateStr.text = mapObj[keylist.getItemAt(21)].toString();
         this.stock1.allottedSecurity.instrumentId.text = mapObj[keylist.getItemAt(9)].toString();
         this.stock1.allotmentQuantityStr.text = mapObj[keylist.getItemAt(19)].toString();
         this.stock1.perShareStr.text = mapObj[keylist.getItemAt(20)].toString();
         this.stock1.allotmentQuantitySplStr.text = mapObj[keylist.getItemAt(22)].toString();    
         this.stock1.splPerShareStr.text = mapObj[keylist.getItemAt(23)].toString();                 
         this.stock1.announcementDate.text = mapObj[keylist.getItemAt(30)].toString();
         this.stock1.dueBillEndDateStr.text =   mapObj[keylist.getItemAt(31)].toString();        
         this.stock1.protectExpirationDate.text = mapObj[keylist.getItemAt(32)].toString();
         this.stock1.creditDateStr.text = mapObj[keylist.getItemAt(33)].toString();
         this.stock1.dividendNo.text = mapObj[keylist.getItemAt(34)].toString();                                 
         this.stock1.finantialYearEndDateStr.text = mapObj[keylist.getItemAt(36)].toString();
         this.stock1.blockVoucherQuantityStr.text = mapObj[keylist.getItemAt(37)].toString();                                
         this.stock1.payOutCcy.ccyText.text =  mapObj[keylist.getItemAt(56)].toString();         
         this.stock1.payOutPriceStr.text = mapObj[keylist.getItemAt(25)].toString();  
         this.stock1.faceValueStr.text = mapObj[keylist.getItemAt(24)].toString();  
         
         //Similar Events Conf Part
         this.someEventsCommon1.security.instrumentId.text = mapObj[keylist.getItemAt(8)].toString();                      
         this.someEventsCommon1.exDateStr.text = mapObj[keylist.getItemAt(14)].toString();
         this.someEventsCommon1.recordDateStr.text = mapObj[keylist.getItemAt(17)].toString();
         this.someEventsCommon1.bookClosingDateStr.text = mapObj[keylist.getItemAt(18)].toString();
         this.someEventsCommon1.paymentDateStr.text = mapObj[keylist.getItemAt(21)].toString();
         this.someEventsCommon1.allottedSecurity.instrumentId.text = mapObj[keylist.getItemAt(9)].toString();
         this.someEventsCommon1.allotmentQuantityStr.text = mapObj[keylist.getItemAt(19)].toString();
         this.someEventsCommon1.perShareStr.text = mapObj[keylist.getItemAt(20)].toString();             
         this.someEventsCommon1.announcementDate.text = mapObj[keylist.getItemAt(30)].toString();
         this.someEventsCommon1.protectExpirationDate.text = mapObj[keylist.getItemAt(32)].toString();                              
         this.someEventsCommon1.payOutCcy.ccyText.text =  mapObj[keylist.getItemAt(56)].toString();      
         this.someEventsCommon1.payOutPriceStr.text = mapObj[keylist.getItemAt(25)].toString();  
         this.someEventsCommon1.dueBillEndDateStr.text = mapObj[keylist.getItemAt(31)].toString();      
         
         //Cash Stock Option Conf Part
         this.cashStockOption1.security.instrumentId.text = mapObj[keylist.getItemAt(8)].toString();                      
         this.cashStockOption1.exDateStr.text = mapObj[keylist.getItemAt(14)].toString();
         this.cashStockOption1.recordDateStr.text = mapObj[keylist.getItemAt(17)].toString();
         this.cashStockOption1.bookClosingDateStr.text = mapObj[keylist.getItemAt(18)].toString();
         this.cashStockOption1.paymentDateStr.text = mapObj[keylist.getItemAt(21)].toString();
         this.cashStockOption1.allttedCcy.ccyText.text = mapObj[keylist.getItemAt(27)].toString();
         this.cashStockOption1.allotmentAmountStr.text = mapObj[keylist.getItemAt(28)].toString();
         this.cashStockOption1.perShareStr.text = mapObj[keylist.getItemAt(20)].toString();
         this.cashStockOption1.splAllotementAmountStr.text = mapObj[keylist.getItemAt(29)].toString();
         this.cashStockOption1.splPerShareStr.text = mapObj[keylist.getItemAt(23)].toString();                                                          
         this.cashStockOption1.deadLineDateStr.text = mapObj[keylist.getItemAt(38)].toString();  
         this.cashStockOption1.rightsExpiryDateStr.text = mapObj[keylist.getItemAt(39)].toString(); 
         
         //Coupon Payment Conf Part
         this.couponPayment1.security.instrumentId.text = mapObj[keylist.getItemAt(8)].toString();                      
         this.couponPayment1.recordDateStr.text = mapObj[keylist.getItemAt(17)].toString();
         this.couponPayment1.paymentDateStr.text = mapObj[keylist.getItemAt(21)].toString();
         this.couponPayment1.allttedCcy.ccyText.text = mapObj[keylist.getItemAt(27)].toString();
         this.couponPayment1.allotmentAmountStr.text = mapObj[keylist.getItemAt(28)].toString();
         this.couponPayment1.perShareStr.text = mapObj[keylist.getItemAt(20)].toString();                                                               
         this.couponPayment1.couponDateStr.text=  mapObj[keylist.getItemAt(40)].toString();  
         this.couponPayment1.couponRateStr.text=  mapObj[keylist.getItemAt(41)].toString(); 
         this.couponPayment1.creditDateStr.text=  mapObj[keylist.getItemAt(33)].toString(); 
         this.couponPayment1.currentFactorStr.text=  mapObj[keylist.getItemAt(44)].toString(); 
         this.couponPayment1.originalRecordDateStr.text= mapObj[keylist.getItemAt(42)].toString();  
         this.couponPayment1.previousFactorStr.text= mapObj[keylist.getItemAt(43)].toString(); 
         
         // XGA-201
         //Rights Allocation/Expiry Conf Part
         this.rtAllocationExpiry1.security.instrumentId.text = mapObj[keylist.getItemAt(8)].toString();                      
         this.rtAllocationExpiry1.exDateStr.text = mapObj[keylist.getItemAt(14)].toString();
         this.rtAllocationExpiry1.allottedRightsSecurity.instrumentId.text = mapObj[keylist.getItemAt(72)].toString();
         this.rtAllocationExpiry1.allotmentRightsQuantityStr.text = mapObj[keylist.getItemAt(73)].toString();
         this.rtAllocationExpiry1.recordDateStr.text = mapObj[keylist.getItemAt(17)].toString();
         this.rtAllocationExpiry1.perShareRightsStr.text = mapObj[keylist.getItemAt(74)].toString();
         this.rtAllocationExpiry1.rightsPaymentDateStr.text = mapObj[keylist.getItemAt(71)].toString();
         this.rtAllocationExpiry1.creditDateStr.text=  mapObj[keylist.getItemAt(33)].toString();
         this.rtAllocationExpiryEnd1.deadLineDateStr.text=  mapObj[keylist.getItemAt(38)].toString();
         this.rtAllocationExpiryEnd1.rightsExpiryDateStr.text=  mapObj[keylist.getItemAt(39)].toString(); 
         this.rtAllocationExpiryEnd1.allottedSecurity.instrumentId.text = mapObj[keylist.getItemAt(9)].toString();
         this.rtAllocationExpiryEnd1.allotmentQuantityStr.text = mapObj[keylist.getItemAt(19)].toString();
         this.rtAllocationExpiryEnd1.perShareStr.text = mapObj[keylist.getItemAt(20)].toString();
         this.rtAllocationExpiryEnd1.paymentDateTakeUpStr.text = mapObj[keylist.getItemAt(70)].toString();
         this.rtAllocationExpiryEnd1.paymentDateStrForRightsExpiry.text = mapObj[keylist.getItemAt(21)].toString();
         this.rtAllocationExpiryEnd1.subscriptionCcy.ccyText.text= mapObj[keylist.getItemAt(47)].toString();
         this.rtAllocationExpiryEnd1.subsCostPerShareStr.text= mapObj[keylist.getItemAt(48)].toString();  
          
                  
         
         
         //Bond Redemption
         this.redemptionBond1.security.instrumentId.text = mapObj[keylist.getItemAt(8)].toString();                      
         this.redemptionBond1.paymentDateStr.text = mapObj[keylist.getItemAt(21)].toString();
         this.redemptionBond1.redemptionCurrency.ccyText.text = mapObj[keylist.getItemAt(46)].toString();
         this.redemptionBond1.redemptionPriceStr.text = mapObj[keylist.getItemAt(61)].toString();           
         this.redemptionBond1.creditDateStr.text=  mapObj[keylist.getItemAt(33)].toString();          
         this.redemptionBond1.rateOfNominalStr.text=  mapObj[keylist.getItemAt(45)].toString(); 
         this.redemptionBond1.redemptionDateStr.text=  mapObj[keylist.getItemAt(65)].toString(); 
         this.redemptionBond1.recordDateStr.text = mapObj[keylist.getItemAt(17)].toString();                                                    
                
         //Others
         this.others1.security.instrumentId.text = mapObj[keylist.getItemAt(8)].toString();                      
         this.others1.exDateStr.text = mapObj[keylist.getItemAt(14)].toString();
         this.others1.recordDateStr.text = mapObj[keylist.getItemAt(17)].toString();
         this.others1.deadLineDateStr.text = mapObj[keylist.getItemAt(38)].toString();
         this.others1.paymentDateStr.text = mapObj[keylist.getItemAt(21)].toString();
         this.others1.allottedInstrument.instrumentId.text = mapObj[keylist.getItemAt(9)].toString();
         this.others1.allotmentQuantityStr.text = mapObj[keylist.getItemAt(19)].toString();
         this.others1.perShareStr.text = mapObj[keylist.getItemAt(20)].toString();           
         this.others1.rightsExpiryDateStr.text = mapObj[keylist.getItemAt(39)].toString();
         this.others1.exerciseDateStr.text = mapObj[keylist.getItemAt(62)].toString();                                       
         this.others1.payOutPriceStr.text = mapObj[keylist.getItemAt(25)].toString();  
         this.others1.eventTypeName.text = mapObj[keylist.getItemAt(63)].toString();
         //Free out parent Security Label value determination        
         var freeOutStr:String = ""; 
         freeOutStr = mapObj[keylist.getItemAt(64)].toString();
         if(XenosStringUtils.equals(freeOutStr,"N")) {
            freeOutStr = "NO"; 
         } if(XenosStringUtils.equals(freeOutStr,"Y")) {
            freeOutStr = "YES";
         }
         this.others1.freeOutParentSecurity.text = freeOutStr;
         
         //Stock Merger                   
         this.stockMerger1.exDateStr.text = mapObj[keylist.getItemAt(14)].toString();
         this.stockMerger1.recordDateStr.text = mapObj[keylist.getItemAt(17)].toString();
         this.stockMerger1.announcementDate.text = mapObj[keylist.getItemAt(30)].toString();
         this.stockMerger1.paymentDateStr.text = mapObj[keylist.getItemAt(21)].toString();
         this.stockMerger1.protectExpirationDate.text = mapObj[keylist.getItemAt(32)].toString();                                   
         this.stockMerger1.bookClosingDateStr.text = mapObj[keylist.getItemAt(18)].toString(); 
         this.stockMerger1.allottedInstrument.instrumentId.text = mapObj[keylist.getItemAt(9)].toString(); 
         //stock entry list to show at the confirmation page         
        //initialize subevent type
        var stockEntryLst:ArrayCollection = new ArrayCollection();
        for each(var item:Object in (mapObj[keylist.getItemAt(67).toString()] as ArrayCollection)){
            stockEntryLst.addItem(item);                
        }       
        this.stockMerger2.addedStockSummaryResult = stockEntryLst;                                               
         
    }    
     
    /**
     * After System Confirmation of amend opeartion, when the Ok button is cliked,
     * the parent document submit query event is dispatched.
     * @param e
     * 
     */
    override public function doAmendSystemConfirm(e:Event):void {
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }    
     
    /**
     * After System Confirmation of cancel opeartion, when the Ok button is cliked,
     * the parent document submit query event is dispatched.
     * @param e
     * 
     */
    override public function doCancelSystemConfirm(e:Event):void {
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }    
        
      
     /**
      * Function when the back button is clicked from user confirmation.
      */
     private function doBack():void {
       errConf.removeError();       
       changeState();   
       vstack.selectedChild = qry;     
     }         
    
    /**
     * Change of State depending upon the Event type
     * 
     */
    private function changeState():void {
        // for CASH_DIVIDEND
        if(XenosStringUtils.equals(eventType,"CASH_DIVIDEND")){
            currentState = "cashDividend";
            //State grid visibility change as the two grids are in the same mxml                        
            cash1.cashDividendEntryGrid.visible = true;
            cash1.cashDividendEntryGrid.includeInLayout = true;      
            cash1.cashDividendEntryConfGrid.visible = false;
            cash1.cashDividendEntryConfGrid.includeInLayout = false; 
            //XGA-408
            cash1.perShareStr.text = defaultPerShare; 

            if(XenosStringUtils.equals(subEventTypeStr,"SCHEME_OF_ARRANGEMENT_CASH")) {
                    taxBlockDisable();                          
                } else {
                    //Tax fee block visibility true    
                    taxFeeBlock.visible = true;
                    taxFeeBlock.includeInLayout = true;
                    taxFeeEntrySummary.visible = true;
                    taxFeeEntrySummary.includeInLayout = true;                          
                }           

            if(XenosStringUtils.equals(mode,"amend")) {
                cash1.dividendNo.enabled = false;
                cash1.bookClosingDateStr.enabled=false;
                this.externalReferenceNo.enabled = false;                
            }                                   
        }
        
        // for CAPITAL_REPAYMENT
        if(XenosStringUtils.equals(eventType,"CAPITAL_REPAYMENT")){
        	currentState = "cashDividend";
            //State grid visibility change as the two grids are in the same mxml                        
            cash1.cashDividendEntryGrid.visible = true;
            cash1.cashDividendEntryGrid.includeInLayout = true;      
            cash1.cashDividendEntryConfGrid.visible = false;
            cash1.cashDividendEntryConfGrid.includeInLayout = false; 
            //XGA-408
            cash1.perShareStr.text = defaultPerShare; 

            taxBlockDisable();                          
                       
			if(XenosStringUtils.equals(mode,"amend")) {
                cash1.dividendNo.enabled = false;
                cash1.bookClosingDateStr.enabled=false;
                this.externalReferenceNo.enabled = false;                
            }                                   
        }
        
        // for COUPON_PAYMENT
        if(XenosStringUtils.equals(eventType,"COUPON_PAYMENT")){
            currentState = "couponPayment";
            //State grid visibility change as the two grids are in the same mxml                        
            couponPayment1.couponPaymentEntryGrid.visible = true;
            couponPayment1.couponPaymentEntryGrid.includeInLayout = true;      
            couponPayment1.couponPaymentEntryConfGrid.visible = false;
            couponPayment1.couponPaymentEntryConfGrid.includeInLayout = false;
            //Tax fee block visibility true                        
            taxFeeBlock.visible = true;
            taxFeeBlock.includeInLayout = true;
            taxFeeEntrySummary.visible = true;
            taxFeeEntrySummary.includeInLayout = true;  
            if(XenosStringUtils.equals(mode,"amend")) {
                this.externalReferenceNo.enabled = false;                
            }                                                 
        }
        
        // for STOCK_DIVIDEND
        if(XenosStringUtils.equals(eventType,"STOCK_DIVIDEND")){
            currentState = "stockDividend";
            stock1.dueBillEndLbl.visible = true;
            stock1.dueBillEndLbl.includeInLayout= true; 
            stock1.dueBillEndDate.includeInLayout= true;
            stock1.dueBillEndDate.visible= true;                                    
            stock1.part1stock.visible= true;
            stock1.part2stock.visible = true;
            stock1.part3stock.visible= true;
            stock1.part1stock.includeInLayout= true;
            stock1.part2stock.includeInLayout = true;
            stock1.part3stock.includeInLayout= true;                    
            //Confirmation state grid visibility change as the two grids are in the same mxml               
            stock1.stockDividendEntryGrid.visible = true;
            stock1.stockDividendEntryGrid.includeInLayout = true;      
            stock1.stockDividendEntryConfGrid.visible = false;
            stock1.stockDividendEntryConfGrid.includeInLayout = false;  
            this.externalReferenceNo.enabled = true;  
            taxBlockDisable();    
            if(XenosStringUtils.equals(mode,"amend")) {
                stock1.dividendNo.enabled = false;
                stock1.bookClosingDateStr.enabled=false;
                
            }                                   
                            
        }
        
        //for STOCK_MERGER  
        if(XenosStringUtils.equals(eventType,"STOCK_MERGER")){
            currentState = "stockMerger";    
            this.externalReferenceNo.enabled = true;    
            taxBlockDisable();                                              
        }
        
        // for RIGHTS_ALLOCATION
        if(XenosStringUtils.equals(eventType,"RIGHTS_ALLOCATION")){
            currentState = "rightsAllocationExpiry";
            rtAllocationExpiry1.rightsAllocationExpiryEntryGrid1.visible = true;
            rtAllocationExpiry1.rightsAllocationExpiryEntryGrid1.includeInLayout = true;
            //rtAllocationExpiryEnd1.informationExerciseLabel.includeInLayout= true;
            //rtAllocationExpiryEnd1.informationExerciseLabel.visible= true;
           	rtAllocationExpiryEnd1.rightsAllocationExpiryEntryGrid2.visible = true;
            rtAllocationExpiryEnd1.rightsAllocationExpiryEntryGrid2.includeInLayout = true;  
            rtAllocationExpiry1.rightsAllocationExpiryEntryConfGrid.visible = false;
            rtAllocationExpiry1.rightsAllocationExpiryEntryConfGrid.includeInLayout = false;
            rtAllocationExpiryEnd1.rightsAllocationExpiryEntryConfGrid2.visible = false;
            rtAllocationExpiryEnd1.rightsAllocationExpiryEntryConfGrid2.includeInLayout = false;
            
            this.externalReferenceNo.enabled = true; 
            taxBlockDisable();  
                                                                                                    
        }
        
        // for RIGHTS_EXPIRY
        /*if(XenosStringUtils.equals(eventType,"RIGHTS_EXPIRY")){
            currentState = "rightsAllocationExpiry";
            rtAllocationExpiry1.takeUpCCyPart.visible=true; 
            rtAllocationExpiry1.takeUpCCyPart.includeInLayout=true;
            rtAllocationExpiry1.rightsExpiryDateLbl.styleName="ReqdLabel";    
            //State grid visibility change as the two grids are in the same mxml                
            rtAllocationExpiry1.rightsAllocationExpiryEntryGrid1.visible = true;
            rtAllocationExpiry1.rightsAllocationExpiryEntryGrid1.includeInLayout = true;
            rtAllocationExpiry1.rightsAllocationExpiryEntryGrid2.visible = true;
            rtAllocationExpiry1.rightsAllocationExpiryEntryGrid2.includeInLayout = true;      
            rtAllocationExpiry1.rightsAllocationExpiryEntryConfGrid.visible = false;
            rtAllocationExpiry1.rightsAllocationExpiryEntryConfGrid.includeInLayout = false;
            
            rtAllocationExpiry1.paymentDateRightsExpiryGrid.includeInLayout=true;
            rtAllocationExpiry1.paymentDateRightsExpiryGrid.visible=true;
            rtAllocationExpiry1.paymentDateRightsAllocationGrid.includeInLayout=false;
            rtAllocationExpiry1.paymentDateRightsAllocationGrid.visible=false;
            rtAllocationExpiry1.informationExerciseLabel.includeInLayout=true;
            rtAllocationExpiry1.informationExerciseLabel.visible=true;
            
            this.externalReferenceNo.enabled = true; 
            taxBlockDisable();                                                                                              
        }*/
        
        // for BONUS_ISSUE
        if(XenosStringUtils.equals(eventType,"BONUS_ISSUE")){
            currentState = "stockDividend";
            stock1.dueBillEndLbl.visible = false;
            stock1.dueBillEndLbl.includeInLayout = false;
            stock1.dueBillEndDate.includeInLayout= false;
            stock1.dueBillEndDate.visible= false;
            stock1.part1stock.visible= false;
            stock1.part2stock.visible = false;
            stock1.part3stock.visible= false;
            stock1.part1stock.includeInLayout= false;
            stock1.part2stock.includeInLayout = false;
            stock1.part3stock.includeInLayout= false;  
            //Confirmation state grid visibility change as the two grids are in the same mxml               
            stock1.stockDividendEntryGrid.visible = true;
            stock1.stockDividendEntryGrid.includeInLayout = true;      
            stock1.stockDividendEntryConfGrid.visible = false;
            stock1.stockDividendEntryConfGrid.includeInLayout = false;  
            this.externalReferenceNo.enabled = true;  
            taxBlockDisable();                                                      
                            
        
        }
        
        
        // for REDEMPTION_BOND
        if(XenosStringUtils.equals(eventType,"REDEMPTION_BOND")){
            currentState = "redemptionBond";
            //State grid visibility change as the two grids are in the same mxml                
            redemptionBond1.redemptionBondEntryGrid.visible = true;
            redemptionBond1.redemptionBondEntryGrid.includeInLayout = true;      
            redemptionBond1.redemptionBondEntryConfGrid.visible = false;
            redemptionBond1.redemptionBondEntryConfGrid.includeInLayout = false;
            if(this.mode == 'amend'){
            	redemptionBond1.recordDtLbl.visible = true;
            	redemptionBond1.recordDtLbl.includeInLayout = true;
            	redemptionBond1.recordDateStr.visible = true;
            	redemptionBond1.recordDateStr.includeInLayout = true;
            }
            this.externalReferenceNo.enabled = true; 
            taxBlockDisable();                                      
            
        }
        
        // for REVERSE_STOCK_SPLIT
        if(XenosStringUtils.equals(eventType,"REVERSE_STOCK_SPLIT")){
            currentState = "capRedRevSplStSplShareEx";
            commonPortionEnableforSomeEvent();                  
        }
        
        // for SHARE_EXCHANGE
        if(XenosStringUtils.equals(eventType,"SHARE_EXCHANGE")){
            currentState = "capRedRevSplStSplShareEx";
            commonPortionEnableforSomeEvent();
        }
        
        // for STOCK_SPLIT
        if(XenosStringUtils.equals(eventType,"STOCK_SPLIT")){
            currentState = "capRedRevSplStSplShareEx";
            commonPortionEnableforSomeEvent();
        }
        
        
        // for NAME_CHANGE
        if(XenosStringUtils.equals(eventType,"NAME_CHANGE")){
            currentState = "capRedRevSplStSplShareEx";
            commonPortionEnableforSomeEvent();   
            if(XenosStringUtils.equals(mode,"amend")) {
                this.externalReferenceNo.enabled = false;
            }                           
        }

        
        // for SPIN_OFF
        if(XenosStringUtils.equals(eventType,"SPIN_OFF")){
            currentState = "capRedRevSplStSplShareEx";
            commonPortionEnableforSomeEvent();
        }
        
        
        // for OPTIONAL_STOCK_DIV
        if(XenosStringUtils.equals(eventType,"OPTIONAL_STOCK_DIV")){
            currentState = "cashStockOption";
            //State grid visibility change as the two grids are in the same mxml                
            cashStockOption1.cashStockOptionEntryGrid.visible = true;
            cashStockOption1.cashStockOptionEntryGrid.includeInLayout = true;      
            cashStockOption1.cashStockOptionEntryConfGrid.visible = false;
            cashStockOption1.cashStockOptionEntryConfGrid.includeInLayout = false;  
            this.externalReferenceNo.enabled = true;
            //XGA-408   
            cashStockOption1.perShareStr.text = defaultPerShare;    
            taxBlockDisable();  
            if(XenosStringUtils.equals(mode,"amend")) {
                cashStockOption1.bookClosingDateStr.enabled=false;
            }                                                                   
            
        }
        
        
        // for DIV_REINVESTMENT
        if(XenosStringUtils.equals(eventType,"DIV_REINVESTMENT")){
            currentState = "cashStockOption";
            //State grid visibility change as the two grids are in the same mxml                
            cashStockOption1.cashStockOptionEntryGrid.visible = true;
            cashStockOption1.cashStockOptionEntryGrid.includeInLayout = true;      
            cashStockOption1.cashStockOptionEntryConfGrid.visible = false;
            cashStockOption1.cashStockOptionEntryConfGrid.includeInLayout = false; 
            this.externalReferenceNo.enabled = true;
            //XGA-408 
            cashStockOption1.perShareStr.text = defaultPerShare;
            taxBlockDisable();  
            if(XenosStringUtils.equals(mode,"amend")) {
                cashStockOption1.bookClosingDateStr.enabled=false;
            }                                                           
        }
        
        // for OTHERS
        if(XenosStringUtils.equals(eventType,"OTHERS")){
            currentState = "others";
            //State grid visibility change as the two grids are in the same mxml                        
            others1.otherEntryGrid.visible = true;
            others1.otherEntryGrid.includeInLayout = true;      
            others1.otherEntryConfGrid.visible = false;
            others1.otherEntryConfGrid.includeInLayout = false;   
            this.externalReferenceNo.enabled = true; 
            taxBlockDisable();                                  
            
        }
        initialStateFlag =false;
        loadInitialState();
                
    
    }
    
    /**
     *  Loads initial state with only event type dropdown  
     * 
     */
    private function loadInitialState():void {          
        if(initialStateFlag == true) {
            part1end.visible = true;
            part1end.includeInLayout = true;
            conditionStatusEntry.visible = false;
            conditionStatusEntry.includeInLayout = false;
            conditionStatusLbl.visible = false;     
            conditionStatusLbl.includeInLayout = false;                  
            part3end.visible = false;
            part3end.includeInLayout = false; 
            taxFeeBlock.visible = false;
            taxFeeBlock.includeInLayout = false;
            taxFeeEntrySummary.visible = false;
            taxFeeEntrySummary.includeInLayout = false;                                 
        } else {
            conditionStatusEntry.visible = true;
            conditionStatusEntry.includeInLayout = true;
            conditionStatusLbl.visible = true;     
            conditionStatusLbl.includeInLayout = true;          
            part1end.visible = true; 
            part1end.includeInLayout= true;
            part3end.visible = true;
            part3end.includeInLayout = true;                
        }

    }
    /**
     *  Make Tax Block Disable  
     * 
     */
    private function taxBlockDisable():void {           
        taxFeeBlock.visible = false;
        taxFeeBlock.includeInLayout = false;
        taxFeeEntrySummary.visible = false;
        taxFeeEntrySummary.includeInLayout = false; 
        taxFeeEntrySummaryConf.visible = false;
        taxFeeEntrySummaryConf.includeInLayout = false;         
    }    
    
    /**
     *  Loads initial state with first amend view screen  
     * 
     */
    private function loadAmendCxlInitialState(initialStateAmdCxl:Boolean):void { 
         if(initialStateAmdCxl == true) {       
            part1end.visible = false; 
            part3end.visible = false;
            part3end.includeInLayout = false;
            submit.visible = false;
            submit.includeInLayout = false;
            reset.visible= false;
            reset.includeInLayout = false; 
            Btn1.visible = false;
            Btn1.includeInLayout = false;
            taxBlockDisable();               
         } else {
            part1end.visible = true; 
            part3end.visible = true;
            part3end.includeInLayout = true;    
            submit.visible = true;
            submit.includeInLayout = true;
            reset.visible = true;
            reset.includeInLayout = true; 
            Btn1.visible = true;
            Btn1.includeInLayout = true;
         }

    }    
        
    /** 
     * Common parts will be enabled for stockSplit,reverseStockSplit,ShareEx,SpinOff...etc
     */
    private function commonPortionEnableforSomeEvent():void {
        if(XenosStringUtils.equals(currentState,"capRedRevSplStSplShareEx")) {
            if(XenosStringUtils.equals(eventType,"NAME_CHANGE")){
                someEventsCommon1.dueBillEndPart.visible=false;
                someEventsCommon1.dueBillEndPart.includeInLayout=false;
                someEventsCommon1.payoutCCyPart.visible=false;
                someEventsCommon1.payoutCCyPart.includeInLayout=false; 
            } else {
                someEventsCommon1.dueBillEndPart.visible=true;
                someEventsCommon1.dueBillEndPart.includeInLayout=true;
                someEventsCommon1.payoutCCyPart.visible=true;
                someEventsCommon1.payoutCCyPart.includeInLayout=true;               
            }
            //state grid visibility change as the two grids are in the same mxml                
            someEventsCommon1.rcCapRadEntryGrid.visible = true;
            someEventsCommon1.rcCapRadEntryGrid.includeInLayout = true;      
            someEventsCommon1.rcCapRadEntryConfGrid.visible = false;
            someEventsCommon1.rcCapRadEntryConfGrid.includeInLayout = false;
            if(XenosStringUtils.equals(mode,"amend") && 
                !XenosStringUtils.equals(eventType,"NAME_CHANGE")) {
                someEventsCommon1.security.enabled = false;
                someEventsCommon1.exDateStr.enabled=false;
                someEventsCommon1.recordDateStr.enabled = false;
                someEventsCommon1.bookClosingDateStr.enabled=false;
                this.externalReferenceNo.enabled = false;                               
            }                       
                        
        } else if (XenosStringUtils.equals(currentState,"capRedRevSplStSplShareExConf")) {
            if(XenosStringUtils.equals(eventType,"NAME_CHANGE")){
                someEventsCommon2.dueBillEndConflbl.visible = false;
                someEventsCommon2.dueBillEndDateConf.visible= false;
                someEventsCommon2.dueBillEndConflbl.includeInLayout= false;
                someEventsCommon2.dueBillEndDateConf.includeInLayout=false; 
                someEventsCommon2.payOutCcyPartConf.visible=false;
                someEventsCommon2.payOutCcyPartConf.includeInLayout=false;
            } else {
                someEventsCommon2.dueBillEndConflbl.visible = true;
                someEventsCommon2.dueBillEndDateConf.visible= true;
                someEventsCommon2.dueBillEndConflbl.includeInLayout= true;
                someEventsCommon2.dueBillEndDateConf.includeInLayout=true;  
                someEventsCommon2.payOutCcyPartConf.visible=true;
                someEventsCommon2.payOutCcyPartConf.includeInLayout=true;           
            }           

            //Confirmation state grid visibility change as the two grids are in the same mxml               
            someEventsCommon1.rcCapRadEntryGrid.visible = false;
            someEventsCommon1.rcCapRadEntryGrid.includeInLayout = false;      
            someEventsCommon1.rcCapRadEntryConfGrid.visible = true;
            someEventsCommon1.rcCapRadEntryConfGrid.includeInLayout = true;                     
        }
            taxBlockDisable();
        
        
    }
        
      /**
       * Result Handler of Change State Event.
       * This is a result handler of OnChangeEvent
       * @param event Event
       * 
       */
      private function changeStateResultHandler(event:ResultEvent):void {
       rs = XML(event.result);
        if (null != event) {
            if(rs != null) {
                // getting event type
                eventType = rs.corporateActionId; 
                subEventTypeStr = rs.subEventType;
                errPage.clearError(event);
                
                //initialize text fields common part
                textFieldInitilize();
                //change State
                changeState();
                //Changing of processing frequency.
                onChangeProcessingFrequency();
                
                // For TAX FEE INFO BLOCK
                if(XenosStringUtils.equals(eventType,"CASH_DIVIDEND") ||
                    XenosStringUtils.equals(eventType,"COUPON_PAYMENT")) {
                        this.taxMode = this.mode;
                        this.addedTaxFeeSummaryResult.removeAll();
                        try {
                            var rec:XML = new XML(); 
                            
                            //Initilizing tax fee list type
                            var initcol:ArrayCollection = new ArrayCollection();                
                            initcol.addItem(" ");                       
                            for each (rec in rs.taxFeeIdList.taxFeeIdDropdownList) {
                                        initcol.addItem(rec);
                                    }               
                            this.taxFeeId.dataProvider = initcol;                               
                            this.taxFeeList = initcol;
                            
                            //Initilizing rate type
                            initcol = new ArrayCollection();                
                            initcol.addItem({label:" ", value: " "});                       
                            for each (rec in rs.rateTypeDropdownList.item) {
                                        initcol.addItem(rec);
                                    }                                   
                            this.rateType.dataProvider = initcol;
                            this.rateTypeList = initcol;                                        
                            
                        }catch(e:Error){
                            XenosAlert.error("No result found");
                        }
                }
            }else if(rs.child("Errors").length()>0) {
                //some error found
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list              
                for each ( var error:XML in rs.Errors.error ) {
                    errorInfoList.addItem(error.toString());
                }
                errPage.showError(errorInfoList);//Display the error
            }
        }                   
     } 

     
    /**
     * Processing Frequency Change action
     * 
     */
    private function onChangeProcessingFrequency():void {       
        var processingFreq:String = this.processingFrequency.selectedItem.value;
        changeProcessingFrequencyValues(processingFreq);
    }
    /**
     * Common handler for Processing Frequency Change/ amend and Entry
     * 
     */     
    private function changeProcessingFrequencyValues(processingFreq:String):void {
        switch(processingFreq)
        {
            case "DAILY" :
                this.processfreq.visible = true;
                this.processfreq.includeInLayout = true;
                this.processstart.visible = true;
                this.processstart.includeInLayout = true;
                this.processstartlbl.visible = true;
                this.processstartlbl.includeInLayout = true;
                break; 
            case "TRIGGER" :
                this.processfreq.visible = false;
                this.processfreq.includeInLayout = false;
                this.processstart.visible = true;
                this.processstart.includeInLayout = true;
                this.processstartlbl.visible = true;
                this.processstartlbl.includeInLayout = true;            
                break;
            case "MANUAL" :
                this.processfreq.visible = false;
                this.processfreq.includeInLayout = false;
                this.processstart.visible = false;
                this.processstart.includeInLayout = false;
                this.processstartlbl.visible = false;
                this.processstartlbl.includeInLayout = false;
                break;
            default :
                this.processfreq.visible = true;
                this.processfreq.includeInLayout = true;
                this.processstart.visible = true;
                this.processstart.includeInLayout = true;
                this.processstartlbl.visible = true;
                this.processstartlbl.includeInLayout = true;
                break;
        }
        
    }            
        
                 
      /**
       * Change to state of User Confirmation 
       * 
       */
      private function changeStateToConf():void {
            
         // change the state to result of view stack
         vstack.selectedChild = rslt;       
         
            // for CASH_DIVIDEND
            if(XenosStringUtils.equals(eventType,"CASH_DIVIDEND")){
                currentState = "cashDividendConf";
                cash1.cashDividendEntryGrid.visible = false;
                cash1.cashDividendEntryGrid.includeInLayout = false;      
                cash1.cashDividendEntryConfGrid.visible = true;
                cash1.cashDividendEntryConfGrid.includeInLayout = true;
                if(XenosStringUtils.equals(subEventTypeStr,"SCHEME_OF_ARRANGEMENT_CASH")) {
                        taxBlockDisable();                          
                    } else {
                        taxFeeEntrySummaryConf.visible = true;
                        taxFeeEntrySummaryConf.includeInLayout = true;                          
                    }                                                       
            }
            
            // for CAPITAL_REPAYMENT
            if(XenosStringUtils.equals(eventType,"CAPITAL_REPAYMENT")){
                currentState = "cashDividendConf";
                cash1.cashDividendEntryGrid.visible = false;
                cash1.cashDividendEntryGrid.includeInLayout = false;      
                cash1.cashDividendEntryConfGrid.visible = true;
                cash1.cashDividendEntryConfGrid.includeInLayout = true;
                taxBlockDisable();
            }

            // for COUPON_PAYMENT
            if(XenosStringUtils.equals(eventType,"COUPON_PAYMENT")){
                currentState = "couponPaymentConf";
                couponPayment1.couponPaymentEntryGrid.visible = false;
                couponPayment1.couponPaymentEntryGrid.includeInLayout = false;      
                couponPayment1.couponPaymentEntryConfGrid.visible = true;
                couponPayment1.couponPaymentEntryConfGrid.includeInLayout = true;   
                taxFeeEntrySummaryConf.visible = true;
                taxFeeEntrySummaryConf.includeInLayout = true;                                      
            }
            
            // for STOCK_DIVIDEND
            if(XenosStringUtils.equals(eventType,"STOCK_DIVIDEND")){
                currentState = "stockDividendConf";
                stock2.part1StockConf.visible= true;
                stock2.part2StockConf.visible = true;
                stock2.part3StockConf.visible= true;
                stock2.part1StockConf.includeInLayout= true;
                stock2.part2StockConf.includeInLayout = true;
                stock2.part3StockConf.includeInLayout= true; 
                stock2.dueBillEndConflbl.visible = true;
                stock2.dueBillEndDateConf.visible= true;
                stock2.dueBillEndConflbl.includeInLayout= true;
                stock2.dueBillEndDateConf.includeInLayout=true; 
                //Confirmation state grid visibility change as the two grids are in the same mxml               
                stock1.stockDividendEntryGrid.visible = false;
                stock1.stockDividendEntryGrid.includeInLayout = false;      
                stock1.stockDividendEntryConfGrid.visible = true;
                stock1.stockDividendEntryConfGrid.includeInLayout = true;
                taxBlockDisable();                                      
                
                                
            }
            
            //for STOCK_MERGER  
            if(XenosStringUtils.equals(eventType,"STOCK_MERGER")){
                currentState = "stockMergerConf";
                taxBlockDisable();                  
                //stockMergerCnf.stockMergerVstack.selectedChild = stockMergerCnf.stockMergerEntryConf;
                //stockEntryList = queryResult.stockEntryList as XML;
            }
            
            // for RIGHTS_ALLOCATION
            if(XenosStringUtils.equals(eventType,"RIGHTS_ALLOCATION")){
                currentState = "rightsAllocationExpiryConf";
                rtAllocationExpiry1.rightsAllocationExpiryEntryGrid1.visible = false;
            rtAllocationExpiry1.rightsAllocationExpiryEntryGrid1.includeInLayout = false;
            //rtAllocationExpiryEnd1.informationExerciseLabel.includeInLayout= true;
            //rtAllocationExpiryEnd1.informationExerciseLabel.visible= true;
           	rtAllocationExpiryEnd1.rightsAllocationExpiryEntryGrid2.visible = false;
            rtAllocationExpiryEnd1.rightsAllocationExpiryEntryGrid2.includeInLayout = false;  
            rtAllocationExpiry1.rightsAllocationExpiryEntryConfGrid.visible = true;
            rtAllocationExpiry1.rightsAllocationExpiryEntryConfGrid.includeInLayout = true;
            rtAllocationExpiryEnd1.rightsAllocationExpiryEntryConfGrid2.visible = true;
            rtAllocationExpiryEnd1.rightsAllocationExpiryEntryConfGrid2.includeInLayout = true;   
                taxBlockDisable();                                                      
            }
            
            // for RIGHTS_EXPIRY
            /*if(XenosStringUtils.equals(eventType,"RIGHTS_EXPIRY")){
                currentState = "rightsAllocationExpiryConf";
               	rtAllocationExpiry2.paymentDateUsrConfRightsExpiry.includeInLayout=true;
         		rtAllocationExpiry2.paymentDateUsrConfRightsExpiry.visible=true;
                rtAllocationExpiry2.takeUpCcyPartConf.visible=true; 
                rtAllocationExpiry2.takeUpCcyPartConf.includeInLayout=true;                     
                rtAllocationExpiry2.creditDateLblConf.visible=false; 
                rtAllocationExpiry2.creditDateLblConf.includeInLayout=false;
                rtAllocationExpiry2.creditDateConf.visible=false; 
                rtAllocationExpiry2.creditDateConf.includeInLayout=false; 
                //Confirmation State grid visibility change as the two grids are in the same mxml               
                 rtAllocationExpiry1.rightsAllocationExpiryEntryGrid1.visible = false;
            	rtAllocationExpiry1.rightsAllocationExpiryEntryGrid1.includeInLayout = false;
             	rtAllocationExpiryEnd1.rightsAllocationExpiryEntryGrid2.visible = false;
            	rtAllocationExpiryEnd1.rightsAllocationExpiryEntryGrid2.includeInLayout = false;     
                rtAllocationExpiry1.rightsAllocationExpiryEntryConfGrid.visible = true;
                rtAllocationExpiry1.rightsAllocationExpiryEntryConfGrid.includeInLayout = true;  
                taxBlockDisable();                                                      
            }*/
            
            // for BONUS_ISSUE
            if(XenosStringUtils.equals(eventType,"BONUS_ISSUE")){
                currentState = "stockDividendConf";
                stock2.part1StockConf.visible= false;
                stock2.part2StockConf.visible = false;
                stock2.part3StockConf.visible= false;
                stock2.part1StockConf.includeInLayout= false;
                stock2.part2StockConf.includeInLayout = false;
                stock2.part3StockConf.includeInLayout= false;
                stock2.dueBillEndConflbl.visible = false;
                stock2.dueBillEndDateConf.visible= false;
                stock2.dueBillEndConflbl.includeInLayout= false;
                stock2.dueBillEndDateConf.includeInLayout=false; 
                //Confirmation state grid visibility change as the two grids are in the same mxml               
                stock1.stockDividendEntryGrid.visible = false;
                stock1.stockDividendEntryGrid.includeInLayout = false;      
                stock1.stockDividendEntryConfGrid.visible = true;
                stock1.stockDividendEntryConfGrid.includeInLayout = true; 
                taxBlockDisable();                                      
                                                        
            }
            
            // for REDEMPTION_BOND
            if(XenosStringUtils.equals(eventType,"REDEMPTION_BOND")){
                currentState = "redemptionBondConf";
                //Confirmation State grid visibility change as the two grids are in the same mxml               
                redemptionBond1.redemptionBondEntryGrid.visible = false;
                redemptionBond1.redemptionBondEntryGrid.includeInLayout = false;      
                redemptionBond1.redemptionBondEntryConfGrid.visible = true;
                redemptionBond1.redemptionBondEntryConfGrid.includeInLayout = true; 
                if(this.mode=='amend'){
	            	redemptionBond2.recordDtConfLbl.visible = true;
	            	redemptionBond2.recordDtConfLbl.includeInLayout = true;
	            	redemptionBond2.recordDateConf.visible = true;
	            	redemptionBond2.recordDateConf.includeInLayout = true;
                }  
                taxBlockDisable();                                      
            }
            
            // for REVERSE_STOCK_SPLIT
            if(XenosStringUtils.equals(eventType,"REVERSE_STOCK_SPLIT")){
                currentState = "capRedRevSplStSplShareExConf";  
                commonPortionEnableforSomeEvent();                  
            }
            
            // for SHARE_EXCHANGE
            if(XenosStringUtils.equals(eventType,"SHARE_EXCHANGE")){
                currentState = "capRedRevSplStSplShareExConf";
                commonPortionEnableforSomeEvent();
            }
            
            // for STOCK_SPLIT
            if(XenosStringUtils.equals(eventType,"STOCK_SPLIT")){
                currentState = "capRedRevSplStSplShareExConf";
                commonPortionEnableforSomeEvent();
            }
            
            
            // for NAME_CHANGE
            if(XenosStringUtils.equals(eventType,"NAME_CHANGE")){
                currentState = "capRedRevSplStSplShareExConf";
                commonPortionEnableforSomeEvent();              
            }

            
            // for SPIN_OFF
            if(XenosStringUtils.equals(eventType,"SPIN_OFF")){
                currentState = "capRedRevSplStSplShareExConf";
                commonPortionEnableforSomeEvent();
            }
            
            
            // for WARRANT_EXPIRY
            if(XenosStringUtils.equals(eventType,"WARRANT_EXPIRY")){
                currentState = "warrantExpiryConf";
            }
            
            
            // for OPTIONAL_STOCK_DIV
            if(XenosStringUtils.equals(eventType,"OPTIONAL_STOCK_DIV")){
                currentState = "cashStockOptionConf";
                //State grid visibility change as the two grids are in the same mxml                
                cashStockOption1.cashStockOptionEntryGrid.visible = false;
                cashStockOption1.cashStockOptionEntryGrid.includeInLayout = false;      
                cashStockOption1.cashStockOptionEntryConfGrid.visible = true;
                cashStockOption1.cashStockOptionEntryConfGrid.includeInLayout = true; 
                taxBlockDisable();                                      
            }
            
            
            // for DIV_REINVESTMENT
            if(XenosStringUtils.equals(eventType,"DIV_REINVESTMENT")){
                currentState = "cashStockOptionConf";
                //State grid visibility change as the two grids are in the same mxml                
                cashStockOption1.cashStockOptionEntryGrid.visible = false;
                cashStockOption1.cashStockOptionEntryGrid.includeInLayout = false;      
                cashStockOption1.cashStockOptionEntryConfGrid.visible = true;
                cashStockOption1.cashStockOptionEntryConfGrid.includeInLayout = true; 
                taxBlockDisable();                                      
            }
            
            // for OTHERS
            if(XenosStringUtils.equals(eventType,"OTHERS")){
                currentState = "othersConf";
                //Confirmation state, grid visibility change as the two grids are in the same mxml                      
                others1.otherEntryGrid.visible = false;
                others1.otherEntryGrid.includeInLayout = false;      
                others1.otherEntryConfGrid.visible = true;
                others1.otherEntryConfGrid.includeInLayout = true; 
                taxBlockDisable();                                      
                
            }
     }  
