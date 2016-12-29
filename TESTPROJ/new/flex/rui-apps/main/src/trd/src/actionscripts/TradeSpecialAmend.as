



 		/**
 		 *	ActionScript file for Trade Special Amend Module
 		 */
		import com.nri.rui.core.Globals;
		import com.nri.rui.core.controls.XenosAlert;
		import com.nri.rui.core.controls.XenosEntry;
		import com.nri.rui.core.startup.XenosApplication;
		import com.nri.rui.core.utils.XenosPopupUtils;
		import com.nri.rui.core.utils.XenosStringUtils;
		import com.nri.rui.trd.validator.TradeEntryValidator;
		
		import flash.events.Event;
		
		import mx.collections.ArrayCollection;
		import mx.controls.Label;
		import mx.core.UIComponent;
		import mx.events.CloseEvent;
		import mx.events.FlexEvent;
		import mx.rpc.events.ResultEvent;
		import mx.utils.StringUtil;
					
			  
		     [Bindable]
		     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     
            [Bindable]private var mode : String = "entry";
            [Bindable]private var tradePkStr : String = "";
            [Bindable]private var updateDateStr : String = "";
            [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
            [Bindable]public var tax:ArrayCollection = new ArrayCollection();
            [Bindable]private var isInFirstEntryScreen:Boolean = true;
            [Bindable]public var cpSecSsiPk:Label = new Label();
            [Bindable]public var cpCashSsiPk:Label = new Label();
            private var keylist:ArrayCollection = new ArrayCollection();
            private var index:Number = -1;
            private var item:Object = new Object();
            private var reqObj : Object = new Object();
            private var initcol:ArrayCollection = new ArrayCollection();
            private var finInstPkStr : String = "";
		    private var fundPkStr : String = "";
		    private var accPkStr : String = "";
		    private var invAccPkStr : String = "";
		    private var instPkStr : String = "";
		    private var deliveryMethodStr : String = "";
		    private var stlLocationSecStr : String = "";
		    private var stlLocationCashStr : String = "";
		    private var trdTypeStr : String = "";
		    private var trdTypeTxtStr : String = "";
		    private var trdCcyStr : String = "";
		    private var issueCcyStr : String = "";
		    private var valDateStr : String = "";
		    private var qtyStr : String = "";
		    private var ipPriceStr : String = "";
	  
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
	           
	       	   if (XenosStringUtils.equals(this.mode,Globals.MODE_SPCL_AMEND)) {
       	   			vstack.selectedChild = qry;
	       	   		this.isInFirstEntryScreen = false;
	       	   	 	app.submitButtonInstance = submitAddlEntry;
	       	     	this.dispatchEvent(new Event('amendEntryInit'));
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
	                        }else if(tempA[0] == "tradePk"){
	                            this.tradePkStr = tempA[1];
	                        }else if(tempA[0] == "updateDate"){
	                            this.updateDateStr = tempA[1];
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
            * Trade Amend Screen (InitAmend-SEQ-1)
            */
            override public function preAmendInit():void{  
            	vstack.selectedChild = qry;
            	var rndNo:Number= Math.random(); 
            	var reqObject:Object = new Object();
            	initLabel.text = this.parentApplication.xResourceManager.getKeyValue('trd.confirm.amendment.info');       	
            	super.getInitHttpService().url = "trd/tradeSpecialAmend.action?";
            	reqObject.rnd = rndNo;
            	reqObject.method= "loadTradeDetailsForSpecialAmend";
		  		reqObject.mode=this.mode;
		  		reqObject.tradePk = this.tradePkStr;
		  		reqObject.updateDate = this.updateDateStr;
		  		reqObject.SCREEN_KEY = "11181";
		  		super.getInitHttpService().request = reqObject; 
            }
	        
	        /**
            * This method is pre-result handler for the Trade Amend
            * Screen. It generates the list of keys which will be populated 
            * during the initialization of the Trade Amend screen. 
            * (InitAmend-SEQ-2)
            */
	        override public function preAmendResultInit():Object{
	        	addCommonResultKeys();
	        	keylist.addItem("tradeScreenData.tradeTypeValues.item");
		    	keylist.addItem("tradeScreenData.tradeDateStr");
		    	keylist.addItem("tradeScreenData.buySellOrientationValues.item");
		    	keylist.addItem("tradeScreenData.shortSellingFlagValues.item");
		    	keylist.addItem("tradeScreenData.shortSellExemptFlagValues.item");
		    	keylist.addItem("tradeScreenData.matchingSupressFlagValues.item");
		    	keylist.addItem("tradeScreenData.grossNetTypeValues.item");
		    	keylist.addItem("tradeScreenData.inputPriceFormatValues.item");
		    	keylist.addItem("tradeScreenData.executionMethodValues.item");
		    	keylist.addItem("tradeScreenData.calculationTypeValues.item");
		    	keylist.addItem("tradeScreenData.exCouponFlagValues.item");
		    	keylist.addItem("tradeScreenData.dirtyPriceFlagValues.item");
		    	keylist.addItem("tradeScreenData.negativeAccruedInterestFlagValues.item");
		    	keylist.addItem("tradeScreenData.filteredTaxFeeIdList.item");
		    	keylist.addItem("tradeScreenData.rateTypeValues.item");
		    	keylist.addItem("tradeScreenData.softDollarFlagValues.item"); 
		    	keylist.addItem("tradeScreenData.executionMarketPk");
		    	keylist.addItem("tradeScreenData.instrumentPk");
		    	keylist.addItem("tradeScreenData.deliveryMethod");
		    	keylist.addItem("tradeScreenData.stlLocationSec");
		    	keylist.addItem("tradeScreenData.stlLocationCash");
		    	keylist.addItem("tradeScreenData.tradeType");
		    	keylist.addItem("tradeScreenData.tradeTypeStr");
		    	keylist.addItem("tradeScreenData.matchingSupressFlag");
		    	keylist.addItem("tradeScreenData.calculationType");
		    	keylist.addItem("tradeScreenData.securitySsi");
		    	keylist.addItem("tradeScreenData.cashSsi");
		    	keylist.addItem("tradeScreenData.cashSsi.participantId2");
		    	keylist.addItem("tradeScreenData.securitySsi.participantId2");//145
		    	keylist.addItem("tradeScreenData.calculationTypeIssuePricing");
		    	keylist.addItem("tradeScreenData.matchExclusionFlagValues.item");
		    	keylist.addItem("reasonList.item");
		    	keylist.addItem("reason");
		    	keylist.addItem("tradeScreenData.instrumentCodeType");
		    	keylist.addItem("tradeScreenData.instructionSuppressFlag");
		    	keylist.addItem("tradeScreenData.specialOriginDataSourceList.item");//152
		    	keylist.addItem("tradeScreenData.directedBrokerFlagValues.item");
		    	keylist.addItem("tradeScreenData.directedBrokerFlag");
		    	keylist.addItem("tradeScreenData.directedBroker");
		    	keylist.addItem("tradeScreenData.fundName");
		    	keylist.addItem("tradeScreenData.originalDataSource");//157
	        	return keylist;
	        }
	        /**
	        * This method populates the elements of the 
	        * Trade Amend screen(mxml)
	        * from the map obtained from preAmendResultInit() (InitAmend-SEQ-3)
	        */
	        override public function postAmendResultInit(mapObj:Object): void{
        		this.upBack.visible = true;
        		this.upBack.includeInLayout = true;
        		viewSsiNotForCancel.visible = true;
	        	viewSsiNotForCancel.includeInLayout = true;
	        	app.submitButtonInstance = submitAddlEntry;
	        	
	        	amendInit(mapObj);
	        }
	        
			 private function addCommonResultKeys():void{
	        	keylist = new ArrayCollection();
		    	keylist.addItem("tradeScreenData.fundCode");
		    	keylist.addItem("tradeScreenData.securityId");
		    	keylist.addItem("tradeScreenData.inventoryAccountNo");
		    	keylist.addItem("tradeScreenData.alternateSecurityCode");
		    	keylist.addItem("tradeScreenData.invAccShortName");
		    	keylist.addItem("tradeScreenData.officialName");
		    	keylist.addItem("tradeScreenData.referenceNo");
		    	keylist.addItem("tradeScreenData.status");
		    	keylist.addItem("tradeScreenData.tradeTypeStr");
		    	keylist.addItem("tradeScreenData.omsExecutionNo");
		    	keylist.addItem("tradeScreenData.etcReferenceNo");
		    	keylist.addItem("tradeScreenData.orderReferenceNo");
		    	keylist.addItem("tradeScreenData.buySellOrientation");
		    	keylist.addItem("tradeScreenData.matchStatus");
		    	keylist.addItem("tradeScreenData.accountNo");
		    	keylist.addItem("tradeScreenData.shortName");
		    	keylist.addItem("tradeScreenData.brokerOgCode");
		    	keylist.addItem("tradeScreenData.principalAgentFlag");
		    	keylist.addItem("tradeScreenData.tradeDateStr");
		    	keylist.addItem("tradeScreenData.tradeTime");
		    	keylist.addItem("tradeScreenData.valueDateStr");
		    	keylist.addItem("tradeScreenData.inputPriceStr");
		    	keylist.addItem("tradeScreenData.grossNetType");
		    	keylist.addItem("tradeScreenData.inputPriceFormat");
		    	keylist.addItem("tradeScreenData.yieldPriceConvType");
		    	keylist.addItem("tradeScreenData.tradeCurrency");
		    	keylist.addItem("tradeScreenData.settlementCurrency");
		    	keylist.addItem("tradeScreenData.issueCurrency");
		    	keylist.addItem("tradeScreenData.exchangeRateStr");
		    	keylist.addItem("tradeScreenData.exchangeRateIssuePricingStr");
		    	keylist.addItem("tradeScreenData.priceStr");
		    	keylist.addItem("tradeScreenData.quantityStr");
		    	keylist.addItem("tradeScreenData.principalAmountStr");
		    	keylist.addItem("tradeScreenData.principalAmountInIssueStr");
		    	keylist.addItem("tradeScreenData.currentFaceValueStr");
		    	keylist.addItem("tradeScreenData.accruedInterestAmountStr");
		    	keylist.addItem("tradeScreenData.interestRateStr");
		    	keylist.addItem("tradeScreenData.accruedStartDateStr");
		    	keylist.addItem("tradeScreenData.totalTaxFee");
		    	keylist.addItem("tradeScreenData.accruedDaysStr");
		    	keylist.addItem("tradeScreenData.netAmountStr");
		    	keylist.addItem("tradeScreenData.netAmountInTradingCurrency");
		    	keylist.addItem("tradeScreenData.poolFactorStr");
		    	keylist.addItem("tradeScreenData.remarks");
		    	keylist.addItem("tradeScreenData.entryDateStr");
		    	keylist.addItem("tradeScreenData.lastEntryDateStr");
		    	keylist.addItem("tradeScreenData.createdBy");
		    	keylist.addItem("tradeScreenData.updatedBy");
		    	keylist.addItem("tradeScreenData.creationDateStr");
		    	keylist.addItem("tradeScreenData.updateDateStr");
		    	keylist.addItem("tradeScreenData.externalReferenceNo");
		    	keylist.addItem("tradeScreenData.brokerReferenceNo");
		    	keylist.addItem("tradeScreenData.basketId");
		    	keylist.addItem("tradeScreenData.projectNo");
		    	keylist.addItem("tradeScreenData.executionMarket");
		    	keylist.addItem("tradeScreenData.executionMethod");
		    	keylist.addItem("tradeScreenData.dataSource");
		    	keylist.addItem("tradeScreenData.shortSellingFlag");//XGA-105  
		    	keylist.addItem("tradeScreenData.shortSellExemptFlag");//XGA-105
		    	keylist.addItem("tradeScreenData.startEndType");
		    	keylist.addItem("tradeScreenData.exCouponFlag");
		    	keylist.addItem("tradeScreenData.dirtyPriceFlag");
		    	keylist.addItem("tradeScreenData.stipulation");
		    	keylist.addItem("tradeScreenData.senderReferenceNo");
		    	keylist.addItem("tradeScreenData.negativeAccruedInterestFlag");
		    	keylist.addItem("tradeScreenData.tipsAdjustPrice");
		    	keylist.addItem("tradeScreenData.tipsIndexAccruedInitDateStr");
		    	keylist.addItem("tradeScreenData.tipsIndexVdStr");
		    	keylist.addItem("tradeScreenData.prefiguredPrincipalFlag");
		    	keylist.addItem("tradeScreenData.stepInOutFlag");
		    	keylist.addItem("tradeScreenData.tradeMatchType");
		    	keylist.addItem("tradeScreenData.tradeConfirmReqd");
		    	keylist.addItem("tradeScreenData.excludeFromNetting");
		    	keylist.addItem("tradeScreenData.traceEligibleFlag");
		    	keylist.addItem("tradeScreenData.formTEligibleFlag");
		    	keylist.addItem("tradeScreenData.forwardRepoFlag");
		    	keylist.addItem("tradeScreenData.remarksForReports");
		    	keylist.addItem("tradeScreenData.affirmSuppressFlag");
		    	keylist.addItem("tradeScreenData.instructionSuppressFlag");
		    	keylist.addItem("tradeScreenData.matchExclusionFlag");
		    	keylist.addItem("tradeScreenData.softDollarFlag");
		    	keylist.addItem("taxFeeAmounts.taxFeeAmount");
		    	keylist.addItem("tradeScreenData.securitySsi.cashSecurityFlag");
		    	keylist.addItem("tradeScreenData.securitySsi.brokerBic");
		    	keylist.addItem("tradeScreenData.securitySsi.acronym");
		    	keylist.addItem("tradeScreenData.securitySsi.instrumentType");
		    	keylist.addItem("tradeScreenData.securitySsi.settlementCcy");
		    	keylist.addItem("tradeScreenData.securitySsi.settlementType");
		    	keylist.addItem("tradeScreenData.securitySsi.bankName");
		    	keylist.addItem("tradeScreenData.securitySsi.contraId");
		    	keylist.addItem("tradeScreenData.securitySsi.dtcParticipantNumber");
		    	keylist.addItem("tradeScreenData.securitySsi.cpExternalSettleAct");
		    	keylist.addItem("tradeScreenData.securitySsi.priority");
		    	keylist.addItem("tradeScreenData.securitySsi.placeOfSettlement");
		    	keylist.addItem("tradeScreenData.securitySsi.participantId");
		    	keylist.addItem("tradeScreenData.cashSsi.cashSecurityFlag");
		    	keylist.addItem("tradeScreenData.cashSsi.brokerBic");
		    	keylist.addItem("tradeScreenData.cashSsi.acronym");
		    	keylist.addItem("tradeScreenData.cashSsi.instrumentType");
		    	keylist.addItem("tradeScreenData.cashSsi.settlementCcy");
		    	keylist.addItem("tradeScreenData.executionMarketPk");
		    	keylist.addItem("tradeScreenData.fundPk");
		    	keylist.addItem("tradeScreenData.accountPk");
		    	keylist.addItem("tradeScreenData.inventoryAccountPk");
		    	keylist.addItem("tradeScreenData.instrumentPk");
		    	keylist.addItem("tradeScreenData.versionNoStr");
		    	keylist.addItem("tradeScreenData.deliveryMethod");
		    	keylist.addItem("tradeScreenData.stlLocationSec");
		    	keylist.addItem("tradeScreenData.stlLocationCash");
		    	keylist.addItem("tradeScreenData.cashSsi.settlementType");
		    	keylist.addItem("tradeScreenData.cashSsi.bankName");
		    	keylist.addItem("tradeScreenData.cashSsi.contraId");
		    	keylist.addItem("tradeScreenData.cashSsi.dtcParticipantNumber");
		    	keylist.addItem("tradeScreenData.cashSsi.cpExternalSettleAct");
		    	keylist.addItem("tradeScreenData.cashSsi.priority");
		    	keylist.addItem("tradeScreenData.cashSsi.placeOfSettlement");
		    	keylist.addItem("tradeScreenData.cashSsi.participantId");
	        }
			 
			 override public function preAmend():void{
			 	var reqObj:Object = new Object();
			 	setValidator();
			 	super.getSaveHttpService().url = "trd/tradeSpecialAmend.action?";  
			 	reqObj = populateRequestParams();
			 	reqObj.mode = this.mode;
			 	super.getSaveHttpService().method = "POST";
	            super.getSaveHttpService().request = reqObj; 	
			 }
			 
			override public function preAmendResultHandler():Object
			{
				return preAmendResultInit();
			}
			
			override public function postAmendResultHandler(mapObj:Object):void
			{
				this.uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('trd.confirm.amend.user.conf');
				commonResult(mapObj);
			}
			
			override public function postAmend():void{
				
			}
			
			override public function preAmendConfirm():void
			{
				 var reqObj :Object = new Object();
				super.getConfHttpService().url = "trd/tradeSpecialAmend.action?";
				reqObj.rnd = Math.random()+"";
				reqObj.SCREEN_KEY = "11185";
				reqObj.method= "tradeAmendPerform";
				super.getConfHttpService().method= "POST";
	            super.getConfHttpService().request = reqObj;
			}
			
			override public function postConfirmAmendResultHandler(mapObj:Object):void
			{
				this.sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('trd.confirm.amend.system.conf');
				submitUserConfResult(mapObj);
			}

		   override public function preResetAmend():void
		   {
				var reqObj:Object = new Object();
				super.getResetHttpService().url = "trd/tradeSpecialAmend.action?";
				reqObj.rnd = Math.random()+ "";
				reqObj.tradePk = this.tradePkStr;
				reqObj.updateDate = this.updateDateStr;
				reqObj.method = "loadTradeDetailsForSpecialAmend";
				super.getResetHttpService().request = reqObj;
		  		super.getResetHttpService().method = "POST";
		   }
		   
		   
			override public function doEntrySystemConfirm(e:Event):void
			{
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
             this.uConfTradeType.text = "";
           	 vstack.selectedChild = qry;
       	   	 this.isInFirstEntryScreen = true;
       	   	 this.showHideFields();	
			 super.postEntrySystemConfirm();
				
			}
			
			override public function doAmendSystemConfirm(e:Event):void
			{
			    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
			}
			override public function doCancelSystemConfirm(e:Event):void
			{
			    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
			}

	        private function amendInit(mapObj:Object):void{
	        	errPage.clearError(super.getInitResultEvent());
	        	hb.visible = false;
	            hb.includeInLayout = false;
	        	finInstPkStr = mapObj[keylist.getItemAt(133)];
				instPkStr = mapObj[keylist.getItemAt(134)];
				deliveryMethodStr = mapObj[keylist.getItemAt(135)];
			    stlLocationSecStr = mapObj[keylist.getItemAt(136)];
			    stlLocationCashStr = mapObj[keylist.getItemAt(137)];
			    trdTypeStr = mapObj[keylist.getItemAt(138)];
			    trdTypeTxtStr = mapObj[keylist.getItemAt(139)];
			    valDateStr = mapObj[keylist.getItemAt(20)];
			    qtyStr = mapObj[keylist.getItemAt(31)];
			    ipPriceStr = mapObj[keylist.getItemAt(21)];
			    
			    showHideFields();			   
			    setVisibility(this.amendRefNoBox,false,false);
			    			    
        		this.amendRefNo.text = mapObj[keylist.getItemAt(6)]+"-"+mapObj[keylist.getItemAt(105)];
				
				if(mapObj[keylist.getItemAt(122)] != null){
					item = new Object();
					initcol = new ArrayCollection();
					index = 0;
					if(mapObj[keylist.getItemAt(122)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(122)] as ArrayCollection)){
							initcol.addItem(item);
							if(item.value == mapObj[keylist.getItemAt(140)].toString()){
								index = (mapObj[keylist.getItemAt(122)] as ArrayCollection).getItemIndex(item);
							}
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(122)]);
						index = 0;
					}
					this.matchingSuppressFlag.dataProvider = initcol;
					if( ! XenosStringUtils.isBlank( mapObj[keylist.getItemAt(140)])){
						this.matchingSuppressFlag.selectedIndex = index;
					}
				}
				
				if(mapObj[keylist.getItemAt(152)] != null){
					item = new Object();
					initcol = new ArrayCollection();
					index = -1;
					if(mapObj[keylist.getItemAt(152)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(152)] as ArrayCollection)){
							initcol.addItem(item);
							if(item.value == mapObj[keylist.getItemAt(157)].toString()){
								index = (mapObj[keylist.getItemAt(152)] as ArrayCollection).getItemIndex(item);
							}
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(152)]);
						index = -1;
					}
					this.originalDataSource.dataProvider = initcol;
					if( index != -1 ){
						this.originalDataSource.selectedIndex = index;
					}
					
				}
				if(mapObj[keylist.getItemAt(153)] != null){
					item = new Object();
					initcol = new ArrayCollection();
					initcol.addItem({label:" ",value:" "});
					index = -1;
					if(mapObj[keylist.getItemAt(153)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(153)] as ArrayCollection)){
							initcol.addItem(item);
							if(item.value == mapObj[keylist.getItemAt(154)].toString()){
								index = (mapObj[keylist.getItemAt(153)] as ArrayCollection).getItemIndex(item);
							}
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(153)]);
						index = 0;
					}
					this.directedBrokerFlag.dataProvider = initcol;
					if( ! XenosStringUtils.isBlank( mapObj[keylist.getItemAt(154)])){
						this.directedBrokerFlag.selectedIndex = index;
					}
				}
				this.directedBroker.text = mapObj[keylist.getItemAt(155)];
				this.omsOrderNo.text = mapObj[keylist.getItemAt(11)];
				this.brokerRefNo.text = mapObj[keylist.getItemAt(51)];
				this.ogRefNo.text = mapObj[keylist.getItemAt(10)];
				this.omsExecutionNo.text = mapObj[keylist.getItemAt(9)];
				
				if(mapObj[keylist.getItemAt(132)] != null){
					item = new Object();
					index = -1;
					initcol = new ArrayCollection();
					initcol.addItem({label:" ",value:" "});
					if(mapObj[keylist.getItemAt(132)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(132)] as ArrayCollection)){
							initcol.addItem(item);
							if(item.value == mapObj[keylist.getItemAt(80)].toString()){
								index = (mapObj[keylist.getItemAt(132)] as ArrayCollection).getItemIndex(item);
							}
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(132)]);
						index = 0;
					}
					this.softDollarFlag.dataProvider = initcol;
					if( ! XenosStringUtils.isBlank( mapObj[keylist.getItemAt(80)])){
						this.softDollarFlag.selectedIndex = index+1;
					}
				}
				
				commonResultPartInit(mapObj);
	        }
			private function commonResultPartInit(mapObj:Object):void{
	        	
	        	fundPkStr = mapObj[keylist.getItemAt(101)].toString();
			    accPkStr = mapObj[keylist.getItemAt(102)].toString();
			    invAccPkStr = mapObj[keylist.getItemAt(103)].toString();
			    finInstPkStr = mapObj[keylist.getItemAt(100)].toString();
			    instPkStr = mapObj[keylist.getItemAt(104)].toString();
			    
			    this.fundCode.text = mapObj[keylist.getItemAt(0)];
			    this.fundName.text = mapObj[keylist.getItemAt(156)];
			    this.securityCode.text = mapObj[keylist.getItemAt(1)];
			    this.fundAccNo.text = mapObj[keylist.getItemAt(2)];
			    this.altSecCode.text = mapObj[keylist.getItemAt(3)];
			    this.fundAccName.text = mapObj[keylist.getItemAt(4)];
			    this.secName.text = mapObj[keylist.getItemAt(5)];
			    if(!XenosStringUtils.isBlank(mapObj[keylist.getItemAt(6)]) && !XenosStringUtils.isBlank(mapObj[keylist.getItemAt(105)])){
			    	this.refNo.text = mapObj[keylist.getItemAt(6)]+"-"+mapObj[keylist.getItemAt(105)];
			    }else{
			    	this.refNo.text = "";
			    }
			    this.status.text = mapObj[keylist.getItemAt(7)];
			    this.tradeType.text = mapObj[keylist.getItemAt(8)];
			   
			    this.buySellFlag.text = mapObj[keylist.getItemAt(12)];
			    this.matchStatus.text = mapObj[keylist.getItemAt(13)];
			    this.accNo.text = mapObj[keylist.getItemAt(14)];
			    this.cpName.text = mapObj[keylist.getItemAt(15)];
			    this.brokerOgCode.text = mapObj[keylist.getItemAt(16)];
			    this.principalAgentFlag.text = mapObj[keylist.getItemAt(17)];
			    this.tradeDate.text = mapObj[keylist.getItemAt(18)];
			    this.tradeTime.text = mapObj[keylist.getItemAt(19)];
			    this.valueDate.text = mapObj[keylist.getItemAt(20)];
			    this.inputPrice.text = mapObj[keylist.getItemAt(21)];
			    this.grossNetType.text = mapObj[keylist.getItemAt(22)];
			    this.inputPriceFormat.text = mapObj[keylist.getItemAt(23)];
			    this.yieldPriceConvType.text = mapObj[keylist.getItemAt(24)];
			    this.tradeCcy.text = mapObj[keylist.getItemAt(25)];
			    this.stlCcy.text = mapObj[keylist.getItemAt(26)];
			    this.issueCcy.text = mapObj[keylist.getItemAt(27)];
			    this.exchngRate.text = mapObj[keylist.getItemAt(28)];
			    this.exchngRateIssuePricing.text = mapObj[keylist.getItemAt(29)];
			    this.price.text = mapObj[keylist.getItemAt(30)];
			    this.quantity.text = mapObj[keylist.getItemAt(31)];
			    this.principalAmt.text = mapObj[keylist.getItemAt(32)];
			    this.principalAmtInIssue.text = mapObj[keylist.getItemAt(33)];
			    this.currentFaceValue.text = mapObj[keylist.getItemAt(34)];
			    this.accrIntAmt.text = mapObj[keylist.getItemAt(35)];
			    this.interestAmt.text = mapObj[keylist.getItemAt(36)];
			    this.accrStartDate.text = mapObj[keylist.getItemAt(37)];
			    this.totalTaxFee.text = mapObj[keylist.getItemAt(38)];
			    this.accrDays.text = mapObj[keylist.getItemAt(39)];
			    this.netAmt.text = mapObj[keylist.getItemAt(40)];
			    this.netAmtInTrdCcy.text = mapObj[keylist.getItemAt(41)];
			    this.poolFactor.text = mapObj[keylist.getItemAt(42)];
				//Additional Entry
				this.extRefNo.text = mapObj[keylist.getItemAt(50)];
			    this.brokerRefNo.text = mapObj[keylist.getItemAt(51)];
			    this.basketId.text = mapObj[keylist.getItemAt(52)];
			    this.projectNo.text = mapObj[keylist.getItemAt(53)];
			    this.execMarket.text = mapObj[keylist.getItemAt(54)];
			    this.execMethod.text = mapObj[keylist.getItemAt(55)];
			    this.dataSrc.text = mapObj[keylist.getItemAt(56)];
			    this.startEndType.text = mapObj[keylist.getItemAt(59)];
			    this.exCouponFlag.text = mapObj[keylist.getItemAt(60)];
			    this.dirtyPriceFlag.text = mapObj[keylist.getItemAt(61)];
			    this.stipulation.text = mapObj[keylist.getItemAt(62)];
			    this.senderRefNo.text = mapObj[keylist.getItemAt(63)];
			    this.negAccIntFlag.text = mapObj[keylist.getItemAt(64)];
			    this.tipsAdjustPrice.text = mapObj[keylist.getItemAt(65)];
			    this.tipsIndexAccruedInitDate.text = mapObj[keylist.getItemAt(66)];
			    this.tipsIndexVd.text = mapObj[keylist.getItemAt(67)];
			    this.prefiguredPrincipalFlag.text = mapObj[keylist.getItemAt(68)];
			    this.stepInOutFlag.text = mapObj[keylist.getItemAt(69)];
			    this.trdMatchType.text = mapObj[keylist.getItemAt(70)];
			    this.trdConfReqd.text = mapObj[keylist.getItemAt(71)];
			    this.excludeFromNetting.text = mapObj[keylist.getItemAt(72)];
			    this.traceEligibleFlag.text = mapObj[keylist.getItemAt(73)];
			    this.formTEligibleFlag.text = mapObj[keylist.getItemAt(74)];
			    this.fwrdRepoFlag.text = mapObj[keylist.getItemAt(75)];
			    this.reportForRemarks.text = mapObj[keylist.getItemAt(76)];
			    this.affirmSppressFlag.text = mapObj[keylist.getItemAt(77)];
			    this.instructionSuppressFlag.text = mapObj[keylist.getItemAt(78)];
			    this.matchExclusionFlag.text = mapObj[keylist.getItemAt(79)];
				
				
				
				tax = new ArrayCollection();
			    if(mapObj[keylist.getItemAt(81)] != null){
			    	initcol = (mapObj[keylist.getItemAt(81)]) as ArrayCollection;
			    	if(initcol != null){
			    		try {
		                      for each ( var item:XML in initcol) {
		                          tax.addItem(item);
		                      }
		                  uConfTaxFeeGrid.visible = true;
		                  uConfTaxFeeGrid.includeInLayout = true;
		                  }catch(e:Error){
		                      XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.load.taxfeelist'));
		                }
			    	}
			    }
			    tax.refresh();
				
				if(mapObj[keylist.getItemAt(142)] != null){
					if(mapObj[keylist.getItemAt(82)] != null){
						this.cashSecFlagSec.text = mapObj[keylist.getItemAt(82)];
					}
					if(mapObj[keylist.getItemAt(83)] != null){
						this.brokerBicSec.text = mapObj[keylist.getItemAt(83)];
					}
					if(mapObj[keylist.getItemAt(84)] != null){
						this.acronymSec.text = mapObj[keylist.getItemAt(84)];
					}
					if(mapObj[keylist.getItemAt(85)] != null){
						this.securityTypeSec.text = mapObj[keylist.getItemAt(85)];
					}
					if(mapObj[keylist.getItemAt(86)] != null){
						this.ccySec.text = mapObj[keylist.getItemAt(86)];
					}
					if(mapObj[keylist.getItemAt(87)] != null){
						this.stlTypeSec.text = mapObj[keylist.getItemAt(87)];
					}
					if(mapObj[keylist.getItemAt(88)] != null){
						this.bankNameSec.text = mapObj[keylist.getItemAt(88)];
					}
					if(mapObj[keylist.getItemAt(89)] != null){
						this.contraIdSec.text = mapObj[keylist.getItemAt(89)];
					}
					if(mapObj[keylist.getItemAt(90)] != null){
						this.dtcPartNoSec.text = mapObj[keylist.getItemAt(90)];
					}
					if(mapObj[keylist.getItemAt(91)] != null){
						this.dtcExtStlAccSec.text = mapObj[keylist.getItemAt(91)];
					}
					if(mapObj[keylist.getItemAt(92)] != null){
						this.prioritySec.text = mapObj[keylist.getItemAt(92)];
					}
					if(mapObj[keylist.getItemAt(93)] != null){
						this.placeOfStlSec.text = mapObj[keylist.getItemAt(93)];
					}
					if(mapObj[keylist.getItemAt(94)] != null){
						this.partIdSec.text = mapObj[keylist.getItemAt(94)];
					}
					if(mapObj[keylist.getItemAt(145)] != null){
						this.partId2Sec.text = mapObj[keylist.getItemAt(145)];
					}
				}
				
				if(mapObj[keylist.getItemAt(143)] != null){
					if(mapObj[keylist.getItemAt(95)] != null){
						this.cashSecFlagCash.text = mapObj[keylist.getItemAt(95)];
					}
					if(mapObj[keylist.getItemAt(96)] != null){
						this.brokerBicCash.text = mapObj[keylist.getItemAt(96)];
					}
					if(mapObj[keylist.getItemAt(97)] != null){
						this.acronymCash.text = mapObj[keylist.getItemAt(97)];
					}
					if(mapObj[keylist.getItemAt(98)] != null){
						this.securityTypeCash.text = mapObj[keylist.getItemAt(98)];
					}
					if(mapObj[keylist.getItemAt(99)] != null){
						this.ccyCash.text = mapObj[keylist.getItemAt(99)];
					}
					if(mapObj[keylist.getItemAt(109)] != null){
						this.stlTypeCash.text = mapObj[keylist.getItemAt(109)];
					}
					if(mapObj[keylist.getItemAt(110)] != null){
						this.bankNameCash.text = mapObj[keylist.getItemAt(110)];
					}
					if(mapObj[keylist.getItemAt(111)] != null){
						this.contraIdCash.text = mapObj[keylist.getItemAt(111)];
					}
					if(mapObj[keylist.getItemAt(112)] != null){
						this.dtcPartNoCash.text = mapObj[keylist.getItemAt(112)];
					}
					if(mapObj[keylist.getItemAt(113)] != null){
						this.dtcExtStlAccCash.text = mapObj[keylist.getItemAt(113)];
					}
					if(mapObj[keylist.getItemAt(114)] != null){
						this.priorityCash.text = mapObj[keylist.getItemAt(114)];
					}
					if(mapObj[keylist.getItemAt(115)] != null){
						this.placeOfStlCash.text = mapObj[keylist.getItemAt(115)];
					}
					if(mapObj[keylist.getItemAt(116)] != null){
						this.partIdCash.text = mapObj[keylist.getItemAt(116)];
					}
					if(mapObj[keylist.getItemAt(144)] != null){
						this.partId2Cash.text = mapObj[keylist.getItemAt(144)];
					}
				}
				
	        }
	        
	        private function commonResultPart(mapObj:Object):void{
	        	
	        	fundPkStr = mapObj[keylist.getItemAt(101)].toString();
			    accPkStr = mapObj[keylist.getItemAt(102)].toString();
			    invAccPkStr = mapObj[keylist.getItemAt(103)].toString();
			    finInstPkStr = mapObj[keylist.getItemAt(100)].toString();
			    instPkStr = mapObj[keylist.getItemAt(104)].toString();
			    
			    this.uConfFundCode.text = mapObj[keylist.getItemAt(0)];
			    this.uConfSecurityCode.text = mapObj[keylist.getItemAt(1)];
			    this.uConfFundAccNo.text = mapObj[keylist.getItemAt(2)];
			    this.uConfAltSecCode.text = mapObj[keylist.getItemAt(3)];
			    this.uConfFundAccName.text = mapObj[keylist.getItemAt(4)];
			    this.uConfSecName.text = mapObj[keylist.getItemAt(5)];
			    if(!XenosStringUtils.isBlank(mapObj[keylist.getItemAt(6)]) && !XenosStringUtils.isBlank(mapObj[keylist.getItemAt(105)])){
			    	this.uConfRefNo.text = mapObj[keylist.getItemAt(6)]+"-"+mapObj[keylist.getItemAt(105)];
			    }else{
			    	this.uConfRefNo.text = "";
			    }
			    this.uConfStatus.text = mapObj[keylist.getItemAt(7)];
			    this.uConfTradeType.text = mapObj[keylist.getItemAt(8)];
			    this.uConfOmsExecNo.text = mapObj[keylist.getItemAt(9)];
			    this.uConfOgRefNo.text = mapObj[keylist.getItemAt(10)];
			   	this.uConfOmsOrderNo.text = mapObj[keylist.getItemAt(11)];
			   this.uConfBuySellFlag.text = mapObj[keylist.getItemAt(12)];
			    this.uConfMatchStatus.text = mapObj[keylist.getItemAt(13)];
			    this.uConfAccNo.text = mapObj[keylist.getItemAt(14)];
			    this.uConfCpName.text = mapObj[keylist.getItemAt(15)];
			    this.uConfBrokerOgCode.text = mapObj[keylist.getItemAt(16)];
			    this.uConfPrincipalAgentFlag.text = mapObj[keylist.getItemAt(17)];
			    this.uConfTradeDate.text = mapObj[keylist.getItemAt(18)];
			    this.uConfTradeTime.text = mapObj[keylist.getItemAt(19)];
			    this.uConfValueDate.text = mapObj[keylist.getItemAt(20)];
			    this.uConfInputPrice.text = mapObj[keylist.getItemAt(21)];
			    this.uConfGrossNetType.text = mapObj[keylist.getItemAt(22)];
			    this.uConfInputPriceFormat.text = mapObj[keylist.getItemAt(23)];
			    this.uConfYieldPriceConvType.text = mapObj[keylist.getItemAt(24)];
			    this.uConfTradeCcy.text = mapObj[keylist.getItemAt(25)];
			    this.uConfStlCcy.text = mapObj[keylist.getItemAt(26)];
			    this.uConfIssueCcy.text = mapObj[keylist.getItemAt(27)];
			    this.uConfExchngRate.text = mapObj[keylist.getItemAt(28)];
			    this.uConfExchngRateIssuePricing.text = mapObj[keylist.getItemAt(29)];
			    this.uConfPrice.text = mapObj[keylist.getItemAt(30)];
			    this.uConfQuantity.text = mapObj[keylist.getItemAt(31)];
			    this.uConfPrincipalAmt.text = mapObj[keylist.getItemAt(32)];
			    this.uConfPrincipalAmtInIssue.text = mapObj[keylist.getItemAt(33)];
			    this.uConfCurrentFaceValue.text = mapObj[keylist.getItemAt(34)];
			    this.uConfAccrIntAmt.text = mapObj[keylist.getItemAt(35)];
			    this.uConfInterestAmt.text = mapObj[keylist.getItemAt(36)];
			    this.uConfAccrStartDate.text = mapObj[keylist.getItemAt(37)];
			    this.uConfTotalTaxFee.text = mapObj[keylist.getItemAt(38)];
			    this.uConfAccrDays.text = mapObj[keylist.getItemAt(39)];
			    this.uConfNetAmt.text = mapObj[keylist.getItemAt(40)];
			    this.uConfNetAmtInTrdCcy.text = mapObj[keylist.getItemAt(41)];
			    this.uConfPoolFactor.text = mapObj[keylist.getItemAt(42)];
			    this.uConfRemarks.text = mapObj[keylist.getItemAt(43)];
			    this.uConfEntryDate.text = mapObj[keylist.getItemAt(44)];
			    this.uConfLastEntryDate.text = mapObj[keylist.getItemAt(45)];
			    this.uConfCreatedBy.text = mapObj[keylist.getItemAt(46)];
			    this.uConfUpdatedBy.text = mapObj[keylist.getItemAt(47)];
			    this.uConfCreationDate.text = mapObj[keylist.getItemAt(48)];
			    this.uConfUpdateDate.text = mapObj[keylist.getItemAt(49)];
			    this.uConfExtRefNo.text = mapObj[keylist.getItemAt(50)];
			    this.uConfBrokerRefNo.text = mapObj[keylist.getItemAt(51)];
			    this.uConfBasketId.text = mapObj[keylist.getItemAt(52)];
			    this.uConfProjectNo.text = mapObj[keylist.getItemAt(53)];
			    this.uConfExecMarket.text = mapObj[keylist.getItemAt(54)];
			    this.uConfExecMethod.text = mapObj[keylist.getItemAt(55)];
			    this.uConfDataSrc.text = mapObj[keylist.getItemAt(56)];
			    this.uConfStartEndType.text = mapObj[keylist.getItemAt(59)];
			    this.uConfExCouponFlag.text = mapObj[keylist.getItemAt(60)];
			    this.uConfDirtyPriceFlag.text = mapObj[keylist.getItemAt(61)];
			    this.uConfStipulation.text = mapObj[keylist.getItemAt(62)];
			    this.uConfSenderRefNo.text = mapObj[keylist.getItemAt(63)];
			    this.uConfNegAccIntFlag.text = mapObj[keylist.getItemAt(64)];
			    this.uConfTipsAdjustPrice.text = mapObj[keylist.getItemAt(65)];
			    this.uConftipsIndexAccruedInitDate.text = mapObj[keylist.getItemAt(66)];
			    this.uConfTipsIndexVd.text = mapObj[keylist.getItemAt(67)];
			    this.uConfprefiguredPrincipalFlag.text = mapObj[keylist.getItemAt(68)];
			    this.uConfStepInOutFlag.text = mapObj[keylist.getItemAt(69)];
			    this.uConfTrdMatchType.text = mapObj[keylist.getItemAt(70)];
			    this.uConfTrdConfReqd.text = mapObj[keylist.getItemAt(71)];
			    this.uConfExcludeFromNetting.text = mapObj[keylist.getItemAt(72)];
			    this.uConfTraceEligibleFlag.text = mapObj[keylist.getItemAt(73)];
			    this.uConfformTEligibleFlag.text = mapObj[keylist.getItemAt(74)];
			    this.uConfFwrdRepoFlag.text = mapObj[keylist.getItemAt(75)];
			    this.uConfReportForRemarks.text = mapObj[keylist.getItemAt(76)];
			    this.uConfAffirmSppressFlag.text = mapObj[keylist.getItemAt(77)];
			    this.uConfInstructionSuppressFlag.text = mapObj[keylist.getItemAt(78)];
			    this.uConfMatchExclusionFlag.text = mapObj[keylist.getItemAt(79)];
			    this.uConfSoftDollarFlag.text = mapObj[keylist.getItemAt(80)];
			    tax = new ArrayCollection();
			    if(mapObj[keylist.getItemAt(81)] != null){
			    	initcol = (mapObj[keylist.getItemAt(81)]) as ArrayCollection;
			    	if(initcol != null){
			    		try {
		                      for each ( var item:XML in initcol) {
		                          tax.addItem(item);
		                      }
		                  uConfTaxFeeGrid.visible = true;
		                  uConfTaxFeeGrid.includeInLayout = true;
		                  }catch(e:Error){
		                      XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.load.taxfeelist'));
		                }
			    	}
			    }
			    tax.refresh();
			    
			    this.uConfCashSecFlagSec.text = mapObj[keylist.getItemAt(82)];
			    this.uConfBrokerBicSec.text = mapObj[keylist.getItemAt(83)];
			    this.uConfAcronymSec.text = mapObj[keylist.getItemAt(84)];
			    this.uConfSecurityTypeSec.text = mapObj[keylist.getItemAt(85)];
			    this.uConfCcySec.text = mapObj[keylist.getItemAt(86)];
			    this.uConfStlTypeSec.text = mapObj[keylist.getItemAt(87)];
			    
			    this.uConfBankNameSec.text = mapObj[keylist.getItemAt(88)];
			    this.uConfContraIdSec.text = mapObj[keylist.getItemAt(89)];
			    this.uConfDtcPartNoSec.text = mapObj[keylist.getItemAt(90)];
			    this.uConfDtcExtStlAccSec.text = mapObj[keylist.getItemAt(91)];
			    this.uConfPrioritySec.text = mapObj[keylist.getItemAt(92)];
			    this.uConfPlaceOfStlSec.text = mapObj[keylist.getItemAt(93)];
			    this.uConfPartIdSec.text = mapObj[keylist.getItemAt(94)];
			    this.uConfPartId2Sec.text = mapObj[keylist.getItemAt(145)];
			    
			    this.uConfCashSecFlagCash.text = mapObj[keylist.getItemAt(95)];
			    this.uConfBrokerBicCash.text = mapObj[keylist.getItemAt(96)];
			    this.uConfAcronymCash.text = mapObj[keylist.getItemAt(97)];
			    this.uConfSecurityTypeCash.text = mapObj[keylist.getItemAt(98)];
			    this.uConfCcyCash.text = mapObj[keylist.getItemAt(99)];
			    this.uConfStlTypeCash.text = mapObj[keylist.getItemAt(109)];
			    this.uConfBankNameCash.text = mapObj[keylist.getItemAt(110)];
			    
			    this.uConfContraIdCash.text = mapObj[keylist.getItemAt(111)];
			    this.uConfDtcPartNoCash.text = mapObj[keylist.getItemAt(112)];
			    this.uConfDtcExtStlAccCash.text = mapObj[keylist.getItemAt(113)];
			    this.uConfPriorityCash.text = mapObj[keylist.getItemAt(114)];
			    this.uConfPlaceOfStlCash.text = mapObj[keylist.getItemAt(115)];
			    this.uConfPartIdCash.text = mapObj[keylist.getItemAt(116)];
			    this.uConfPartId2Cash.text = mapObj[keylist.getItemAt(144)];
			    

			    this.uConfMatchingSuppressFlag.text = mapObj[keylist.getItemAt(140)];
			    this.uConfDirectedBrokerFlag.text = mapObj[keylist.getItemAt(154)];
			    this.uConfDirectedBroker.text = mapObj[keylist.getItemAt(155)];
			    this.uConfFundName.text = mapObj[keylist.getItemAt(156)];
			    this.uConfOriginalDataSource.text = mapObj[keylist.getItemAt(157)];
	        }
	        
	        private function commonResult(mapObj:Object):void{
		    	if(mapObj!=null){  
			    	if(mapObj["errorFlag"].toString() == "error"){
			    		errPage.showError(mapObj["errorMsg"]);		    			
			    	}else if(mapObj["errorFlag"].toString() == "noError"){
			    	 errPage.clearError(super.getSaveResultEvent());
			    	 app.submitButtonInstance = uConfSubmit;			    			
		             commonResultPart(mapObj);
					 changeCurrentState();
			    	}else{
			    		errPage.removeError();
			    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			    	}    		
		    	}
	        }
        
       
        
    	private function setValidator():void{
		
		  var trdValidationModel:Object={
                            tradeEntry:{
                            	isSpecialAmend:this.mode == Globals.MODE_SPCL_AMEND ? "true":"false",
                            	omsOrderNo:StringUtil.trim(this.omsOrderNo.text) != null ? StringUtil.trim(this.omsOrderNo.text):"",
                            	omsExecutionNo:StringUtil.trim(this.omsExecutionNo.text) != null ? StringUtil.trim(this.omsExecutionNo.text):"",
                            	originalDataSource:this.originalDataSource.selectedItem != null ? this.originalDataSource.selectedItem.value : "" 
                            }
                           }; 
                    
                    super._validator = new TradeEntryValidator();
	         		super._validator.source = trdValidationModel ;
	         		super._validator.property = "tradeEntry";
		}
		 
		
		override public function preConfirmAmendResultHandler():Object{
			return preAmendResultInit();
		}

		private function submitUserConfResult(mapObj:Object):void{
	    	if(mapObj!=null){    
		    	if(mapObj["errorFlag"].toString() == "error"){
		    		uConfSubmit.enabled = true;
		    		usrConfErrPage.showError(mapObj["errorMsg"]);
		    	}else if(mapObj["errorFlag"].toString() == "noError"){
		    	   if(mode!="cancel")
		    		  errPage.clearError(super.getConfResultEvent());
		    	   usrConfErrPage.clearError(super.getConfResultEvent());
		    	   commonResultPart(mapObj);
		    	   this.back.includeInLayout = false;
		    	   this.back.visible = false;
		    	   this.backUsrConf.visible = false;
		    	   this.backUsrConf.includeInLayout = false;
				   uConfSubmit.enabled = true;
	               uConfLabel.includeInLayout = false;
	               uConfLabel.visible = false;
	               uConfSubmit.includeInLayout = false;
	               uConfSubmit.visible = false;
	               hb.visible = true;
	               hb.includeInLayout = true;
	               sConfLabel.includeInLayout = true;
	               sConfLabel.visible = true;
	               sConfSubmit.includeInLayout = true;
	               sConfSubmit.visible = true;
	               app.submitButtonInstance = sConfSubmit;
		    	}else{
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('trd.error.occurred'));
		    	}    		
	    	}
	    }
	    
    
   /**
    * This method will populate the request parameters for the
    * submission of trade entry (FINAL) screen and bind the parameters 
    * with the HTTPService object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	reqObj.rnd = Math.random()+"";
    	reqObj.method= "confirmEntry";
    	if(XenosStringUtils.equals(this.mode,Globals.MODE_SPCL_AMEND)){
    		reqObj['SCREEN_KEY'] = "11184";
    	}
    	reqObj.mode = this.mode;
    	reqObj['tradeScreenData.matchingSupressFlag'] = this.matchingSuppressFlag.selectedItem != null ? this.matchingSuppressFlag.selectedItem.value : "";
    	reqObj['tradeScreenData.originalDataSource'] = this.originalDataSource.selectedItem != null ? this.originalDataSource.selectedItem.value : "";
    	reqObj['tradeScreenData.directedBrokerFlag'] = this.directedBrokerFlag.selectedItem != null ? this.directedBrokerFlag.selectedItem.value : "";
    	reqObj['tradeScreenData.directedBroker'] = this.directedBroker.text;
    	reqObj['tradeScreenData.orderReferenceNo'] = this.omsOrderNo.text;
    	reqObj['tradeScreenData.brokerReferenceNo'] = this.brokerRefNo.text;
    	reqObj['tradeScreenData.etcReferenceNo'] = this.ogRefNo.text;
    	reqObj['tradeScreenData.omsExecutionNo'] = this.omsExecutionNo.text;
    	//reqObj['tradeScreenData.senderReferenceNo'] = this.senderRefNo.text;
    	//reqObj['tradeScreenData.externalReferenceNo'] = this.externalRefNo.text;
    	reqObj['tradeScreenData.softDollarFlag'] = this.softDollarFlag.selectedItem != null ? this.softDollarFlag.selectedItem.value : "";
    	
    	return reqObj;
    }
    
    private function populateReqFromMandatoryEntryScreen():Object {
    	reqObj = new Object();
    	reqObj.rnd = Math.random()+"";
    	reqObj.method= "populate";
    	reqObj['SCREEN_KEY'] = "40";
    	reqObj['tradeScreenData.matchingSupressFlag'] = this.matchingSuppressFlag.selectedItem != null ? this.matchingSuppressFlag.selectedItem.value : "";
    	return reqObj;
    }
    
   
	  private function doBack():void{
	  	app.submitButtonInstance = submitAddlEntry;
	  	usrConfErrPage.clearError(super.getConfResultEvent());
	    vstack.selectedChild = qry;
	  } 
	  
	  private function doEntryBack():void{
	  	var reqObj:Object = new Object();
	  	reqObj.rnd = Math.random()+"";
	  	if( XenosStringUtils.equals(this.mode,Globals.MODE_SPCL_AMEND) ){
	  		reqObj.SCREEN_KEY = "11181";
	  		backToFirstEntryScreenRequestForAmend.request = reqObj;
        	backToFirstEntryScreenRequestForAmend.send();
	  	}
	  }
	  
	  private function loadFirstEntryScreenFromSecondHandler(event:ResultEvent):void{
	  	
	  }
	    
	    private function doSubmit():void{
	    	this.dispatchEvent(new Event('amendEntrySave'));
	    }
	    
	    private function doSave():void{
	    	uConfSubmit.enabled = false;
	    	this.dispatchEvent(new Event('amendEntryConf'));
	    }
	    
	    private function doReset():void{
	    	var reqObj:Object = new Object();
	    	if(XenosStringUtils.equals(this.mode,Globals.MODE_SPCL_AMEND)){
	    		this.dispatchEvent(new Event('amendEntryReset'));
	    	}
	    }
		/**
		 *  Function to set visibility
		 * 
		 */
		private function setVisibility(obj:Object,isVisible:Boolean,isIncludeInLayout:Boolean):void{
			obj.visible = isVisible;
			obj.includeInLayout = isIncludeInLayout;
		}
		
		private function showHideFields():void{
			if(XenosStringUtils.equals(this.mode,Globals.MODE_SPCL_AMEND)){
				setVisibility(this.back,false,false);
				setVisibility(this.entryCriteria,false,false);
				setVisibility(this.firstSubmitPanel,false,false);
				setVisibility(this.specialAmendCriteria,true,true);
			}
		}
	    
      /**
	   * This method is used for loading FinInstPopUp module 
	   * 
	   */  
	   private function showFinInstPopUp():void{
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			XenosPopupUtils.showFinInstDetails(finInstPkStr,parentApp);
	   }
	   /**
	   * This method is used for loading Fund Code popup module
	   * 
	   */  
	   private function showFundCode():void{
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			XenosPopupUtils.showFundCodeDetails(fundPkStr,parentApp);
	   }
	   /**
	   * This method is used for loading Account Details popup module
	   * 
	   */  
	   private function showAccountDetail():void{
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			XenosPopupUtils.showAccountSummary(accPkStr,parentApp);
	   }
	   /**
	   * This method is used for loading Inventory Account Details popup module
	   * 
	   */  
	   private function showInventoryAccountDetail():void{
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			XenosPopupUtils.showAccountSummary(invAccPkStr,parentApp);
	   }
	   /**
	   * This method is used for loading Instrument Details popup module
	   * 
	   */  
	   private function showInstrumentDetail():void{
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			XenosPopupUtils.showInstrumentDetails(instPkStr, parentApp);
	   }
	       
       private function setFocusOnParent(event:Event):void{
        (TextInput(event.currentTarget)).setFocus();
        (TextInput(event.currentTarget)).removeEventListener(FlexEvent.VALUE_COMMIT,setFocusOnParent);
       }
       	     
