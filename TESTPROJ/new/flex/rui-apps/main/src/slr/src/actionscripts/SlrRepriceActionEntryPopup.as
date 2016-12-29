		// ActionScript file for BkgTradeEntryModule
		import com.nri.rui.core.Globals;
		import com.nri.rui.core.controls.XenosAlert;
		import com.nri.rui.core.controls.XenosEntry;
		import com.nri.rui.core.startup.XenosApplication;
		import com.nri.rui.core.utils.DateUtils;
		import com.nri.rui.core.utils.XenosStringUtils;
		
		import flash.events.Event;
		
		import mx.collections.ArrayCollection;
		import mx.events.CloseEvent;
		import mx.rpc.events.ResultEvent;
		import mx.utils.StringUtil;
					
			  
		     [Bindable]
		     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     
            [Bindable]private var mode : String = "entry";
            [Bindable]private var lastAction : Boolean = false;
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
	        [Bindable]private var conTractRefNo:String = XenosStringUtils.EMPTY_STR;
	        [Bindable]private var accountPkStr:String = XenosStringUtils.EMPTY_STR;
	        [Bindable]private var invAccountPkStr:String = XenosStringUtils.EMPTY_STR;
	        [Bindable]private var versionNo:String = XenosStringUtils.EMPTY_STR;
	        [Bindable]private var interestManual:String = 'false';
	  
			private function changeCurrentState():void{
				vstack.selectedChild = rslt;
			}
			 
		  
	  	/**
         * Load the Entry/Amend/Cancel according to 
         * the operational mode (e.g. Entry/Amend/Cancel)
         */  
		   public function loadAll():void {
	       	   parseUrlString();
	       	   super.setXenosEntryControl(new XenosEntry());
	       	   this.dispatchEvent(new Event('entryInit'));
	       	   vstack.selectedChild = qry;
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
            	super.getInitHttpService().url = "slr/ContractDetailsDispatch.action?";
            	var reqObject:Object = new Object();
            	reqObject.rnd = rndNo;
            	reqObject.method= "contractActionEntryExecute";
		  		reqObject.mode="action";
		  		reqObject.actionType="REPRICE";
		  		reqObject.SCREEN_KEY = "124";
		  		super.getInitHttpService().request = reqObject;
            }
            
	        /**
            * This method is pre-result handler for the SLR Trade Reprice Action Entry
            * Screen. It generates the list of keys which will be populated 
            * during the initialization of the SLR trade Entry Reprice Action screen. 
            * (InitEntry-SEQ-2)
            */
	        override public function preEntryResultInit():Object{
	        	addCommonResultKeys(); 
	        	return keylist;
	        }
	        
	         override public function preEntry():void{
			 	super.getSaveHttpService().url = "slr/RepriceActionDispatch.action?";
			 	var reqObj:Object = new Object();
			 	reqObj = populateRequestParam();
			 	reqObj.method = "submitRepriceContract";
			 	reqObj.SCREEN_KEY = "125";
	            super.getSaveHttpService().request = reqObj;
	            super.getSaveHttpService().method = "POST";
			 }
			 
			override public function preEntryResultHandler():Object {
				 addCommonResultKeys() ;
				 return keylist;
			}
			
			private function addCommonResultKeys():void{
	        	keylist = new ArrayCollection();
		    	keylist.addItem("contractNumber");
		    	keylist.addItem("versionNo");
		    	keylist.addItem("openEnded");
		    	keylist.addItem("contractPK");
		    	keylist.addItem("tradeType");
		    	keylist.addItem("subTradeType");
		    	keylist.addItem("accountNo");
		    	keylist.addItem("accountPk");
		    	keylist.addItem("rr");
		    	keylist.addItem("executingRr");
		    	keylist.addItem("traderId");
		    	keylist.addItem("inventoryAccount");
		    	keylist.addItem("inventoryAccountPk");
		    	keylist.addItem("hairCut");
		    	keylist.addItem("brokerCode");
		    	keylist.addItem("extRefNo");
		    	keylist.addItem("accountBalanceTypeValue");
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
		    	keylist.addItem("netPrincipal");
		    	keylist.addItem("brokerReferenceNo");
		    	keylist.addItem("paidInterest");
		    	keylist.addItem("subLimit");
		    	keylist.addItem("commission");
		    	keylist.addItem("remarks");
		    	keylist.addItem("lastActionDate");
		    	keylist.addItem("newAutoPairOff");
		    	keylist.addItem("securities.security");
		    	keylist.addItem("newInterestAmount");
		    	keylist.addItem("newNetAmount");
		    	keylist.addItem("newValueDate");
	        }
			 
			 
			/**
	        * This method populates the elements of the SLR
	        * Trade Entry screen(mxml)
	        * from the map obtained from preEntryResultInit() (InitEntry-SEQ-3)
	        */
	        override public function postEntryResultInit(mapObj:Object): void{
	        	app.submitButtonInstance = submit;
	        	commonInit(mapObj);
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
		             commonResultPart(mapObj);
					 changeCurrentState();
			    	}else{
			    		errPage.removeError();
			    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			    	}    		
		    	}
	        }
			 
			 
			override public function preEntryConfirm():void {
				var reqObj :Object = new Object();
				super.getConfHttpService().url = "slr/RepriceActionDispatch.action?";  
				reqObj.method= "commitContract";
				reqObj.rnd = Math.random()+"";
				reqObj.SCREEN_KEY = "126";
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
			    	}else if(mapObj["errorFlag"].toString() == "noError"){
			    	   if(mode!="cancel")
			    		  errPage.clearError(super.getConfResultEvent());
			    	   commonResultPart(mapObj);
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
		               hb.visible = true;
	               	   hb.includeInLayout = true;  
		               app.submitButtonInstance = sConfSubmit;  
			    	}else{
			    		errPage.removeError();
			    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('slr.label.erroroccured'));
			    	}    		
		    	}
		    }
		    
		  
		    
		    override public function doEntrySystemConfirm(e:Event):void {
			     this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
				 this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
			}
	        
	        private function commonInit(mapObj:Object):void{
	        	hb.visible = false;
	            hb.includeInLayout = false;
	            interestManual = 'false';
	            if(!XenosStringUtils.isBlank(mapObj[keylist.getItemAt(1)].toString())){
	            	this.contractNo.text = mapObj[keylist.getItemAt(0)]+"-"+mapObj[keylist.getItemAt(1)];
	            }else{
	            	this.contractNo.text = mapObj[keylist.getItemAt(0)];
	            }
	            this.conTractRefNo = mapObj[keylist.getItemAt(0)];
	            this.versionNo = mapObj[keylist.getItemAt(1)];
	            this.openended.text = mapObj[keylist.getItemAt(2)];
	            this.tradeType.text = mapObj[keylist.getItemAt(4)];
	            this.subTradeType.text = mapObj[keylist.getItemAt(5)];
	            this.accNo.text = mapObj[keylist.getItemAt(6)];
	            this.accountPkStr = mapObj[keylist.getItemAt(7)];
	            this.rr.text = mapObj[keylist.getItemAt(8)];
	            this.execRr.text = mapObj[keylist.getItemAt(9)];
	            this.traderId.text = mapObj[keylist.getItemAt(10)];
	            this.fundAccNo.text = mapObj[keylist.getItemAt(11)];
	            this.invAccountPkStr = mapObj[keylist.getItemAt(12)];
	            this.hairCut.text = mapObj[keylist.getItemAt(13)];
	            this.brokerCode.text = mapObj[keylist.getItemAt(14)];
	            this.extRefNo.text = mapObj[keylist.getItemAt(15)];
	            //this.accBalType.text = mapObj[keylist.getItemAt(16)];
	            this.tradeCcy.text = mapObj[keylist.getItemAt(17)];
	            this.stlCcy.text = mapObj[keylist.getItemAt(18)];
	            this.tradeDate.text = mapObj[keylist.getItemAt(19)];
	            this.startDate.text = mapObj[keylist.getItemAt(20)];
	            this.tradeTime.text = mapObj[keylist.getItemAt(21)];
	            this.endDate.text = mapObj[keylist.getItemAt(22)];
	            if(mapObj[keylist.getItemAt(22)] == null || XenosStringUtils.isBlank(mapObj[keylist.getItemAt(22)].toString())){
	            	interestAmtEditLbl.visible = false;
	            	interestAmtEditLbl.includeInLayout = false;
	            	interestAmtEditImg.visible = false;
	            	interestAmtEditImg.includeInLayout = false;
	            	interestAmtEdit.visible = false;
	            	interestAmtEdit.includeInLayout = false;
	            	
	            	NetAmtEditLbl.visible = false;
	            	NetAmtEditLbl.includeInLayout = false;
	            	NetAmtEditImg.visible = false;
	            	NetAmtEditImg.includeInLayout = false;
	            	NetAmtEdit.visible = false;
	            	NetAmtEdit.includeInLayout = false;
	            }else{
	            	interestAmtEditLbl.visible = true;
	            	interestAmtEditLbl.includeInLayout = true;
	            	interestAmtEditImg.visible = true;
	            	interestAmtEditImg.includeInLayout = true;
	            	interestAmtEdit.visible = true;
	            	interestAmtEdit.includeInLayout = true;
	            	
	            	NetAmtEditLbl.visible = true;
	            	NetAmtEditLbl.includeInLayout = true;
	            	NetAmtEditImg.visible = true;
	            	NetAmtEditImg.includeInLayout = true;
	            	NetAmtEdit.visible = true;
	            	NetAmtEdit.includeInLayout = true;
	            }
	            this.expirationDate.text = mapObj[keylist.getItemAt(23)];
	            this.accruedDays.text = mapObj[keylist.getItemAt(24)];
	            this.dividentDate.text = mapObj[keylist.getItemAt(25)];
	            this.interestAmt.text = mapObj[keylist.getItemAt(26)];
	            this.interestRate.text = mapObj[keylist.getItemAt(27)];
	            this.prinAmt.text = mapObj[keylist.getItemAt(28)];
	            this.brokerRefNo.text = mapObj[keylist.getItemAt(29)];
	            this.paidInterest.text = mapObj[keylist.getItemAt(30)];
	            this.subLimit.text = mapObj[keylist.getItemAt(31)];
	            this.commission.text = mapObj[keylist.getItemAt(32)];
	            this.remarks.text = mapObj[keylist.getItemAt(33)];
	            this.lastAxnDate.text = mapObj[keylist.getItemAt(34)];
	            
	            /* Populating Auto Pair Off drop down*/
	        	initcol = new ArrayCollection();
		    	if(mapObj[keylist.getItemAt(2)]!=null){
		    		this.initcol.addItem({label:"Yes",value:"Y"});
		    		this.initcol.addItem({label:"No",value:"N"});
		    	}
		    	this.autoPairOff.dataProvider = initcol;
		    	this.autoPairOff.selectedIndex = 0;
		    	
		    	/* Populating Carryover drop down*/
	        	initcol = new ArrayCollection();
		    	if(mapObj[keylist.getItemAt(2)]!=null){
		    		this.initcol.addItem({label:this.parentApplication.xResourceManager.getKeyValue('slr.label.optionyes'),value:"Y"});
		    		this.initcol.addItem({label:this.parentApplication.xResourceManager.getKeyValue('slr.label.optionno'),value:"N"});
		    	}
		    	this.carryOver.dataProvider = initcol;
		    	this.carryOver.selectedIndex = 0;
	        	
	        	this.securityList = new ArrayCollection();
				    if(mapObj[keylist.getItemAt(36)] != null){
				    	initcol = (mapObj[keylist.getItemAt(36)]) as ArrayCollection;
				    	if(initcol != null){
				    		try {
			                      for each ( var it:XML in initcol) {
			                          securityList.addItem(it);
			                      }
			                  }catch(e:Error){
			                      XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.errloadingseclist'));
			                }
				    	}
				    }
				 securityList.refresh();
				 
				 this.interestAmtEdit.text = mapObj[keylist.getItemAt(37)];
				 this.NetAmtEdit.text = mapObj[keylist.getItemAt(38)];
				 if(mapObj[keylist.getItemAt(39)] != null){
	            	this.valueDateEdit.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(39)].toString());
	            }
	            if(!XenosStringUtils.isBlank(mapObj[keylist.getItemAt(22)].toString())){
	            	this.netamnt.visible = true;
	            	this.interestAmnt.visible = true;
	            }else{
	            	this.netamnt.visible = false;
	            	this.interestAmnt.visible = false;
	            }
	        }
	        
	        
	        
	        
	         private function commonResultPart(mapObj:Object):void{
        		 
	            this.uContractNo.text = mapObj[keylist.getItemAt(0)].toString()+"-"+mapObj[keylist.getItemAt(1)].toString();
	            this.uOpenended.text = mapObj[keylist.getItemAt(2)];
	            this.uTradeType.text = mapObj[keylist.getItemAt(4)];
	            this.uSubTradeType.text = mapObj[keylist.getItemAt(5)];
	            this.uAccNo.text = mapObj[keylist.getItemAt(6)];
	            this.uRr.text = mapObj[keylist.getItemAt(8)];
	            this.uExecRr.text = mapObj[keylist.getItemAt(9)];
	            this.uTraderId.text = mapObj[keylist.getItemAt(10)];
	            this.uFundAccNo.text = mapObj[keylist.getItemAt(11)];
	            this.uHairCut.text = mapObj[keylist.getItemAt(13)];
	            this.uBrokerCode.text = mapObj[keylist.getItemAt(14)];
	            this.uExtRefNo.text = mapObj[keylist.getItemAt(15)];
	            //this.uAccBalType.text = mapObj[keylist.getItemAt(16)];
	            this.uTradeCcy.text = mapObj[keylist.getItemAt(17)];
	            this.uStlCcy.text = mapObj[keylist.getItemAt(18)];
	            this.uTradeDate.text = mapObj[keylist.getItemAt(19)];
	            this.uStartDate.text = mapObj[keylist.getItemAt(20)];
	            this.uTradeTime.text = mapObj[keylist.getItemAt(21)];
	            this.uEndDate.text = mapObj[keylist.getItemAt(22)];
	            this.uExpirationDate.text = mapObj[keylist.getItemAt(23)];
	            this.uAccruedDays.text = mapObj[keylist.getItemAt(24)];
	            this.uDividentDate.text = mapObj[keylist.getItemAt(25)];
	            this.uInterestAmt.text = mapObj[keylist.getItemAt(26)];
	            this.uInterestRate.text = mapObj[keylist.getItemAt(27)];
	            this.uPrinAmt.text = mapObj[keylist.getItemAt(28)];
	            this.uBrokerRefNo.text = mapObj[keylist.getItemAt(29)];
	            this.uPaidInterest.text = mapObj[keylist.getItemAt(30)];
	            this.uSubLimit.text = mapObj[keylist.getItemAt(31)];
	            this.uCommission.text = mapObj[keylist.getItemAt(32)];
	            this.uRemarks.text = mapObj[keylist.getItemAt(33)];

		         this.securityList = new ArrayCollection();
				    if(mapObj[keylist.getItemAt(36)] != null){
				    	initcol = (mapObj[keylist.getItemAt(36)]) as ArrayCollection;
				    	if(initcol != null){
				    		try {
			                      for each ( var it:XML in initcol) {
			                          securityList.addItem(it);
			                      }
			                  }catch(e:Error){
			                      XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.errloadingseclist'));
			                }
				    	}
				    }
				 securityList.refresh();
				 
				 if(XenosStringUtils.equals(mapObj[keylist.getItemAt(4)].toString(),"SB") || 
				    XenosStringUtils.equals(mapObj[keylist.getItemAt(4)].toString(),"SL")){
				 	this.cashvaluedate.visible = true;
	            }else{
	            	this.cashvaluedate.visible = false;
	            }
	        } 
	        
		/*  override public function preEntryConfirmResultHandler():Object{
			addCommonResultKes();
			return keylist;
		} */
		
    
   
	  private function doBack():void{
	  	 app.submitButtonInstance = submit;
	     vstack.selectedChild = qry;
	  } 
	  
	    
	    private function doSave():void{
	    	if(uConfSubmit.enabled == true){
	    		this.dispatchEvent(new Event('entryConf'));
	    	}
	    	uConfSubmit.enabled = false;
	    }
	    
	    private function populateRequestParam():Object{
	    	var reqObj:Object = new Object();
	    	
			reqObj.rnd = Math.random()+"";
	    	reqObj['contractNumber'] = this.conTractRefNo;
	    	reqObj['versionNo'] = this.versionNo;
	    	reqObj['openEnded'] = this.openended.text;
	    	reqObj['contractPK'] = this.contractPkStr;
	    	reqObj['tradeType'] = this.tradeType.text;
	    	reqObj['subTradeType'] = this.subTradeType.text;
	    	reqObj['accountNo'] = this.accNo.text;
	    	reqObj['accountPk'] = this.accountPkStr;
	    	reqObj['rr'] = this.rr.text;
	    	reqObj['executingRr'] = this.execRr.text;
	    	reqObj['traderId'] = this.traderId.text;
	    	reqObj['inventoryAccountPk'] =this.invAccountPkStr; 
	    	reqObj['inventoryAccount'] = this.fundAccNo.text;
	    	reqObj['hairCut'] = this.hairCut.text;
	    	reqObj['brokerCode'] = this.brokerCode.text;
	    	reqObj['extRefNo'] = this.extRefNo.text;
	    	//reqObj['accountBalanceTypeValue'] = this.accBalType.text;
	    	reqObj['tradeCurrency'] = this.tradeCcy.text;
	    	reqObj['settlementCurrency'] = this.stlCcy.text;
	    	reqObj['tradeDate'] = this.tradeDate.text;
	    	reqObj['startDate'] = this.startDate.text;
	    	reqObj['tradetime'] = this.tradeTime.text;
	    	reqObj['endDate'] = this.endDate.text;
	    	reqObj['expirationDate'] = this.expirationDate.text;
	    	reqObj['accrualDays'] = this.accruedDays.text;
	    	reqObj['dividendRate'] = this.dividentDate.text;
	    	reqObj['interestAmount'] = this.interestAmt.text;
	    	reqObj['interestRate'] = this.interestRate.text;
	    	reqObj['netPrincipal'] = this.prinAmt.text;
	    	reqObj['brokerReferenceNo'] = this.brokerRefNo.text;
	    	reqObj['paidInterest'] = this.paidInterest.text;
	    	reqObj['subLimit'] = this.subLimit.text;
	    	reqObj['commission'] = this.commission.text;
	    	reqObj['remarks'] = this.remarks.text;
	    	reqObj['lastActionDate'] = this.lastAxnDate.text;
	    	reqObj['newAutoPairOff'] = this.autoPairOff.selectedItem != null ? this.autoPairOff.selectedItem.value : ""; 
	    	reqObj['newCarryover'] = this.carryOver.selectedItem != null ? this.carryOver.selectedItem.value : "";
	    	reqObj['newValueDate'] = !XenosStringUtils.isBlank(this.valueDateEdit.text) ? StringUtil.trim(this.valueDateEdit.text) : "";
	    	reqObj['manualInterest'] = this.interestManual;
	    	
	    	if(interestAmtEdit.visible){
	    		reqObj['newInterestAmount'] = this.interestAmtEdit.text;
	    	}
	    	if(NetAmtEdit.visible){
	    		reqObj['newNetAmount'] = this.NetAmtEdit.text;
	    	}
	    	
	    	for each(var secInfo:Object in this.securityList){
		    	reqObj['securityInfo['+securityList.getItemIndex(secInfo)+'].manualPrincipal'] = secInfo.manualPrincipal;
		    	reqObj['securityInfo['+securityList.getItemIndex(secInfo)+'].principalAmount'] = secInfo.principalAmount;
		    	reqObj['securityInfo['+securityList.getItemIndex(secInfo)+'].price'] = secInfo.price;
		    	reqObj['securityInfo['+securityList.getItemIndex(secInfo)+'].startLegExtRefNo'] = secInfo.startLegExtRefNo;
		    	reqObj['securityInfo['+securityList.getItemIndex(secInfo)+'].endLegExtRefNo'] = secInfo.endLegExtRefNo;
		    	reqObj['securityInfo['+securityList.getItemIndex(secInfo)+'].interest'] = secInfo.interest;
		    	reqObj['securityInfo['+securityList.getItemIndex(secInfo)+'].manualInterest'] = secInfo.manualInterest;
		    	reqObj['securityInfo['+securityList.getItemIndex(secInfo)+'].manualNetAmount'] = secInfo.manualNetAmount;
		    	reqObj['securityInfo['+securityList.getItemIndex(secInfo)+'].netAmount'] = secInfo.netAmount;
	    	}
	    	
	    	return reqObj;
	    }
	    
	    private function calculateNetAmount():void{
	    		var reqObj:Object = new Object();
		    	reqObj = populateRequestParam();
		    	reqObj.method = "calculateNetAmount";
		    	reqObj.rnd = Math.random()+"";
		    	calculationRequest.request = reqObj;
		    	calculationRequest.send();
	    }
	    
	    private function loadCalculatedFields(event:ResultEvent):void{
	    	if(event != null){
	    		if(event.result != null){
	    			if(event.result.slrContractModifyActionForm != null){
	    				errPage.clearError(super.getInitResultEvent());
	    				this.interestAmtEdit.text = event.result.slrContractModifyActionForm.newInterestAmount;
	    				this.NetAmtEdit.text = event.result.slrContractModifyActionForm.newNetAmount;
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
	    
	    private function calculateInterestAmount():void{
	    	
	    		var reqObj:Object = new Object();
	    		var send:Boolean = false;
	    		if(!XenosStringUtils.isBlank(this.valueDateEdit.text)) {
	    		  send=true;	
	    		}
	    		if(send){
			    	reqObj = populateRequestParam();
			    	reqObj.method = "calculateInterestAmount";
			    	reqObj.rnd = Math.random()+"";
			    	calculationRequest.request = reqObj;
			    	calculationRequest.send();
		    	}
		    	else{
		    		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.valuedateempty'));
		    	}
	    }
	    
	    public function calculateSecPrincipalAmt(sec:Object):void {
	    	var reqObj:Object = new Object();
	    	reqObj = populateRequestParam();
	    	reqObj.method = "calculateSecurityPrincipalAmount";
	    	reqObj.rnd = Math.random()+"";
	    	reqObj.pk = sec.pk;
	    	secCalculationRequest.request = reqObj;
	    	secCalculationRequest.send();
	    }
	    public function calculateSecInterestAmt(sec:Object):void {
	    	var reqObj:Object = new Object();
	    	reqObj = populateRequestParam();
	    	reqObj.method = "calculateSecurityInterestAmount";
	    	reqObj.rnd = Math.random()+"";
	    	reqObj.pk = sec.pk;
	    	secCalculationRequest.request = reqObj;
	    	secCalculationRequest.send();
	    }
	    public function calculateSecNetAmt(sec:Object):void {
	    	var reqObj:Object = new Object();
	    	reqObj = populateRequestParam();
	    	reqObj.method = "calculateSecurityNetAmount";
	    	reqObj.rnd = Math.random()+"";
	    	reqObj.pk = sec.pk;
	    	secCalculationRequest.request = reqObj;
	    	secCalculationRequest.send();
	    }
	    
	    private function loadSecurityCalculatedFields(event:ResultEvent):void {
	    	if(event != null){
	    		if(event.result != null){
	    			if(event.result.slrContractModifyActionForm != null){
	    				securityList = new ArrayCollection();
	    				errPage.clearError(super.getInitResultEvent());
	    				if(event.result.slrContractModifyActionForm.securities != null){
	    					if(event.result.slrContractModifyActionForm.securities.security != null){
		    					if(event.result.slrContractModifyActionForm.securities.security is ArrayCollection){
			    					securityList = event.result.slrContractModifyActionForm.securities.security as ArrayCollection;
			    				}else{
			    					securityList.addItem(event.result.slrContractModifyActionForm.securities.security);
			    				}
			    				securityList.refresh();
		    				}
	    				}
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
	    
	   private function changeInterestAmt(event:Event):void {
	   	 interestManual = 'true';
	   }
	   
		private function submitBtn():void{
			var send:Boolean = false;
			if(!XenosStringUtils.isBlank(this.valueDateEdit.text)) {
				send=true;	
			}
			if(send){
				this.dispatchEvent(new Event('entrySave'));
			}
			else{
				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.valuedateempty'));
			}
		} 
