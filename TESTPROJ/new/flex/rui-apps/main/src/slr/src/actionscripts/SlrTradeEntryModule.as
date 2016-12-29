		// ActionScript file for BkgTradeEntryModule
		import com.nri.rui.core.Globals;
		import com.nri.rui.core.controls.XenosAlert;
		import com.nri.rui.core.controls.XenosEntry;
		import com.nri.rui.core.startup.XenosApplication;
		import com.nri.rui.core.utils.DateUtils;
		import com.nri.rui.core.utils.HiddenObject;
		import com.nri.rui.core.utils.ProcessResultUtil;
		import com.nri.rui.core.utils.XenosStringUtils;
		import com.nri.rui.ref.popupImpl.StrategyPopUp;
		import com.nri.rui.ref.popupImpl.TrdSsiPopup;
		import com.nri.rui.slr.validator.SlrEntryValidator;
		
		import flash.events.Event;
		
		import mx.collections.ArrayCollection;
		import mx.collections.XMLListCollection;
		import mx.core.UIComponent;
		import mx.events.CloseEvent;
		import mx.events.FlexEvent;
		import mx.events.ResourceEvent;
		import mx.managers.PopUpManager;
		import mx.resources.ResourceBundle;
		import mx.rpc.events.ResultEvent;
		import mx.utils.StringUtil;

					
			  
		     [Bindable]
		     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     
            [Bindable]private var mode : String = "entry";
            [Bindable]private var lastAction : Boolean = false;
            [Bindable]private var mtmClose : Boolean = false;
            [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
            [Bindable]private var trdTypeDP:ArrayCollection = new ArrayCollection();
            [Bindable]private var securityList:ArrayCollection = new ArrayCollection();
            [Bindable]public var cpSecSsiPk:Label = new Label();
            [Bindable]public var cpCashSsiPk:Label = new Label();
            [Bindable]private var contractPkStr : String = "";
            private var keylist:ArrayCollection = new ArrayCollection();
            private var initcol:ArrayCollection = new ArrayCollection();
            private var item:Object = new Object();
            private var allSBTType:ArrayCollection = new ArrayCollection(); 
	        private var subTypeForRPRV:ArrayCollection = new ArrayCollection(); 
	        private var subTypeForBBBL:ArrayCollection = new ArrayCollection(); 
	        private var subTypeForSB:ArrayCollection = new ArrayCollection(); 
	        private var subTypeForSL:ArrayCollection = new ArrayCollection(); 
	        private var tradeTypeVal : String = "";
	        private var stlFor:String = XenosStringUtils.EMPTY_STR;
	        private var deliveryMethod:String = XenosStringUtils.EMPTY_STR;
	        private var sbTypeObj:ArrayCollection = new ArrayCollection();
	        [Bindable]private var conTractRefNo:String = XenosStringUtils.EMPTY_STR;
	        [Bindable]private var accountPkStr:String = XenosStringUtils.EMPTY_STR;
	        [Bindable]private var invAccountPkStr:String = XenosStringUtils.EMPTY_STR;
	        [Bindable]private var queryResult:XML= new XML();
            [Bindable]public var actions:XMLListCollection = new XMLListCollection();
            [Bindable]private var actionSelectedIndx : int = -1; 
            [Bindable]private var secCode:String =  XenosStringUtils.EMPTY_STR;
            [Bindable]private var refNo:String =  XenosStringUtils.EMPTY_STR;
	  
			  private function changeCurrentState():void{
						vstack.selectedChild = rslt;
			 }
			 
		  
	  	/**
         * Load the Entry/Amend/Cancel according to 
         * the operational mode (e.g. Entry/Amend/Cancel)
         */  
		   public function loadAll():void {
	       	   parseUrlString();
	       	   populateSubTradeType();
	       	   this.actBalTypeGrd.visible = false;
	       	   this.actBalTypeGrd.includeInLayout = false;
	       	   
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
	                        }else if(tempA[0] == "contractPk"){
	                            this.contractPkStr = tempA[1];
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
            * This method fires the dispatchAction to initialize the
            * SLR Trade Entry Screen (InitEntry-SEQ-1)
            */
            override public function preEntryInit():void{            	
		        var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "slr/slrContractEntryDispatch.action?";
            	var reqObject:Object = new Object();
            	reqObject.rnd = rndNo;
            	reqObject.method= "initialExecute";
		  		reqObject.mode="entry";
		  		reqObject.screenType = "M";
		  		reqObject.SCREEN_KEY = "120";
		  		super.getInitHttpService().request = reqObject;
            }
            
            /**
            * This method fires the dispatchaction to initialize the
            * SLR Trade Amend Screen (InitAmend-SEQ-1)
            */
             override public function preAmendInit():void{     
            	initLabel.text = this.parentApplication.xResourceManager.getKeyValue('slr.label.slrtradeamendment');       	
		        var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "slr/AmendDetailsDispatch.action?";
            	var reqObject:Object = new Object();
            	reqObject.rnd = rndNo;
            	reqObject.method= "contractDetailsAmendQueryExecute";
		  		reqObject.mode=this.mode;
		  		reqObject.contractPk = this.contractPkStr;
		  		reqObject.SCREEN_KEY = "784";
		  		super.getInitHttpService().request = reqObject;
            } 
            
            /**
            * This method fires the dispatchaction to initialize the
            * SLR Trade Cancel Screen (InitCancel-SEQ-1)
            */
             override public function preCancelInit():void{            	
		        this.back.includeInLayout = false;
			    this.back.visible = false;
			    this.partForCancel.visible = true;
			    this.partForCancel.includeInLayout = true;
			    //this.actnNo.includeInLayout = false;
			    this.actnNo.visible = true;
			    this.legType.visible = true;
			    this.actnType.visible = true;
			    this.statusCol.visible = true;
			    this.inputfactor.visible = false;
			    this.startlegextrefno.visible = false;
			    this.endlegextrefno.visible = false;
			    this.startsenderrefno.visible = false;
			    this.endsenderrefno.visible = false;
			    this.cashvaluedate.visible = false;
			    this.ssiInfo.visible = false;
			    this.ssiInfo.includeInLayout = false;
			    this.uNetAmt.visible = false;
			    this.uNetAmt.includeInLayout = false;
			    this.netLabel.visible = false;
			    this.netLabel.includeInLayout = false;
			    this.prinAmnt.visible = true;
			    this.prinAmnt.includeInLayout = true;
			    this.prinLabel.visible = true;
			    this.prinLabel.includeInLayout = true;
			    this.reasonForCancel.visible = true;
			    this.reasonForCancel.includeInLayout = true;
			    this.secInfo.label = this.parentApplication.xResourceManager.getKeyValue('slr.contract.label.actionhistory');
			    
			    
			    changeCurrentState(); 			             	
		        var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "slr/ContractCancelDetailsDispatch.action?";
            	var reqObject:Object = new Object();
            	reqObject.rnd = rndNo;
            	reqObject.method= "contractDetailsCancelQueryExecute";
		  		reqObject.mode=this.mode;
		  		reqObject.contractPk = this.contractPkStr;
		  		reqObject.SCREEN_KEY = "133";
		  		super.getInitHttpService().request = reqObject;
            } 
        
	        /**
            * This method is pre-result handler for the SLR Trade Entry
            * Screen. It generates the list of keys which will be populated 
            * during the initialization of the SLR trade Entry screen. 
            * (InitEntry-SEQ-2)
            */
	        override public function preEntryResultInit():Object{
	        	addCommonKeys();
	        	keylist.addItem("settlementFor");
		    	keylist.addItem("deliveryMethod"); 
	        	this.contractNoLbl.visible=false;
	        	this.contractNo.visible=false;
	        	this.openEndedLbl.visible=false;
	        	this.openEndedVal.visible=false;
	        	this.contractNoLbl.includeInLayout=false;
	        	this.contractNo.includeInLayout=false;
	        	this.openEndedLbl.includeInLayout=false;
	        	this.openEndedVal.includeInLayout=false;
	        	return keylist;
	        }
	        
	        /**
            * This method is pre-result handler for the SLR Trade Amend
            * Screen. It generates the list of keys which will be populated 
            * during the initialization of the SLR trade Amend screen. 
            * (InitAmend-SEQ-2)
            */
	         override public function preAmendResultInit():Object{
	        	addCommonKeys(); 
	        	keylist.addItem("contractNumber");
		    	keylist.addItem("versionNo");
		    	keylist.addItem("openEnded");
		    	keylist.addItem("tradeType");
		    	keylist.addItem("subTradeType");
		    	keylist.addItem("accountNo");
		    	keylist.addItem("rr");	
		    	keylist.addItem("inventoryAccount");
		    	keylist.addItem("executingRr");
		    	keylist.addItem("traderId");
		    	keylist.addItem("hairCut");
		    	keylist.addItem("brokerCode");
		    	keylist.addItem("extRefNo");
		    	keylist.addItem("accountBalanceType");
		    	keylist.addItem("tradeCurrency");
		    	keylist.addItem("settlementCurrency");
		    	keylist.addItem("expirationDate");
		    	keylist.addItem("endDate");
		    	keylist.addItem("dividendRate");
		    	keylist.addItem("accrualDays");	
		    	keylist.addItem("interestRate");
		    	keylist.addItem("interestAmount");
		    	keylist.addItem("commission");
		    	keylist.addItem("netAmount");
		    	keylist.addItem("subLimit");
		    	keylist.addItem("brokerReferenceNo");
		    	keylist.addItem("remarks");
		    	keylist.addItem("noSlr01ReqFlag");
		    	keylist.addItem("stlLocSec");
		    	keylist.addItem("stlLocCash");
		    	keylist.addItem("customerPk");
		    	keylist.addItem("accountPk");
		    	keylist.addItem("inventoryAccountPk");
		    	keylist.addItem("securities.security");
		    	//keylist.addItem("contractPK");
	        	return keylist;
	        } 
	        
	        /**
            * This method is pre-result handler for the SLR Trade Cancel
            * Screen. It generates the list of keys which will be populated 
            * during the initialization of the SLR trade Cancel screen. 
            * (InitCancel-SEQ-2)
            */
	         override public function preCancelResultInit():Object{
	        	addCommonResultKeys();         	
	        	return keylist;
	        } 
	        
	        
	        /**
	        * This method populates the elements of the SLR
	        * Trade Entry screen(mxml)
	        * from the map obtained from preEntryResultInit() (InitEntry-SEQ-3)
	        */
	        override public function postEntryResultInit(mapObj:Object): void{
	        	app.submitButtonInstance = submit;
	        	resetSecurity();
	        	commonInit(mapObj);
	        }
	        
	        /**
	        * This method populates the elements of the SLR
	        * Trade Amend screen(mxml)
	        * from the map obtained from preAmendResultInit() (InitAmend-SEQ-3)
	        */
	         override public function postAmendResultInit(mapObj:Object): void{
	         	
	        	app.submitButtonInstance = submit;
	        	//commonInit(mapObj);
	        	resetSecurity();
	        	this.contractNo.text = mapObj[keylist.getItemAt(7)] != null ? mapObj[keylist.getItemAt(7)].toString()+"-"+mapObj[keylist.getItemAt(8)].toString() : "";
	        	this.openEndedVal.text = mapObj[keylist.getItemAt(9)] != null ? mapObj[keylist.getItemAt(9)].toString() : "";
	        	
	        	
	        	// for trade Type
	        		var index:int=0;
	        		item = new Object();
	        	var tradeTypeList:ArrayCollection = new ArrayCollection();
	        	tradeTypeList.addItem("");
	        	if(mapObj[keylist.getItemAt(0)]!=null){
		    		if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
		    				tradeTypeList.addItem(item);
				    		if(item == mapObj[keylist.getItemAt(10)].toString()){
				    			index = (mapObj[keylist.getItemAt(0)] as ArrayCollection).getItemIndex(item);
				    		}
				    	}
		    		}else{
		    			tradeTypeList.addItem(mapObj[keylist.getItemAt(0)]);
		    			index = 0;
		    		}
		    	}
		    	this.tradeTypeVal = mapObj[keylist.getItemAt(10)] != null ? mapObj[keylist.getItemAt(10)].toString() : "";
		    	this.tradeType.dataProvider = tradeTypeList;
	        	this.tradeType.selectedIndex = index+1;
	        	this.tradeType.setFocus();
	        	changeSubTradeType();
	        	
	        	// for sub trade Type
	        		index=0;
	        	item = new Object();
	        	var subTradeTypeList:ArrayCollection = sbTypeObj;
	        	if(sbTypeObj!=null){
		    		
		    			for each(item in (sbTypeObj as ArrayCollection)){
		    				//subTradeTypeList.addItem(item);
				    		if(item.value == mapObj[keylist.getItemAt(11)].toString()){
				    			index = (sbTypeObj as ArrayCollection).getItemIndex(item);
				    		}
		    		}
		    	}
		    	this.subTradeType.dataProvider = subTradeTypeList;
	        	this.subTradeType.selectedIndex = index;
	        	
	        	this.brokerAccPopUp.accountNo.text = mapObj[keylist.getItemAt(12)] != null ? mapObj[keylist.getItemAt(12)].toString() : "";
	        	this.rr.salesCode.text = mapObj[keylist.getItemAt(13)] != null ? mapObj[keylist.getItemAt(13)].toString() : "";
	        	this.fundAccountPopup.accountNo.text = mapObj[keylist.getItemAt(14)] != null ? mapObj[keylist.getItemAt(14)].toString() : "";
	        	this.executingRr.salesCode.text = mapObj[keylist.getItemAt(15)] != null ? mapObj[keylist.getItemAt(15)].toString() : "";
	        	this.traderId.salesCode.text = mapObj[keylist.getItemAt(16)] != null ? mapObj[keylist.getItemAt(16)].toString() : "";
	        	this.hairCut.text = mapObj[keylist.getItemAt(17)] != null ? mapObj[keylist.getItemAt(17)].toString() : "";
	        	this.brokerCode.finInstCode.text = mapObj[keylist.getItemAt(18)] != null ? mapObj[keylist.getItemAt(18)].toString() : "";
	        	this.extRefNo.text = mapObj[keylist.getItemAt(19)] != null ? mapObj[keylist.getItemAt(19)].toString() : "";
	        	// for accout balance Type
	        		index=0;
	        		item = new Object();
	        	var accBalTypeList:ArrayCollection = new ArrayCollection();
	        	if(mapObj[keylist.getItemAt(2)]!=null){
		    		if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
		    				accBalTypeList.addItem(item);
				    		if(item.value == mapObj[keylist.getItemAt(20)].toString()){
				    			index = (mapObj[keylist.getItemAt(2)] as ArrayCollection).getItemIndex(item);
				    		}
				    	}
		    		}else{
		    			accBalTypeList.addItem(mapObj[keylist.getItemAt(2)]);
		    			index = 0;
		    		}
		    	}
		    	this.accBalType.dataProvider = accBalTypeList;
	        	this.accBalType.selectedIndex = index;
	        	
	        	this.tradeCurrency.ccyText.text = mapObj[keylist.getItemAt(21)] != null ? mapObj[keylist.getItemAt(21)].toString() : "";
	        	this.settlementCurrency.ccyText.text = mapObj[keylist.getItemAt(22)] != null ? mapObj[keylist.getItemAt(22)].toString() : "";
	        	if(mapObj[keylist.getItemAt(5)]!=null){
		    	  this.tradeDate.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(5)].toString());  		
		    	}
		    	if(mapObj[keylist.getItemAt(6)]!=null){
		    	  this.startDate.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(6)].toString());  		
		    	}
		    	if(mapObj[keylist.getItemAt(23)]!=null){
		    	  this.expirationDate.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(23)].toString());  		
		    	}
		    	if(mapObj[keylist.getItemAt(24)]!=null){
		    	  this.endDate.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(24)].toString());  		
		    	}
	        	
	        	
	        	this.dividendRate.text = mapObj[keylist.getItemAt(25)] != null ? mapObj[keylist.getItemAt(25)].toString() : "";
	        	this.accrualDays.text = mapObj[keylist.getItemAt(26)] != null ? mapObj[keylist.getItemAt(26)].toString() : "";
	        	this.interestRate.text = mapObj[keylist.getItemAt(27)] != null ? mapObj[keylist.getItemAt(27)].toString() : "";
	        	this.interestAmount.text = mapObj[keylist.getItemAt(28)] != null ? mapObj[keylist.getItemAt(28)].toString() : "";
	        	this.commission.text = mapObj[keylist.getItemAt(29)] != null ? mapObj[keylist.getItemAt(29)].toString() : "";
	        	this.netAmount.text = mapObj[keylist.getItemAt(30)] != null ? mapObj[keylist.getItemAt(30)].toString() : "";
	        	
	        	this.subLimit.text = mapObj[keylist.getItemAt(31)] != null ? mapObj[keylist.getItemAt(31)].toString() : "";
	        	this.brokerReferenceNo.text = mapObj[keylist.getItemAt(32)] != null ? mapObj[keylist.getItemAt(32)].toString() : "";
	        	this.remarks.text = mapObj[keylist.getItemAt(33)] != null ? mapObj[keylist.getItemAt(33)].toString() : "";
	        	
	        	// for stl security location
	        		 index=0;
	        		item = new Object();
	        	var stlSecLocList:ArrayCollection = new ArrayCollection();
	        	stlSecLocList.addItem({label:" ",value:" "});
	        	if(mapObj[keylist.getItemAt(3)]!=null){
		    		if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
		    				stlSecLocList.addItem(item);
				    		if(item.value == mapObj[keylist.getItemAt(35)].toString()){
				    			index = (mapObj[keylist.getItemAt(3)] as ArrayCollection).getItemIndex(item);
				    		}
				    	}
		    		}else{
		    			stlSecLocList.addItem(mapObj[keylist.getItemAt(3)]);
		    			index = 0;
		    		}
		    	}
		    	this.stlLocSec.dataProvider = stlSecLocList;
	        	this.stlLocSec.selectedIndex = index+1;
	        	
	        	// for stl security location
	        		index=0;
	        		item = new Object();
	        	var stlCashLocList:ArrayCollection = new ArrayCollection();
	        	stlCashLocList.addItem({label:" ",value:" "});
	        	if(mapObj[keylist.getItemAt(3)]!=null){
		    		if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
		    				stlCashLocList.addItem(item);
				    		if(item.value == mapObj[keylist.getItemAt(36)].toString()){
				    			index = (mapObj[keylist.getItemAt(3)] as ArrayCollection).getItemIndex(item);
				    		}
				    	}
		    		}else{
		    			stlCashLocList.addItem(mapObj[keylist.getItemAt(3)]);
		    			index = 0;
		    		}
		    	}
		    	this.stlLocCash.dataProvider = stlCashLocList;
	        	this.stlLocCash.selectedIndex = index+1;
	        	
	        	
	        //	this.remarks.text = mapObj[keylist.getItemAt(41)] != null ? mapObj[keylist.getItemAt(41)].toString() : "";
	        	
	        	//load security info
	        	
	        	 this.securityList = new ArrayCollection();
				    if(mapObj[keylist.getItemAt(40)] != null){
				    	initcol = (mapObj[keylist.getItemAt(40)]) as ArrayCollection;
				    	if(initcol != null){
				    		try {
			                      for each (var item1:XML in initcol) {
			                          securityList.addItem(item1);
			                      }
			                  }catch(e:Error){
			                      XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.loadingtaxfeelist'));
			                }
				    	}
				    }
				 securityList.refresh();
	        	
	        	
	    		this.subLimit.editable=false;
	    		this.interestAmount.editable=false;
	    		this.openEndedCombLbl.visible=false;
	    		this.openEnded.visible=false;
	    		this.split.visible=false;
	    		this.splitLbl.visible=false;
	    		this.ssiGrid.visible=false;
	    		this.openEndedCombLbl.includeInLayout=false;
	    		this.openEnded.includeInLayout=false;
	    		this.split.includeInLayout=false;
	    		this.splitLbl.includeInLayout=false;
	    		this.ssiGrid.includeInLayout=false;
	    		//changeSubTradeType();
	        } 
	        
	        
	        /**
	        * Method for resetting the security info fields
	        */ 
	        private function resetSecurity():void{
	        	this.securityCode.instrumentId.text = XenosStringUtils.EMPTY_STR;
	        	this.securityPrice.text = XenosStringUtils.EMPTY_STR;
	        	this.securityQuantity.text = XenosStringUtils.EMPTY_STR;
	        	this.securityPrincipalAmount.text = XenosStringUtils.EMPTY_STR;
	        	this.securityInterestAmount.text = XenosStringUtils.EMPTY_STR;
	        	this.securityNetAmount.text = XenosStringUtils.EMPTY_STR;
	        	this.inputFactor.text = XenosStringUtils.EMPTY_STR;
	        	this.securityStartLegRefNo.text = XenosStringUtils.EMPTY_STR;
	        	this.securityEndLegRefNo.text = XenosStringUtils.EMPTY_STR;
	        	this.securityStartSenderRefNo.text = XenosStringUtils.EMPTY_STR;
	        	this.securityEndSenderRefNo.text = XenosStringUtils.EMPTY_STR;
	        } 
	        
	        /**
	        * This method populates the elements of the SLR
	        * Trade Cancel screen(mxml)
	        * from the map obtained from preCancelResultInit() (InitCancel-SEQ-3)
	        */
	         override public function postCancelResultInit(mapObj:Object): void{
	        		
	            commonResultPart(mapObj);
	        	uConfLabel.text=this.parentApplication.xResourceManager.getKeyValue('slr.contract.label.cancelview');
	        	uConfSubmit.includeInLayout = false;
	        	uConfSubmit.visible = false;
	        	cancelSubmit.visible = true;
	        	cancelSubmit.includeInLayout = true;
	        	cancelSubmit.label = this.parentApplication.xResourceManager.getKeyValue('slr.label.cxlcontract');
	        	cxlLastActn.visible = true;
	        	cxlLastActn.includeInLayout = true;
	        	cxlMt.visible = true;
	        	cxlMt.includeInLayout = true;
	        	cxlMt2.visible = false;
	        	cxlMt2.includeInLayout = false;
	        	this.slr01FlagLabel.text = this.parentApplication.xResourceManager.getKeyValue('slr.contract.label.slr01suppressed');
	        	app.submitButtonInstance = cancelSubmit;
	        } 
	        
	         override public function preEntry():void{
			 	setValidator();
			 	super.getSaveHttpService().url = "slr/slrContractEntryDispatch.action?";
			 	var reqObj:Object = new Object();
			 	reqObj = populateRequestParam();
			 	reqObj.method = "submitContract";
			 	reqObj.SCREEN_KEY = "127";
	            super.getSaveHttpService().request = reqObj;
	            super.getSaveHttpService().method = "POST";
			 }
			 
			override public function preEntryResultHandler():Object {
				 addCommonResultKeys() ;
				 return keylist;
			}
			
			private function addCommonResultKeys():void{
	        	keylist = new ArrayCollection();
		    	keylist.addItem("cpCustomerCode");
		    	keylist.addItem("accountNo");
		    	keylist.addItem("cpAccShortName");
		    	keylist.addItem("cpAccSalesCode");
		    	keylist.addItem("brokerCode");
		    	keylist.addItem("brokerName");
		    	keylist.addItem("inventoryAccount");
		    	keylist.addItem("firmAcName");
		    	keylist.addItem("contractNumber");
		    	keylist.addItem("versionNo");
		    	keylist.addItem("openEnded");
		    	keylist.addItem("tradeType");
		    	keylist.addItem("subTradeType");
		    	keylist.addItem("accountNo");
		    	keylist.addItem("rr");
		    	keylist.addItem("inventoryAccount");
		    	keylist.addItem("executingRr");
		    	keylist.addItem("traderId");
		    	keylist.addItem("hairCut");
		    	keylist.addItem("brokerCode");
		    	keylist.addItem("extRefNo");
		    	keylist.addItem("accountBalanceType");
		    	keylist.addItem("tradeCurrency");
		    	keylist.addItem("settlementCurrency");
		    	keylist.addItem("tradeDate");
		    	keylist.addItem("startDate");
		    	keylist.addItem("tradeTime");
		    	keylist.addItem("endDate");
		    	keylist.addItem("expirationDate");
		    	keylist.addItem("accrualDays");
		    	keylist.addItem("dividendRate");
		    	keylist.addItem("interestAmount");
		    	keylist.addItem("interestRate");
		    	keylist.addItem("netAmount");
		    	keylist.addItem("commission");
		    	keylist.addItem("subLimit");
		    	keylist.addItem("brokerReferenceNo");
		    	keylist.addItem("remarks");
		    	keylist.addItem("noSlr01ReqFlag");
		    	keylist.addItem("stlLocSec");
		    	keylist.addItem("stlLocCash");
		    	keylist.addItem("customerPk");
		    	keylist.addItem("accountPk");
		    	keylist.addItem("inventoryAccountPk");
		    	keylist.addItem("securities.security");
		    	keylist.addItem("securitySsi.cashSecurityFlag");
		    	keylist.addItem("securitySsi.acronym");
		    	keylist.addItem("securitySsi.instrumentType");
		    	keylist.addItem("securitySsi.settlementCcy");
		    	keylist.addItem("securitySsi.settlementType");
		    	keylist.addItem("securitySsi.bankName");
		    	keylist.addItem("securitySsi.contraId");
		    	keylist.addItem("securitySsi.dtcParticipantNumber");
		    	keylist.addItem("securitySsi.cpExternalSettleAct");
		    	keylist.addItem("securitySsi.priority");
		    	keylist.addItem("cashSsi.cashSecurityFlag");
		    	keylist.addItem("cashSsi.acronym");
		    	keylist.addItem("cashSsi.instrumentType");
		    	keylist.addItem("cashSsi.settlementCcy");
		    	keylist.addItem("cashSsi.settlementType");
		    	keylist.addItem("cashSsi.bankName");
		    	keylist.addItem("cashSsi.contraId");
		    	keylist.addItem("cashSsi.dtcParticipantNumber");
		    	keylist.addItem("cashSsi.cpExternalSettleAct");
		    	keylist.addItem("cashSsi.priority");
		    	keylist.addItem("contractNumber");
		    	keylist.addItem("paidInterest");
		    	keylist.addItem("netPrincipal");
		    	keylist.addItem("lastActionDate");
		    	keylist.addItem("reasonList.item");
		    	
	        }
			 
			 
			override public function postEntryResultHandler(mapObj:Object):void {
				commonResult(mapObj);
			}
			
			private function commonResult(mapObj:Object):void{
		    	if(mapObj!=null){  
			    	if(mapObj["errorFlag"].toString() == "error"){
			    		errPage.showError(mapObj["errorMsg"]);
			    	}else if(mapObj["errorFlag"].toString() == "noError"){
			    	 errPage.clearError(super.getSaveResultEvent());
			    	 usrConfErrPage.clearError(super.getSaveResultEvent());			    			
		             commonResultPart(mapObj);
					 changeCurrentState();
					 // hide ssi part for amend
					 if(this.mode=='amend'){
					 this.ucSsiGrid.visible=false;
					 this.ucSsiGrid.includeInLayout=false;
					 this.partForCancel.visible=true;
					 this.partForCancel.includeInLayout=true; 
					 }
			    	}else{
			    		errPage.removeError();
			    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			    	}    		
		    	}
	        }
			 
			 
			override public function preEntryConfirm():void {
				var reqObj :Object = new Object();
				super.getConfHttpService().url = "slr/slrContractEntryDispatch.action?";  
				reqObj.method= "commitContract";
				reqObj.rnd = Math.random()+"";
				reqObj.SCREEN_KEY = "128";
	            super.getConfHttpService().request = reqObj;
			}
			
			override public function preEntryConfirmResultHandler():Object{
				addCommonResultKeys();
				return keylist;
			}
			
			override public function postConfirmEntryResultHandler(mapObj:Object):void {
				submitUserConfResult(mapObj);
			}
			
			private function submitUserConfResult(mapObj:Object):void{
		    	if(mapObj!=null){    
			    	if(mapObj["errorFlag"].toString() == "error"){
			    		usrConfErrPage.showError(mapObj["errorMsg"]);
			    		uConfLabel.includeInLayout = true;
		               	uConfLabel.visible = true;
		               	sConfLabel.includeInLayout = false;
		                sConfLabel.visible = false;
						uConfSubmit.includeInLayout = true;
		                uConfSubmit.visible = true;
			    		uConfSubmit.enabled = true;
			    	}else if(mapObj["errorFlag"].toString() == "noError"){
			    	   if(mode!="cancel")
			    		  usrConfErrPage.clearError(super.getConfResultEvent());
			    	   commonResultPart(mapObj);
			    	   this.back.includeInLayout = false;
			    	   this.back.visible = false;
					   uConfSubmit.enabled = true;	
		               uConfLabel.includeInLayout = false;
		               uConfLabel.visible = false;
		               uConfSubmit.includeInLayout = false;
		               uConfSubmit.visible = false;
		               if(mode == 'amend'){
		               	  sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('slr.label.slrtradeamendsysconf');	               	
		               }
		               sConfLabel.includeInLayout = true;
		               sConfLabel.visible = true;
		               sConfSubmit.includeInLayout = true;
		               sConfSubmit.visible = true; 
		               hb.visible = true;
	               	   hb.includeInLayout = true;  
		               app.submitButtonInstance = sConfSubmit;  
		               
		               
		               this.reasonForCancel.visible = false;
			    	   this.reasonForCancel.includeInLayout = false;     
			    	}else{
			    		errPage.removeError();
			    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('slr.label.erroroccured'));
			    	}    		
		    	}
		    }
		    
		    private function submitUserInfoResultForCancel(mapObj:Object):void{
		    	if(mapObj!=null){    
			    	if(mapObj["errorFlag"].toString() == "error"){
			    		usrConfErrPage.showError(mapObj["errorMsg"]);
			    		uConfLabel.text=this.parentApplication.xResourceManager.getKeyValue('slr.contract.label.cancelview');
			    		uConfLabel.includeInLayout = true;
				        uConfLabel.visible = true;
				        this.reasonForCancel.visible = true;
			            this.reasonForCancel.includeInLayout = true;
			            cxlLastActn.visible = true;
			            cxlLastActn.includeInLayout = true;
			            cxlMt.visible = true;
			            cxlMt.includeInLayout = true;
			            cxlMt2.visible = false;
			            cxlMt2.includeInLayout = false;
			            uCancelConfSubmit.visible = false;
	        	        uCancelConfSubmit.includeInLayout = false;
	        	        cancelSubmit.visible = true;
	        	        cancelSubmit.includeInLayout = true;
	        	        cancelSubmit.label = this.parentApplication.xResourceManager.getKeyValue('slr.label.cxlcontract');
	        	        app.submitButtonInstance = cancelSubmit;
	        	        app.submitButtonInstance = cxlLastActn;
	        	        app.submitButtonInstance = cxlMt;
	        	        
			    	}else if(mapObj["errorFlag"].toString() == "noError"){
			    	   if(mode!="cancel")
			    		  usrConfErrPage.clearError(super.getConfResultEvent());
			    	   commonResultPart(mapObj);
			    	   uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('slr.label.slrtradecxlusrconf');
					   uConfLabel.includeInLayout = true;
				       uConfLabel.visible = true;
			    	   this.back.includeInLayout = false;
			    	   this.back.visible = false;
					   uConfSubmit.enabled = true;	
//		               uConfLabel.includeInLayout = false;
//		               uConfLabel.visible = false;
		               uConfSubmit.includeInLayout = false;
		               uConfSubmit.visible = false;
		               uCancelConfSubmit.includeInLayout = true;
		               uCancelConfSubmit.visible = true; 
		               app.submitButtonInstance = uCancelConfSubmit; 
		               actnNo.visible = false;
		               rdSelect.visible = false;
		               
		               
		               this.reasonForCancel.visible = false;
			    	   this.reasonForCancel.includeInLayout = false; 
			    	   cxlLastActn.visible = false;
			           cxlLastActn.includeInLayout = false;
			           cxlMt.visible = false;
			           cxlMt.includeInLayout = false; 
			           cxlMt2.visible = false;
			           cxlMt2.includeInLayout = false;
			           uCancelConfSubmit.visible = true;
	        	       uCancelConfSubmit.includeInLayout = true; 
	        	       cancelSubmit.visible = false;
	        	       cancelSubmit.includeInLayout = false; 
	        	       backCancel.visible = true;
	        	       backCancel.includeInLayout = true;
	        	        
	        	       
	        	       
			    	}else{
			    		errPage.removeError();
			    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('slr.label.erroroccured'));
			    	}    		
		    	}
		    }
		    
		    
		    override public function doEntrySystemConfirm(e:Event):void {
			     super.preEntrySystemConfirm();
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
	           	 vstack.selectedChild = qry;	
				 super.postEntrySystemConfirm();
			}
			 
			 override public function preAmend():void{
			 	setValidator();
			 	super.getSaveHttpService().url = "slr/slrContractEntryAmendDispatch.action?";  
			 	var reqObj:Object = populateRequestParam();
			 	reqObj.method = "submitAmendContract";
			 	reqObj.SCREEN_KEY = 11105;
	            super.getSaveHttpService().request = reqObj;
			 } 
			
			override public function preCancel():void{
			 	super._validator = null;
			 	super.getSaveHttpService().url = "slr/SlrCancelDispatch.action?"; 
			 	var reqObj:Object = new Object();
			 	if(lastAction == true){
			 		usrConfErrPage.clearError(super.getConfResultEvent());
			 		reqObj.method="contractDetailsCancelExecute";
			 		reqObj.cancel="cancelaction";
			 		reqObj.SCREEN_KEY = 11108;
			 	}else if(mtmClose == true){
			 		usrConfErrPage.clearError(super.getConfResultEvent());
			 		reqObj.method="contractDetailsCancelExecute";
			 		reqObj.cancel="cancelmtmcloseout";
			 		reqObj[secCode] = refNo;
			 		reqObj.SCREEN_KEY = 11111;
			 	}else {
			 		usrConfErrPage.clearError(super.getConfResultEvent());
			 	    reqObj.method="contractDetailsCancelExecute";
			 		reqObj.cancel="cancelcontract";
			 		reqObj.SCREEN_KEY = 137;
			 	}
			 	
	            super.getSaveHttpService().request = reqObj;
			 }
			 
			 
			 
			
			override public function preAmendResultHandler():Object
			{
				addCommonResultKeys();
				return keylist;
			} 
			
			
			
			
			
			override public function postAmendResultHandler(mapObj:Object):void
			{
				commonResult(mapObj);
				app.submitButtonInstance = uConfSubmit;
				if(mode == 'amend'){
					uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('slr.label.slrtradeamendusrconf');
				}
			}
			 
			 
			
			
			
			override public function preAmendConfirm():void
			{
				var reqObj :Object = new Object();
				super.getConfHttpService().url = "slr/slrContractEntryAmendDispatch.action?";  
				reqObj.method= "commitAmendContract";
				reqObj.SCREEN_KEY = 11106;
				reqObj.rnd = Math.random()+"";
	            super.getConfHttpService().request = reqObj;
			}
			
			override public function preCancelConfirm():void
			{
				var reqObj :Object = new Object();
				super.getConfHttpService().url = "slr/SlrCancelDispatch.action?";  
				reqObj.method= "cancelPerform";
				if(lastAction == true){
			 		reqObj.SCREEN_KEY = 11109;
			 	}else if(mtmClose == true){
			 		reqObj.SCREEN_KEY = 11112;
			 	}else {
			 		reqObj.SCREEN_KEY = 138;
			 	}				
				//reqObj.SCREEN_KEY = "138";
	            super.getConfHttpService().request = reqObj;
			}
			
			override public function postConfirmAmendResultHandler(mapObj:Object):void
			{
				
				submitUserConfResult(mapObj);
			}
		
		
		override public function postConfirmCancelResultHandler(mapObj:Object):void
			{
				submitUserConfResult(mapObj);
				sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('slr.label.slrtradecxlsysconf');
				//sConfLabel.includeInLayout = true;
				//sConfLabel.visible = true;
	        	cancelSubmit.visible = false;
	        	cancelSubmit.includeInLayout = false;
	        	uCancelConfSubmit.visible = false;
	        	uCancelConfSubmit.includeInLayout = false;
	        	cxlLastActn.visible = false;
	        	cxlLastActn.includeInLayout = false;
	        	cxlMt.visible = false;
	        	cxlMt.includeInLayout = false;
	        	backCancel.visible = false;
	        	backCancel.includeInLayout = false;
	        	//uConfLabel.includeInLayout = false;
				//uConfLabel.visible = false;
			}
	        
	        override public function preResetEntry():void
		   {
		       var rndNo:Number= Math.random();
		  		super.getResetHttpService().url = "slr/slrContractEntryDispatch.action?method=resetForm&rnd=" + rndNo; 
		   }
		    override public function preResetAmend():void
		   {
		       var rndNo:Number= Math.random();
		  		super.getResetHttpService().url = "slr/slrContractEntryAmendDispatch.action?method=resetAmendForm&rnd=" + rndNo;
		  		
		   } 
		   
		   
			/*  */
			
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
	        
	        
	        /**
	        * This method adds the common keys to a list
	        * which will be populated for both entry and amend
	        */
	        private function addCommonKeys():void{        	
		    	keylist = new ArrayCollection();
		    	keylist.addItem("tradeTypeValues.tradeType");
		    	keylist.addItem("subTradeTypeValues.item");
		    	keylist.addItem("accountBalanceTypeValues.item");
		    	keylist.addItem("stlLocationValues.item");
		    	keylist.addItem("settlementCurrency");
		    	keylist.addItem("tradeDate");
		    	keylist.addItem("startDate");
		    	
		    	
	        }
	        
	        private function commonInit(mapObj:Object):void{
	        	hb.visible = false;
	            hb.includeInLayout = false;
	        	/* Populating Trade type drop down*/
	        	initcol = new ArrayCollection();
	        	securityList = new ArrayCollection();
	        	item = new Object();
	        	initcol.addItem(" ");
		    	if(mapObj[keylist.getItemAt(0)]!=null){
		    		if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(0)].toString());
		    		}
		    	}
		    	this.tradeType.dataProvider = initcol;
		    	this.tradeType.selectedIndex = 0;
		    	
		    	/* Populating Sub Trade type drop down*/
	        	initcol = new ArrayCollection();
	        	item = new Object();
	        	initcol.addItem({label:" ",value:" "});
		    	if(mapObj[keylist.getItemAt(1)]!=null){
		    		if(mapObj[keylist.getItemAt(1)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(1)].toString());
		    		}
		    	}
		    	allSBTType = initcol;
		    	this.subTradeType.dataProvider = initcol;
		    	this.subTradeType.selectedIndex = 0;
		    	
		    	this.brokerAccPopUp.accountNo.text = "";
		    	this.rr.salesCode.text = "";
		    	this.fundAccountPopup.accountNo.text = "";
		    	this.executingRr.salesCode.text = "";
		    	this.traderId.salesCode.text = "";
		    	this.hairCut.text = "";
		    	this.brokerCode.finInstCode.text = "";
		    	this.extRefNo.text = "";
		    	
		    	/* Populating Account Balance type drop down*/
	        	initcol = new ArrayCollection();
	        	item = new Object();
		    	if(mapObj[keylist.getItemAt(2)]!=null){
		    		if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(2)].toString());
		    		}
		    	}
		    	this.accBalType.dataProvider = initcol;
		    	this.accBalType.selectedIndex = 0;
		    	
		    	this.tradeCurrency.ccyText.text = "";
		    	if(mapObj[keylist.getItemAt(4)]!=null){
		    	  this.settlementCurrency.ccyText.text = mapObj[keylist.getItemAt(4)]; 		
		    	}
		    	this.tradeTime.text = "";
		    	if(mapObj[keylist.getItemAt(5)]!=null){
		    	  this.tradeDate.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(5)].toString());  		
		    	}
		    	if(mapObj[keylist.getItemAt(6)]!=null){
		    	  this.startDate.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(6)].toString());  		
		    	}
		    	this.expirationDate.selectedDate = null;
		    	this.expirationDate.text = "";
		    	
		    	this.endDate.selectedDate = null;
		    	this.endDate.text = "";
		    	
		    	this.dividendRate.text = "";
		    	this.accrualDays.text = "";
		    	
		    	this.interestRate.text = "";
		    	this.interestAmount.text = "";
		    	
		    	this.commission.text = "";
		    	this.netAmount.text = "";
		    	
		    	this.subLimit.text = "";
		    	/* Populating Open Ended drop down*/
	        	initcol = new ArrayCollection();
		    	if(mapObj[keylist.getItemAt(2)]!=null){
		    		this.initcol.addItem({label:this.parentApplication.xResourceManager.getKeyValue('slr.label.optionno'),value:"N"});
		    		this.initcol.addItem({label:this.parentApplication.xResourceManager.getKeyValue('slr.label.optionyes'),value:"Y"});
		    	}
		    	this.openEnded.dataProvider = initcol;
		    	this.openEnded.selectedIndex = 0;
		    	
		    	this.brokerReferenceNo.text = "";
		    	/* Populating Split drop down*/
	        	initcol = new ArrayCollection();
		    	if(mapObj[keylist.getItemAt(2)]!=null){
		    		this.initcol.addItem({label:this.parentApplication.xResourceManager.getKeyValue('slr.label.optionyes'),value:"Y"});
		    		this.initcol.addItem({label:this.parentApplication.xResourceManager.getKeyValue('slr.label.optionno'),value:"N"});
		    	}
		    	this.split.dataProvider = initcol;
		    	this.split.selectedIndex = 0;
		    	
		    	/* Populating Open Ended drop down*/
	        	initcol = new ArrayCollection();
		    	if(mapObj[keylist.getItemAt(2)]!=null){
		    		this.initcol.addItem({label:this.parentApplication.xResourceManager.getKeyValue('slr.label.optionno'),value:"N"});
		    		this.initcol.addItem({label:this.parentApplication.xResourceManager.getKeyValue('slr.label.optionyes'),value:"Y"});
		    	}
		    	this.slr01Reqd.dataProvider = initcol;
		    	this.slr01Reqd.selectedIndex = 0;
		    	
		    	/* Populating Stl Location for Security drop down*/
	        	initcol = new ArrayCollection();
	        	item = new Object();
	        	initcol.addItem({label:" ",value:" "});
		    	if(mapObj[keylist.getItemAt(3)]!=null){
		    		if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(3)].toString());
		    		}
		    	}
		    	this.stlLocSec.dataProvider = initcol;
		    	
		    	/* Populating Stl Location for Cash drop down*/
	        	initcol = new ArrayCollection();
	        	item = new Object();
	        	initcol.addItem({label:" ",value:" "});
		    	if(mapObj[keylist.getItemAt(3)]!=null){
		    		if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(3)].toString());
		    		}
		    	}
		    	this.stlLocCash.dataProvider = initcol;
		    	stlFor = mapObj[keylist.getItemAt(7)];
		    	deliveryMethod = mapObj[keylist.getItemAt(8)];
	        }
	        
	        
	        
	        
	         private function commonResultPart(mapObj:Object):void{
        		 
	             this.uTradeType.text = mapObj[keylist.getItemAt(11)].toString();
	             this.uSubTradeType.text = mapObj[keylist.getItemAt(12)].toString();
	             this.uAccNo.text = mapObj[keylist.getItemAt(13)].toString();
	             this.uRr.text = mapObj[keylist.getItemAt(14)].toString();
	             this.uFundAccNo.text = mapObj[keylist.getItemAt(15)].toString();
	             this.uExecRr.text = mapObj[keylist.getItemAt(16)].toString();
	             this.uTraderId.text = mapObj[keylist.getItemAt(17)].toString();
	             this.uHairCut.text = mapObj[keylist.getItemAt(18)].toString();
	             this.uBrokerCode.text = mapObj[keylist.getItemAt(19)].toString();
	             this.uExtRefNo.text = mapObj[keylist.getItemAt(20)].toString();
	             //this.uAccBalType.text = mapObj[keylist.getItemAt(21)].toString();
	             this.uTradeCcy.text = mapObj[keylist.getItemAt(22)].toString();
	             this.uStlCcy.text = mapObj[keylist.getItemAt(23)].toString();
	             this.uTradeDate.text = mapObj[keylist.getItemAt(24)].toString();
	             this.uStartDate.text = mapObj[keylist.getItemAt(25)].toString();
	             this.uTradeTime.text = mapObj[keylist.getItemAt(26)].toString();
	             this.uEndDate.text = mapObj[keylist.getItemAt(27)].toString();
	             this.uExpirationDate.text = mapObj[keylist.getItemAt(28)].toString();
	             this.uAccruedDays.text = mapObj[keylist.getItemAt(29)].toString();
	             this.uDividentDate.text = mapObj[keylist.getItemAt(30)].toString();
	             this.uInterestAmt.text = mapObj[keylist.getItemAt(31)].toString();
	             this.uInterestRate.text = mapObj[keylist.getItemAt(32)].toString();
	             this.uNetAmt.text = mapObj[keylist.getItemAt(33)].toString();
	             this.uCommission.text = mapObj[keylist.getItemAt(34)].toString();
	             this.uSubLimit.text = mapObj[keylist.getItemAt(35)].toString();
	             this.uBrokerRefNo.text = mapObj[keylist.getItemAt(36)].toString();
	             this.uRemarks.text = mapObj[keylist.getItemAt(37)].toString();
	             this.uNoSlr01ReqFlag.text = mapObj[keylist.getItemAt(38)].toString();

		         this.securityList = new ArrayCollection();
				    if(mapObj[keylist.getItemAt(44)] != null){
				    	initcol = (mapObj[keylist.getItemAt(44)]) as ArrayCollection;
				    	if(initcol != null){
				    		try {
			                      for each ( var it:XML in initcol) {
			                          securityList.addItem(it);
			                      }
			                  }catch(e:Error){
			                      XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.loadingtaxfeelist'));
			                }
				    	}
				    }
				 securityList.refresh();
				 
				 this.uStlLocSec.text = mapObj[keylist.getItemAt(39)].toString();
	             this.uStlLocCash.text = mapObj[keylist.getItemAt(40)].toString();
	             
	             
	             
	             if(this.mode=='entry')
				 {
				 	//hide fields
				 this.partForCancel.visible=false;
				 this.partForCancel.includeInLayout=false;
	             this.uCashSecFlagSec.text = mapObj[keylist.getItemAt(45)].toString();
	             this.uAcronymSec.text = mapObj[keylist.getItemAt(46)].toString();
	             this.uSecurityTypeSec.text = mapObj[keylist.getItemAt(47)].toString();
	             this.uCcySec.text = mapObj[keylist.getItemAt(48)].toString();
	             this.uStlTypeSec.text = mapObj[keylist.getItemAt(49)].toString();
	             this.uBankNameSec.text = mapObj[keylist.getItemAt(50)].toString();
	             this.uContraIdSec.text = mapObj[keylist.getItemAt(51)].toString();
	             this.uDtcPartNoSec.text = mapObj[keylist.getItemAt(52)].toString();
	             this.uDtcExtStlAccSec.text = mapObj[keylist.getItemAt(53)].toString();
	             this.uPrioritySec.text = mapObj[keylist.getItemAt(54)].toString();
	             this.uCashSecFlagCash.text = mapObj[keylist.getItemAt(55)].toString();
	             this.uAcronymCash.text = mapObj[keylist.getItemAt(56)].toString();
	             this.uSecurityTypeCash.text = mapObj[keylist.getItemAt(57)].toString();
	             this.uCcyCash.text = mapObj[keylist.getItemAt(58)].toString();
	             this.uStlTypeCash.text = mapObj[keylist.getItemAt(59)].toString();
	             this.uBankNameCash.text = mapObj[keylist.getItemAt(60)].toString();
	             this.uContraIdCash.text = mapObj[keylist.getItemAt(61)].toString();
	             this.uDtcPartNoCash.text = mapObj[keylist.getItemAt(62)].toString();
	             this.uDtcExtStlAccCash.text = mapObj[keylist.getItemAt(63)].toString();
	             this.uPriorityCash.text = mapObj[keylist.getItemAt(64)].toString();
				 
				 }
				 conTractRefNo = mapObj[keylist.getItemAt(65)].toString()+"-"+mapObj[keylist.getItemAt(9)].toString();
				 this.uContractNo.text = mapObj[keylist.getItemAt(8)].toString()+"-"+mapObj[keylist.getItemAt(9)].toString();
				 this.openended.text = mapObj[keylist.getItemAt(10)].toString();
				 this.paidInterest.text = mapObj[keylist.getItemAt(66)].toString();
				 this.prinAmnt.text = mapObj[keylist.getItemAt(67)].toString();
				 accountPkStr = mapObj[keylist.getItemAt(42)].toString();
				 invAccountPkStr = mapObj[keylist.getItemAt(43)].toString();
				 this.lastActnDate.text = mapObj[keylist.getItemAt(68)].toString(); 
				 
				 initcol = new ArrayCollection();
		    	 item = new Object();
		    	 initcol.addItem({label:" ", value: " "});
		    	 if(mapObj[keylist.getItemAt(69)]!=null){
		    		if(mapObj[keylist.getItemAt(69)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(69)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(69)].toString());
		    		}
		    	 }
		    	 this.reasonCode.dataProvider = initcol;
				 
	        } 
	        
	        /* 
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
	        } */
	        
	        /* private function commonResult(mapObj:Object):void{
		    	if(mapObj!=null){  
			    	if(mapObj["errorFlag"].toString() == "error"){
			    		errPage.showError(mapObj["errorMsg"]);		    			
			    	}else if(mapObj["errorFlag"].toString() == "noError"){
			    		
			    	 errPage.clearError(super.getSaveResultEvent());			    			
		             commonResultPart(mapObj);
					 changeCurrentState();
			    	 app.submitButtonInstance = uConfSubmit;	
			    	}else{
			    		errPage.removeError();
			    		XenosAlert.info("Data Not Found");
			    	}    		
		    	}
	        } */
        
       
        
    	 private function setValidator():void{
		
		  var validateModel:Object={
                            slrTradeEntry:{
                            	tradeType:this.tradeType.selectedItem != null ? this.tradeType.selectedItem : "",
                            	brokerAccNo:this.brokerAccPopUp.accountNo != null ? this.brokerAccPopUp.accountNo.text : "",
                            	fundAccNo:this.fundAccountPopup.accountNo != null ? this.fundAccountPopup.accountNo.text : "",
                            	tradeDate:this.tradeDate.text,
                            	startDate:this.startDate.text,
                            	endDate:this.endDate.text,
                            	expirationDate:this.expirationDate.text,
                            	securityListSize:this.securityList.length,
                            	interestRate:StringUtil.trim(this.interestRate.text)!= null ? StringUtil.trim(this.interestRate.text) : ""
                            }
                           }; 
	         super._validator = new SlrEntryValidator();
	         super._validator.source = validateModel ;
	         super._validator.property = "slrTradeEntry";
		}  
		 
		/*  override public function preEntryConfirmResultHandler():Object{
			addCommonResultKes();
			return keylist;
		} */
		
		override public function preConfirmAmendResultHandler():Object{
			addCommonResultKeys();
			return keylist;
		}
		
		override public function preCancelResultHandler():Object{
			addCommonResultKeys();
			return keylist;
		}
		
		 override public function preConfirmCancelResultHandler():Object{
			addCommonResultKeys();
			return keylist;
		} 
		
		override public function postCancelResultHandler(mapObj:Object):void
			{
				submitUserInfoResultForCancel(mapObj);
				

	        	app.submitButtonInstance = uCancelConfSubmit;
	        	sConfSubmit.includeInLayout = false;
	        	sConfSubmit.visible = false;
	        	sConfLabel.includeInLayout = false;
	        	sConfLabel.visible = false;
	        	slr01FlagLabel.visible = false;
	        	slr01FlagLabel.includeInLayout = false;
	        	uNoSlr01ReqFlag.visible = false;
	        	uNoSlr01ReqFlag.includeInLayout = false;
	        	actnDtPart.visible = false;
	        	actnDtPart.includeInLayout = false;
	        	
//	        	if(mtmClose == true){
//	        		this.actnNo.visible = false;
//	        	}else{
	        		this.actnNo.visible = false;
	        		this.valdt.visible = true;
	        		this.rateField.visible = true;
	        		this.acrDays.visible = true;
				    this.legType.visible = true;
				    this.actnType.visible = true;
				    this.statusCol.visible = true;
				    this.inputfactor.visible = false;
				    this.startlegextrefno.visible = false;
				    this.endlegextrefno.visible = false;
				    this.startsenderrefno.visible = false;
				    this.endsenderrefno.visible = false;
				    this.cashvaluedate.visible = false;
				    this.ssiInfo.visible = false;
				    this.ssiInfo.includeInLayout = false;
				    this.uNetAmt.visible = false;
				    this.uNetAmt.includeInLayout = false;
				    this.netLabel.visible = false;
				    this.netLabel.includeInLayout = false;
				    this.prinAmnt.visible = true;
				    this.prinAmnt.includeInLayout = true;
				    this.prinLabel.visible = true;
				    this.prinLabel.includeInLayout = true;
	
				    this.secInfo.label = this.parentApplication.xResourceManager.getKeyValue('slr.contract.label.actionhistory');
				    
				    hb.visible = false;
		            hb.includeInLayout = false;
	
//	        	}
	        	
	        	
			}
		
		 
    
   
    
   
	  private function doBack():void{
	  	 app.submitButtonInstance = submit;
	     vstack.selectedChild = qry;
	  }
	  
	  private function doBackForCancel():void{
	  	var reqObj:Object = new Object();
		reqObj.rnd = Math.random()+"";
		reqObj.method = "getCancelPage";
		cancelBack.request = reqObj;
	   	cancelBack.send();
	  	
	  } 
	  
	  private function doCancelLastAction():void{
	  	 lastAction = true;
	  	 mtmClose = false;
	  	 this.dispatchEvent(new Event('cancelEntrySave'))
	  	 
	  }
	  
	   private function doCancelContract():void{
	  	 lastAction = false;
	  	 mtmClose = false;
	  	 this.dispatchEvent(new Event('cancelEntrySave'))
	  	 
	  }
	  
	  private function doMtmCloseOut():void{
	  	var reqObj:Object = new Object();
		reqObj.rnd = Math.random()+"";
		reqObj.method = "cancelMTMCloseout";
		reqObj.cancel = "cancelmtmcloseout";
		reqObj.SCREEN_KEY = 11110;
		cancelMtmCloseOut.request = reqObj;
	   	cancelMtmCloseOut.send();
	  	 
	  }
	  
	  private function doCancelMtmCloseOut():void{
	  	 mtmClose = true;
	  	 lastAction = false;
	  	 this.dispatchEvent(new Event('cancelEntrySave'))
	  	 
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
            actTypeArray[0]="T|B";
            //cpTypeArray[1]="CLIENT";
        myContextList.addItem(new HiddenObject("actType",actTypeArray));    
                  
        var cpTypeArray:Array = new Array(1);
            cpTypeArray[0]="BROKER";
            //cpTypeArray[1]="CLIENT";
        myContextList.addItem(new HiddenObject("actCpType",cpTypeArray));
    
        //passing account status                
        var actStatusArray:Array = new Array(1);
        actStatusArray[0]="OPEN";
        myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
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
	      
	        //passing counter party type                
	        var cpTypeArray:Array = new Array(1);
	            cpTypeArray[0]="INTERNAL";
	            //cpTypeArray[1]="CLIENT";
	        myContextList.addItem(new HiddenObject("invCpTypeContext",cpTypeArray));
	    
	        //passing account status                
	        var actStatusArray:Array = new Array(1);
	        actStatusArray[0]="OPEN";
	        myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
	        return myContextList;
	    }
	    
	    private function doSave():void{
	    	if(uConfSubmit.enabled == true){
	    		this.mode == 'entry' ?  this.dispatchEvent(new Event('entryConf')) :  this.dispatchEvent(new Event('amendEntryConf'));
	    	}
	    	uConfSubmit.enabled = false;
	    }
	    
	    private function addSecurity():void{
	    	var reqSend:Boolean = true;
	    	reqSend = validateOnAddToNewSecurities();
	    	if(reqSend){
	    		var reqObj:Object = new Object();
		    	reqObj = populateRequestParam();
		    	reqObj.rnd = Math.random()+"";
		    	if(this.mode=='entry'){
			    	reqObj.method = "addSecurity";
		    	}
		    	else if(this.mode=='amend'){
		    		addSecurityRequest.url="slr/slrContractEntryAmendDispatch.action?";
		    		reqObj.method = "addSecurityForAmend";
		    	}
		    	addSecurityRequest.request = reqObj;
		    	addSecurityRequest.send();
	    	}
	    }
	    
	    private function validateOnAddToNewSecurities():Boolean {
	    	var validationMessage:String = XenosStringUtils.EMPTY_STR;
	    	if(XenosStringUtils.isBlank(this.securityCode.instrumentId.text)){
	    		validationMessage += this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.seccodeempty')+"\n";
	    	}
	    	if(!(XenosStringUtils.equals(this.subTradeType.selectedItem.value,'NONCASH')
	    	   ||XenosStringUtils.equals(this.subTradeType.selectedItem.value,'LR-COL'))){
	    		
	    		if(!XenosStringUtils.equals(this.subTradeType.selectedItem.value,'CASH')){
	    			if(XenosStringUtils.isBlank(this.securityPrincipalAmount.text)){
	    				if(XenosStringUtils.isBlank(this.securityPrice.text)
	    					|| XenosStringUtils.isBlank(this.securityQuantity.text)){
	    						validationMessage += this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.principalamtoramtandqtyempty')+"\n";
	    					}
	    			}
	    		}
	    	}
	    	
	    	if(XenosStringUtils.equals(this.subTradeType.selectedItem.value,'NONCASH')
	    	   ||XenosStringUtils.equals(this.subTradeType.selectedItem.value,'LR-COL')){
	    		
	    		if(XenosStringUtils.isBlank(this.securityQuantity.text)){
	    			validationMessage += this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.lqtyempty')+"\n";
	    		}
	    	}
	    	
	    	if(XenosStringUtils.equals(this.subTradeType.selectedItem.value,'CASH')){
	    		
	    		if(XenosStringUtils.isBlank(this.securityPrincipalAmount.text)){
	    			validationMessage += this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.principalamtempty')+"\n";
	    		}
	    	}
	    	
	    	if(XenosStringUtils.isBlank(validationMessage)){
	    		return true;
	    	}else{
	    		XenosAlert.error(validationMessage);
	    		return false;
	    	}
	    }
	    
	    private function populateRequestParam():Object{
	    	var reqObj:Object = new Object();
	    	
			reqObj.rnd = Math.random()+"";
			
	    	
	    	reqObj['tradeType'] = this.tradeType.selectedItem != null ? StringUtil.trim(this.tradeType.selectedItem.toString()) : "";
	    	reqObj['subTradeType']  = this.subTradeType.selectedItem != null ? StringUtil.trim(this.subTradeType.selectedItem.value) : "";
	    	reqObj['accountNo']  = this.brokerAccPopUp.accountNo != null ? StringUtil.trim(this.brokerAccPopUp.accountNo.text) : "";
	    	reqObj['rr']  = this.rr.salesCode != null ? StringUtil.trim(this.rr.salesCode.text) : "";
	    	reqObj['inventoryAccount']  = this.fundAccountPopup.accountNo != null ? StringUtil.trim(this.fundAccountPopup.accountNo.text) : "";
	    	reqObj['executingRr']  = this.executingRr.salesCode != null ? StringUtil.trim(this.executingRr.salesCode.text) : "";
	    	reqObj['traderId']  = this.traderId.salesCode != null ? StringUtil.trim(this.traderId.salesCode.text) : "";
	    	reqObj['hairCut']  = StringUtil.trim(this.hairCut.text);
	    	reqObj['brokerCode']  = this.brokerCode.finInstCode != null ? StringUtil.trim(this.brokerCode.finInstCode.text): "";
	    	reqObj['extRefNo']  = StringUtil.trim(this.extRefNo.text);
	    	reqObj['accountBalanceType']  = this.accBalType.selectedItem != null ? StringUtil.trim(this.accBalType.selectedItem.value) : "";
	    	reqObj['tradeCurrency']  = this.tradeCurrency.ccyText != null ? StringUtil.trim(this.tradeCurrency.ccyText.text) : "";
	    	reqObj['settlementCurrency']  = this.settlementCurrency.ccyText != null ? StringUtil.trim(this.settlementCurrency.ccyText.text) : "";
	    	reqObj['tradeDate']  = StringUtil.trim(this.tradeDate.text);
	    	reqObj['tradeTime']  = StringUtil.trim(this.tradeTime.text);
	    	reqObj['startDate']  = StringUtil.trim(this.startDate.text);
	    	reqObj['expirationDate']  = StringUtil.trim(this.expirationDate.text);
	    	reqObj['endDate']  = StringUtil.trim(this.endDate.text);
	    	reqObj['dividendRate']  = StringUtil.trim(this.dividendRate.text);
	    	reqObj['accrualDays']  = StringUtil.trim(this.accrualDays.text);
	    	reqObj['interestRate']  = StringUtil.trim(this.interestRate.text);
	    	reqObj['interestAmount']  = StringUtil.trim(this.interestAmount.text);
	    	reqObj['commission']  = StringUtil.trim(this.commission.text);
	    	reqObj['netAmount']  = StringUtil.trim(this.netAmount.text);
	    	reqObj['subLimit']  = StringUtil.trim(this.subLimit.text);
	    	reqObj['openEnded']  = this.openEnded.selectedItem != null ? StringUtil.trim(this.openEnded.selectedItem.value) : "";
	    	reqObj['brokerReferenceNo']  = StringUtil.trim(this.brokerReferenceNo.text);
	    	reqObj['split']  = this.split.selectedItem != null ? StringUtil.trim(this.split.selectedItem.value) : "";
	    	reqObj['remarks']  = StringUtil.trim(this.remarks.text);
	    	
	    	reqObj['securityCode']  = this.securityCode.instrumentId != null ? StringUtil.trim(this.securityCode.instrumentId.text) : "";
	    	reqObj['price']  = StringUtil.trim(this.securityPrice.text);
	    	reqObj['quantity']  = StringUtil.trim(this.securityQuantity.text);
	    	reqObj['principalAmount']  = StringUtil.trim(this.securityPrincipalAmount.text);
	    	reqObj['secInterest']  = StringUtil.trim(this.securityInterestAmount.text);
	    	reqObj['secNetAmount']  = StringUtil.trim(this.securityNetAmount.text);
	    	reqObj['inputFactor']  = StringUtil.trim(this.inputFactor.text);
	    	reqObj['startLegExtRefNo']  = StringUtil.trim(this.securityStartLegRefNo.text);
	    	reqObj['endLegExtRefNo']  = StringUtil.trim(this.securityEndLegRefNo.text);
	    	reqObj['startSenderRefNo']  = StringUtil.trim(this.securityStartSenderRefNo.text);
	    	reqObj['endSenderRefNo'] = StringUtil.trim(this.securityEndSenderRefNo.text);
	    	reqObj['stlLocSec']  = this.stlLocSec.selectedItem != null ? StringUtil.trim(this.stlLocSec.selectedItem.value) : "";
	    	reqObj['stlLocCash']  = this.stlLocCash.selectedItem != null ? StringUtil.trim(this.stlLocCash.selectedItem.value) : "";
	    	
	    	
	    	if(this.mode=='entry'){
	    	reqObj['securitySsi.cpSsiPk'] = this.cpSecSsiPk.text;
	    	reqObj['securitySsi.cashSecurityFlag'] = StringUtil.trim(this.cashSecFlagSec.text);
	    	reqObj['securitySsi.acronym'] = StringUtil.trim(this.acronymSec.text);
	    	reqObj['securitySsi.instrumentType'] = StringUtil.trim(this.securityTypeSec.text);
	    	reqObj['securitySsi.settlementCcy'] = StringUtil.trim(this.ccySec.text);
	    	reqObj['securitySsi.settlementType'] = StringUtil.trim(this.stlTypeSec.text);
	    	reqObj['securitySsi.bankName'] = StringUtil.trim(this.bankNameSec.text);
	    	reqObj['securitySsi.contraId'] = StringUtil.trim(this.contraIdSec.text);
	    	reqObj['securitySsi.dtcParticipantNumber'] = StringUtil.trim(this.dtcPartNoSec.text);
	    	reqObj['securitySsi.cpExternalSettleAct'] = StringUtil.trim(this.dtcExtStlAccSec.text);
	    	reqObj['securitySsi.priority'] = StringUtil.trim(this.prioritySec.text);
	    	reqObj['securitySsi.status'] = 'NORMAL';
	    	
	    	reqObj['cashSsi.cpSsiPk'] = this.cpCashSsiPk.text;
	    	reqObj['cashSsi.cashSecurityFlag'] = StringUtil.trim(this.cashSecFlagCash.text);
	    	reqObj['cashSsi.acronym'] = StringUtil.trim(this.acronymCash.text);
	    	reqObj['cashSsi.instrumentType'] = StringUtil.trim(this.securityTypeCash.text);
	    	reqObj['cashSsi.settlementCcy'] = StringUtil.trim(this.ccyCash.text);
	    	reqObj['cashSsi.settlementType'] = StringUtil.trim(this.stlTypeCash.text);
	    	reqObj['cashSsi.bankName'] = StringUtil.trim(this.bankNameCash.text);
	    	reqObj['cashSsi.contraId'] = StringUtil.trim(this.contraIdCash.text);
	    	reqObj['cashSsi.dtcParticipantNumber'] = StringUtil.trim(this.dtcPartNoCash.text);
	    	reqObj['cashSsi.cpExternalSettleAct'] = StringUtil.trim(this.dtcExtStlAccCash.text);
	    	reqObj['cashSsi.priority'] = StringUtil.trim(this.priorityCash.text);
	    	reqObj['cashSsi.status'] = 'NORMAL';
	    	}
	    	return reqObj;
	    }
	    
	    
	    
	    private function loadSecurity(event:ResultEvent):void{
	    	if(event != null){
	    		if(event.result != null){
	    			if(event.result.slrContractEntryActionForm != null){
	    				errPage.clearError(super.getInitResultEvent());
	    				securityList = new ArrayCollection();
	    				if(event.result.slrContractEntryActionForm.securities != null){
	    					if(event.result.slrContractEntryActionForm.securities.security != null){
	    						if(event.result.slrContractEntryActionForm.securities.security is ArrayCollection){
	    							securityList = (event.result.slrContractEntryActionForm.securities.security) as ArrayCollection;
	    						}else{
	    							securityList.addItem(event.result.slrContractEntryActionForm.securities.security);
	    						}
	    					}
	    				}
	    				securityList.refresh();
	    				this.securityCode.instrumentId.text = "";
	    				this.securityPrice.text = "";
	    				this.securityQuantity.text = "";
	    				this.securityPrincipalAmount.text = "";
	    				this.securityInterestAmount.text = "";
	    				this.securityNetAmount.text = "";
	    				this.inputFactor.text = "";
	    				this.securityStartLegRefNo.text = "";
	    				this.securityEndLegRefNo.text = "";
	    				this.securityStartSenderRefNo.text = "";
	    				this.securityEndSenderRefNo.text = "";
	    			}else if(event.result.XenosErrors != null){
	    				errPage.clearError(super.getInitResultEvent());
	    				if(event.result.XenosErrors.Errors != null){
							if(event.result.XenosErrors.Errors.error != null){
								var errorInfoList : ArrayCollection = new ArrayCollection();
								if(event.result.XenosErrors.Errors.error is ArrayCollection){
			    					errorInfoList = event.result.XenosErrors.Errors.error as ArrayCollection;
			    				}else{
			    					errorInfoList.addItem(event.result.XenosErrors.Errors.error);
			    				}
							}
						}
						errPage.showError(errorInfoList);
	    			}else{
	    				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    			}
	    		}else{
	    			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    		}
	    	}else{
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}
	    }
	    
	    
	    public function editSecurity(data:Object):void{
			if(this.mode == 'entry'){
				editSecurityRequest.url = 'slr/slrContractEntryDispatch.action?';
				
			}
			else if(this.mode == 'amend'){
				editSecurityRequest.url = 'slr/slrContractEntryAmendDispatch.action?';
			}
			editSecurityRequest.request = populateReqForSecurityEdit(data);
    		editSecurityRequest.send();
		}
		
		private function populateReqForSecurityEdit(data:Object):Object{
	    	var reqObj : Object = new Object();
	    	reqObj.rnd = Math.random()+"";
	    	reqObj.method= "editSecurity";
    		reqObj.rowNo = this.securityList.getItemIndex(data);
    		reqObj.securityCode = data.securityCode;
	    	return reqObj;
	    }
	    
	    private function loadEditedSecurity(event:ResultEvent):void{
	    	if(event != null){
	    		if(event.result != null){
	    			if(event.result.slrContractEntryActionForm != null){
	    				errPage.clearError(super.getInitResultEvent());
	    				securityList = new ArrayCollection();
	    				if(event.result.slrContractEntryActionForm.securities != null){
	    					if(event.result.slrContractEntryActionForm.securities.security != null){
	    						if(event.result.slrContractEntryActionForm.securities.security is ArrayCollection){
	    							securityList = (event.result.slrContractEntryActionForm.securities.security) as ArrayCollection;
	    						}else{
	    							securityList.addItem(event.result.slrContractEntryActionForm.securities.security);
	    						}
	    					}
	    				}
	    				securityList.refresh();
	    				this.securityCode.instrumentId.text = event.result.slrContractEntryActionForm.securityCode;
	    				this.securityPrice.text = event.result.slrContractEntryActionForm.price;
	    				this.securityQuantity.text = event.result.slrContractEntryActionForm.quantity;
	    				this.securityPrincipalAmount.text = event.result.slrContractEntryActionForm.principalAmount;
	    				this.securityInterestAmount.text = event.result.slrContractEntryActionForm.secInterest;
	    				this.securityNetAmount.text = event.result.slrContractEntryActionForm.secNetAmount;
	    				this.inputFactor.text = event.result.slrContractEntryActionForm.inputFactor;
	    				this.securityStartLegRefNo.text = event.result.slrContractEntryActionForm.startLegExtRefNo;
	    				this.securityEndLegRefNo.text = event.result.slrContractEntryActionForm.endLegExtRefNo;
	    				this.securityStartSenderRefNo.text = event.result.slrContractEntryActionForm.startSenderRefNo;
	    				this.securityEndSenderRefNo.text = event.result.slrContractEntryActionForm.endSenderRefNo;
	    			}else if(event.result.XenosErrors != null){
	    				errPage.clearError(super.getInitResultEvent());
	    				if(event.result.XenosErrors.Errors != null){
							if(event.result.XenosErrors.Errors.error != null){
								var errorInfoList : ArrayCollection = new ArrayCollection();
								if(event.result.XenosErrors.Errors.error is ArrayCollection){
			    					errorInfoList = event.result.XenosErrors.Errors.error as ArrayCollection;
			    				}else{
			    					errorInfoList.addItem(event.result.XenosErrors.Errors.error);
			    				}
							}
						}
						errPage.showError(errorInfoList);
	    			}else{
	    				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    			}
	    		}else{
	    			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    		}
	    	}else{
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}
	    }
		
		public function deleteSecurity(data:Object):void{
			if(this.mode == 'entry'){
				deleteSecurityRequest.url = 'slr/slrContractEntryDispatch.action?';
			}
			else if(this.mode == 'amend'){
				deleteSecurityRequest.url = 'slr/slrContractEntryAmendDispatch.action?';
			}
			deleteSecurityRequest.request = populateReqForSecurityDelete(data);
    		deleteSecurityRequest.send();
		}
		
		private function populateReqForSecurityDelete(data:Object):Object{
	    	var reqObj : Object = new Object();
	    	reqObj.rnd = Math.random()+"";
	    	reqObj.method= "deleteSecurity";
    		reqObj.rowNo = this.securityList.getItemIndex(data);
    		reqObj.securityCode = data.securityCode;
	    	return reqObj;
	    }
	    
	    private function loadDeletedSecurity(event:ResultEvent):void{
	    	if(event != null){
	    		if(event.result != null){
	    			if(event.result.slrContractEntryActionForm != null){
	    				errPage.clearError(super.getInitResultEvent());
	    				securityList = new ArrayCollection();
	    				if(event.result.slrContractEntryActionForm.securities != null){
	    					if(event.result.slrContractEntryActionForm.securities.security != null){
	    						if(event.result.slrContractEntryActionForm.securities.security is ArrayCollection){
	    							securityList = (event.result.slrContractEntryActionForm.securities.security) as ArrayCollection;
	    						}else{
	    							securityList.addItem(event.result.slrContractEntryActionForm.securities.security);
	    						}
	    					}
	    				}
	    				securityList.refresh();
	    				this.securityCode.instrumentId.text = "";
	    				this.securityPrice.text = "";
	    				this.securityQuantity.text = "";
	    				this.securityPrincipalAmount.text = "";
	    				this.securityInterestAmount.text = "";
	    				this.securityNetAmount.text = "";
	    				this.inputFactor.text = "";
	    				this.securityStartLegRefNo.text = "";
	    				this.securityEndLegRefNo.text = "";
	    				this.securityStartSenderRefNo.text = "";
	    				this.securityEndSenderRefNo.text = "";
	    			}else if(event.result.XenosErrors != null){
	    				errPage.clearError(super.getInitResultEvent());
	    				if(event.result.XenosErrors.Errors != null){
							if(event.result.XenosErrors.Errors.error != null){
								var errorInfoList : ArrayCollection = new ArrayCollection();
								if(event.result.XenosErrors.Errors.error is ArrayCollection){
			    					errorInfoList = event.result.XenosErrors.Errors.error as ArrayCollection;
			    				}else{
			    					errorInfoList.addItem(event.result.XenosErrors.Errors.error);
			    				}
							}
						}
						errPage.showError(errorInfoList);
	    			}else{
	    				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    			}
	    		}else{
	    			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    		}
	    	}else{
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}
	    }
	    
	    
	    
	    private function calculateAccruedDays():void{
	    	var sendReq:Boolean = true;
	    	var alertStr:String = XenosStringUtils.EMPTY_STR;
	    	if(XenosStringUtils.isBlank(this.startDate.text)){
	    		alertStr += this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.startdatemissing');
	    		sendReq = false;
	    	}
	    	if(XenosStringUtils.isBlank(this.endDate.text)){
	    		alertStr += "\n"+this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.enddatemissing');
	    		sendReq = false;
	    	}
	    	if(alertStr.length > 0){
	    		XenosAlert.error(alertStr);
	    	}
	    	if(sendReq){
	    		var reqObj:Object = new Object();
		    	reqObj = populateRequestParam();
		    	reqObj.method = "calculateAccrualDays";
		    	reqObj.rnd = Math.random()+"";
		    	calculationRequest.request = reqObj;
		    	calculationRequest.send();
	    	}
	    }
	    
	     private function calculateInterestAmount():void{
	    	var sendReq:Boolean = true;
	    	if(commonFieldCheckFailed()){
	    		sendReq = false;
	    	}
	    	if(sendReq){
	    		var reqObj:Object = new Object();
		    	reqObj = populateRequestParam();
		    	reqObj.method = "calculateInterestAmount";
		    	reqObj.rnd = Math.random()+"";
		    	calculationRequest.request = reqObj;
		    	calculationRequest.send();
	    	}
	    }
	    
	    private function calculateNetAmount():void{
	    	var sendReq:Boolean = true;
	    	if(commonFieldCheckFailed()){
	    		sendReq = false;
	    	}
	    	if(sendReq){
	    		var reqObj:Object = new Object();
		    	reqObj = populateRequestParam();
		    	reqObj.method = "calculateNetAmount";
		    	reqObj.rnd = Math.random()+"";
		    	calculationRequest.request = reqObj;
		    	calculationRequest.send();
	    	}
	    }
	    
	    
	    private function loadCalculatedFields(event:ResultEvent):void{
	    	if(event != null){
	    		if(event.result != null){
	    			if(event.result.slrContractEntryActionForm != null){
	    				errPage.clearError(super.getInitResultEvent());
	    				this.accrualDays.text = event.result.slrContractEntryActionForm.accrualDays;
	    				this.interestAmount.text = event.result.slrContractEntryActionForm.interestAmount;
	    				this.netAmount.text = event.result.slrContractEntryActionForm.netAmount;
	    			}else if(event.result.XenosErrors != null){
	    				errPage.clearError(super.getInitResultEvent());
	    				if(event.result.XenosErrors.Errors != null){
							if(event.result.XenosErrors.Errors.error != null){
								var errorInfoList : ArrayCollection = new ArrayCollection();
								if(event.result.XenosErrors.Errors.error is ArrayCollection){
			    					errorInfoList = event.result.XenosErrors.Errors.error as ArrayCollection;
			    				}else{
			    					errorInfoList.addItem(event.result.XenosErrors.Errors.error);
			    				}
							}
						}
						errPage.showError(errorInfoList);
	    			}else{
	    				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    			}
	    		}else{
	    			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    		}
	    	}else{
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}
	    }
	    
	    private function clearSecSsi():void{
		   	var reqObj:Object = new Object();
			reqObj.rnd = Math.random()+"";
			reqObj.method = "clearSsi";
			reqObj.cashSec = "SECURITY";
			resetSecuritySsiRequest.request = reqObj;
		   	resetSecuritySsiRequest.send();
		}
		
		private function loadResetSecuritySsi(event:ResultEvent):void{
		   	cashSecFlagSec.text = "";
	        acronymSec.text = "";
	        securityTypeSec.text = "";
	        ccySec.text = "";
	        stlTypeSec.text = "";
	        bankNameSec.text = "";
	        contraIdSec.text = "";
	        dtcPartNoSec.text = "";
	        dtcExtStlAccSec.text = "";
	        prioritySec.text = "";
	   }
	   private function openSecSsiPopup():void{
	   	var sendReq:Boolean = true;
	   	var errorStr:String = XenosStringUtils.EMPTY_STR;
	   	if(this.tradeType.selectedItem != null){
	   		if(XenosStringUtils.isBlank(this.tradeType.selectedItem.toString())){
		   		errorStr += this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.trdtypereqd')+"\n";
		   	}
	   	}else{
	   		errorStr += this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.trdtypereqd')+"\n";
	   	}
	   	
	   	if(this.brokerAccPopUp.accountNo != null){
	   		if(XenosStringUtils.isBlank(this.brokerAccPopUp.accountNo.text)){
		   		errorStr += this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.accnoreqd')+"\n";
		   	}
	   	}else{
	   		errorStr += this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.accnoreqd')+"\n";
	   	}
	   	
	   	if(XenosStringUtils.isBlank(errorStr)){
	   		sendReq = true;
	   	}else{
	   		sendReq = false;
	   		XenosAlert.error(errorStr);
	   	}
	   	if(sendReq){
	   		selectSecSsi();
	   	}
	   }
	   private function openCashSsiPopup():void{
	   	var sendReq:Boolean = true;
	   	var errorStr:String = XenosStringUtils.EMPTY_STR;
	   	if(this.tradeType.selectedItem != null){
	   		if(XenosStringUtils.isBlank(this.tradeType.selectedItem.toString())){
		   		errorStr += this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.trdtypereqd')+"\n";
		   	}
	   	}else{
	   		errorStr += this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.trdtypereqd')+"\n";
	   	}
	   	
	   	if(this.brokerAccPopUp.accountNo != null){
	   		if(XenosStringUtils.isBlank(this.brokerAccPopUp.accountNo.text)){
		   		errorStr += this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.accnoreqd')+"\n";
		   	}
	   	}else{
	   		errorStr += this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.accnoreqd')+"\n";
	   	}
	   	
	   	if(XenosStringUtils.isBlank(errorStr)){
	   		sendReq = true;
	   	}else{
	   		sendReq = false;
	   		XenosAlert.error(errorStr);
	   	}
	   	if(sendReq){
	   		selectCashSsi();
	   	}
	   }
	   private function selectSecSsi():void{
		   	var ssiRulePopUp:TrdSsiPopup = TrdSsiPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication), TrdSsiPopup , true));
		   	PopUpManager.centerPopUp(ssiRulePopUp);
                
            var recItem:ArrayCollection = new ArrayCollection();
            
            var accountNoArray:Array = new Array(1);
 	   	  	accountNoArray[0]= this.brokerAccPopUp.accountNo.text;
 	   	  	recItem.addItem(new HiddenObject("accountNo",accountNoArray));
 	   	  	
 	   	  	var stlCcyArray:Array = new Array(1);
 	   	  	stlCcyArray[0]= this.settlementCurrency.ccyText.text;
 	   	  	recItem.addItem(new HiddenObject("settlementcurrency",stlCcyArray));
 	   	  	
 	   	  	var subTradeTypeArray:Array = new Array(1);
 	   	  	subTradeTypeArray[0]= this.subTradeType.selectedItem != null ? this.subTradeType.selectedItem.value : "";
 	   	  	recItem.addItem(new HiddenObject("subTradeType",subTradeTypeArray));
 	   	  	
            var tradeTypeArray:Array = new Array(1);
 	   	  	tradeTypeArray[0]= this.tradeType.selectedItem != null ? this.tradeType.selectedItem : "";
 	   	  	recItem.addItem(new HiddenObject("tradeType",tradeTypeArray));
 	   	  	
 	   	  	var secFlagArray:Array = new Array(1);
 	   	  	secFlagArray[0]= "SECURITY";
 	   	  	recItem.addItem(new HiddenObject("secFlag",secFlagArray));
 	   	  	
 	   	  	var moduleArray:Array = new Array(1);
 	   	  	moduleArray[0]= "SLR";
 	   	  	recItem.addItem(new HiddenObject("module",moduleArray));
 	   	  	
 	   	  	var settlementForArray:Array = new Array(1);
 	   	  	settlementForArray[0]= stlFor;
 	   	  	recItem.addItem(new HiddenObject("settlementFor",settlementForArray));
 	   	  	
 	   	  	var deliveryMethodArray:Array = new Array(1);
 	   	  	deliveryMethodArray[0]= deliveryMethod;
 	   	  	recItem.addItem(new HiddenObject("deliveryMethod",deliveryMethodArray));
 	   	  	
 	   	  	var contractPkArray:Array = new Array(1);
 	   	  	contractPkArray[0]= "";
 	   	  	recItem.addItem(new HiddenObject("contractPk",contractPkArray));
 	   	  	
 	   	  	var stlLocSecArray:Array = new Array(1);
 	   	  	stlLocSecArray[0]= "";
 	   	  	recItem.addItem(new HiddenObject("stlLocSec",stlLocSecArray));
 	   	  	
 	   	  	ssiRulePopUp.showCloseButton=true; 		   	  	
	        ssiRulePopUp.owner = this;
	        ssiRulePopUp.receiveCtxItems = recItem;
	        
	        ssiRulePopUp.retCpSecSsiPk = this.cpSecSsiPk;
	        ssiRulePopUp.retSecurityFlag = this.cashSecFlagSec;
	        ssiRulePopUp.retAcronymForSec = this.acronymSec;
	        ssiRulePopUp.retInstrumentTypeForSec = this.securityTypeSec;
	        ssiRulePopUp.retSettlementCcyForSec = this.ccySec;
	        ssiRulePopUp.retSettlementTypeForSec = this.stlTypeSec;
	        ssiRulePopUp.retBankNameForSec = this.bankNameSec;
	        ssiRulePopUp.retContraIdForSec = this.contraIdSec;
	        ssiRulePopUp.retDtcParticipantNumberForSec = this.dtcPartNoSec;
	        ssiRulePopUp.retCpExternalSettleActForSec = this.dtcExtStlAccSec;
	        ssiRulePopUp.retPriorityForSec = this.prioritySec;
	        ssiRulePopUp.retStatusSec = this.statusSec;
	       
	        ssiRulePopUp.initSsiInfoPopup();
	   }
	   
	   
	   private function selectCashSsi():void{
		   	var ssiRulePopUp:TrdSsiPopup = TrdSsiPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication), TrdSsiPopup , true));
		   	PopUpManager.centerPopUp(ssiRulePopUp);
                
            var recItem:ArrayCollection = new ArrayCollection();
            
            var accountNoArray:Array = new Array(1);
 	   	  	accountNoArray[0]= this.brokerAccPopUp.accountNo.text;
 	   	  	recItem.addItem(new HiddenObject("accountNo",accountNoArray));
 	   	  	
 	   	  	var stlCcyArray:Array = new Array(1);
 	   	  	stlCcyArray[0]= this.settlementCurrency.ccyText.text;
 	   	  	recItem.addItem(new HiddenObject("settlementcurrency",stlCcyArray));
 	   	  	
 	   	  	var subTradeTypeArray:Array = new Array(1);
 	   	  	subTradeTypeArray[0]= this.subTradeType.selectedItem != null ? this.subTradeType.selectedItem.value : "";
 	   	  	recItem.addItem(new HiddenObject("subTradeType",subTradeTypeArray));
 	   	  	
            var tradeTypeArray:Array = new Array(1);
 	   	  	tradeTypeArray[0]= this.tradeType.selectedItem != null ? this.tradeType.selectedItem.toString() : "";
 	   	  	recItem.addItem(new HiddenObject("tradeType",tradeTypeArray));
 	   	  	
 	   	  	var secFlagArray:Array = new Array(1);
 	   	  	secFlagArray[0]= "CASH";
 	   	  	recItem.addItem(new HiddenObject("cashFlag",secFlagArray));
 	   	  	
 	   	  	var moduleArray:Array = new Array(1);
 	   	  	moduleArray[0]= "SLR";
 	   	  	recItem.addItem(new HiddenObject("module",moduleArray));
 	   	  	
 	   	  	var settlementForArray:Array = new Array(1);
 	   	  	settlementForArray[0]= stlFor;
 	   	  	recItem.addItem(new HiddenObject("settlementFor",settlementForArray));
 	   	  	
 	   	  	var deliveryMethodArray:Array = new Array(1);
 	   	  	deliveryMethodArray[0]= deliveryMethod;
 	   	  	recItem.addItem(new HiddenObject("deliveryMethod",deliveryMethodArray));
 	   	  	
 	   	  	var contractPkArray:Array = new Array(1);
 	   	  	contractPkArray[0]= "";
 	   	  	recItem.addItem(new HiddenObject("contractPk",contractPkArray));
 	   	  	
 	   	  	var stlLocSecArray:Array = new Array(1);
 	   	  	stlLocSecArray[0]= "";
 	   	  	recItem.addItem(new HiddenObject("stlLocSec",stlLocSecArray));
 	   	  	
 	   	  	ssiRulePopUp.showCloseButton=true; 		   	  	
	        ssiRulePopUp.owner = this;
	        ssiRulePopUp.receiveCtxItems = recItem;
	        
	        ssiRulePopUp.retCpSecSsiPk = this.cpCashSsiPk;
	        ssiRulePopUp.retCashFlag = this.cashSecFlagCash;
	        ssiRulePopUp.retAcronymForCash = this.acronymCash;
	        ssiRulePopUp.retInstrumentTypeForCash = this.securityTypeCash;
	        ssiRulePopUp.retSettlementCcyForCash = this.ccyCash;
	        ssiRulePopUp.retSettlementTypeForCash = this.stlTypeCash;
	        ssiRulePopUp.retBankNameForCash = this.bankNameCash;
	        ssiRulePopUp.retContraIdForCash = this.contraIdCash;
	        ssiRulePopUp.retDtcParticipantNumberForCash = this.dtcPartNoCash;
	        ssiRulePopUp.retCpExternalSettleActForCash = this.dtcExtStlAccCash;
	        ssiRulePopUp.retPriorityForCash = this.priorityCash;
	        ssiRulePopUp.retStatusCash = this.statusCash;
	       
	        ssiRulePopUp.initSsiInfoPopup();
	   }
	   
	   private function clearCashSsi():void{
		   	var reqObj:Object = new Object();
			reqObj.rnd = Math.random()+"";
			reqObj.method = "clearSsi";
			reqObj.cashSec = "CASH";
			resetCashSsiRequest.request = reqObj;
		   	resetCashSsiRequest.send();
	   }
	   
	   private function loadResetCashSsi(event:ResultEvent):void{
	   		cashSecFlagCash.text = "";
	        acronymCash.text = "";
	        securityTypeCash.text = "";
	        ccyCash.text = "";
	        stlTypeCash.text = "";
	        bankNameCash.text = "";
	        contraIdCash.text = "";
	        dtcPartNoCash.text = "";
	        dtcExtStlAccCash.text = "";
	        priorityCash.text = "";
	   }
	    
	    private function commonFieldCheckFailed():Boolean{
	    	//var checkFailed:Boolean = false;
	    	//var alertStr:String = XenosStringUtils.EMPTY_STR;
	    	if(XenosStringUtils.isBlank(this.startDate.text)){
	    		//alertStr += "Start Date is missing";
	    		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.startdatemissing'));
	    		return true;
	    	}else if(XenosStringUtils.isBlank(this.endDate.text)){
	    		//alertStr += "\nEnd Date is missing";
	    		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.enddatemissing'));
	    		return true;
	    	}else if(XenosStringUtils.isBlank(this.interestRate.text)) {
	    		//alertStr += "\nPlease enter Interest Rate";
		        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.intratereqd'));
		        return true;
		    }else if(XenosStringUtils.isBlank(this.tradeType.selectedItem.toString())) {
		    	//alertStr += "Please enter Trade Type";
		        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.entertrdtype'));
		        return true;
		    }else if(XenosStringUtils.equals(tradeType.selectedItem.toString(),"SB") 
		    	||  XenosStringUtils.equals(tradeType.selectedItem.toString(),"SL")) {
		    	//alertStr += "\nCalculation is not Valid for Trade Type SB/SL";
		        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.calctypenotvallidforsbsl'));
		        return true;
		    }else if(this.securityList.length == 0) {
	    		//alertStr += "\nPlease add atleast one Security";
		        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.enteratleastonesec'));
		        return true;
		    }  
		   /*  if(alertStr.length > 0){
		    	XenosAlert.error(alertStr);
		    } */ 
	    	
	    	return false;
	    }
	    
	    private function changeSubTradeType():void{
			sbTypeObj = new ArrayCollection();
			if(this.tradeType.selectedItem != null){
				if(XenosStringUtils.isBlank(StringUtil.trim(this.tradeType.selectedItem.toString()))){
					sbTypeObj = allSBTType;	
				}else if(XenosStringUtils.equals(StringUtil.trim(this.tradeType.selectedItem.toString()),"RP") || 
						XenosStringUtils.equals(StringUtil.trim(this.tradeType.selectedItem.toString()),"RV")){
					sbTypeObj = subTypeForRPRV;
				}else if(XenosStringUtils.equals(StringUtil.trim(this.tradeType.selectedItem.toString()),"SB")){
					sbTypeObj = subTypeForSB;
				}else if(XenosStringUtils.equals(StringUtil.trim(this.tradeType.selectedItem.toString()),"SL")){
					sbTypeObj = subTypeForSL;
				}else{
					sbTypeObj = subTypeForBBBL;
				}
			}else if(!XenosStringUtils.isBlank(tradeTypeVal)){
				if(XenosStringUtils.equals(tradeTypeVal,"RP") || 
						XenosStringUtils.equals(tradeTypeVal,"RV")){
					sbTypeObj = subTypeForRPRV;
				}else if(XenosStringUtils.equals(tradeTypeVal,"SB")){
					sbTypeObj = subTypeForSB;
				}else if(XenosStringUtils.equals(tradeTypeVal,"SL")){
					sbTypeObj = subTypeForSL;
				}else{
					sbTypeObj = subTypeForBBBL;
				}
			}
			this.subTradeType.dataProvider = sbTypeObj;
			this.subTradeType.selectedIndex = 0;
		}
		
		private function changeSublimit():void{
			if((this.tradeType.selectedItem == 'RP') || (this.tradeType.selectedItem == 'RV')) {
		        subLimit.editable = true;
		    }else if((this.tradeType.selectedItem == 'BB') || 
		    (this.tradeType.selectedItem == 'BL') || 
		    (this.tradeType.selectedItem == 'SB') || 
		    (this.tradeType.selectedItem == 'SL')) {
		        subLimit.text = "";
		        subLimit.editable = false;
		    }else {
		        subLimit.editable = true;
		    }
		}
		
		private function resetSsiInfo():void{
			if(!XenosStringUtils.equals(this.mode,"amend")){
				cashSecFlagSec.text = "";
		        acronymSec.text = "";
		        securityTypeSec.text = "";
		        ccySec.text = "";
		        stlTypeSec.text = "";
		        bankNameSec.text = "";
		        contraIdSec.text = "";
		        dtcPartNoSec.text = "";
		        dtcExtStlAccSec.text = "";
		        prioritySec.text = "";
		
		        cashSecFlagCash.text = "";
		        acronymCash.text = "";
		        securityTypeCash.text = "";
		        ccyCash.text = "";
		        stlTypeCash.text = "";
		        bankNameCash.text = "";
		        contraIdCash.text = "";
		        dtcPartNoCash.text = "";
		        dtcExtStlAccCash.text = "";
		        priorityCash.text = "";
			}
		}
		
		private function changeSettlementCCY():void {
			var defaultVal:String = XenosStringUtils.EMPTY_STR;
		    if(!XenosStringUtils.isBlank(settlementCurrency.ccyText.text)) {
		        defaultVal = settlementCurrency.ccyText.text;
		    }
		    if(subTradeType.selectedItem.value == "NONCASH" || subTradeType.selectedItem.value == "LR-COL") {
		        defaultVal = settlementCurrency.ccyText.text;
		        settlementCurrency.ccyText.text = "";
		        settlementCurrency.visible = false;
		        settlementCurrency.includeInLayout = false;
		    }
		    else {
		        settlementCurrency.ccyText.text = defaultVal;
		        settlementCurrency.visible = true;
		        settlementCurrency.includeInLayout = true;
		    }
		}
		
		private function disableTradeDate():void{
			if(subTradeType.selectedItem.value == 'LR-COL') {
		        tradeDate.enabled = false;
		        startDate.enabled = false;
		    } else {
		        tradeDate.enabled = true;
		        startDate.enabled = true;
			}
		}
		
		private function showNoSlr01ReqFlagField():void {
		    var openEndedFlag:String = openEnded.selectedItem.value;
			if(XenosStringUtils.equals(openEndedFlag,'N')){
				slr01ReqdRow.visible = false;
				slr01ReqdRow.includeInLayout = false;
			} else {
				slr01ReqdRow.visible = true;
				slr01ReqdRow.includeInLayout = true;
			}
		}
		
		private function changeExpirationDate():void {
		    if(this.tradeType.selectedItem == 'RP' 
		    || this.tradeType.selectedItem == 'RV' 
		    || this.tradeType.selectedItem == 'BB' 
		    || this.tradeType.selectedItem == 'BL') {
		    	expirationDate.selectedDate = null;
		    	expirationDate.text = ""
		    	expirationDate.visible = false;
		    	expirationDate.includeInLayout = false;
		    } else {
		    	expirationDate.visible = true;
		    	expirationDate.includeInLayout = true;
		    }
		}
		
		public function populateSubTradeType():void {
	       	allSBTType.addItem({label:" ",value:" "});
	       	allSBTType.addItem({label:"GC",value:"GC"});
	       	allSBTType.addItem({label:"GCF",value:"GCF"});
	       	allSBTType.addItem({label:"TP",value:"TP"});
	       	allSBTType.addItem({label:"HIC",value:"HIC"});
	       	allSBTType.addItem({label:"FWD",value:"FWD"});
	       	allSBTType.addItem({label:"NONCASH",value:"NONCASH"});
	       	allSBTType.addItem({label:"CASH",value:"CASH"});
	       	allSBTType.addItem({label:"LR-CASH",value:"LR-CASH"});
	       	allSBTType.addItem({label:"LR-COL",value:"LR-COL"});
	       	
	       	subTypeForRPRV.addItem({label:" ",value:" "});
	       	subTypeForRPRV.addItem({label:"GC",value:"GC"});
	       	subTypeForRPRV.addItem({label:"GCF",value:"GCF"});
	       	subTypeForRPRV.addItem({label:"TP",value:"TP"});
	       	subTypeForRPRV.addItem({label:"HIC",value:"HIC"});
	       	subTypeForRPRV.addItem({label:"FWD",value:"FWD"});
	       	subTypeForRPRV.addItem({label:"NONCASH",value:"NONCASH"});
	       	subTypeForRPRV.addItem({label:"CASH",value:"CASH"});
	       	subTypeForRPRV.addItem({label:"LR-CASH",value:"LR-CASH"});
	       	subTypeForRPRV.addItem({label:"LR-COL",value:"LR-COL"});
	       	
	       	subTypeForBBBL.addItem({label:" ",value:" "});
	       	subTypeForBBBL.addItem({label:"TP",value:"TP"});
	       	subTypeForBBBL.addItem({label:"FWD",value:"FWD"});
	       	subTypeForBBBL.addItem({label:"NONCASH",value:"NONCASH"});
	       	subTypeForBBBL.addItem({label:"CASH",value:"CASH"});
	       	subTypeForBBBL.addItem({label:"LR-CASH",value:"LR-CASH"});
	       	subTypeForBBBL.addItem({label:"LR-COL",value:"LR-COL"});
	       	
	       	subTypeForSB.addItem({label:" ",value:" "});
	       	subTypeForSB.addItem({label:"NONCASH",value:"NONCASH"});
	       	subTypeForSB.addItem({label:"CASH",value:"CASH"});
	       	
	       	subTypeForSL.addItem({label:" ",value:" "});
	       	subTypeForSL.addItem({label:"NONCASH",value:"NONCASH"});
	       	subTypeForSL.addItem({label:"CASH",value:"CASH"});
	       	subTypeForSL.addItem({label:"TP",value:"TP"});
       	
       }
       
       
      /**
       * result handler for mtm closeout page
       */
       private function loadCancelMtmResult(event:ResultEvent):void{
	    	if(event != null){
	    		queryResult = XML(event.result);
	    		if(queryResult.child("Errors").length()<=0){
	    			usrConfErrPage.clearError(super.getInitResultEvent());
	    			if(queryResult.child("securities").security.length()>0){
	    				securityList.removeAll();
	    				try {
		                    for each ( var rec:XML in queryResult.securities.security ) {
		                        securityList.addItem(rec);
		                    }
		                    
		                    //replace null objects in datagrid with empty string
		                    securityList=ProcessResultUtil.process(securityList,securitySummaryConf.columns);
		                    securityList.refresh();
		                }catch(e:Error){
		                    //XenosAlert.error(e.toString() + e.message);
		                    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		                }
			    			}

	    				securityList.refresh();
	    				this.uContractNo.text = queryResult.contractNumber;
	    				this.openended.text = queryResult.openEnded;
	    				this.uTradeType.text = queryResult.tradeType;
	    				this.uSubTradeType.text = queryResult.subTradeType;
	    				this.uAccNo.text = queryResult.accountNo;
	    				this.uRr.text = queryResult.rr;
	    				this.uFundAccNo.text = queryResult.inventoryAccount;
	    				this.uExecRr.text = queryResult.executingRr;
	    				this.uTraderId.text = queryResult.traderId;
	    				this.uHairCut.text = queryResult.hairCut;
	    				this.uBrokerCode.text = queryResult.brokerCode;
	    				this.uExtRefNo.text = queryResult.extRefNo;
	    				//this.uAccBalType.text = queryResult.accountBalanceType;
	    				this.uTradeCcy.text = queryResult.tradeCurrency;
	    				this.uStlCcy.text = queryResult.settlementCurrency;
	    				this.uTradeDate.text = queryResult.tradeDate;
	    				this.uStartDate.text = queryResult.startDate;
	    				this.uTradeTime.text = queryResult.tradeTime;
	    				
	    				
	    				this.uEndDate.text = queryResult.endDate;
	    				this.uExpirationDate.text = queryResult.expirationDate;
	    				this.uAccruedDays.text = queryResult.accrualDays;
	    				this.uDividentDate.text = queryResult.dividendRate;
	    				this.uInterestAmt.text = queryResult.interestAmount;
	    				this.uInterestRate.text = queryResult.interestRate;
	    				this.prinAmnt.text = queryResult.netPrincipal;
//	    				XenosAlert.info("prinAmnt ::"+queryResult.netPrincipal);
	    				this.uCommission.text = queryResult.commission;
	    				this.uSubLimit.text = queryResult.subLimit;
	    				this.uBrokerRefNo.text = queryResult.brokerReferenceNo;
	    				this.paidInterest.text = queryResult.paidInterest;
	    				this.uRemarks.text = queryResult.remarks;
	    				this.uNoSlr01ReqFlag.text = queryResult.noSlr01ReqFlag;
	    				this.lastActnDate.text = queryResult.lastActionDate;
	    				this.slr01FlagLabel.text = this.parentApplication.xResourceManager.getKeyValue('slr.contract.label.slr01suppressed');
	    				this.paidLabel.visible = true;
	    				this.paidLabel.includeInLayout = true;
	    				this.paidValue.visible = true;
	    				this.paidValue.includeInLayout = true;
	    				
	    				cxlMt.visible = false;
			        	cxlMt.includeInLayout = false;
			        	cxlMt2.visible = true;
			        	cxlMt2.includeInLayout = true;
			        	cxlLastActn.visible = false;
			        	cxlLastActn.includeInLayout = false;
			        	cancelSubmit.visible = false;
			        	cancelSubmit.includeInLayout = false;
			        	
			        	uConfLabel.text=this.parentApplication.xResourceManager.getKeyValue('slr.contract.label.mtmcloseoutcancelview');
	        	       	rdSelect.visible = true;
	        	       	backCancel.visible = true;
	        	        backCancel.includeInLayout = true;
	    				
	    				
	    			}else if(queryResult.child("Errors").length()>=0){
	    				
	    				var errorInfoList : ArrayCollection = new ArrayCollection();
		                //populate the error info list              
		                for each ( var error:XML in queryResult.Errors.error ) {
		                   errorInfoList.addItem(error.toString());
		                }
		                usrConfErrPage.showError(errorInfoList);//Display the error
	    				this.actions=new XMLListCollection(queryResult.securities.security);                    
                        //securityList =  this.actions;
                        securitySummaryConf.dataProvider = this.actions;

	    			}else{
	    				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    			}
	    	}else{
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}
	    }
	    
	    
	  /**
       * result handler for cancel back page
       */
       private function loadCancelBackResult(event:ResultEvent):void{
	    	if(event != null){
	    		queryResult = XML(event.result);
	    		if(queryResult.child("Errors").length()<=0){
	    			usrConfErrPage.clearError(super.getInitResultEvent());
	    			if(queryResult.child("securities").security.length()>0){
	    				securityList.removeAll();
	    				try {
		                    for each ( var rec:XML in queryResult.securities.security ) {
		                        securityList.addItem(rec);
		                    }
		                    
		                    //replace null objects in datagrid with empty string
		                    securityList=ProcessResultUtil.process(securityList,securitySummaryConf.columns);
		                    securityList.refresh();
		                }catch(e:Error){
		                    //XenosAlert.error(e.toString() + e.message);
		                    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		                }
			    			}

	    				securityList.refresh();
	    				this.uContractNo.text = queryResult.contractNumber;
	    				this.openended.text = queryResult.openEnded;
	    				this.uTradeType.text = queryResult.tradeType;
	    				this.uSubTradeType.text = queryResult.subTradeType;
	    				this.uAccNo.text = queryResult.accountNo;
	    				this.uRr.text = queryResult.rr;
	    				this.uFundAccNo.text = queryResult.inventoryAccount;
	    				this.uExecRr.text = queryResult.executingRr;
	    				this.uTraderId.text = queryResult.traderId;
	    				this.uHairCut.text = queryResult.hairCut;
	    				this.uBrokerCode.text = queryResult.brokerCode;
	    				this.uExtRefNo.text = queryResult.extRefNo;
	    				//this.uAccBalType.text = queryResult.accountBalanceType;
	    				this.uTradeCcy.text = queryResult.tradeCurrency;
	    				this.uStlCcy.text = queryResult.settlementCurrency;
	    				this.uTradeDate.text = queryResult.tradeDate;
	    				this.uStartDate.text = queryResult.startDate;
	    				this.uTradeTime.text = queryResult.tradeTime;
	    				
	    				
	    				this.uEndDate.text = queryResult.endDate;
	    				this.uExpirationDate.text = queryResult.expirationDate;
	    				this.uAccruedDays.text = queryResult.accrualDays;
	    				this.uDividentDate.text = queryResult.dividendRate;
	    				this.uInterestAmt.text = queryResult.interestAmount;
	    				this.uInterestRate.text = queryResult.interestRate;
	    				this.prinAmnt.text = queryResult.netPrincipal;
	    				this.uCommission.text = queryResult.commission;
	    				this.uSubLimit.text = queryResult.subLimit;
	    				this.uBrokerRefNo.text = queryResult.brokerReferenceNo;
	    				this.paidInterest.text = queryResult.paidInterest;
	    				this.uRemarks.text = queryResult.remarks;
	    				this.uNoSlr01ReqFlag.text = queryResult.noSlr01ReqFlag;
	    				this.lastActnDate.text = queryResult.lastActionDate;
	    				
	    				this.paidLabel.visible = true;
	    				this.paidLabel.includeInLayout = true;
	    				this.paidValue.visible = true;
	    				this.paidValue.includeInLayout = true;
	    				
//	    				cxlMt.visible = false;
//			        	cxlMt.includeInLayout = false;
//			        	cxlMt2.visible = true;
//			        	cxlMt2.includeInLayout = true;
//			        	uConfLabel.text="Contract Details View for Cancel MTM/Closeout";
//	        	       	rdSelect.visible = true;

					  	usrConfErrPage.clearError(super.getConfResultEvent());
					  	uConfLabel.text=this.parentApplication.xResourceManager.getKeyValue('slr.contract.label.cancelview');
					  	uConfLabel.includeInLayout = true;
				        uConfLabel.visible = true;
				        this.reasonForCancel.visible = true;
				        this.reasonForCancel.includeInLayout = true;
				        cxlLastActn.visible = true;
				        cxlLastActn.includeInLayout = true;
				        cxlMt.visible = true;
				        cxlMt.includeInLayout = true;
				        cxlMt2.visible = false;
				        cxlMt2.includeInLayout = false;
				        uCancelConfSubmit.visible = false;
				        uCancelConfSubmit.includeInLayout = false;
				        cancelSubmit.visible = true;
				        cancelSubmit.includeInLayout = true;
				        
				        cancelSubmit.label = this.parentApplication.xResourceManager.getKeyValue('slr.label.cxlcontract');
				        app.submitButtonInstance = cancelSubmit;
				        app.submitButtonInstance = cxlLastActn;
				        app.submitButtonInstance = cxlMt;
				        
				        this.actnNo.visible = true;
		        		this.valdt.visible = false;
		        		this.rateField.visible = false;
		        		this.acrDays.visible = false;
				        rdSelect.visible = false;
				        backCancel.visible = false;
				        backCancel.includeInLayout = false;
				        
					    				
	    				
	    			}else if(queryResult.child("Errors").length()>=0){
	    				
	    				var errorInfoList : ArrayCollection = new ArrayCollection();
		                //populate the error info list              
		                for each ( var error:XML in queryResult.Errors.error ) {
		                   errorInfoList.addItem(error.toString());
		                }
		                usrConfErrPage.showError(errorInfoList);//Display the error
	    				this.actions=new XMLListCollection(queryResult.securities.security);                    
                        securitySummaryConf.dataProvider = this.actions;

	    			}else{
	    				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    			}
	    	}else{
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}
	    }
	    
	    public function selectAction(data:Object):void{
	    	//XenosAlert.info("data.selected :: " + data.radioSelect);
	    	secCode = data.securityCode;
	    	refNo = data.refNo;
	    	
		}
	    
	    
	    private function validateTime(timeStr:String):String {
	    	var timeVal:String = StringUtil.trim(timeStr);
			var hh:String = "";
			var mm:String = "";
			var ss:String = "";
			var m:Number = 0;
			var s:Number = 0;
			
	    	if(timeVal.length == 0){
				return "";
	    	}else if (timeVal.length == 8){
	    		m = 3;
   				s = 6;
   				if ((timeVal.charAt(2) != ":") || (timeVal.charAt(5) != ":") || (!(int(timeVal)==0))){ 
   					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.8charhhmmss'));
			     	return "";
			    }
  			}else if (timeVal.length == 6){ 
  				m = 2;
			    s = 4;
			    if (int(timeVal)==0){ 
			    	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.6charhhmmss'));
			     	return "";
			    }
			  }else if (timeVal.length == 5){
				  m = 3;
			      if (timeVal.charAt(2) != ":"){ 
			   	   XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.5charhhmmss'));
			       return "";
			      }
			  }else if (timeVal.length == 4){ 
			  	m = 2;
   				if (int(timeVal)==0){ 
   					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.4charhhmmss'));
     				return "";
    		    }
              }else { 
			   XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.timeformat'));
			   return "";
			  }
			  
			  //------hours validation------------
			 var strHH:String = timeVal.charAt(0) + timeVal.charAt(1);
			 if (int(strHH)==0)
			  { XenosAlert.error (this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.hhnonnumeric'));
			   return "";
			  }
			 var numHH:Number = parseInt(strHH);
			 if (numHH > 23)
			  { XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.hhlessthan24'));
			   return "";
			  }
			
			 //------minutes validation------------
			 var strMM:String = timeVal.charAt(m) + timeVal.charAt(m+1);
			 if (int(strMM)==0)
			  { XenosAlert.error (this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.mmnonnumeric'));
			   return "";
			  }
			 var numMM:Number = parseInt(strMM);
			 if (numMM > 59)
			  { XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.mmlessthan60'));
			   return "";
			  }
			
			 //------seconds validation------------
			 var strSS:String = '00';
			 if ((timeVal.length == 8) || (timeVal.length == 6)){ 
			 	strSS = timeVal.charAt(s) + timeVal.charAt(s+1);
			   if (int(strSS)==0){ 
			   		XenosAlert.error (this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.ssnonnumeric'));
			        return "";
			   }
			   var numSS:Number = parseInt(strSS);
			   if (numSS > 59){ 
			   		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.sslessthan60'));
			     	return "";
			   }
			  }else 
			  	strSS = "00";
			  	
			  timeVal = strHH + ":" + strMM + ":" + strSS;
	    	  return timeVal;	
	    }
	   