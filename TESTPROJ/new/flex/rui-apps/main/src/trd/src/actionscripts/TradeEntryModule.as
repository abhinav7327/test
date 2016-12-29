		// ActionScript file for Trade Entry Module
		import com.nri.rui.core.Globals;
		import com.nri.rui.core.controls.XenosAlert;
		import com.nri.rui.core.controls.XenosEntry;
		import com.nri.rui.core.startup.XenosApplication;
		import com.nri.rui.core.utils.DateUtils;
		import com.nri.rui.core.utils.HiddenObject;
		import com.nri.rui.core.utils.NumberUtils;
		import com.nri.rui.core.utils.OnDataChangeUtil;
		import com.nri.rui.core.utils.XenosPopupUtils;
		import com.nri.rui.core.utils.XenosStringUtils;
		import com.nri.rui.ref.popupImpl.TrdSsiPopup;
		import com.nri.rui.trd.validator.TradeEntryValidator;
		
		import flash.events.Event;
		import flash.events.FocusEvent;
		
		import mx.collections.ArrayCollection;
		import mx.controls.Label;
		import mx.core.FlexTextField;
		import mx.core.UIComponent;
		import mx.events.CloseEvent;
		import mx.events.FlexEvent;
		import mx.events.ResourceEvent;
		import mx.events.ValidationResultEvent;
		import mx.managers.FocusManager;
		import mx.managers.PopUpManager;
		import mx.resources.ResourceBundle;
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
		    private var indxRatioTempStr : String = "";
		    private var principalAmtTemp:String = "";
		    private var ipPriceStr : String = "";
		     private var datasourceStr : String = "";
		     private var instrumentTypeParent : String = "";
	  
			  private function changeCurrentState():void{
			  	//XenosAlert.info("Inside change state");
				vstack.selectedChild = rslt;
			  }
			 
		/**
         * Load the Entry/Amend/Cancel according to
         * the operational mode (e.g. Entry/Amend/Cancel)
         */
		   public function loadAll():void{
	       	   parseUrlString();
	       	   super.setXenosEntryControl(new XenosEntry());
	           tradeCcy.ccyText.addEventListener(FocusEvent.FOCUS_OUT,checkTradeCcy);
		       tradeCcy.imgCcy.addEventListener(MouseEvent.CLICK,trdImgClickHandler);
	           executionMarket.addEventListener(Event.CHANGE,checkExecutionMarket);
	           securityCode.instrumentPopup.addEventListener(MouseEvent.CLICK,securityImgClickHandler);
	           securityCode.instrumentId.addEventListener(FocusEvent.FOCUS_OUT,checkSecurity);
			   	           
	       	   if(this.mode == 'entry'){
	       	   	 app.submitButtonInstance = submit;	       	   	
	       	   	 this.dispatchEvent(new Event('entryInit'));
	       	   	 fundAccountPopup.accountNo.addEventListener(FlexEvent.VALUE_COMMIT, onChangeFundAccountNo);
		         brokerAccPopUp.accountNo.addEventListener(FlexEvent.VALUE_COMMIT, onChangeBrokerAccountNo);
		         securityCode.instrumentId.addEventListener(FlexEvent.VALUE_COMMIT, onChangeSecurityCode);
	       	   	 vstack.selectedChild = qry;
	       	   } else if(this.mode == 'amendment'){
	       	   	 app.submitButtonInstance = submitAddlEntry;
	       	   	 this.isInFirstEntryScreen = false;
	       	   	 this.dispatchEvent(new Event('amendEntryInit'));
	       	   	 vstack.selectedChild = qry;
	       	   	 fundAccountPopup.accountNo.addEventListener(FlexEvent.VALUE_COMMIT, onChangeFundAccountNo);
		         brokerAccPopUp.accountNo.addEventListener(FlexEvent.VALUE_COMMIT, onChangeBrokerAccountNo);
		         securityCode.instrumentId.addEventListener(FlexEvent.VALUE_COMMIT, onChangeSecurityCode);
	       	   	 fundAccNoTxt.addEventListener(FlexEvent.VALUE_COMMIT, onChangeFundAccountNoTxt);
	       	   	 brokerAccNoTxt.addEventListener(FlexEvent.VALUE_COMMIT, onChangeBrokerAccountNoTxt);
	       	   	 securityCodeTxt.addEventListener(FlexEvent.VALUE_COMMIT, onChangeSecurityCodeTxt);
	       	   } else { 
	       	   	 app.submitButtonInstance = cancelSubmit;
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
            * Trade Entry Screen (InitEntry-SEQ-1)
            */
            override public function preEntryInit():void{            	
		        var rndNo:Number= Math.random();
		        var reqObject:Object = new Object(); 
            	super.getInitHttpService().url = "trd/tradeEntry.action?";
            	reqObject.rnd = rndNo;
            	reqObject.method= "view";
            	reqObject.mode="entry";
            	reqObject.menuType="Y";
            	reqObject.SCREEN_KEY = "40";
            	super.getInitHttpService().request = reqObject;
            }
            
            /**
            * This method fires the dispatchaction to initialize the
            * Trade Amend Screen (InitAmend-SEQ-1)
            */
            override public function preAmendInit():void{  
            	vstack.selectedChild = qry;
            	var rndNo:Number= Math.random(); 
            	var reqObject:Object = new Object();
            	initLabel.text = this.parentApplication.xResourceManager.getKeyValue('trd.amendment.info');       	
            	super.getInitHttpService().url = "trd/tradeAmend.action?";
            	reqObject.rnd = rndNo;
            	reqObject.method= "loadTradeDetails";
		  		reqObject.mode=this.mode;
		  		reqObject.tradePk = this.tradePkStr;
		  		reqObject.updateDate = this.updateDateStr;
		  		reqObject.SCREEN_KEY = "44";
		  		super.getInitHttpService().request = reqObject; 
            }
            
            /**
            * This method fires the dispatchaction to initialize the
            * Trade Cancel Screen (InitCancel-SEQ-1)
            */
            override public function preCancelInit():void{
		        this.back.includeInLayout = false;
			    this.back.visible = false;
			    changeCurrentState(); 
			    uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('trd.cancel.user.conf');			             	
		        var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "trd/tradeQueryResultCancel.action?";
            	var reqObject:Object = new Object();
            	reqObject.rnd = rndNo;
            	reqObject.method= "viewTradeDetails";
		  		reqObject.mode=this.mode;
		  		reqObject.tradePk = this.tradePkStr;
		  		reqObject.updateDate = this.updateDateStr;
		  		reqObject.SCREEN_KEY = "45";
		  		super.getInitHttpService().request = reqObject; 
            }
        
	        /**
            * This method is pre-result handler for the Trade Entry
            * Screen. It generates the list of keys which will be populated 
            * during the initialization of the Trade Entry screen. 
            * (InitEntry-SEQ-2)
            */
	        override public function preEntryResultInit():Object{
	        	addCommonKeys(); 
	        	return keylist;
	        }
	        
	        /**
	        * This method adds the common keys to a list
	        * which will be populated for both entry and amend
	        */
	        private function addCommonKeys():void{        	
		    	keylist = new ArrayCollection();
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
		    	keylist.addItem("tradeScreenData.plSuppressFlagValues.item");
		    	
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
		    	keylist.addItem("tradeScreenData.securitySsi.participantId2");
		    	keylist.addItem("tradeScreenData.calculationTypeIssuePricing");
		    	keylist.addItem("tradeScreenData.matchExclusionFlagValues.item");
		    	keylist.addItem("reasonList.item");
		    	keylist.addItem("reason");
		    	keylist.addItem("tradeScreenData.instrumentCodeType");
		    	keylist.addItem("tradeScreenData.instructionSuppressFlag");
		    	keylist.addItem("tradeScreenData.remarksList.remarks");
		    	keylist.addItem("tradeScreenData.origDataSource");
		    	keylist.addItem("tradeScreenData.instrumentTypeParent");
		    	keylist.addItem("tradeScreenData.plSuppressFlag");	  
		    	keylist.addItem("tradeScreenData.plSuppressFlagValues.item");
		    	keylist.addItem("tradeScreenData.indexRatioStr"); 
	        	return keylist;
	        }
	        
	        /**
            * This method is pre-result handler for the Trade Cancel
            * Screen. It generates the list of keys which will be populated 
            * during the initialization of the Trade Cancel screen. 
            * (InitCancel-SEQ-2)
            */
	        override public function preCancelResultInit():Object{
	        	addCommonResultKeys();
	        	keylist.addItem("tradeScreenData.cashSsi.participantId2");
		    	keylist.addItem("tradeScreenData.securitySsi.participantId2");  
		    	
		    	keylist.addItem("tradeScreenData.ssiIntermediary.cpSecurityFlag");
		    	keylist.addItem("tradeScreenData.ssiIntermediary.cpSecBrokerBic"); 
		    	keylist.addItem("tradeScreenData.ssiIntermediary.cpSecGlobalCustodianBic");
		    	keylist.addItem("tradeScreenData.ssiIntermediary.cpSecGlobalCustodianName");
		    	keylist.addItem("tradeScreenData.ssiIntermediary.cpSecSettlementAccount");
		    	keylist.addItem("tradeScreenData.ssiIntermediary.cpSecLocalCustodianBic");
		    	keylist.addItem("tradeScreenData.ssiIntermediary.cpSecLocalCustodianName");
		    	keylist.addItem("tradeScreenData.ssiIntermediary.cpSecPlaceOfSettlement");
		    	keylist.addItem("tradeScreenData.ssiIntermediary.cpSecParticipantId");
		    	keylist.addItem("tradeScreenData.ssiIntermediary.cpSecParticipantId2"); 
		    	
		    	keylist.addItem("tradeScreenData.ssiIntermediary.cpCashFlag");
		    	keylist.addItem("tradeScreenData.ssiIntermediary.cpCashBrokerBic"); 
		    	keylist.addItem("tradeScreenData.ssiIntermediary.cpCashGlobalCustodianBic");
		    	keylist.addItem("tradeScreenData.ssiIntermediary.cpCashGlobalCustodianName");
		    	keylist.addItem("tradeScreenData.ssiIntermediary.cpCashSettlementAccount");
		    	keylist.addItem("tradeScreenData.ssiIntermediary.cpCashLocalCustodianBic");
		    	keylist.addItem("tradeScreenData.ssiIntermediary.cpCashLocalCustodianName");
		    	keylist.addItem("tradeScreenData.ssiIntermediary.cpCashPlaceOfSettlement");
		    	keylist.addItem("tradeScreenData.ssiIntermediary.cpCashParticipantId");
		    	keylist.addItem("tradeScreenData.ssiIntermediary.cpCashParticipantId2");    
		    	keylist.addItem("tradeScreenData.fundName");  	
		    	keylist.addItem("tradeScreenData.plSuppressFlag");
		    	keylist.addItem("tradeScreenData.indexRatioStr");	  
	        	return keylist;
	        }
	        
	        
	        /**
	        * This method populates the elements of the
	        * Trade Entry screen(mxml)
	        * from the map obtained from preEntryResultInit() (InitEntry-SEQ-3)
	        */
	        override public function postEntryResultInit(mapObj:Object): void{
	        	viewSsiNotForCancel.visible = true;
	        	viewSsiNotForCancel.includeInLayout = true;
	        	viewSsiForCancel.visible = false;
	        	viewSsiForCancel.includeInLayout = false;
	        	if(isInFirstEntryScreen){
	        		this.additionalEntryCriteria.visible = false;
	        		this.additionalEntryCriteria.includeInLayout = false;
	        		this.upBack.visible = false;
	        		this.upBack.includeInLayout = false;
	        		cpSecSsiPk.text = XenosStringUtils.EMPTY_STR;
	        		cpCashSsiPk.text = XenosStringUtils.EMPTY_STR;
	        	}
	        	commonInit(mapObj);
	        	showHideFields();
	        	
	        	
	        }
	        
	        /**
	        * This method populates the elements of the 
	        * Trade Amend screen(mxml)
	        * from the map obtained from preAmendResultInit() (InitAmend-SEQ-3)
	        */
	        override public function postAmendResultInit(mapObj:Object): void{
	        	this.additionalEntryCriteria.visible = true;
        		this.additionalEntryCriteria.includeInLayout = true;
        		this.upBack.label = 'Amend';
        		this.back.label = 'Amend';
        		this.remarksLbl.styleName = 'ReqdLabel';
        		this.upBack.visible = true;
        		this.upBack.includeInLayout = true;
        		viewSsiNotForCancel.visible = true;
	        	viewSsiNotForCancel.includeInLayout = true;
	        	viewSsiForCancel.visible = false;
	        	viewSsiForCancel.includeInLayout = false;
	        	this.matchExclusionFlag.visible = true;
	        	this.matchExclusionFlag.includeInLayout = true;
	        	this.matchExclusionFlagLbl.visible = true;
	        	this.matchExclusionFlagLbl.includeInLayout = true;
	        	app.submitButtonInstance = submitAddlEntry;
	        	
	        	amendInit(mapObj);
	        }
	        
	        /**
	        * This method populates the elements of the
	        * Trade Cancel screen(mxml)
	        * from the map obtained from preCancelResultInit() (InitCancel-SEQ-3)
	        */
	        override public function postCancelResultInit(mapObj:Object): void{
	        		
	            commonResultPart(mapObj);
	        	uConfLabel.text=this.parentApplication.xResourceManager.getKeyValue('trd.cancel.user.conf1');
	        	uConfSubmit.includeInLayout = false;
	        	uConfSubmit.visible = false;
	        	cancelSubmit.visible = true;
	        	cancelSubmit.includeInLayout = true;
	        	backUsrConf.visible = false;
	        	backUsrConf.includeInLayout = false;
	        	viewSsiNotForCancel.visible = false;
	        	viewSsiNotForCancel.includeInLayout = false;
	        	viewSsiForCancel.visible = true;
	        	viewSsiForCancel.includeInLayout = true;
	        }
	        
	        override public function preEntry():void{
			 	setValidator();
			 	super.getSaveHttpService().url = "trd/tradeEntry.action?";  
	            super.getSaveHttpService().request = populateRequestParams();
	            super.getSaveHttpService().method = "POST";
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
			 
			 override public function preEntryResultHandler():Object {
			 	//XenosAlert.info("Inside Entry Result Handler ");
				 addCommonResultKeys();
				 keylist.addItem("tradeScreenData.cashSsi.participantId2");
		    	 keylist.addItem("tradeScreenData.securitySsi.participantId2");
		    	 keylist.addItem("tradeScreenData.fundName");
		    	 keylist.addItem("tradeScreenData.plSuppressFlag");
		    	 keylist.addItem("tradeScreenData.indexRatioStr");//index ratio(position: 122)
				 return keylist;
			}
			
			override public function postEntryResultHandler(mapObj:Object):void
			{
				commonResult(mapObj);
			}
			 
			 override public function preAmend():void{
			 	var reqObj:Object = new Object();
			 	setValidator();
			 	super.getSaveHttpService().url = "trd/tradeEntryAmend.action?";  
			 	reqObj = populateRequestParams();
			 	reqObj.mode = this.mode;
			 	super.getSaveHttpService().method = "POST";
	            super.getSaveHttpService().request = reqObj; 	
			 } 
			 
			override public function preAmendResultHandler():Object
			{
				addCommonResultKeys();
				keylist.addItem("tradeScreenData.cashSsi.participantId2");
		    	keylist.addItem("tradeScreenData.securitySsi.participantId2");
		    	keylist.addItem("tradeScreenData.fundName");
		    	keylist.addItem("tradeScreenData.plSuppressFlag");
		    	keylist.addItem("tradeScreenData.indexRatioStr"); 
				return keylist;
			} 
			
			override public function postCancelResultHandler(mapObj:Object):void
			{
				submitUserConfResult(mapObj);
				
				uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('trd.cancel.user.conf2');
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
			} 
			
			
			
			override public function postAmendResultHandler(mapObj:Object):void
			{
				this.uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('trd.amend.user.conf');
				commonResult(mapObj);
			}
			 
			 
			
			override public function preEntryConfirm():void
			{
				var reqObj :Object = new Object();
				super.getConfHttpService().url = "trd/tradeEntry.action?"; 
				reqObj.rnd = Math.random()+"";
				reqObj.SCREEN_KEY = "46";
				reqObj.method= "insertTrade";
	            super.getConfHttpService().request = reqObj;
			}
			
			override public function preAmendConfirm():void
			{
				 var reqObj :Object = new Object();
				super.getConfHttpService().url = "trd/tradeAmend.action?";
				reqObj.rnd = Math.random()+"";
				reqObj.SCREEN_KEY = "11079";
				reqObj.method= "tradeAmendPerform";
				super.getConfHttpService().method= "POST";
	            super.getConfHttpService().request = reqObj; 
			}
			
			override public function postConfirmEntryResultHandler(mapObj:Object):void
			{
				submitUserConfResult(mapObj);
			}
			override public function postConfirmAmendResultHandler(mapObj:Object):void
			{
				this.sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('trd.amend.system.conf');
				submitUserConfResult(mapObj);
			}
			override public function postConfirmCancelResultHandler(mapObj:Object):void
			{
				submitUserConfResult(mapObj);
				sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('trd.cancel.system.conf1');
				sConfLabel.includeInLayout = true;
				sConfLabel.visible = true;
	        	cancelSubmit.visible = false;
	        	cancelSubmit.includeInLayout = false; 
	            uCancelConfSubmit.visible = false;
	        	uCancelConfSubmit.includeInLayout = false;
	        	uConfLabel.includeInLayout = false;
				uConfLabel.visible = false;
			}
	        
	        override public function preResetEntry():void
		   {
		        var rndNo:Number= Math.random();
		  		super.getResetHttpService().url = "trd/tradeEntry.action?method=view&rnd=" + rndNo; 
		   }
		   override public function preResetAmend():void
		   {
				var reqObj:Object = new Object();
				super.getResetHttpService().url = "trd/tradeAmend.action?";
				reqObj.rnd = Math.random()+ "";
				reqObj.tradePk = this.tradePkStr;
				reqObj.updateDate = this.updateDateStr;
				reqObj.method = "loadTradeDetails";
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
       	   	 this.additionalEntryCriteria.visible = true;
       	   	 this.additionalEntryCriteria.includeInLayout = true;
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
	        
	        
	        private function commonInit(mapObj:Object):void{
	        	errPage.clearError(super.getInitResultEvent());
	        	this.matchExclusionFlag.visible = false;
	        	this.matchExclusionFlag.includeInLayout = false;
	        	this.matchExclusionFlagLbl.visible = false;
	        	this.matchExclusionFlagLbl.includeInLayout = false;
	        	this.cxlReasonCodeRow.visible = false;
        		this.cxlReasonCodeRow.includeInLayout = false;
	        	hb.visible = false;
	            hb.includeInLayout = false;
	            backUsrConf.visible = true;
	        	backUsrConf.includeInLayout = true;
	            trdCcyStr = "";
		    	issueCcyStr = "";
		    	valDateStr = "";
		    	qtyStr = "";
		    	indxRatioTempStr = "";
		    	ipPriceStr = "";
		    	instrumentTypeParent = XenosStringUtils.EMPTY_STR;
	        	trdTypeStr = XenosStringUtils.EMPTY_STR;
		    	issuePricingRow.visible = false;
		    	issuePricingRow.includeInLayout = false;
		    	tax = new ArrayCollection();
		    	tax.refresh();
	        	/* Populating Trade type drop down*/
	        	initcol = new ArrayCollection();
	        	item = new Object();
	        	initcol.addItem({label:" ",value:" "});
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
		    	this.tradeType.selectedIndex = -1;
		    	
		    	if(mapObj[keylist.getItemAt(1)]!=null){
		    	  this.tradeDate.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(1)].toString());  		
		    	}
		    	
		    	this.tradeTime.text = "";
		    	this.valueDate.selectedDate = null;
		    	
		    	/* Populating Buy/Sell drop down*/
		    	initcol = new ArrayCollection();
		    	item = new Object();
	        	initcol.addItem({label:" ",value:" "});
		    	if(mapObj[keylist.getItemAt(2)]!=null){
		    		if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(2)].toString());
		    		}
		    	}
		    	this.buySellFlag.dataProvider = initcol;
		    	
		    	//XGA-105
		    	/* Populating Short Selling Flag drop down*/
		    	/*
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
		    	this.shortSellFlag.dataProvider = initcol;
		    	*/
		    	
		    	/* Populating Short Sell Exempt Flag drop down*/
		    	//XGA-105
		    	/*
		    	initcol = new ArrayCollection();
		    	item = new Object();
	        	initcol.addItem({label:" ",value:" "});
		    	if(mapObj[keylist.getItemAt(4)]!=null){
		    		if(mapObj[keylist.getItemAt(4)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(4)].toString());
		    		}
		    	}
		    	this.shortSellExemptFlag.dataProvider = initcol;
		    	*/
		    	
		    	this.fundAccountPopup.accountNo.text = "";
		    	this.fundAccName.text = "";
		    	this.brokerAccPopUp.accountNo.text = "";
		    	this.brokerAccName.text = "";
		    	/* Populating Matching Suppress Flag drop down*/
		    	initcol = new ArrayCollection();
		    	item = new Object();
		    	if(mapObj[keylist.getItemAt(5)]!=null){
		    		if(mapObj[keylist.getItemAt(5)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(5)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(5)].toString());
		    		}
		    	}
		    	this.matchingSuppressFlag.dataProvider = initcol;
		    	this.matchingSuppressFlag.selectedIndex = 0;
		    	
		    	this.securityCode.instrumentId.text = "";
		    	this.securityName.text = "";
		    	this.quantity.text = "";
		    	this.inputPrice.text = "";
		    	
		    	/* Populating Gross Net Type drop down*/
		    	initcol = new ArrayCollection();
		    	item = new Object();
		    	if(mapObj[keylist.getItemAt(6)]!=null){
		    		if(mapObj[keylist.getItemAt(6)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(6)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(6)].toString());
		    		}
		    	}
		    	this.grossNetType.dataProvider = initcol;
		    	this.grossNetType.selectedIndex = 0;
		    	
		    	/* Populating Input Price Format Flag drop down*/
		    	initcol = new ArrayCollection();
		    	item = new Object();
		    	index = -1;
	        	initcol.addItem({label:" ",value:" "});
		    	if(mapObj[keylist.getItemAt(7)]!=null){
		    		if(mapObj[keylist.getItemAt(7)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(7)] as ArrayCollection)){
			    			initcol.addItem(item);
			    			if(item.value == 'UNIT PRICE'){
			    				index = (mapObj[keylist.getItemAt(7)] as ArrayCollection).getItemIndex(item);
			    			}
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(7)].toString());
		    			index = 0;
		    		}
		    	}
		    	this.inputPriceFormat.dataProvider = initcol;
		    	this.inputPriceFormat.selectedIndex = index+1;
		    	
		    	this.tradeCcy.ccyText.text = "";
		    	this.executionMarket.text = "";
		    	
		    	/* Populating Execution Method drop down*/
		    	initcol = new ArrayCollection();
		    	item = new Object();
		    	index = -1;
	        	initcol.addItem({label:" ",value:" "});
		    	if(mapObj[keylist.getItemAt(8)]!=null){
		    		if(mapObj[keylist.getItemAt(8)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(8)] as ArrayCollection)){
			    			initcol.addItem(item);
			    			if(item.value == "MARKET"){
			    				index = (mapObj[keylist.getItemAt(8)] as ArrayCollection).getItemIndex(item);
			    			}
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(8)].toString());
		    			index = 0;
		    		}
		    	}
		    	this.executionMethod.dataProvider = initcol;
		    	this.executionMethod.selectedIndex = index+1;
		    	
		    	this.stlCcy.ccyText.text = "";
		    	this.exchangeRate.text = "";
		    	
		    	/* Populating Calculation Type drop down*/
		    	initcol = new ArrayCollection();
		    	item = new Object();
	        	initcol.addItem({label:" ",value:" "});
		    	if(mapObj[keylist.getItemAt(9)]!=null){
		    		if(mapObj[keylist.getItemAt(9)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(9)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(9)].toString());
		    		}
		    	}
		    	this.calculationType.dataProvider = initcol;
		    	
		    	this.issueCcy.text = "";
		    	this.issuePricingExchangeRate.text = "";
		    	
		    	/* Populating Calculation Type for Issue Pricing drop down*/
		    	initcol = new ArrayCollection();
		    	item = new Object();
	        	initcol.addItem({label:" ",value:" "});
		    	if(mapObj[keylist.getItemAt(9)]!=null){
		    		if(mapObj[keylist.getItemAt(9)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(9)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(9)].toString());
		    		}
		    	}
		    	this.issuePricingCalculationType.dataProvider = initcol;
		    	
		    	
		    	/* Populating Excoupon Flag drop down*/
		    	initcol = new ArrayCollection();
		    	item = new Object();
	        	initcol.addItem({label:" ",value:" "});
		    	if(mapObj[keylist.getItemAt(10)]!=null){
		    		if(mapObj[keylist.getItemAt(10)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(10)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(10)].toString());
		    		}
		    	}
		    	this.excouponFlag.dataProvider = initcol;
		    	
		    	/* Populating Dirty Price Flag drop down*/
		    	initcol = new ArrayCollection();
		    	item = new Object();
	        	initcol.addItem({label:" ",value:" "});
		    	if(mapObj[keylist.getItemAt(11)]!=null){
		    		if(mapObj[keylist.getItemAt(11)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(11)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(11)].toString());
		    		}
		    	}
		    	this.dirtyPriceFlag.dataProvider = initcol;
		    	
		    	/* Populating Negative Accrued Interest Flag drop down*/
		    	initcol = new ArrayCollection();
		    	item = new Object();
	        	initcol.addItem({label:" ",value:" "});
		    	if(mapObj[keylist.getItemAt(12)]!=null){
		    		if(mapObj[keylist.getItemAt(12)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(12)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(12)].toString());
		    		}
		    	}
		    	this.negativeAccruedInterestFlag.dataProvider = initcol;
		    	
		    	this.poolFactor.text = "";
		    	this.indexRatio.text = "";
		    	this.currentFaceValue.text = "";
		    	
		    	/* Populating Tax Fee Id drop down*/
		    	initcol = new ArrayCollection();
		    	item = new Object();
	        	initcol.addItem({label:" ",value:" "});
		    	if(mapObj[keylist.getItemAt(13)]!=null){
		    		if(mapObj[keylist.getItemAt(13)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(13)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(13)].toString());
		    		}
		    	}
		    	this.taxFeeIdCombo.dataProvider = initcol;
		    	
		    	/* Populating Tax Rate Type drop down*/
		    	initcol = new ArrayCollection();
		    	item = new Object();
	        	initcol.addItem({label:" ",value:" "});
		    	if(mapObj[keylist.getItemAt(14)]!=null){
		    		if(mapObj[keylist.getItemAt(14)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(14)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(14)].toString());
		    		}
		    	}
		    	this.taxRateTypeCombo.dataProvider = initcol;
		    	
		    	/* Populating Soft Dollar Flag drop down*/
		    	initcol = new ArrayCollection();
		    	item = new Object();
	        	initcol.addItem({label:" ",value:" "});
		    	if(mapObj[keylist.getItemAt(15)]!=null){
		    		if(mapObj[keylist.getItemAt(15)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(15)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(15)].toString());
		    		}
		    	}
		    	this.softDollarFlag.dataProvider = initcol;
		    	
		    	/* Populating PL Suppress Flag drop down*/
		    	initcol = new ArrayCollection();
		    	item = new Object();
	        	initcol.addItem({label:"",value:""});
		    	if(mapObj[keylist.getItemAt(16)]!=null){
		    		if(mapObj[keylist.getItemAt(16)] is ArrayCollection){
		    			//initcol = mapObj[keylist.getItemAt(16)] as ArrayCollection ;
		    			for each(item in (mapObj[keylist.getItemAt(16)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(16)].toString());
		    		}
		    	}
		    	this.plSuppressFlag.dataProvider = initcol;
		    	this.plSuppressFlag.selectedIndex = 1;
		    	
		    	
		    	this.remarks.text = XenosStringUtils.EMPTY_STR;
				this.remarksForReports.text = XenosStringUtils.EMPTY_STR;
				this.omsOrderNo.text = XenosStringUtils.EMPTY_STR;
				this.brokerRefNo.text = XenosStringUtils.EMPTY_STR;
				this.ogRefNo.text = XenosStringUtils.EMPTY_STR;
				this.omsExecutionNo.text = XenosStringUtils.EMPTY_STR;
				this.senderRefNo.text = XenosStringUtils.EMPTY_STR;
				this.externalRefNo.text = XenosStringUtils.EMPTY_STR;
				
				this.cashSecFlagSec.text = XenosStringUtils.EMPTY_STR;
				this.brokerBicSec.text = XenosStringUtils.EMPTY_STR;
				this.acronymSec.text = XenosStringUtils.EMPTY_STR;
				this.securityTypeSec.text = XenosStringUtils.EMPTY_STR;
				this.ccySec.text = XenosStringUtils.EMPTY_STR;
				this.stlTypeSec.text = XenosStringUtils.EMPTY_STR;
				this.bankNameSec.text = XenosStringUtils.EMPTY_STR;
				this.contraIdSec.text = XenosStringUtils.EMPTY_STR;
				this.dtcPartNoSec.text = XenosStringUtils.EMPTY_STR;
				this.dtcExtStlAccSec.text = XenosStringUtils.EMPTY_STR;
				this.prioritySec.text = XenosStringUtils.EMPTY_STR;
				this.placeOfStlSec.text = XenosStringUtils.EMPTY_STR;
				this.partIdSec.text = XenosStringUtils.EMPTY_STR;
				this.partId2Sec.text = XenosStringUtils.EMPTY_STR;
				
				this.cashSecFlagCash.text = XenosStringUtils.EMPTY_STR;
				this.brokerBicCash.text = XenosStringUtils.EMPTY_STR;
				this.acronymCash.text = XenosStringUtils.EMPTY_STR;
				this.securityTypeCash.text = XenosStringUtils.EMPTY_STR;
				this.ccyCash.text = XenosStringUtils.EMPTY_STR;
				this.stlTypeCash.text = XenosStringUtils.EMPTY_STR;
				this.bankNameCash.text = XenosStringUtils.EMPTY_STR;
				this.contraIdCash.text = XenosStringUtils.EMPTY_STR;
				this.dtcPartNoCash.text = XenosStringUtils.EMPTY_STR;
				this.dtcExtStlAccCash.text = XenosStringUtils.EMPTY_STR;
				this.priorityCash.text = XenosStringUtils.EMPTY_STR;
				this.placeOfStlCash.text = XenosStringUtils.EMPTY_STR;
				this.partIdCash.text = XenosStringUtils.EMPTY_STR;
				this.partId2Cash.text = XenosStringUtils.EMPTY_STR;
	        }
	        
	        private function amendInit(mapObj:Object):void{
	        	errPage.clearError(super.getInitResultEvent());
	        	hb.visible = false;
	            hb.includeInLayout = false;
	            backUsrConf.visible = true;
	        	backUsrConf.includeInLayout = true;
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
			    instrumentTypeParent = mapObj["tradeScreenData.instrumentTypeParent"].toString();
			    datasourceStr = mapObj["tradeScreenData.origDataSource"].toString();
			    showHideFields();
			    this.plSuppressFlag.enabled = false;
        		this.amendRefNoBox.visible = true;
        		this.amendRefNoBox.includeInLayout = true;
        		this.cxlReasonCodeRow.visible = true;
        		this.cxlReasonCodeRow.includeInLayout = true;
        		this.remarkListRow.visible = false;
        		this.remarkListRow.includeInLayout = false;
        		this.amendRefNo.text = mapObj[keylist.getItemAt(6)]+"-"+mapObj[keylist.getItemAt(105)];
        		if(mapObj[keylist.getItemAt(27)] != null && mapObj[keylist.getItemAt(25)]!= null){
        			if(!isTrdCcyIssueCcyEqual(mapObj[keylist.getItemAt(25)].toString(),mapObj[keylist.getItemAt(27)].toString())){
	        			issuePricingRow.visible = true;
	        			issuePricingRow.includeInLayout = true;
	        		}else{
	        			issuePricingRow.visible = false;
	        			issuePricingRow.includeInLayout = false;
	        		}
        		}
        		
				
				this.tradeTypeTxt.text = mapObj[keylist.getItemAt(139)];
				if(mapObj[keylist.getItemAt(117)] != null){
					item = new Object();
					initcol = new ArrayCollection();
					index = -1;
					initcol.addItem({label:" ",value:" "});
					if(mapObj[keylist.getItemAt(117)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(117)] as ArrayCollection)){
							initcol.addItem(item);
							if(item.value == mapObj[keylist.getItemAt(138)].toString()){
								index = (mapObj[keylist.getItemAt(117)] as ArrayCollection).getItemIndex(item);
							}
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(117)]);
						index = 0;
					}
				}
				this.tradeType.dataProvider = initcol;
				this.tradeType.selectedIndex = index+1;
				
				this.tradeDateTxt.text = mapObj[keylist.getItemAt(18)];
				if(mapObj[keylist.getItemAt(18)] != null){
					tradeDate.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(18)]);
				}
				this.tradeTime.text = mapObj[keylist.getItemAt(19)];
				if(mapObj[keylist.getItemAt(20)] != null){
					this.valueDate.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(20)]);
				}
				this.buySellFlagTxt.text = mapObj[keylist.getItemAt(12)];
				
				if(mapObj[keylist.getItemAt(119)] != null){
					item = new Object();
					initcol = new ArrayCollection();
					index = -1;
					initcol.addItem({label:" ",value:" "});
					if(mapObj[keylist.getItemAt(119)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(119)] as ArrayCollection)){
							initcol.addItem(item);
							if(item.label == mapObj[keylist.getItemAt(12)].toString()){
								index = (mapObj[keylist.getItemAt(119)] as ArrayCollection).getItemIndex(item);
							}
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(119)]);
						index = 0;
					}
				}
				this.buySellFlag.dataProvider = initcol;
				this.buySellFlag.selectedIndex = index+1;
				
				//XGA-105
				/*
				if(mapObj[keylist.getItemAt(120)] != null){
					item = new Object();
					initcol = new ArrayCollection();
					index = -1;
					initcol.addItem({label:" ",value:" "});
					if(mapObj[keylist.getItemAt(120)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(120)] as ArrayCollection)){
							initcol.addItem(item);
							if(item.value == mapObj[keylist.getItemAt(57)].toString()){
								index = (mapObj[keylist.getItemAt(120)] as ArrayCollection).getItemIndex(item);
							}
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(120)]);
						index = 0;
					}
				}
				this.shortSellFlag.dataProvider = initcol;
				this.shortSellFlag.selectedIndex = index+1;
				
				if(mapObj[keylist.getItemAt(121)] != null){
					item = new Object();
					initcol = new ArrayCollection();
					index = -1;
					initcol.addItem({label:" ",value:" "});
					if(mapObj[keylist.getItemAt(121)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(121)] as ArrayCollection)){
							initcol.addItem(item);
							if(item.value == mapObj[keylist.getItemAt(58)].toString()){
								index = (mapObj[keylist.getItemAt(121)] as ArrayCollection).getItemIndex(item);
							}
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(121)]);
						index = 0;
					}
				}
				this.shortSellExemptFlag.dataProvider = initcol;
				this.shortSellExemptFlag.selectedIndex = index+1;
				*/
				
				//controlShortSellAndExemptFlag();//XGA-105
				
				this.fundAccNoTxt.text = mapObj[keylist.getItemAt(2)];
				fundAccountPopup.accountNo.text = mapObj[keylist.getItemAt(2)];
				
				this.brokerAccNoTxt.text = mapObj[keylist.getItemAt(14)];
				brokerAccPopUp.accountNo.text = mapObj[keylist.getItemAt(14)];
				
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
				}
				this.matchingSuppressFlag.dataProvider = initcol;
				this.matchingSuppressFlag.selectedIndex = index;
				
				if(mapObj[keylist.getItemAt(147)] != null){
					item = new Object();
					initcol = new ArrayCollection();
					index = -1;
					if(mapObj[keylist.getItemAt(147)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(147)] as ArrayCollection)){
							initcol.addItem(item);
							if(item.value == mapObj[keylist.getItemAt(79)].toString()){
								index = (mapObj[keylist.getItemAt(147)] as ArrayCollection).getItemIndex(item);
							}
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(147)]);
						index = 0;
					}
				}
				this.matchExclusionFlag.dataProvider = initcol;
				this.matchExclusionFlag.selectedIndex = index;
				
				this.securityCodeTxt.text = mapObj[keylist.getItemAt(1)];
				securityCode.instrumentId.text = mapObj[keylist.getItemAt(1)];
				
				this.quantity.text = mapObj[keylist.getItemAt(31)];
				this.inputPrice.text = mapObj[keylist.getItemAt(21)];
				
			     // PL Suppress Flag
			     // This needs to be set after Quantity has been set. As based on value of quantity
			     // it will be decided whether Principal Amount field needs to be editable or not.
				
				if(mapObj[keylist.getItemAt(155)] != null){
					item = new Object();
					initcol = new ArrayCollection();
					index = 0;
					initcol.addItem({label:" ",value:" "});
					if(mapObj[keylist.getItemAt(156)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(156)] as ArrayCollection)){
							initcol.addItem(item);
							if(item.value == mapObj[keylist.getItemAt(155)].toString()){
								index = (mapObj[keylist.getItemAt(156)] as ArrayCollection).getItemIndex(item)+1;
							}
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(156)]);
						if(mapObj[keylist.getItemAt(155)].toString() != null){
							index = 1;
						}else{
							index = 0;
						}
					}
				}
				this.plSuppressFlag.dataProvider = initcol;
				this.plSuppressFlag.selectedIndex = index;
				
				// Check Whether Principal Amount field needs to be editable
				// Based on PL Suppress Flag & Quantity
				checkPlSuppressFlag();
				
				this.grossNetTypeTxt.text = mapObj[keylist.getItemAt(22)];
				if(mapObj[keylist.getItemAt(123)] != null){
					item = new Object();
					initcol = new ArrayCollection();
					index = -1;
					initcol.addItem({label:" ",value:" "});
					if(mapObj[keylist.getItemAt(123)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(123)] as ArrayCollection)){
							initcol.addItem(item);
							if(item.value == mapObj[keylist.getItemAt(22)].toString()){
								index = (mapObj[keylist.getItemAt(123)] as ArrayCollection).getItemIndex(item);
							}
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(123)]);
						index = 0;
					}
				}
				this.grossNetType.dataProvider = initcol;
				this.grossNetType.selectedIndex = index+1;
				
				if(mapObj[keylist.getItemAt(124)] != null){
					item = new Object();
					initcol = new ArrayCollection();
					index = -1;
					initcol.addItem({label:" ",value:" "});
					if(mapObj[keylist.getItemAt(124)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(124)] as ArrayCollection)){
							initcol.addItem(item);
							if(item.value == mapObj[keylist.getItemAt(23)].toString()){
								index = (mapObj[keylist.getItemAt(124)] as ArrayCollection).getItemIndex(item);
							}
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(124)]);
						index = 0;
					}
				}
				this.inputPriceFormat.dataProvider = initcol;
				this.inputPriceFormat.selectedIndex = index+1;
				
				this.tradeCcyTxt.text = mapObj[keylist.getItemAt(25)];
				this.tradeCcy.ccyText.text = mapObj[keylist.getItemAt(25)];
				
				this.executionMarket.itemCombo.text = mapObj[keylist.getItemAt(54)];
				
				
				if(mapObj[keylist.getItemAt(125)] != null){
					item = new Object();
					initcol = new ArrayCollection();
					index = -1;
					initcol.addItem({label:" ",value:" "});
					if(mapObj[keylist.getItemAt(125)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(125)] as ArrayCollection)){
							initcol.addItem(item);
							if(item.value == mapObj[keylist.getItemAt(55)].toString()){
								index = (mapObj[keylist.getItemAt(125)] as ArrayCollection).getItemIndex(item);
							}
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(125)]);
						index = 0;
					}
				}
				this.executionMethod.dataProvider = initcol;
				this.executionMethod.selectedIndex = index+1;
				this.stlCcy.ccyText.text = mapObj[keylist.getItemAt(26)];
				this.exchangeRate.text = mapObj[keylist.getItemAt(28)];
				
				if(mapObj[keylist.getItemAt(126)] != null){
					item = new Object();
					initcol = new ArrayCollection();
					index = -1;
					initcol.addItem({label:" ",value:" "});
					if(mapObj[keylist.getItemAt(126)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(126)] as ArrayCollection)){
							initcol.addItem(item);
							if(item.value == mapObj[keylist.getItemAt(141)].toString()){
								index = (mapObj[keylist.getItemAt(126)] as ArrayCollection).getItemIndex(item);
							}
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(126)]);
						index = 0;
					}
				}
				this.calculationType.dataProvider = initcol;
				this.calculationType.selectedIndex = index+1;
				
				
				this.issueCcy.text = mapObj[keylist.getItemAt(27)];
				this.issuePricingExchangeRate.text = mapObj[keylist.getItemAt(29)];
				
				if(mapObj[keylist.getItemAt(126)] != null){
					item = new Object();
					initcol = new ArrayCollection();
					index = -1;
					initcol.addItem({label:" ",value:" "});
					if(mapObj[keylist.getItemAt(126)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(126)] as ArrayCollection)){
							initcol.addItem(item);
							if(item.value == mapObj[keylist.getItemAt(146)].toString()){
								index = (mapObj[keylist.getItemAt(126)] as ArrayCollection).getItemIndex(item);
							}
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(126)]);
						index = 0;
					}
				}
				this.issuePricingCalculationType.dataProvider = initcol;
				this.issuePricingCalculationType.selectedIndex = index+1;
				
				
				if(mapObj[keylist.getItemAt(127)] != null){
					item = new Object();
					initcol = new ArrayCollection();
					index = -1;
					initcol.addItem({label:" ",value:" "});
					if(mapObj[keylist.getItemAt(127)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(127)] as ArrayCollection)){
							initcol.addItem(item);
							if(item.value == mapObj[keylist.getItemAt(60)].toString()){
								index = (mapObj[keylist.getItemAt(127)] as ArrayCollection).getItemIndex(item);
							}
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(127)]);
						index = 0;
					}
				}
				this.excouponFlag.dataProvider = initcol;
				this.excouponFlag.selectedIndex = index+1;
				
				if(mapObj[keylist.getItemAt(128)] != null){
					item = new Object();
					initcol = new ArrayCollection();
					index = -1;
					initcol.addItem({label:" ",value:" "});
					if(mapObj[keylist.getItemAt(128)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(128)] as ArrayCollection)){
							initcol.addItem(item);
							if(item.value == mapObj[keylist.getItemAt(61)].toString()){
								index = (mapObj[keylist.getItemAt(128)] as ArrayCollection).getItemIndex(item);
							}
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(128)]);
						index = 0;
					}
				}
				this.dirtyPriceFlag.dataProvider = initcol;
				this.dirtyPriceFlag.selectedIndex = index+1;
				
				if(mapObj[keylist.getItemAt(129)] != null){
					item = new Object();
					initcol = new ArrayCollection();
					index = -1;
					initcol.addItem({label:" ",value:" "});
					if(mapObj[keylist.getItemAt(129)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(129)] as ArrayCollection)){
							initcol.addItem(item);
							if(item.value == mapObj[keylist.getItemAt(64)].toString()){
								index = (mapObj[keylist.getItemAt(129)] as ArrayCollection).getItemIndex(item);
							}
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(129)]);
						index = 0;
					}
				}
				this.negativeAccruedInterestFlag.dataProvider = initcol;
				this.negativeAccruedInterestFlag.selectedIndex = index+1;
				
				this.poolFactor.text = mapObj[keylist.getItemAt(42)];
				this.currentFaceValue.text = mapObj[keylist.getItemAt(34)];
				
				this.accrInterestAmt.text = mapObj[keylist.getItemAt(35)];
				this.accrDays.text = mapObj[keylist.getItemAt(39)];
				
				if(mapObj[keylist.getItemAt(37)] != null){
					this.accruedStartDate.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(37)]);
				}
				this.price.text = mapObj[keylist.getItemAt(30)];
				this.principalAmt.text = mapObj[keylist.getItemAt(32)];
				this.principalAmtInIssueCcy.text = mapObj[keylist.getItemAt(33)];
				this.interestRate.text = mapObj[keylist.getItemAt(36)];
				this.netAmt.text = mapObj[keylist.getItemAt(40)];
				this.netAmtInTrdCcy.text = mapObj[keylist.getItemAt(41)];
				
				if(mapObj[keylist.getItemAt(130)] != null){
					item = new Object();
					initcol = new ArrayCollection();
					index = -1;
					initcol.addItem({label:" ",value:" "});
					if(mapObj[keylist.getItemAt(130)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(130)] as ArrayCollection)){
							initcol.addItem(item);
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(130)]);
					}
				}
				this.taxFeeIdCombo.dataProvider = initcol;
				
				this.taxRateTxt.text = "";
				
				if(mapObj[keylist.getItemAt(131)] != null){
					item = new Object();
					initcol = new ArrayCollection();
					initcol.addItem({label:" ",value:" "});
					if(mapObj[keylist.getItemAt(131)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(131)] as ArrayCollection)){
							initcol.addItem(item);
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(131)]);
					}
				}
				this.taxRateTypeCombo.dataProvider = initcol;
				
				this.taxAmountTxt.text = "";
				
				this.tax = new ArrayCollection();
				tax.refresh();
				if(mapObj[keylist.getItemAt(81)] != null){
					item = new Object();
					if(mapObj[keylist.getItemAt(81)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(81)] as ArrayCollection)){
							tax.addItem(item);
						}
					}else{
						tax.addItem(mapObj[keylist.getItemAt(81)]);
					}
				}
				
				//STL Instruction Suppress Flag
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				initcol.addItem({label:"Y",value:"Y"});
				initcol.addItem({label:"N",value:"N"});
			 if(mapObj[keylist.getItemAt(151)] != null){
				if(mapObj[keylist.getItemAt(151)] == "Y"){
					index = 1;
				}else if(mapObj[keylist.getItemAt(151)] == "N"){
					index = 2;
				}else{
					index = 0;
				}
			}else{
				index = 0;
			}
			this.stlInsSuprFlag.dataProvider = initcol;
			this.stlInsSuprFlag.selectedIndex = index; 
				
				
				
				if(mapObj[keylist.getItemAt(148)] != null){
					item = new Object();
					initcol = new ArrayCollection();
					index = -1;
					initcol.addItem({label:" ",value:" "});
					if(mapObj[keylist.getItemAt(148)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(148)] as ArrayCollection)){
							initcol.addItem(item);
							if(item.value == mapObj[keylist.getItemAt(149)].toString()){
								index = (mapObj[keylist.getItemAt(148)] as ArrayCollection).getItemIndex(item);
							}
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(148)]);
						index = 0;
					}
				}
				this.cxlRsnCode.dataProvider = initcol;
				this.cxlRsnCode.selectedIndex = index+1;
				// code modification for remarks handling
				initcol = new ArrayCollection();
		    	item = new Object();
		    	index = -1;
		    	initcol.addItem("");
	        	if(mapObj[keylist.getItemAt(152)]!=null){
		    		if(mapObj[keylist.getItemAt(152)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(152)] as ArrayCollection)){
			    			initcol.addItem(item);
			    			if(item == mapObj[keylist.getItemAt(43)].toString()){
								index = (mapObj[keylist.getItemAt(152)] as ArrayCollection).getItemIndex(item);
							}
			    		}
			    		if(initcol.length == 1){
		    				this.remarks.text = mapObj[keylist.getItemAt(43)];
		    				this.remarkListRow.visible = false;
		    				this.remarkListRow.includeInLayout = false;
		    				this.remarkRow.visible = true;
		    				this.remarkRow.includeInLayout = true;
		    				this.remarks.editable = true;
			    		}
			    		else if(initcol.length == 2){
		    				this.remarks.text = item.toString();
			    			this.remarkListRow.visible = false;
		    				this.remarkListRow.includeInLayout = false;
		    				this.remarkRow.visible = true;
		    				this.remarkRow.includeInLayout = true;
		    				this.remarks.editable = false;
			    		}else{
			    			this.remarkListRow.visible = true;
		    				this.remarkListRow.includeInLayout = true;
		    				this.remarkRow.visible = false;
		    				this.remarkRow.includeInLayout = false;
			    		}
		    		}
		    	}else{
		    		this.remarks.text = mapObj[keylist.getItemAt(43)];
		    		this.remarkListRow.visible = false;
		    		this.remarkListRow.includeInLayout = false;
		    		this.remarkRow.visible = true;
		    		this.remarkRow.includeInLayout = true;
		    		this.remarks.editable = true;
		    		
		    		
		    	}
		    	this.remarksList.dataProvider = initcol;
		    	this.remarksList.selectedIndex = index+1;
				//this.remarks.text = mapObj[keylist.getItemAt(43)];
				this.remarksForReports.text = mapObj[keylist.getItemAt(76)];
				this.omsOrderNo.text = mapObj[keylist.getItemAt(11)];
				this.brokerRefNo.text = mapObj[keylist.getItemAt(51)];
				this.ogRefNo.text = mapObj[keylist.getItemAt(10)];
				this.omsExecutionNo.text = mapObj[keylist.getItemAt(9)];
				this.senderRefNo.text = mapObj[keylist.getItemAt(63)];
				this.externalRefNo.text = mapObj[keylist.getItemAt(50)];
				
				if(mapObj[keylist.getItemAt(132)] != null){
					item = new Object();
					index = -1;
					initcol = new ArrayCollection();
					initcol.addItem({label:" ",value:" "});
					if(mapObj[keylist.getItemAt(132)] is ArrayCollection){
						for each(item in (mapObj[keylist.getItemAt(132)] as ArrayCollection)){
							initcol.addItem(item);
							if(item.value == mapObj[keylist.getItemAt(64)].toString()){
								index = (mapObj[keylist.getItemAt(129)] as ArrayCollection).getItemIndex(item);
							}
						}
					}else{
						initcol.addItem(mapObj[keylist.getItemAt(129)]);
						index = 0;
					}
				}
				this.softDollarFlag.dataProvider = initcol;
				this.softDollarFlag.selectedIndex = index+1;
				
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
				//index ration amend
				this.indexRatio.text = mapObj["tradeScreenData.indexRatioStr"].toString();
				indxRatioTempStr = mapObj["tradeScreenData.indexRatioStr"].toString();
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
			    //this.uConfShortSellFlag.text = mapObj[keylist.getItemAt(57)];//XGA-105
			    //this.uConfShortSellExemptFlag.text = mapObj[keylist.getItemAt(58)];//XGA-105
			    this.uConfStartEndType.text = mapObj[keylist.getItemAt(59)];
			    this.uConfExCouponFlag.text = mapObj[keylist.getItemAt(60)];
			    this.uConfDirtyPriceFlag.text = mapObj[keylist.getItemAt(61)];
			    this.uConfStipulation.text = mapObj[keylist.getItemAt(62)];
			    this.uConfSenderRefNo.text = mapObj[keylist.getItemAt(63)];
			    this.uConfNegAccIntFlag.text = mapObj[keylist.getItemAt(64)];
			    
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
			    this.uConfPartId2Sec.text = mapObj[keylist.getItemAt(118)];
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
			    this.uConfPartId2Cash.text = mapObj[keylist.getItemAt(117)];
			    this.uConfFundName.text = mapObj["tradeScreenData.fundName"].toString();
			    //XenosAlert.info("PL Suppress Flag Common result part :: "+ (mapObj[keylist.getItemAt(123)]).toString());
			    this.uConfPlSuppressFlag.text = mapObj["tradeScreenData.plSuppressFlag"].toString();
			    this.uConfIndexRatio.text = mapObj["tradeScreenData.indexRatioStr"].toString();
			    if(this.mode == "cancel"){
			    	this.cpSecFlag.text = mapObj[keylist.getItemAt(119)];
			    	this.cpSecBrokerBic.text = mapObj[keylist.getItemAt(120)];
			    	this.cpSecGlobalCustodianBic.text = mapObj[keylist.getItemAt(121)];
			    	this.cpSecGlobalCustodianName.text = mapObj[keylist.getItemAt(122)];
			    	this.cpSecSettlementAccount.text = mapObj[keylist.getItemAt(123)];
			    	this.cpSecLocalCustodianBic.text = mapObj[keylist.getItemAt(124)];
			    	this.cpSecLocalCustodianName.text = mapObj[keylist.getItemAt(125)];
			    	this.cpSecPlaceOfSettlement.text = mapObj[keylist.getItemAt(126)];
			    	this.cpSecParticipantId.text = mapObj[keylist.getItemAt(127)];
			    	this.cpSecParticipantId2.text = mapObj[keylist.getItemAt(128)];
			    	
			    	this.cpCashFlag.text = mapObj[keylist.getItemAt(129)];
			    	this.cpCashBrokerBic.text = mapObj[keylist.getItemAt(130)];
			    	this.cpCashGlobalCustodianBic.text = mapObj[keylist.getItemAt(131)];
			    	this.cpCashGlobalCustodianName.text = mapObj[keylist.getItemAt(132)];
			    	this.cpCashSettlementAccount.text = mapObj[keylist.getItemAt(133)];
			    	this.cpCashLocalCustodianBic.text = mapObj[keylist.getItemAt(134)];
			    	this.cpCashLocalCustodianName.text = mapObj[keylist.getItemAt(135)];
			    	this.cpCashPlaceOfSettlement.text = mapObj[keylist.getItemAt(136)];
			    	this.cpCashParticipantId.text = mapObj[keylist.getItemAt(137)];
			    	this.cpCashParticipantId2.text = mapObj[keylist.getItemAt(138)];
			    }
	        }
	        
	        private function commonResult(mapObj:Object):void{
	        //	XenosAlert.info("Inside common result ");
		    	if(mapObj!=null){  
		    	//	XenosAlert.info("Error occured "+ mapObj["errorFlag"].toString());
			    	if(mapObj["errorFlag"].toString() == "error"){
			    		errPage.showError(mapObj["errorMsg"]);		    			
			    	}else if(mapObj["errorFlag"].toString() == "noError"){
			    //		XenosAlert.info("No error");
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
                            	isInFirstEntryPage:this.isInFirstEntryScreen ? "true":"false",
                            	isAmend:this.mode == "amendment" ? "true":"false",
                            	tradeDate:this.isInFirstEntryScreen ? (this.tradeDate.text != "" ? StringUtil.trim(this.tradeDate.text) : "") : (StringUtil.trim(this.tradeDateTxt.text) != null ? StringUtil.trim(this.tradeDateTxt.text):""),
                            	valueDate:this.valueDate.text != "" ? StringUtil.trim(this.valueDate.text) : "",
                            	buySell:this.isInFirstEntryScreen ? (this.buySellFlag.selectedItem != null ? this.buySellFlag.selectedItem.value : "") : (StringUtil.trim(this.buySellFlagTxt.text) != null ? StringUtil.trim(this.buySellFlagTxt.text):""),
                            	fundAccNo:this.isInFirstEntryScreen ? (this.fundAccountPopup.accountNo != null ? this.fundAccountPopup.accountNo.text : "") : (StringUtil.trim(this.fundAccNoTxt.text) != null ? StringUtil.trim(this.fundAccNoTxt.text):""),
                            	brokerAccNo:this.isInFirstEntryScreen ? (this.brokerAccPopUp.accountNo != null ? this.brokerAccPopUp.accountNo.text : ""):(StringUtil.trim(this.brokerAccNoTxt.text) != null ? StringUtil.trim(this.brokerAccNoTxt.text):""),
                            	securityCode:this.isInFirstEntryScreen ? (this.securityCode.instrumentId != null ? this.securityCode.instrumentId.text : "") : (StringUtil.trim(this.securityCodeTxt.text) != null ? StringUtil.trim(this.securityCodeTxt.text):""),
                            	quantity:StringUtil.trim(this.quantity.text) != null ? StringUtil.trim(this.quantity.text):"",
                            	inputPrice:StringUtil.trim(this.inputPrice.text) != null ? StringUtil.trim(this.inputPrice.text):"",
                            	grossNetType:this.isInFirstEntryScreen ? (this.grossNetType.selectedItem != null ? this.grossNetType.selectedItem.value : "") : (StringUtil.trim(this.grossNetTypeTxt.text) != null ? StringUtil.trim(this.grossNetTypeTxt.text):""),
                            	inputPriceFormat:this.inputPriceFormat.selectedItem != null ? this.inputPriceFormat.selectedItem.value : "",
                            	isRemarksList:this.remarkListRow.visible ? "true":"false",
                            	remarksFromList:this.remarksList.selectedItem != null ? this.remarksList.selectedItem : "",
                            	remarks:StringUtil.trim(this.remarks.text) != null ? StringUtil.trim(this.remarks.text):"",
                            	omsOrderNo:StringUtil.trim(this.omsOrderNo.text) != null ? StringUtil.trim(this.omsOrderNo.text):"",
                            	omsExecutionNo:StringUtil.trim(this.omsExecutionNo.text) != null ? StringUtil.trim(this.omsExecutionNo.text):""
                            }
                           }; 
                    
                    super._validator = new TradeEntryValidator();
	         		super._validator.source = trdValidationModel ;
	         		super._validator.property = "tradeEntry"; 
	         
		}
		
		 
		override public function preEntryConfirmResultHandler():Object{
			addCommonResultKeys();
			keylist.addItem("tradeScreenData.cashSsi.participantId2");
		    keylist.addItem("tradeScreenData.securitySsi.participantId2");
		    keylist.addItem("tradeScreenData.fundName");
		    keylist.addItem("tradeScreenData.plSuppressFlag");
		    keylist.addItem("tradeScreenData.indexRatioStr");
			return keylist;
		}
		
		override public function preConfirmAmendResultHandler():Object{
			addCommonResultKeys();
			keylist.addItem("tradeScreenData.cashSsi.participantId2");
		    keylist.addItem("tradeScreenData.securitySsi.participantId2");
		    keylist.addItem("tradeScreenData.fundName");
		   	keylist.addItem("tradeScreenData.plSuppressFlag");
		   	keylist.addItem("tradeScreenData.indexRatioStr");
			return keylist;
		}
		
		override public function preCancelResultHandler():Object{
			addCommonResultKeys();
			keylist.addItem("tradeScreenData.cashSsi.participantId2");
		    keylist.addItem("tradeScreenData.securitySsi.participantId2");
		    keylist.addItem("tradeScreenData.indexRatioStr"); 
			return keylist;
		}
		
		override public function preConfirmCancelResultHandler():Object{
			addCommonResultKeys();
			keylist.addItem("tradeScreenData.cashSsi.participantId2");
		    keylist.addItem("tradeScreenData.securitySsi.participantId2");
		    keylist.addItem("tradeScreenData.indexRatioStr");
			return keylist;
		}
		
		private function submitUserConfResult(mapObj:Object):void{
			backUsrConf.enabled = true;
			uConfSubmit.enabled = true;
	    	if(mapObj!=null){    
		    	if(mapObj["errorFlag"].toString() == "error"){
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
    	if(this.mode == 'entry'){
    		reqObj['SCREEN_KEY'] = "45";
    	}else if(this.mode == 'amendment'){
    		reqObj['SCREEN_KEY'] = "11078";
    	}
    	reqObj['tradeScreenData.tradeType'] = this.trdTypeStr;
    	reqObj['tradeScreenData.tradeDateStr'] = this.tradeDateTxt.text;
    	reqObj['tradeScreenData.tradeTime'] = this.tradeTime.text;
    	reqObj['tradeScreenData.valueDateStr'] = this.valueDate.text;
    	reqObj['tradeScreenData.buySellOrientation'] = this.buySellFlagTxt.text;
    	//reqObj['tradeScreenData.shortSellingFlag'] = this.shortSellFlag.selectedItem != null ? this.shortSellFlag.selectedItem.value : "";
    	//reqObj['tradeScreenData.shortSellExemptFlag'] = this.shortSellExemptFlag.selectedItem != null ? this.shortSellExemptFlag.selectedItem.value : "";//XGA-105
    	reqObj['tradeScreenData.inventoryAccountNo'] = this.fundAccNoTxt.text;
    	reqObj['tradeScreenData.brokerAccount'] = this.brokerAccNoTxt.text;
    	reqObj['tradeScreenData.matchingSupressFlag'] = this.matchingSuppressFlag.selectedItem != null ? this.matchingSuppressFlag.selectedItem.value : "";
    	reqObj['tradeScreenData.matchExclusionFlag'] = this.matchExclusionFlag.selectedItem != null ? this.matchExclusionFlag.selectedItem.value : "";
    	reqObj['tradeScreenData.securityInfo'] = this.securityCodeTxt.text;
    	reqObj['tradeScreenData.quantityStr'] = this.quantity.text;
    	reqObj['tradeScreenData.inputPriceStr'] = this.inputPrice.text;
    	reqObj['tradeScreenData.grossNetType'] = this.grossNetTypeTxt.text;
    	reqObj['tradeScreenData.inputPriceFormat'] = this.inputPriceFormat.selectedItem != null ? this.inputPriceFormat.selectedItem.value : "";
    	reqObj['tradeScreenData.tradeCurrency'] = this.tradeCcyTxt.text;
    	reqObj['tradeScreenData.executionMarket'] = executionMarket.itemCombo != null ? executionMarket.itemCombo.text : "" ;
    	reqObj['tradeScreenData.executionMethod'] = this.executionMethod.selectedItem != null ? this.executionMethod.selectedItem.value : "";
    	reqObj['tradeScreenData.settlementCurrency'] = this.stlCcy.ccyText != null ? this.stlCcy.ccyText.text : "";
    	reqObj['tradeScreenData.exchangeRateStr'] = this.exchangeRate.text;
    	reqObj['tradeScreenData.calculationTypeStr'] = this.calculationType.selectedItem != null ? this.calculationType.selectedItem.value : "";
    	reqObj['tradeScreenData.issueCurrency'] = this.issueCcy.text;
    	reqObj['tradeScreenData.exchangeRateIssuePricingStr'] = this.issuePricingExchangeRate.text;
    	reqObj['tradeScreenData.calculationTypeIssuePricing'] = this.issuePricingCalculationType.selectedItem != null ? this.issuePricingCalculationType.selectedItem.value : "";
    	reqObj['tradeScreenData.exCouponFlag'] = this.excouponFlag.selectedItem != null ? this.excouponFlag.selectedItem.value : "";
    	reqObj['tradeScreenData.dirtyPriceFlag'] = this.dirtyPriceFlag.selectedItem != null ? this.dirtyPriceFlag.selectedItem.value : "";
    	reqObj['tradeScreenData.negativeAccruedInterestFlag'] = this.negativeAccruedInterestFlag.selectedItem != null ? this.negativeAccruedInterestFlag.selectedItem.value : "";
    	reqObj['tradeScreenData.poolFactorStr'] = this.poolFactor.text;
    	reqObj['tradeScreenData.currentFaceValueStr'] = this.currentFaceValue.text;
    	reqObj['tradeScreenData.accruedInterestAmountStr'] = this.accrInterestAmt.text;
    	reqObj['tradeScreenData.accruedDaysStr'] = this.accrDays.text;
    	reqObj['tradeScreenData.accruedStartDateStr'] = this.accruedStartDate.text;
    	reqObj['tradeScreenData.priceStr'] = this.price.text;
    	reqObj['tradeScreenData.principalAmountStr'] = this.principalAmt.text;
    	reqObj['tradeScreenData.principalAmountInIssueStr'] = this.principalAmtInIssueCcy.text;
    	reqObj['tradeScreenData.interestRateStr'] = this.interestRate.text;
    	reqObj['tradeScreenData.netAmountStr'] = this.netAmt.text;
    	reqObj['tradeScreenData.netAmountInTradingCurrency'] = this.netAmtInTrdCcy.text;
    	reqObj['tradeScreenData.instructionSuppressFlag'] = this.stlInsSuprFlag.selectedItem != null ? this.stlInsSuprFlag.selectedItem.value : "";
    	//set remarks depending on remarkslist or text
    	if(this.remarkRow.visible == true){
    		reqObj['tradeScreenData.remarks'] = this.remarks.text;
    	}else{
    		reqObj['tradeScreenData.remarks'] = this.remarksList.selectedItem != null ? this.remarksList.selectedItem : "";
    	}
    	
    	reqObj['tradeScreenData.remarksForReports'] = this.remarksForReports.text;
    	reqObj['tradeScreenData.orderReferenceNo'] = this.omsOrderNo.text;
    	reqObj['tradeScreenData.brokerReferenceNo'] = this.brokerRefNo.text;
    	reqObj['tradeScreenData.etcReferenceNo'] = this.ogRefNo.text;
    	reqObj['tradeScreenData.omsExecutionNo'] = this.omsExecutionNo.text;
    	reqObj['tradeScreenData.senderReferenceNo'] = this.senderRefNo.text;
    	reqObj['tradeScreenData.externalReferenceNo'] = this.externalRefNo.text;
    	reqObj['tradeScreenData.softDollarFlag'] = this.softDollarFlag.selectedItem != null ? this.softDollarFlag.selectedItem.value : "";
    	
    	reqObj['tradeScreenData.securitySsi.cpSsiPk'] = this.cpSecSsiPk.text;
    	reqObj['tradeScreenData.securitySsi.cashSecurityFlag'] = this.cashSecFlagSec.text;
    	reqObj['tradeScreenData.securitySsi.brokerBic'] = this.brokerBicSec.text;
    	reqObj['tradeScreenData.securitySsi.acronym'] = this.acronymSec.text;
    	reqObj['tradeScreenData.securitySsi.instrumentType'] = this.securityTypeSec.text;
    	reqObj['tradeScreenData.securitySsi.settlementCcy'] = this.ccySec.text;
    	reqObj['tradeScreenData.securitySsi.settlementType'] = this.stlTypeSec.text;
    	reqObj['tradeScreenData.securitySsi.bankName'] = this.bankNameSec.text;
    	reqObj['tradeScreenData.securitySsi.contraId'] = this.contraIdSec.text;
    	reqObj['tradeScreenData.securitySsi.dtcParticipantNumber'] = this.dtcPartNoSec.text;
    	reqObj['tradeScreenData.securitySsi.cpExternalSettleAct'] = this.dtcExtStlAccSec.text;
    	reqObj['tradeScreenData.securitySsi.priority'] = this.prioritySec.text;
    	reqObj['tradeScreenData.securitySsi.placeOfSettlement'] = this.placeOfStlSec.text;
    	reqObj['tradeScreenData.securitySsi.participantId'] = this.partIdSec.text;
    	reqObj['tradeScreenData.securitySsi.participantId2'] = this.partId2Sec.text;
    	reqObj['tradeScreenData.securitySsi.status'] = 'NORMAL';
    	
    	reqObj['tradeScreenData.cashSsi.cpSsiPk'] = this.cpCashSsiPk.text;
    	reqObj['tradeScreenData.cashSsi.cashSecurityFlag'] = this.cashSecFlagCash.text;
    	reqObj['tradeScreenData.cashSsi.brokerBic'] = this.brokerBicCash.text;
    	reqObj['tradeScreenData.cashSsi.acronym'] = this.acronymCash.text;
    	reqObj['tradeScreenData.cashSsi.instrumentType'] = this.securityTypeCash.text;
    	reqObj['tradeScreenData.cashSsi.settlementCcy'] = this.ccyCash.text;
    	reqObj['tradeScreenData.cashSsi.settlementType'] = this.stlTypeCash.text;
    	reqObj['tradeScreenData.cashSsi.bankName'] = this.bankNameCash.text;
    	reqObj['tradeScreenData.cashSsi.contraId'] = this.contraIdCash.text;
    	reqObj['tradeScreenData.cashSsi.dtcParticipantNumber'] = this.dtcPartNoCash.text;
    	reqObj['tradeScreenData.cashSsi.cpExternalSettleAct'] = this.dtcExtStlAccCash.text;
    	reqObj['tradeScreenData.cashSsi.priority'] = this.priorityCash.text;
    	reqObj['tradeScreenData.cashSsi.placeOfSettlement'] = this.placeOfStlCash.text;
    	reqObj['tradeScreenData.cashSsi.participantId'] = this.partIdCash.text;
    	reqObj['tradeScreenData.cashSsi.participantId2'] = this.partId2Cash.text;
    	reqObj['tradeScreenData.cashSsi.status'] = 'NORMAL';
    //	XenosAlert.info("PL Suppress Flag Pre Entry :: " + this.plSuppressFlag.selectedItem.value);
    	if(this.plSuppressFlag.visible == true){
    		reqObj['tradeScreenData.plSuppressFlag'] = this.plSuppressFlag.selectedItem != null ? this.plSuppressFlag.selectedItem.value : "";
    	}
    	reqObj['tradeScreenData.principalAmtTemp'] = this.principalAmtTemp;
    	if(this.mode == 'amendment'){
    		reqObj['reason'] = this.cxlRsnCode.selectedItem != null ? this.cxlRsnCode.selectedItem.value : "";
    	} 
    	reqObj['tradeScreenData.indexRatioStr'] = this.indexRatio.text;
    	
    	return reqObj;
    }
    
    private function populateReqFromMandatoryEntryScreen():Object {
    	reqObj = new Object();
    	reqObj.rnd = Math.random()+"";
    	reqObj.method= "populate";
    	reqObj['SCREEN_KEY'] = "40";
    	reqObj['tradeScreenData.tradeType'] = this.tradeType.selectedItem != null ? this.tradeType.selectedItem.value : "";
    	reqObj['tradeScreenData.tradeDateStr'] = this.tradeDate.text;
    	reqObj['tradeScreenData.tradeTime'] = this.tradeTime.text;
    	reqObj['tradeScreenData.valueDateStr'] = this.valueDate.text;
    	reqObj['tradeScreenData.buySellOrientation'] = this.buySellFlag.selectedItem != null ? this.buySellFlag.selectedItem.value : "";
    	//reqObj['tradeScreenData.shortSellingFlag'] = this.shortSellFlag.selectedItem != null ? this.shortSellFlag.selectedItem.value : "";
    	//reqObj['tradeScreenData.shortSellExemptFlag'] = this.shortSellExemptFlag.selectedItem != null ? this.shortSellExemptFlag.selectedItem.value : "";//XGA-105
    	reqObj['tradeScreenData.inventoryAccountNo'] = this.fundAccountPopup.accountNo != null ? this.fundAccountPopup.accountNo.text : "";
    	reqObj['tradeScreenData.brokerAccount'] = this.brokerAccPopUp.accountNo != null ? this.brokerAccPopUp.accountNo.text : "";
    	reqObj['tradeScreenData.matchingSupressFlag'] = this.matchingSuppressFlag.selectedItem != null ? this.matchingSuppressFlag.selectedItem.value : "";
    	reqObj['tradeScreenData.securityInfo'] = this.securityCode.instrumentId != null ? this.securityCode.instrumentId.text : "";
    	reqObj['tradeScreenData.quantityStr'] = this.quantity.text;
    	reqObj['tradeScreenData.inputPriceStr'] = this.inputPrice.text;
    	reqObj['tradeScreenData.grossNetType'] = this.grossNetType.selectedItem != null ? this.grossNetType.selectedItem.value : "";
    	reqObj['tradeScreenData.inputPriceFormat'] = this.inputPriceFormat.selectedItem != null ? this.inputPriceFormat.selectedItem.value : "";
    	reqObj['tradeScreenData.tradeCurrency'] = this.tradeCcy.ccyText != null ? this.tradeCcy.ccyText.text : "";
    	reqObj['tradeScreenData.executionMarket'] = executionMarket.itemCombo != null ? executionMarket.itemCombo.text : "" ;
    	reqObj['tradeScreenData.executionMethod'] = this.executionMethod.selectedItem != null ? this.executionMethod.selectedItem.value : "";
    	reqObj['tradeScreenData.settlementCurrency'] = this.stlCcy.ccyText != null ? this.stlCcy.ccyText.text : "";
    	reqObj['tradeScreenData.exchangeRateStr'] = this.exchangeRate.text;
    	reqObj['tradeScreenData.calculationTypeStr'] = this.calculationType.selectedItem != null ? this.calculationType.selectedItem.value : "";
    	reqObj['tradeScreenData.exCouponFlag'] = this.excouponFlag.selectedItem != null ? this.excouponFlag.selectedItem.value : "";
    	reqObj['tradeScreenData.dirtyPriceFlag'] = this.dirtyPriceFlag.selectedItem != null ? this.dirtyPriceFlag.selectedItem.value : "";
    	reqObj['tradeScreenData.negativeAccruedInterestFlag'] = this.negativeAccruedInterestFlag.selectedItem != null ? this.negativeAccruedInterestFlag.selectedItem.value : "";
    	reqObj['tradeScreenData.poolFactorStr'] = this.poolFactor.text;
    	reqObj['tradeScreenData.currentFaceValueStr'] = this.currentFaceValue.text;
    	reqObj['tradeScreenData.issueCurrency'] = this.issueCcy.text;
    	reqObj['tradeScreenData.exchangeRateIssuePricingStr'] = this.issuePricingExchangeRate.text;
    	reqObj['tradeScreenData.calculationTypeIssuePricing'] = this.issuePricingCalculationType.selectedItem != null ? this.issuePricingCalculationType.selectedItem.value : "";
    	reqObj['tradeScreenData.principalAmountStr'] = this.principalAmt.text;
    	reqObj['tradeScreenData.netAmountStr'] = this.netAmt.text;
    	reqObj['tradeScreenData.netAmountInTradingCurrency'] = this.netAmtInTrdCcy.text;
    	reqObj['tradeScreenData.accruedInterestAmountStr'] = this.accrInterestAmt.text;
    	reqObj['tradeScreenData.accruedDaysStr'] = this.accrDays.text;
    	reqObj['tradeScreenData.accruedStartDateStr'] = this.accruedStartDate.text;
    	if(this.plSuppressFlag.visible == true){
    		reqObj['tradeScreenData.plSuppressFlag'] = this.plSuppressFlag.selectedItem != null ? this.plSuppressFlag.selectedItem.value : "";
    	}
    	reqObj['tradeScreenData.indexRatioStr'] = this.indexRatio.text;
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
	  	if(this.mode=='entry'){
	  		reqObj.SCREEN_KEY = "40";
	  		backToFirstEntryScreenRequest.request = reqObj;
        	backToFirstEntryScreenRequest.send();
	  	}else if(this.mode=='amendment'){
	  		reqObj.SCREEN_KEY = "44";
	  		backToFirstEntryScreenRequestForAmend.request = reqObj;
        	backToFirstEntryScreenRequestForAmend.send();
	  	}
	  }
	  
	  private function loadFirstEntryScreenFromSecondHandler(event:ResultEvent):void{
	  	if(event != null){
				if(event.result != null){
					if(event.result.tradeEntryActionForm != null){
						app.submitButtonInstance = submit;
						isInFirstEntryScreen = true;
						this.additionalEntryCriteria.visible = false;
						this.additionalEntryCriteria.includeInLayout = false;
						this.upBack.visible = true;
						this.upBack.includeInLayout = true;
						if(event.result.tradeEntryActionForm.tradeScreenData != null){
							errPage.clearError(super.getInitResultEvent());
							populateMandatoryTradeEntryFieldValues(event.result.tradeEntryActionForm.tradeScreenData);
							showHideFields();
						}
					}else if(event.result.XenosErrors != null){
						app.submitButtonInstance = submitAddlEntry;
						errPage.clearError(super.getInitResultEvent());
						isInFirstEntryScreen = true;
						this.upBack.visible = false;
						this.upBack.includeInLayout = false;
						this.additionalEntryCriteria.visible = false;
						this.additionalEntryCriteria.includeInLayout = false;
						if(XenosStringUtils.equals(event.result.XenosErrors.errorForIssueCcy,"NOT_FOUND")){
							this.issuePricingRow.visible = true;
							this.issuePricingRow.includeInLayout = true;
							this.issueCcy.text = StringUtil.trim(event.result.XenosErrors.issueCcy);
						}
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
						XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
					}
				}else{
					XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				}
			}else{
				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			}
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
        myContextList.addItem(new HiddenObject("actTypeContext",actTypeArray));    
                  
        var cpTypeArray:Array = new Array(1);
            cpTypeArray[0]="BROKER";
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
	    
	    private function validateTime(timeStr:String):String{
	    	var timeVal:String = StringUtil.trim(timeStr);
			var hh:String = "";
			var mm:String = "";
			var ss:String = "";
			var m:Number = 0;
			var s:Number = 0;
			
	    	if(timeVal.length == 0){
	    		var dt:Date = new Date();
			 	hh = dt.getHours().toString();
				if(dt.getHours()<10){
					hh = "0" + hh ;
				}
				mm = dt.getMinutes().toString();
				if(dt.getMinutes()<10){
					mm = "0" + mm ;
				}
				ss = dt.getSeconds().toString();
				if(dt.getSeconds()<10){
				  ss = "0" + ss ;
				}
				timeVal = hh +":" + mm + ":" +ss ;
				return timeVal;
	    	}else if (timeVal.length == 8){
	    		m = 3;
   				s = 6;
   				if ((timeVal.charAt(2) != ":") || (timeVal.charAt(5) != ":") || (!(int(timeVal)==0))){ 
   					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.tradetime.invalid.eight'));
			     	return "";
			    }
  			}else if (timeVal.length == 6){ 
  				m = 2;
			    s = 4;
			    if (!NumberUtils.checkValidNumber(timeVal)){ 
			    	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.tradetime.invalid.six'));
			     	return "";
			    }
			  }else if (timeVal.length == 5){
				  m = 3;
			      if (timeVal.charAt(2) != ":"){ 
			   	   XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.tradetime.invalid.five'));
			       return "";
			      }
			  }else if (timeVal.length == 4){ 
			  	m = 2;
   				if (int(timeVal)==0){ 
   					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.tradetime.invalid.four'));
     				return "";
    		    }
              }else { 
			   XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.tradetime.invalid.error'));
			   return "";
			  }
			  
			  //------hours validation------------
			 var strHH:String = timeVal.charAt(0) + timeVal.charAt(1);
			 if (!NumberUtils.checkValidNumber(strHH))
			  { XenosAlert.error (this.parentApplication.xResourceManager.getKeyValue('trd.notvalid.nonnumeric.hour'));
			   return "";
			  }
			 var numHH:Number = parseInt(strHH);
			 if (numHH > 23)
			  { XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.notvalid.hour'));
			   return "";
			  }
			
			 //------minutes validation------------
			 var strMM:String = timeVal.charAt(m) + timeVal.charAt(m+1);
			 if (!NumberUtils.checkValidNumber(strMM))
			  { XenosAlert.error (this.parentApplication.xResourceManager.getKeyValue('trd.notvalid.nonnumeric.minute'));
			   return "";
			  }
			 var numMM:Number = parseInt(strMM);
			 if (numMM > 59)
			  { XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.notvalid.minute'));
			   return "";
			  }
			
			 //------seconds validation------------
			 var strSS:String = '00';
			 if ((timeVal.length == 8) || (timeVal.length == 6)){ 
			 	strSS = timeVal.charAt(s) + timeVal.charAt(s+1);
			 if (!NumberUtils.checkValidNumber(strSS)){ 
			   		XenosAlert.error (this.parentApplication.xResourceManager.getKeyValue('trd.notvalid.nonnumeric.second'));
			        return "";
			   }
			   var numSS:Number = parseInt(strSS);
			   if (numSS > 59){ 
			   		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.notvalid.second'));
			     	return "";
			   }
			  }else 
			  	strSS = "00";
			  	
			  timeVal = strHH + ":" + strMM + ":" + strSS;
	    	  return timeVal;	
	    }	
	    
	    
	    private function doSubmit():void{
	    	var reqSend:Boolean = true;
	    	if(!isInFirstEntryScreen){
	        	if(!XenosStringUtils.isBlank(StringUtil.trim(this.tradeCcy.ccyText.text)) && !XenosStringUtils.isBlank(StringUtil.trim(this.stlCcy.ccyText.text))){
	        		if(!isTrdCcyIssueCcyEqual(StringUtil.trim(this.tradeCcy.ccyText.text),StringUtil.trim(this.stlCcy.ccyText.text))){
	        			if(XenosStringUtils.isBlank(StringUtil.trim(this.exchangeRate.text))){
		        			reqSend = false;
		        			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.entry.empty.exchangerate'));
		        		}
	        		}
	        	}
	        	if(!numValInputPrice.handleNumericField(numberFormatter) ||
	        		!numValQty.handleNumericField(numberFormatter) ||
	        		!numValAccrIntAmt.handleNumericField(numberFormatter) ||
	        		!numValAccrDays.handleNumericField(numberFormatter) ||
	        		!numValPrincipalAmt.handleNumericField(numberFormatter) ||  
	        		!numValIndexRatio.handleNumericField(numberFormatter)) {
	        		reqSend = false;
	        	}
	        	if(reqSend){
	        		//this.clearAmountFields();
	        		this.principalAmtTemp = this.principalAmt.text;
	        		if((XenosStringUtils.equals(datasourceStr,"OG"))||
	        					(XenosStringUtils.equals(datasourceStr,"TRD-SUITE"))){
	        			checkInputPrice();
	        		    checkQty();
	        		    checkIndexRatio();
	        		}else{
	        			checkInputPrice();
	        		    checkQty();
	        		    checkIndexRatio();
	        			this.clearAmountFields();
	        		}
	        		checkValueDate();
	        		//XenosAlert.info("Submit second entry screen");
	        		
	        		this.mode == 'entry' ?  this.dispatchEvent(new Event('entrySave')) :  this.dispatchEvent(new Event('amendEntrySave'));
	        	}
	    	}else{
	    		var tradeValidationModel:Object={
                            tradeEntry:{
	                                isInFirstEntryPage:this.isInFirstEntryScreen ? "true":"false",
	                            	isAmend:this.mode == "amendment" ? "true":"false",
	                            	tradeDate:this.isInFirstEntryScreen ? (this.tradeDate.text != "" ? StringUtil.trim(this.tradeDate.text) : "") : (StringUtil.trim(this.tradeDateTxt.text) != null ? StringUtil.trim(this.tradeDateTxt.text):""),
	                            	valueDate:this.valueDate.text != "" ? StringUtil.trim(this.valueDate.text) : "",
	                            	buySell:this.isInFirstEntryScreen ? (this.buySellFlag.selectedItem != null ? this.buySellFlag.selectedItem.value : "") : (StringUtil.trim(this.buySellFlagTxt.text) != null ? StringUtil.trim(this.buySellFlagTxt.text):""),
	                            	fundAccNo:this.isInFirstEntryScreen ? (this.fundAccountPopup.accountNo != null ? this.fundAccountPopup.accountNo.text : "") : (StringUtil.trim(this.fundAccNoTxt.text) != null ? StringUtil.trim(this.fundAccNoTxt.text):""),
	                            	brokerAccNo:this.isInFirstEntryScreen ? (this.brokerAccPopUp.accountNo != null ? this.brokerAccPopUp.accountNo.text : ""):(StringUtil.trim(this.brokerAccNoTxt.text) != null ? StringUtil.trim(this.brokerAccNoTxt.text):""),
	                            	securityCode:this.isInFirstEntryScreen ? (this.securityCode.instrumentId != null ? this.securityCode.instrumentId.text : "") : (StringUtil.trim(this.securityCodeTxt.text) != null ? StringUtil.trim(this.securityCodeTxt.text):""),
	                            	quantity:StringUtil.trim(this.quantity.text) != null ? StringUtil.trim(this.quantity.text):"",
	                            	inputPrice:StringUtil.trim(this.inputPrice.text) != null ? StringUtil.trim(this.inputPrice.text):"",
	                            	grossNetType:this.isInFirstEntryScreen ? (this.grossNetType.selectedItem != null ? this.grossNetType.selectedItem.value : "") : (StringUtil.trim(this.grossNetTypeTxt.text) != null ? StringUtil.trim(this.grossNetTypeTxt.text):""),
	                            	inputPriceFormat:this.inputPriceFormat.selectedItem != null ? this.inputPriceFormat.selectedItem.value : "",
	                            	remarks:StringUtil.trim(this.remarks.text) != null ? StringUtil.trim(this.remarks.text):"",
	                            	omsOrderNo:StringUtil.trim(this.omsOrderNo.text) != null ? StringUtil.trim(this.omsOrderNo.text):"",
	                            	omsExecutionNo:StringUtil.trim(this.omsExecutionNo.text) != null ? StringUtil.trim(this.omsExecutionNo.text):""
                            	}
                           }; 
		        var trdEntryValidator:TradeEntryValidator = new TradeEntryValidator();
		        trdEntryValidator.source = tradeValidationModel;
		        trdEntryValidator.property = "tradeEntry";
		        var validationResult:ValidationResultEvent = trdEntryValidator.validate();
		        if(validationResult.type == ValidationResultEvent.INVALID){
		            var errorMsg:String = validationResult.message;
		            XenosAlert.error(errorMsg);
		        }else {
		        	reqSend = true;
		        	if(!XenosStringUtils.isBlank(StringUtil.trim(this.tradeCcy.ccyText.text)) && !XenosStringUtils.isBlank(StringUtil.trim(this.stlCcy.ccyText.text))){
		        		if(!isTrdCcyIssueCcyEqual(StringUtil.trim(this.tradeCcy.ccyText.text),StringUtil.trim(this.stlCcy.ccyText.text))){
		        			if(XenosStringUtils.isBlank(StringUtil.trim(this.exchangeRate.text))){
			        			reqSend = false;
			        			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.entry.empty.exchangerate'));
			        		}
		        		}
		        	}
		        	if(!numValInputPrice.handleNumericField(numberFormatter) ||
		        		!numValQty.handleNumericField(numberFormatter) ||
		        		!numValAccrIntAmt.handleNumericField(numberFormatter) ||
		        		!numValAccrDays.handleNumericField(numberFormatter) ||  
	        		    !numValIndexRatio.handleNumericField(numberFormatter)) {
		        		reqSend = false;
		        	}
		        	if(reqSend){
	      				if((XenosStringUtils.equals(datasourceStr,"OG"))||
	      				(XenosStringUtils.equals(datasourceStr,"TRD-SUITE"))){
	        			   checkInputPrice();
	        		       checkQty();
	        		       checkIndexRatio();
	        		    }else{
	        		      checkInputPrice();
	        		      checkQty();
	        		      checkIndexRatio();
	        			  this.clearAmountFields();
	        		}
		        		checkValueDate();
		        	}
		        	if(this.mode == 'entry'){
		        		addlTradeEntryRequest.request = populateReqFromMandatoryEntryScreen();
		        	}else if(this.mode == 'amendment'){
		        		addlTradeEntryRequest.url = 'trd/tradeEntryAmend.action?';
		        		addlTradeEntryRequest.request = populateReqFromMandatoryEntryScreen();
		        	}
	    			addlTradeEntryRequest.method = "POST";
	    			if(reqSend){
	    				/* checkInputPrice();
		        		checkQty();
		        		checkValueDate(); */
	    				addlTradeEntryRequest.send();
	    			}
		        }
	    	}
	    }
	    
	    private function doSave():void{
	    	uConfSubmit.enabled = false;
	    	backUsrConf.enabled = false;
	    	this.mode == 'entry' ?  this.dispatchEvent(new Event('entryConf')) :  this.dispatchEvent(new Event('amendEntryConf'));
	    }
	    
	    private function doReset():void{
	    	var reqObj:Object = new Object();
	    	if(this.mode == "entry"){
	    		reqObj.rnd = Math.random()+"";
	    		resetRequest.request = reqObj;
		        resetRequest.send();
	    	}else if(this.mode == "amendment"){
	    		this.dispatchEvent(new Event('amendEntryReset'));
	    	}
	    }
	    
	    /**
	    * This method is the result handler for the HTTPRequest
	    * which is thrown from FIRST trade entry screen to go to
	    * the SECOND trade Entry screen.
	    */
	    private function loadAdditionalTradeEntryScreen(event:ResultEvent):void {
			if(event != null){
				if(event.result != null){
					if(event.result.tradeEntryActionForm != null){
						app.submitButtonInstance = submitAddlEntry;
						isInFirstEntryScreen = false;
						this.additionalEntryCriteria.visible = true;
						this.additionalEntryCriteria.includeInLayout = true;
						this.upBack.visible = true;
						this.upBack.includeInLayout = true;
						if(event.result.tradeEntryActionForm.tradeScreenData != null){
							errPage.clearError(super.getInitResultEvent());
							if(tax != null){
								if(tax.length > 0){
									taxFeeGrid.visible = true;
									taxFeeGrid.includeInLayout = true;
								}else{
									taxFeeGrid.visible = false;
									taxFeeGrid.includeInLayout = false;
								}
							}else{
								taxFeeGrid.visible = false;
								taxFeeGrid.includeInLayout = false;
							}
							populateMandatoryTradeEntryFieldValues(event.result.tradeEntryActionForm.tradeScreenData);
							showHideFields();
						}
					}else if(event.result.XenosErrors != null){
						app.submitButtonInstance = submit;
						errPage.clearError(super.getInitResultEvent());
						isInFirstEntryScreen = true;
						this.upBack.visible = false;
						this.upBack.includeInLayout = false;
						this.additionalEntryCriteria.visible = false;
						this.additionalEntryCriteria.includeInLayout = false;
						if(XenosStringUtils.equals(event.result.XenosErrors.errorForIssueCcy,"NOT_FOUND")){
							this.issuePricingRow.visible = true;
							this.issuePricingRow.includeInLayout = true;
							this.issueCcy.text = StringUtil.trim(event.result.XenosErrors.issueCcy);
						}
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
						XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
					}
				}else{
					XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				}
			}else{
				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			}
		}
		
		private function loadResetTradeEntryScreen(event:ResultEvent):void{
			if(event != null){
				if(event.result != null){
					if(event.result.tradeEntryActionForm != null){
						if(this.mode == "amendment"){
							app.submitButtonInstance = submitAddlEntry;
							isInFirstEntryScreen = false;
							this.additionalEntryCriteria.visible = true;
							this.additionalEntryCriteria.includeInLayout = true;
							this.upBack.visible = true;
							this.upBack.includeInLayout = true;
						}else if(this.mode == "entry"){
							app.submitButtonInstance = submit;
							isInFirstEntryScreen = true;
							this.additionalEntryCriteria.visible = false;
							this.additionalEntryCriteria.includeInLayout = false;
							this.upBack.visible = false;
							this.upBack.includeInLayout = false;
							tax = new ArrayCollection();
						}
						if(event.result.tradeEntryActionForm.tradeScreenData != null){
							errPage.clearError(super.getInitResultEvent());
							if(tax != null){
								if(tax.length > 0){
									taxFeeGrid.visible = true;
									taxFeeGrid.includeInLayout = true;
								}else{
									taxFeeGrid.visible = false;
									taxFeeGrid.includeInLayout = false;
								}
							}else{
								taxFeeGrid.visible = false;
								taxFeeGrid.includeInLayout = false;
							}
							resetMandatoryTradeEntryFieldValues(event.result.tradeEntryActionForm.tradeScreenData);
						}
						showHideFields();
					}else if(event.result.XenosErrors != null){
						app.submitButtonInstance = submit;
						errPage.clearError(super.getInitResultEvent());
						isInFirstEntryScreen = true;
						this.upBack.visible = false;
						this.upBack.includeInLayout = false;
						this.additionalEntryCriteria.visible = false;
						this.additionalEntryCriteria.includeInLayout = false;
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
						XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
					}
				}else{
					XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				}
			}else{
				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			}
		}
		
		private function isTrdCcyIssueCcyEqual(trdCcy:String, issueCcy:String):Boolean{
			var trdCcyCode:String = "";
	    	var issueCcyCode:String = "";
	    	if(trdCcy.indexOf("/") != -1){
	    		trdCcyCode = trdCcy.split("/")[0];
	    	}else{
	    		trdCcyCode = trdCcy;
	    	}
	    	if(issueCcy.indexOf("/") != -1){
	    		issueCcyCode = issueCcy.split("/")[0];
	    	}else{
	    		issueCcyCode = issueCcy;
	    	}
	    	return XenosStringUtils.equals(trdCcyCode,issueCcyCode);
		}
		
		private function populateMandatoryTradeEntryFieldValues(data:Object):void{
			finInstPkStr = data.executionMarketPk;
			instPkStr = data.instrumentPk;
			deliveryMethodStr = data.deliveryMethod;
		    stlLocationSecStr = data.stlLocationSec;
		    stlLocationCashStr = data.stlLocationCash;
		    trdTypeStr = data.tradeType;
		    trdTypeTxtStr = data.tradeTypeStr;
		    trdCcyStr = data.tradeCurrency;
		    issueCcyStr = data.issueCurrency;
		    valDateStr = data.valueDateStr;
		    qtyStr = data.quantityStr;
		    ipPriceStr = data.inputPriceStr;
		    instrumentTypeParent = data.instrumentTypeParent;
		    
		    if(trdCcyStr != null && issueCcyStr != null){
		    	if(!isTrdCcyIssueCcyEqual(trdCcyStr,issueCcyStr)){
			    	this.issuePricingRow.visible = true;
			    	this.issuePricingRow.includeInLayout = true;
			    }else{
			    	this.issuePricingRow.visible = false;
			    	this.issuePricingRow.includeInLayout = false;
			    }
		    }
			
			this.tradeTypeTxt.text = data.tradeTypeStr;
			if(data.tradeTypeValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.tradeTypeValues.item is ArrayCollection){
					for each(item in (data.tradeTypeValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.tradeType){
							index = (data.tradeTypeValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(data.tradeTypeValues.item);
					index = 0;
				}
			}
			this.tradeType.dataProvider = initcol;
			this.tradeType.selectedIndex = index+1;
			
			this.tradeDateTxt.text = data.tradeDateStr;
			if(data.tradeDateStr != null){
				this.tradeDate.selectedDate = DateUtils.toDate(data.tradeDateStr);
			}
			this.tradeTime.text = data.tradeTime;
			if(data.valueDateStr != null){
				this.valueDate.selectedDate = DateUtils.toDate(data.valueDateStr);
			}
			this.buySellFlagTxt.text = data.buySellOrientation;
			
			if(data.buySellOrientationValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.buySellOrientationValues.item is ArrayCollection){
					for each(item in (data.buySellOrientationValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.buySellOrientation){
							index = (data.buySellOrientationValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(data.buySellOrientationValues.item);
					index = 0;
				}
			}
			this.buySellFlag.dataProvider = initcol;
			this.buySellFlag.selectedIndex = index+1;
			
			//XGA-105
			/*
			if(data.shortSellingFlagValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.shortSellingFlagValues.item is ArrayCollection){
					for each(item in (data.shortSellingFlagValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.shortSellingFlag){
							index = (data.shortSellingFlagValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(data.shortSellingFlagValues.item);
					index = 0;
				}
			}
			this.shortSellFlag.dataProvider = initcol;
			this.shortSellFlag.selectedIndex = index+1;
			
			if(data.shortSellExemptFlagValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.shortSellExemptFlagValues.item is ArrayCollection){
					for each(item in (data.shortSellExemptFlagValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.shortSellExemptFlag){
							index = (data.shortSellExemptFlagValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(data.shortSellExemptFlagValues.item);
					index = 0;
				}
			}
			this.shortSellExemptFlag.dataProvider = initcol;
			this.shortSellExemptFlag.selectedIndex = index+1;
			*/
			
			this.fundAccNoTxt.text = data.inventoryAccountNo;
			this.fundAccountPopup.accountNo.text = data.inventoryAccountNo;
			this.brokerAccNoTxt.text = data.accountNo;
			this.brokerAccPopUp.accountNo.text = data.accountNo;
			
			if(data.matchingSupressFlagValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = 0;
				if(data.matchingSupressFlagValues.item is ArrayCollection){
					for each(item in (data.matchingSupressFlagValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.matchingSupressFlag){
							index = (data.matchingSupressFlagValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(data.matchingSupressFlagValues.item);
					index = 0;
				}
			}
			this.matchingSuppressFlag.dataProvider = initcol;
			this.matchingSuppressFlag.selectedIndex = index;
			
			// PL Suppress Flag
			if(data.plSuppressFlagValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = 0;
				initcol.addItem({label:"",value:""});
				if(data.plSuppressFlagValues.item is ArrayCollection){
					for each(item in (data.plSuppressFlagValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.plSuppressFlag){
							index = (data.plSuppressFlagValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(data.plSuppressFlagValues.item);
					if(data.plSuppressFlag == null){
							index = 0;
						}else if (data.plSuppressFlag == Globals.DATABASE_YES){
							index = 1;
						}
					
				}
			}
			this.plSuppressFlag.dataProvider = initcol;
			this.plSuppressFlag.selectedIndex = index;
			
			this.securityCodeTxt.text = data.securityId ;
			this.securityCode.instrumentId.text = data.securityId ;
			
			this.quantity.text = data.quantityStr;
			this.inputPrice.text = data.inputPriceStr;
			
			this.grossNetTypeTxt.text = data.grossNetType;
			if(data.grossNetTypeValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = 0;
				if(data.grossNetTypeValues.item is ArrayCollection){
					for each(item in (data.grossNetTypeValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.grossNetType){
							index = (data.grossNetTypeValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(data.grossNetTypeValues.item);
					index = 0;
				}
			}
			this.grossNetType.dataProvider = initcol;
			this.grossNetType.selectedIndex = index;
			
			
			if(data.inputPriceFormatValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.inputPriceFormatValues.item is ArrayCollection){
					for each(item in (data.inputPriceFormatValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.inputPriceFormat){
							index = (data.inputPriceFormatValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(data.inputPriceFormatValues.item);
					index = 0;
				}
			}
			this.inputPriceFormat.dataProvider = initcol;
			this.inputPriceFormat.selectedIndex = index+1;
			
			this.tradeCcyTxt.text = data.tradeCurrency;
			this.tradeCcy.ccyText.text = data.tradeCurrency;
			
			this.executionMarket.itemCombo.text = data.executionMarket;
			
			
			if(data.executionMethodValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.executionMethodValues.item is ArrayCollection){
					for each(item in (data.executionMethodValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.executionMethod){
							index = (data.executionMethodValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(data.executionMethodValues.item);
					index = 0;
				}
			}
			this.executionMethod.dataProvider = initcol;
			this.executionMethod.selectedIndex = index+1;
			this.stlCcy.ccyText.text = data.settlementCurrency;
			this.exchangeRate.text = data.exchangeRateStr;
			
			if(data.calculationTypeValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.calculationTypeValues.item is ArrayCollection){
					for each(item in (data.calculationTypeValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.calculationType){
							index = (data.calculationTypeValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(data.calculationTypeValues.item);
					index = 0;
				}
			}
			this.calculationType.dataProvider = initcol;
			this.calculationType.selectedIndex = index+1;
			
			this.issueCcy.text = data.issueCurrency;
			this.issuePricingExchangeRate.text = data.exchangeRateIssuePricingStr;
			
			if(data.calculationTypeValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.calculationTypeValues.item is ArrayCollection){
					for each(item in (data.calculationTypeValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.calculationTypeIssuePricing){
							index = (data.calculationTypeValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(data.calculationTypeValues.item);
					index = 0;
				}
			}
			this.issuePricingCalculationType.dataProvider = initcol;
			this.issuePricingCalculationType.selectedIndex = index+1;
			
			if(data.exCouponFlagValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.exCouponFlagValues.item is ArrayCollection){
					for each(item in (data.exCouponFlagValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.exCouponFlag){
							index = (data.exCouponFlagValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(data.exCouponFlagValues.item);
					index = 0;
				}
			}
			this.excouponFlag.dataProvider = initcol;
			this.excouponFlag.selectedIndex = index+1;
			
			if(data.dirtyPriceFlagValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.dirtyPriceFlagValues.item is ArrayCollection){
					for each(item in (data.dirtyPriceFlagValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.dirtyPriceFlag){
							index = (data.dirtyPriceFlagValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(data.dirtyPriceFlagValues.item);
					index = 0;
				}
			}
			this.dirtyPriceFlag.dataProvider = initcol;
			this.dirtyPriceFlag.selectedIndex = index+1;
			
			if(data.negativeAccruedInterestFlagValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.negativeAccruedInterestFlagValues.item is ArrayCollection){
					for each(item in (data.negativeAccruedInterestFlagValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.negativeAccruedInterestFlag){
							index = (data.negativeAccruedInterestFlagValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(data.negativeAccruedInterestFlagValues.item);
					index = 0;
				}
			}
			this.negativeAccruedInterestFlag.dataProvider = initcol;
			this.negativeAccruedInterestFlag.selectedIndex = index+1;
			
			this.poolFactor.text = data.poolFactorStr;
			this.indexRatio.text = data.indexRatioStr;
			indxRatioTempStr = data.indexRatioStr;
			this.currentFaceValue.text = data.currentFaceValueStr;
			
			this.accrInterestAmt.text = data.accruedInterestAmountStr;
			this.accrDays.text = data.accruedDaysStr;
			
			if(data.accruedStartDateStr != null){
				this.accruedStartDate.selectedDate = DateUtils.toDate(data.accruedStartDateStr);
			}
			this.principalAmtTemp = "";
			this.price.text = data.priceStr;
			this.principalAmt.text = data.principalAmountStr;
			this.principalAmtInIssueCcy.text = data.principalAmountInIssueStr;
			this.interestRate.text = data.interestRateStr;
			this.netAmt.text = data.netAmountStr;
			this.netAmtInTrdCcy.text = data.netAmountInTradingCurrency;
			if(data.filteredTaxFeeIdList != null){
				item = new Object();
				initcol = new ArrayCollection();
				initcol.addItem({label:" ",value:" "});
				if(data.filteredTaxFeeIdList.item is ArrayCollection){
					for each(item in (data.filteredTaxFeeIdList.item as ArrayCollection)){
						initcol.addItem(item);
					}
				}else{
					initcol.addItem(data.filteredTaxFeeIdList.item);
				}
			}
			this.taxFeeIdCombo.dataProvider = initcol;
			
			this.taxRateTxt.text = "";
			
			if(data.rateTypeValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				initcol.addItem({label:" ",value:" "});
				if(data.rateTypeValues.item is ArrayCollection){
					for each(item in (data.rateTypeValues.item as ArrayCollection)){
						initcol.addItem(item);
					}
				}else{
					initcol.addItem(data.rateTypeValues.item);
				}
			}
			this.taxRateTypeCombo.dataProvider = initcol;
			
			// set remarks list if list is not null
		    	initcol = new ArrayCollection();
		    	item = new Object();
		    	initcol.addItem("");
		    	if(data.remarksList!=null){
		    		if(data.remarksList.remarks is ArrayCollection){
		    			for each(item in (data.remarksList.remarks as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
			    		    this.remarkListRow.visible = true;
		    				this.remarkListRow.includeInLayout = true;
		    				this.remarkRow.visible = false;
		    				this.remarkRow.includeInLayout = false;
		    		}else{
		    			this.remarks.text = data.remarksList.remarks.toString();
			    		this.remarkListRow.visible = false;
		    			this.remarkListRow.includeInLayout = false;
		    			this.remarkRow.visible = true;
		    			this.remarkRow.includeInLayout = true;
		    			this.remarks.editable = false;
		    		}
		    	}else{
		    		this.remarks.text = XenosStringUtils.EMPTY_STR;
		    		this.remarkListRow.visible = false;
		    		this.remarkListRow.includeInLayout = false;
		    		this.remarkRow.visible = true;
		    		this.remarkRow.includeInLayout = true;
		    		this.remarks.editable = true;
		    		
		    		
		    	}
		    	this.remarksList.dataProvider = initcol;
			
			//STL Instruction Suppress Flag
			item = new Object();
			initcol = new ArrayCollection();
			index = -1;
			if(XenosStringUtils.equals(mode, "amendment")){
				initcol.addItem({label:" ",value:" "});
			}
			initcol.addItem({label:"Y",value:"Y"});
			initcol.addItem({label:"N",value:"N"});
			if(XenosStringUtils.equals(mode, "amendment")){
				if(data.instructionSuppressFlag != null){
					if(data.instructionSuppressFlag == "Y"){
						index = 1;
					}else if(data.instructionSuppressFlag == "N"){
						index = 2;
					}else{
						index = 0;
					}
				}else{
					index = 0;
				}
			}else{
				if(data.instructionSuppressFlag != null){
					if(data.instructionSuppressFlag == "Y"){
						index = 0;
					}else if(data.instructionSuppressFlag == "N"){
						index = 1;
					}
				}else{
					index = 0;
				}
			}
			this.stlInsSuprFlag.dataProvider = initcol;
			this.stlInsSuprFlag.selectedIndex = index;
			
			this.taxAmountTxt.text = "";
			/* if(!XenosStringUtils.isBlank(data.remarks)){
				this.remarks.text = data.remarks;
			} */
			if(!XenosStringUtils.isBlank(data.remarksForReports)){
				this.remarksForReports.text = data.remarksForReports;
			}
			if(!XenosStringUtils.isBlank(data.orderReferenceNo)){
				this.omsOrderNo.text = data.orderReferenceNo;
			}
			if(!XenosStringUtils.isBlank(data.brokerReferenceNo)){
				this.brokerRefNo.text = data.brokerReferenceNo;
			}
			if(!XenosStringUtils.isBlank(data.etcReferenceNo)){
				this.ogRefNo.text = data.etcReferenceNo;
			}
			if(!XenosStringUtils.isBlank(data.omsExecutionNo)){
				this.omsExecutionNo.text = data.omsExecutionNo;
			}
			if(!XenosStringUtils.isBlank(data.senderReferenceNo)){
				this.senderRefNo.text = data.senderReferenceNo;
			}
			if(!XenosStringUtils.isBlank(data.externalReferenceNo)){
				this.externalRefNo.text = data.externalReferenceNo;
			}
			
			if(data.softDollarFlagValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				initcol.addItem({label:" ",value:" "});
				if(data.softDollarFlagValues.item is ArrayCollection){
					for each(item in (data.softDollarFlagValues.item as ArrayCollection)){
						initcol.addItem(item);
					}
				}else{
					initcol.addItem(data.softDollarFlagValues.item);
				}
			}
			this.softDollarFlag.dataProvider = initcol;
			if(data.securitySsi != null){
				if(data.securitySsi.cashSecurityFlag != null){
					this.cashSecFlagSec.text = data.securitySsi.cashSecurityFlag;
				}
				if(data.securitySsi.brokerBic != null){
					this.brokerBicSec.text = data.securitySsi.brokerBic;
				}
				if(data.securitySsi.acronym != null){
					this.acronymSec.text = data.securitySsi.acronym;
				}
				if(data.securitySsi.instrumentType != null){
					this.securityTypeSec.text = data.securitySsi.instrumentType;
				}
				if(data.securitySsi.settlementCcy != null){
					this.ccySec.text = data.securitySsi.settlementCcy;
				}
				if(data.securitySsi.settlementType != null){
					this.stlTypeSec.text = data.securitySsi.settlementType;
				}
				if(data.securitySsi.bankName != null){
					this.bankNameSec.text = data.securitySsi.bankName;
				}
				if(data.securitySsi.contraId != null){
					this.contraIdSec.text = data.securitySsi.contraId;
				}
				if(data.securitySsi.dtcParticipantNumber != null){
					this.dtcPartNoSec.text = data.securitySsi.dtcParticipantNumber;
				}
				if(data.securitySsi.cpExternalSettleAct != null){
					this.dtcExtStlAccSec.text = data.securitySsi.cpExternalSettleAct;
				}
				if(data.securitySsi.priority != null){
					this.prioritySec.text = data.securitySsi.priority;
				}
				if(data.securitySsi.placeOfSettlement != null){
					this.placeOfStlSec.text = data.securitySsi.placeOfSettlement;
				}
				if(data.securitySsi.participantId != null){
					this.partIdSec.text = data.securitySsi.participantId;
				}
				if(data.securitySsi.participantId2 != null){
					this.partId2Sec.text = data.securitySsi.participantId2;
				}
			}
			
			if(data.cashSsi != null){
				if(data.cashSsi.cashSecurityFlag != null){
					this.cashSecFlagCash.text = data.cashSsi.cashSecurityFlag;
				}
				if(data.cashSsi.brokerBic != null){
					this.brokerBicCash.text = data.cashSsi.brokerBic;
				}
				if(data.cashSsi.acronym != null){
					this.acronymCash.text = data.cashSsi.acronym;
				}
				if(data.cashSsi.instrumentType != null){
					this.securityTypeCash.text = data.cashSsi.instrumentType;
				}
				if(data.cashSsi.settlementCcy != null){
					this.ccyCash.text = data.cashSsi.settlementCcy;
				}
				if(data.cashSsi.settlementType != null){
					this.stlTypeCash.text = data.cashSsi.settlementType;
				}
				if(data.cashSsi.bankName != null){
					this.bankNameCash.text = data.cashSsi.bankName;
				}
				if(data.cashSsi.contraId != null){
					this.contraIdCash.text = data.cashSsi.contraId;
				}
				if(data.cashSsi.dtcParticipantNumber != null){
					this.dtcPartNoCash.text = data.cashSsi.dtcParticipantNumber;
				}
				if(data.cashSsi.cpExternalSettleAct != null){
					this.dtcExtStlAccCash.text = data.cashSsi.cpExternalSettleAct;
				}
				if(data.cashSsi.priority != null){
					this.priorityCash.text = data.cashSsi.priority;
				}
				if(data.cashSsi.placeOfSettlement != null){
					this.placeOfStlCash.text = data.cashSsi.placeOfSettlement;
				}
				if(data.cashSsi.participantId != null){
					this.partIdCash.text = data.cashSsi.participantId;
				}
				if(data.cashSsi.participantId2 != null){
					this.partId2Cash.text = data.cashSsi.participantId2;
				}
			}
		
			checkPlSuppressFlag();
		}
		
		private function resetMandatoryTradeEntryFieldValues(data:Object):void{
			finInstPkStr = data.executionMarketPk;
			instPkStr = data.instrumentPk;
			deliveryMethodStr = data.deliveryMethod;
		    stlLocationSecStr = data.stlLocationSec;
		    stlLocationCashStr = data.stlLocationCash;
		    trdTypeStr = data.tradeType;
		    valDateStr = data.valueDateStr;
		    qtyStr = data.quantityStr;
		    ipPriceStr = data.inputPriceStr;
		    instrumentTypeParent = data.instrumentTypeParent;
		    
		    if(!XenosStringUtils.isBlank(data.tradeCurrency) && !XenosStringUtils.isBlank(data.issueCurrency)){
		    	if(!isTrdCcyIssueCcyEqual(data.tradeCurrency, data.issueCurrency)){
		    		issuePricingRow.visible = true;
		    		issuePricingRow.includeInLayout = true;
		    	}else{
			    	issuePricingRow.visible = false;
			    	issuePricingRow.includeInLayout = false;
			    }
		    }
			
			this.tradeTypeTxt.text = data.tradeTypeStr;
			if(data.tradeTypeValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.tradeTypeValues.item is ArrayCollection){
					for each(item in (data.tradeTypeValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.tradeTypeStr){
							index = (data.tradeTypeValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(item);
					index = 0;
				}
			}
			this.tradeType.dataProvider = initcol;
			this.tradeType.selectedIndex = index+1;
			this.tradeDateTxt.text = data.tradeDateStr;
			if(data.tradeDateStr != null){
				this.tradeDate.selectedDate = DateUtils.toDate(data.tradeDateStr);
			}else{
				this.tradeDate.selectedDate = null;
			}
			this.tradeTime.text = data.tradeTime;
			if(data.valueDateStr != null){
				this.valueDate.selectedDate = DateUtils.toDate(data.valueDateStr);
			}else{
				this.valueDate.selectedDate = null;
			}
			this.buySellFlagTxt.text = data.buySellOrientation;
			if(data.buySellOrientationValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.buySellOrientationValues.item is ArrayCollection){
					for each(item in (data.buySellOrientationValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.buySellOrientation){
							index = (data.buySellOrientationValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(item);
					index = 0;
				}
			}
			this.buySellFlag.dataProvider = initcol;
			this.buySellFlag.selectedIndex = index+1;
			
			//XGA-105
			/*
			if(data.shortSellingFlagValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.shortSellingFlagValues.item is ArrayCollection){
					for each(item in (data.shortSellingFlagValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.shortSellingFlag){
							index = (data.shortSellingFlagValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(item);
					index = 0;
				}
			}
			this.shortSellFlag.dataProvider = initcol;
			this.shortSellFlag.selectedIndex = index+1;
			
			if(data.shortSellExemptFlagValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.shortSellExemptFlagValues.item is ArrayCollection){
					for each(item in (data.shortSellExemptFlagValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.shortSellExemptFlag){
							index = (data.shortSellExemptFlagValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(item);
					index = 0;
				}
			}
			this.shortSellExemptFlag.dataProvider = initcol;
			this.shortSellExemptFlag.selectedIndex = index+1;
			*/
			
			this.fundAccNoTxt.text = data.inventoryAccountNo;
			this.fundAccountPopup.accountNo.text = data.inventoryAccountNo;
			
			this.brokerAccNoTxt.text = data.accountNo;
			this.brokerAccPopUp.accountNo.text = data.accountNo;
			
			if(data.matchingSupressFlagValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = 0;
				if(data.matchingSupressFlagValues.item is ArrayCollection){
					for each(item in (data.matchingSupressFlagValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.matchingSupressFlag){
							index = (data.matchingSupressFlagValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(item);
					index = 0;
				}
			}
			this.matchingSuppressFlag.dataProvider = initcol;
			this.matchingSuppressFlag.selectedIndex = index;
			
				// Reset PL Suppress Flag
			
			if(data.plSuppressFlagValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = 0;
				initcol.addItem({label:"",value:""});
				if(data.plSuppressFlagValues.item is ArrayCollection){
					 for each(item in (data.plSuppressFlagValues.item as ArrayCollection)){
						initcol.addItem(item);
					} 
				}else{
					initcol.addItem(data.plSuppressFlagValues.item);
					index = 1;
				}
			}
			this.plSuppressFlag.dataProvider = initcol;
			this.plSuppressFlag.selectedIndex = index;
			
			this.securityCodeTxt.text = data.securityId;
			this.securityCode.instrumentId.text = data.securityId;
			
			this.quantity.text = data.quantityStr;
			this.inputPrice.text = data.inputPriceStr;
			
			this.grossNetTypeTxt.text = data.grossNetType;
			if(data.grossNetTypeValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				if(data.grossNetTypeValues.item is ArrayCollection){
					for each(item in (data.grossNetTypeValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.grossNetType){
							index = (data.grossNetTypeValues.item as ArrayCollection).getItemIndex(item);
						}
						if(XenosStringUtils.isBlank(data.grossNetType)){
							index = 0;
						}
					}
				}else{
					initcol.addItem(item);
					index = 0;
				}
			}
			this.grossNetType.dataProvider = initcol;
			this.grossNetType.selectedIndex = index;
			
			
			if(data.inputPriceFormatValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.inputPriceFormatValues.item is ArrayCollection){
					for each(item in (data.inputPriceFormatValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.inputPriceFormat){
							index = (data.inputPriceFormatValues.item as ArrayCollection).getItemIndex(item);
						}
						if(XenosStringUtils.isBlank(data.inputPriceFormat)){
							if(item.value == "UNIT PRICE"){
								index = (data.inputPriceFormatValues.item as ArrayCollection).getItemIndex(item);
							}
						}
					}
				}else{
					initcol.addItem(item);
					index = 0;
				}
			}
			this.inputPriceFormat.dataProvider = initcol;
			this.inputPriceFormat.selectedIndex = index+1;
			
			this.tradeCcyTxt.text = data.tradeCurrency;
			this.tradeCcy.ccyText.text = data.tradeCurrency;
			
			this.executionMarket.itemCombo.text = data.executionMarket;
			
			if(data.executionMethodValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.executionMethodValues.item is ArrayCollection){
					for each(item in (data.executionMethodValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.executionMethod){
							index = (data.executionMethodValues.item as ArrayCollection).getItemIndex(item);
						}
						if(XenosStringUtils.isBlank(data.executionMethod)){
							if(item.value == "MARKET"){
								index = (data.executionMethodValues.item as ArrayCollection).getItemIndex(item);
							}
						}
					}
				}else{
					initcol.addItem(item);
					index = 0;
				}
			}
			this.executionMethod.dataProvider = initcol;
			this.executionMethod.selectedIndex = index+1;
			this.stlCcy.ccyText.text = data.settlementCurrency;
			this.exchangeRate.text = data.exchangeRateStr;
			
			if(data.calculationTypeValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.calculationTypeValues.item is ArrayCollection){
					for each(item in (data.calculationTypeValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.calculationType){
							index = (data.calculationTypeValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(item);
					index = 0;
				}
			}
			this.calculationType.dataProvider = initcol;
			this.calculationType.selectedIndex = index+1;
			
			this.issueCcy.text = data.issueCurrency;
			this.issuePricingExchangeRate.text = data.exchangeRateIssuePricingStr;
			
			if(data.calculationTypeValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.calculationTypeValues.item is ArrayCollection){
					for each(item in (data.calculationTypeValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.calculationTypeIssuePricing){
							index = (data.calculationTypeValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(item);
					index = 0;
				}
			}
			this.issuePricingCalculationType.dataProvider = initcol;
			this.issuePricingCalculationType.selectedIndex = index+1;
			
			if(data.exCouponFlagValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.exCouponFlagValues.item is ArrayCollection){
					for each(item in (data.exCouponFlagValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.exCouponFlag){
							index = (data.exCouponFlagValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(item);
					index = 0;
				}
			}
			this.excouponFlag.dataProvider = initcol;
			this.excouponFlag.selectedIndex = index+1;
			
			if(data.dirtyPriceFlagValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.dirtyPriceFlagValues.item is ArrayCollection){
					for each(item in (data.dirtyPriceFlagValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.dirtyPriceFlag){
							index = (data.dirtyPriceFlagValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(item);
					index = 0;
				}
			}
			this.dirtyPriceFlag.dataProvider = initcol;
			this.dirtyPriceFlag.selectedIndex = index+1;
			
			if(data.negativeAccruedInterestFlagValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				index = -1;
				initcol.addItem({label:" ",value:" "});
				if(data.negativeAccruedInterestFlagValues.item is ArrayCollection){
					for each(item in (data.negativeAccruedInterestFlagValues.item as ArrayCollection)){
						initcol.addItem(item);
						if(item.value == data.negativeAccruedInterestFlag){
							index = (data.negativeAccruedInterestFlagValues.item as ArrayCollection).getItemIndex(item);
						}
					}
				}else{
					initcol.addItem(item);
					index = 0;
				}
			}
			this.negativeAccruedInterestFlag.dataProvider = initcol;
			this.negativeAccruedInterestFlag.selectedIndex = index+1;
			
			this.poolFactor.text = data.poolFactorStr;
			this.indexRatio.text = data.indexRatioStr;
			indxRatioTempStr = data.indexRatioStr;
			this.currentFaceValue.text = data.currentFaceValueStr;
			
			this.accrInterestAmt.text = data.accruedInterestAmountStr;
			this.accrDays.text = data.accruedDaysStr;
			
			if(data.accruedStartDateStr != null){
				this.accruedStartDate.selectedDate = DateUtils.toDate(data.accruedStartDateStr);
			}
			
			this.price.text = data.priceStr;
			this.principalAmt.text = data.principalAmountStr;
			this.principalAmtInIssueCcy.text = data.principalAmountInIssueStr;
			this.interestRate.text = data.interestRateStr;
			this.netAmt.text = data.netAmountStr;
			this.netAmtInTrdCcy.text = data.netAmountInTradingCurrency;
			if(data.filteredTaxFeeIdList != null){
				item = new Object();
				initcol = new ArrayCollection();
				initcol.addItem({label:" ",value:" "});
				if(data.filteredTaxFeeIdList.item is ArrayCollection){
					for each(item in (data.filteredTaxFeeIdList.item as ArrayCollection)){
						initcol.addItem(item);
					}
				}else{
					initcol.addItem(item);
				}
			}
			this.taxFeeIdCombo.dataProvider = initcol;
			
			this.taxRateTxt.text = "";
			
			if(data.rateTypeValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				initcol.addItem({label:" ",value:" "});
				if(data.rateTypeValues.item is ArrayCollection){
					for each(item in (data.rateTypeValues.item as ArrayCollection)){
						initcol.addItem(item);
					}
				}else{
					initcol.addItem(item);
				}
			}
			this.taxRateTypeCombo.dataProvider = initcol;
			
			this.taxAmountTxt.text = "";
			// reset remarks list if list is not null
		    	initcol = new ArrayCollection();
		    	item = new Object();
	        	if(data.remarksList!=null){
		    		if(data.remarksList.remarks is ArrayCollection){
		    			for each(item in (data.remarksList.remarks as ArrayCollection)){
			    			initcol.addItem(item);
			    			if(item == data.remarks){
								index = (data.remarksList.remarks as ArrayCollection).getItemIndex(item);
							}
			    		}
			    		    this.remarkListRow.visible = true;
		    				this.remarkListRow.includeInLayout = true;
		    				this.remarkRow.visible = false;
		    				this.remarkRow.includeInLayout = false;
		    		}else{
		    			this.remarks.text = data.remarksList.remarks.toString();
			    		this.remarkListRow.visible = false;
		    			this.remarkListRow.includeInLayout = false;
		    			this.remarkRow.visible = true;
		    			this.remarkRow.includeInLayout = true;
		    			this.remarks.editable = false;
		    		}
		    	}else{
		    		this.remarks.text = data.remarks;
		    		this.remarkListRow.visible = false;
		    		this.remarkListRow.includeInLayout = false;
		    		this.remarkRow.visible = true;
		    		this.remarkRow.includeInLayout = true;
		    		this.remarks.editable = true;
		    		
		    		
		    	}
		    	this.remarksList.dataProvider = initcol;
		    	this.remarksList.selectedIndex = index;
		    	
			this.remarksForReports.text = data.remarksForReports;
			this.omsOrderNo.text = data.orderReferenceNo;
			this.brokerRefNo.text = data.brokerReferenceNo;
			this.ogRefNo.text = data.etcReferenceNo;
			this.omsExecutionNo.text = data.omsExecutionNo;
			this.senderRefNo.text = data.senderReferenceNo;
			this.externalRefNo.text = data.externalReferenceNo;
			
			if(data.softDollarFlagValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				initcol.addItem({label:" ",value:" "});
				if(data.softDollarFlagValues.item is ArrayCollection){
					for each(item in (data.softDollarFlagValues.item as ArrayCollection)){
						initcol.addItem(item);
					}
				}else{
					initcol.addItem(item);
				}
			}
			this.softDollarFlag.dataProvider = initcol;
			
			this.cashSecFlagSec.text = "";
			this.brokerBicSec.text = "";
			this.acronymSec.text = "";
			this.securityTypeSec.text = "";
			this.ccySec.text = "";
			this.stlTypeSec.text = "";
			this.bankNameSec.text = "";
			this.contraIdSec.text = "";
			this.dtcPartNoSec.text = "";
			this.dtcExtStlAccSec.text = "";
			this.prioritySec.text = "";
			this.placeOfStlSec.text = "";
			this.partIdSec.text = "";
			
			this.cashSecFlagCash.text = "";
			this.brokerBicCash.text = "";
			this.acronymCash.text = "";
			this.securityTypeCash.text = "";
			this.ccyCash.text = "";
			this.stlTypeCash.text = "";
			this.bankNameCash.text = "";
			this.contraIdCash.text = "";
			this.dtcPartNoCash.text = "";
			this.dtcExtStlAccCash.text = "";
			this.priorityCash.text = "";
			this.placeOfStlCash.text = "";
			this.partIdCash.text = "";
			
		}
		
		private function showHideFields():void{
			checkTradeType();
			if(isInFirstEntryScreen){
				this.additionalEntryCriteria.visible = false;
				this.additionalEntryCriteria.includeInLayout = false;
				this.tradeType.visible = true;
				this.tradeType.includeInLayout = true;
				this.tradeTypeTxt.visible = false;
				this.tradeTypeTxt.includeInLayout = false;
				this.tradeDate.visible = true;
				this.tradeDate.includeInLayout = true;
				this.tradeDateTxt.visible = false;
				this.tradeDateTxt.includeInLayout = false;
				this.buySellFlag.visible = true;
				this.buySellFlag.includeInLayout = true;
				this.buySellFlagTxt.visible = false;
				this.buySellFlagTxt.includeInLayout = false;
				this.fundAccountPopup.visible = true;
				this.fundAccountPopup.includeInLayout = true;
				this.fundAccNoTxt.visible = false;
				this.fundAccNoTxt.includeInLayout = false;
				this.brokerAccPopUp.visible = true;
				this.brokerAccPopUp.includeInLayout = true;
				this.brokerAccNoTxt.visible = false;
				this.brokerAccNoTxt.includeInLayout = false;
				this.securityCode.visible = true;
				this.securityCode.includeInLayout = true;
				this.securityCodeTxt.visible = false;
				this.securityCodeTxt.includeInLayout = false;
				this.grossNetType.visible = true;
				this.grossNetType.includeInLayout = true;
				this.grossNetTypeTxt.visible = false;
				this.grossNetTypeTxt.includeInLayout = false;
				this.tradeCcy.visible = true;
				this.tradeCcy.includeInLayout = true;
				this.tradeCcyTxt.visible = false;
				this.tradeCcyTxt.includeInLayout = false;
				upBack.visible = false;
				upBack.includeInLayout = false;
			}else{
				this.additionalEntryCriteria.visible = true;
				this.additionalEntryCriteria.includeInLayout = true;
				this.tradeType.visible = false;
				this.tradeType.includeInLayout = false;
				this.tradeTypeTxt.visible = true;
				this.tradeTypeTxt.includeInLayout = true;
				this.tradeDate.visible = false;
				this.tradeDate.includeInLayout = false;
				this.tradeDateTxt.visible = true;
				this.tradeDateTxt.includeInLayout = true;
				this.buySellFlag.visible = false;
				this.buySellFlag.includeInLayout = false;
				this.buySellFlagTxt.visible = true;
				this.buySellFlagTxt.includeInLayout = true;
				this.fundAccountPopup.visible = false;
				this.fundAccountPopup.includeInLayout = false;
				this.fundAccNoTxt.visible = true;
				this.fundAccNoTxt.includeInLayout = true;
				this.brokerAccPopUp.visible = false;
				this.brokerAccPopUp.includeInLayout = false;
				this.brokerAccNoTxt.visible = true;
				this.brokerAccNoTxt.includeInLayout = true;
				this.securityCode.visible = false;
				this.securityCode.includeInLayout = false;
				this.securityCodeTxt.visible = true;
				this.securityCodeTxt.includeInLayout = true;
				this.grossNetType.visible = false;
				this.grossNetType.includeInLayout = false;
				this.grossNetTypeTxt.visible = true;
				this.grossNetTypeTxt.includeInLayout = true;
				this.tradeCcy.visible = false;
				this.tradeCcy.includeInLayout = false;
				this.tradeCcyTxt.visible = true;
				this.tradeCcyTxt.includeInLayout = true;
				upBack.visible = true;
				upBack.includeInLayout = true;
			}
		}
		
		
		private function addTax():void{
			this.netAmt.text = "";
			this.netAmtInTrdCcy.text = "";
			if(this.taxFeeIdCombo.selectedItem && XenosStringUtils.isBlank(this.taxFeeIdCombo.selectedItem.value)){
				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.enter.taxfeeorcommission'));
			}else if(this.taxRateTypeCombo.selectedItem &&
			         StringUtil.trim(this.taxAmountTxt.text).length == 0 &&
			         StringUtil.trim(this.taxRateTxt.text).length > 0 &&
			         StringUtil.trim(this.taxRateTypeCombo.selectedItem.value).length > 0){
				if(StringUtil.trim(this.taxRateTypeCombo.selectedItem.value) == "AMOUNT"){
					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.invalid.taxfee.amount'));
				}else{
					if(numValTaxRate.handleNumericField(numberFormatter)){
						
						if(this.mode == 'amendment'){
							addTaxInfoRequest.url = 'trd/tradeEntryAmend.action?';
						}else if(this.mode == 'entry'){
							addTaxInfoRequest.url = 'trd/tradeEntry.action?';
						}
						addTaxInfoRequest.request = populateReqForTaxFeeAddition();
	    				addTaxInfoRequest.send();	
					}
				}
			}else if(this.taxRateTypeCombo.selectedItem &&
			         StringUtil.trim(this.taxAmountTxt.text).length > 0 &&
			         StringUtil.trim(this.taxRateTxt.text).length == 0 &&
			         StringUtil.trim(this.taxRateTypeCombo.selectedItem.value)== "AMOUNT"){
			         
			         if(numValTaxAmt.handleNumericField(numberFormatter)){
							if(this.mode == 'amendment'){
								addTaxInfoRequest.url = 'trd/tradeEntryAmend.action?';
							}else if(this.mode == 'entry'){
								addTaxInfoRequest.url = 'trd/tradeEntry.action?';
							}
						     addTaxInfoRequest.request = populateReqForTaxFeeAddition();
			    			 addTaxInfoRequest.send();  
							
					}
			}else{
				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.specify.rateoramount'));
			}
		}
		
		public function editTax(data:Object):void{
			if(this.mode == 'amendment'){
				editTaxInfoRequest.url = 'trd/tradeEntryAmend.action?';
			}else if(this.mode == 'entry'){
				editTaxInfoRequest.url = 'trd/tradeEntry.action?';
			}
			editTaxInfoRequest.request = populateReqForTaxFeeEdit(data);
    		editTaxInfoRequest.send();
		}
		public function deleteTax(data:Object):void{
			if(this.mode == 'amendment'){
				deleteTaxInfoRequest.url = 'trd/tradeEntryAmend.action?';
			}else if(this.mode == 'entry'){
				deleteTaxInfoRequest.url = 'trd/tradeEntry.action?';
			}
			deleteTaxInfoRequest.request = populateReqForTaxFeeDelete(data);
    		deleteTaxInfoRequest.send();
		}
	    
	    private function populateReqForTaxFeeAddition():Object{
	    	var reqObj : Object = new Object();
	    	reqObj.rnd = Math.random()+"";
	    	reqObj.method= "addTaxFee";
	    	reqObj['tradeScreenData.taxFeeId'] = this.taxFeeIdCombo.selectedItem != null ? this.taxFeeIdCombo.selectedItem.value : "";
    		reqObj['tradeScreenData.taxRate'] = this.taxRateTxt.text;
    		reqObj['tradeScreenData.taxRateType'] = this.taxRateTypeCombo.selectedItem != null ? this.taxRateTypeCombo.selectedItem.value : "";
    		reqObj['tradeScreenData.taxAmount'] = this.taxAmountTxt.text;
	    	return reqObj;
	    }
	    
	    private function populateReqForTaxFeeEdit(data:Object):Object{
	    	var reqObj : Object = new Object();
	    	reqObj.rnd = Math.random()+"";
	    	reqObj.method= "editTaxFee";
    		reqObj.rowNoForTaxFee = this.tax.getItemIndex(data);
	    	return reqObj;
	    }
	    
	    private function populateReqForTaxFeeDelete(data:Object):Object{
	    	var reqObj : Object = new Object();
	    	reqObj.rnd = Math.random()+"";
	    	reqObj.method= "deleteTaxFee";
    		reqObj.rowNoForTaxFee = this.tax.getItemIndex(data);
	    	return reqObj;
	    }
	    
	    private function addTaxInfoResultHandler(event:ResultEvent):void{
	    	app.submitButtonInstance = submitAddlEntry;
	    	if(event != null){
	    		if(event.result != null){
	    			if(event.result.tradeEntryActionForm != null){
	    				tax = new ArrayCollection();
	    				if(event.result.tradeEntryActionForm.taxFeeAmounts != null){
		    				if(event.result.tradeEntryActionForm.taxFeeAmounts.taxFeeAmount != null){
		    					if(event.result.tradeEntryActionForm.taxFeeAmounts.taxFeeAmount is ArrayCollection){
		    						tax = (event.result.tradeEntryActionForm.taxFeeAmounts.taxFeeAmount) as ArrayCollection;
		    					}else{
		    						tax.addItem(event.result.tradeEntryActionForm.taxFeeAmounts.taxFeeAmount);
		    					}
		    					tax.refresh();
		    					/* Initialising the tax fields */
		    					resetTaxFeeFields(event.result.tradeEntryActionForm.tradeScreenData);
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
	    			if(tax != null){
						if(tax.length > 0){
							taxFeeGrid.visible = true;
							taxFeeGrid.includeInLayout = true;
						}else{
							taxFeeGrid.visible = false;
							taxFeeGrid.includeInLayout = false;
						}
					}else{
						taxFeeGrid.visible = false;
						taxFeeGrid.includeInLayout = false;
					}
	    		}else{
	    			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    		}
	    	}else{
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}
	    }
	    
	    
	    private function editTaxInfoResultHandler(event:ResultEvent):void{
	    	app.submitButtonInstance = submitAddlEntry;
	    	if(event != null){
	    		if(event.result != null){
	    			if(event.result.tradeEntryActionForm != null){
	    				tax = new ArrayCollection();
	    				if(event.result.tradeEntryActionForm.taxFeeAmounts != null){
		    				if(event.result.tradeEntryActionForm.taxFeeAmounts.taxFeeAmount != null){
		    					if(event.result.tradeEntryActionForm.taxFeeAmounts.taxFeeAmount is ArrayCollection){
		    						tax = (event.result.tradeEntryActionForm.taxFeeAmounts.taxFeeAmount) as ArrayCollection;
		    					}else{
		    						tax.addItem(event.result.tradeEntryActionForm.taxFeeAmounts.taxFeeAmount);
		    					}
		    					tax.refresh();
							}
		    			}
	    				if(event.result.tradeEntryActionForm.tradeScreenData != null){
	    					if(event.result.tradeEntryActionForm.tradeScreenData.filteredTaxFeeIdList != null){
								item = new Object();
								index = -1;
								initcol = new ArrayCollection();
								initcol.addItem({label:" ",value:" "});
								if(event.result.tradeEntryActionForm.tradeScreenData.filteredTaxFeeIdList.item is ArrayCollection){
									for each(item in (event.result.tradeEntryActionForm.tradeScreenData.filteredTaxFeeIdList.item as ArrayCollection)){
										initcol.addItem(item);
										if(event.result.tradeEntryActionForm.tradeScreenData.taxFeeId == item.value){
											index = (event.result.tradeEntryActionForm.tradeScreenData.filteredTaxFeeIdList.item as ArrayCollection).getItemIndex(item);											
										}
									}
								}else{
									initcol.addItem(event.result.tradeEntryActionForm.tradeScreenData.filteredTaxFeeIdList.item);
									index = 0;
								}
							}
							this.taxFeeIdCombo.dataProvider = initcol;
							this.taxFeeIdCombo.selectedIndex = index+1;
							
							this.taxRateTxt.text = event.result.tradeEntryActionForm.tradeScreenData.taxRate;
							
							if(event.result.tradeEntryActionForm.tradeScreenData.rateTypeValues != null){
								item = new Object();
								index = -1;
								initcol = new ArrayCollection();
								initcol.addItem({label:" ",value:" "});
								if(event.result.tradeEntryActionForm.tradeScreenData.rateTypeValues.item is ArrayCollection){
									for each(item in (event.result.tradeEntryActionForm.tradeScreenData.rateTypeValues.item as ArrayCollection)){
										initcol.addItem(item);
										if(event.result.tradeEntryActionForm.tradeScreenData.taxRateType == item.value){
											index = (event.result.tradeEntryActionForm.tradeScreenData.rateTypeValues.item as ArrayCollection).getItemIndex(item);											
										}
									}
								}else{
									initcol.addItem(event.result.tradeEntryActionForm.tradeScreenData.rateTypeValues.item);
									index = 0;
								}
							}
							this.taxRateTypeCombo.dataProvider = initcol;
							this.taxRateTypeCombo.selectedIndex = index+1;
							
							this.taxAmountTxt.text = event.result.tradeEntryActionForm.tradeScreenData.taxAmount;
	    				}else{
	    					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    				}
	    			}else if(event.result.XenosErrors != null){
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
	    				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    			}
	    			if(tax != null){
						if(tax.length > 0){
							taxFeeGrid.visible = true;
							taxFeeGrid.includeInLayout = true;
						}else{
							taxFeeGrid.visible = false;
							taxFeeGrid.includeInLayout = false;
						}
					}else{
						taxFeeGrid.visible = false;
						taxFeeGrid.includeInLayout = false;
					}
	    		}else{
	    			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    		}
	    	}else{
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}
	    }
	    
	    private function deleteTaxInfoResultHandler(event:ResultEvent):void{
	    	app.submitButtonInstance = submitAddlEntry;
	    	if(event != null){
	    		if(event.result != null){
	    			if(event.result.tradeEntryActionForm != null){
	    				tax = new ArrayCollection();
	    				if(event.result.tradeEntryActionForm.taxFeeAmounts != null){
		    				if(event.result.tradeEntryActionForm.taxFeeAmounts.taxFeeAmount != null){
		    					if(event.result.tradeEntryActionForm.taxFeeAmounts.taxFeeAmount is ArrayCollection){
		    						tax = (event.result.tradeEntryActionForm.taxFeeAmounts.taxFeeAmount) as ArrayCollection;
		    					}else{
		    						tax.addItem(event.result.tradeEntryActionForm.taxFeeAmounts.taxFeeAmount);
		    					}
		    					tax.refresh();
		    					/* Initialising the tax fields */
		    					resetTaxFeeFields(event.result.tradeEntryActionForm.tradeScreenData);
							}
		    			}
	    				if(event.result.tradeEntryActionForm.tradeScreenData != null){
	    					resetTaxFeeFields(event.result.tradeEntryActionForm.tradeScreenData);
	    				}else{
	    					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    				}
	    			}else if(event.result.XenosErrors != null){
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
	    				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    			}
	    			if(tax != null){
						if(tax.length > 0){
							taxFeeGrid.visible = true;
							taxFeeGrid.includeInLayout = true;
						}else{
							taxFeeGrid.visible = false;
							taxFeeGrid.includeInLayout = false;
						}
					}else{
						taxFeeGrid.visible = false;
						taxFeeGrid.includeInLayout = false;
					}
	    		}else{
	    			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    		}
	    	}else{
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}
	    }
	    
	    private function resetTaxFeeFields(data:Object):void{
	    	if(data.filteredTaxFeeIdList != null){
				item = new Object();
				initcol = new ArrayCollection();
				initcol.addItem({label:" ",value:" "});
				if(data.filteredTaxFeeIdList.item is ArrayCollection){
					for each(item in (data.filteredTaxFeeIdList.item as ArrayCollection)){
						initcol.addItem(item);
					}
				}else{
					initcol.addItem(data.filteredTaxFeeIdList.item);
				}
			}
			this.taxFeeIdCombo.dataProvider = initcol;
			
			this.taxRateTxt.text = "";
			
			if(data.rateTypeValues != null){
				item = new Object();
				initcol = new ArrayCollection();
				initcol.addItem({label:" ",value:" "});
				if(data.rateTypeValues.item is ArrayCollection){
					for each(item in (data.rateTypeValues.item as ArrayCollection)){
						initcol.addItem(item);
					}
				}else{
					initcol.addItem(data.rateTypeValues.item);
				}
			}
			this.taxRateTypeCombo.dataProvider = initcol;
			
			this.taxAmountTxt.text = "";
	    }
	    
	    
	    private function checkValueDate():void{
	    	if(!XenosStringUtils.equals(valDateStr,valueDate.text)){
	    		this.accrInterestAmt.text = "";
		    	this.accrDays.text = "";
		    	this.poolFactor.text = "";
		    	this.principalAmt.text = "";
		    	this.netAmt.text = "";
		    	this.netAmtInTrdCcy.text = "";
		    	this.currentFaceValue.text = "";
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
	   
	   private function clearSecSsi():void{
	   	var reqObj:Object = new Object();
		reqObj.rnd = Math.random()+"";
		reqObj.method = "clearSsi";
		reqObj.cashSec = "SECURITY";
		resetSecuritySsiRequest.request = reqObj;
	   	resetSecuritySsiRequest.send();
	   }
	   
	   private function loadResetSecuritySsi(event:ResultEvent):void{
	   	this.cashSecFlagSec.text = "";
	   	this.brokerBicSec.text = "";
	   	this.acronymSec.text = "";
	   	this.securityTypeSec.text = "";
	   	this.ccySec.text = "";
	   	this.stlTypeSec.text = "";
	   	this.bankNameSec.text = "";
	   	this.contraIdSec.text = "";
	   	this.dtcPartNoSec.text = "";
	   	this.dtcExtStlAccSec.text = "";
	   	this.prioritySec.text = "";
	   	this.placeOfStlSec.text = "";
	   	this.partIdSec.text = "";
	   	this.partId2Sec.text = "";
	   }
	   
	   private function selectSecSsi():void{
		   	var ssiRulePopUp:TrdSsiPopup = TrdSsiPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication), TrdSsiPopup , true));
		   	PopUpManager.centerPopUp(ssiRulePopUp);
                
            var recItem:ArrayCollection = new ArrayCollection();
            
            var accountNoArray:Array = new Array(1);
 	   	  	accountNoArray[0]= this.brokerAccNoTxt.text;
 	   	  	recItem.addItem(new HiddenObject("accountNo",accountNoArray));
 	   	  	
 	   	  	var stlCcyArray:Array = new Array(1);
 	   	  	var stlCcy:String = this.stlCcy.ccyText.text;
 	   	  	if(stlCcy != null){
 	   	  		if(stlCcy.indexOf("/") != -1){
 	   	  			stlCcy = stlCcy.split("/")[0];
 	   	  		}
 	   	  	}
 	   	  	stlCcyArray[0]= stlCcy;
 	   	  	recItem.addItem(new HiddenObject("settlementcurrency",stlCcyArray));
 	   	  	
 	   	  	var instrumentPkArray:Array = new Array(1);
 	   	  	instrumentPkArray[0]= this.instPkStr;
 	   	  	recItem.addItem(new HiddenObject("instrumentPk",instrumentPkArray));
 	   	  	
            var tradeTypeArray:Array = new Array(1);
 	   	  	tradeTypeArray[0]= this.trdTypeStr;
 	   	  	recItem.addItem(new HiddenObject("tradeType",tradeTypeArray));
 	   	  	
 	   	  	var secFlagArray:Array = new Array(1);
 	   	  	secFlagArray[0]= "SECURITY";
 	   	  	recItem.addItem(new HiddenObject("secFlag",secFlagArray));
 	   	  	
 	   	  	var moduleArray:Array = new Array(1);
 	   	  	moduleArray[0]= "TRD";
 	   	  	recItem.addItem(new HiddenObject("module",moduleArray));
 	   	  	
 	   	  	var settlementForArray:Array = new Array(1);
 	   	  	settlementForArray[0]= "SECURITY_TRADE";
 	   	  	recItem.addItem(new HiddenObject("settlementFor",settlementForArray));
 	   	  	
 	   	  	var deliveryMethodArray:Array = new Array(1);
 	   	  	deliveryMethodArray[0]= this.deliveryMethodStr;
 	   	  	//deliveryMethodArray[0]= "BOOK_ENTRY";
 	   	  	recItem.addItem(new HiddenObject("deliveryMethod",deliveryMethodArray));
 	   	  	
 	   	  	var executionMarketPkArray:Array = new Array(1);
 	   	  	executionMarketPkArray[0]= this.finInstPkStr;
 	   	  	recItem.addItem(new HiddenObject("executionMarketPk",executionMarketPkArray));
 	   	  	
 	   	  	var stlLocSecArray:Array = new Array(1);
 	   	  	stlLocSecArray[0]= this.stlLocationSecStr != null ? this.stlLocationSecStr: "";
 	   	  	recItem.addItem(new HiddenObject("stlLocSec",stlLocSecArray));
 	   	  	
 	   	  	ssiRulePopUp.showCloseButton=true; 		   	  	
	        ssiRulePopUp.owner = this;
	        ssiRulePopUp.receiveCtxItems = recItem;
	        
	        ssiRulePopUp.retCpSecSsiPk = this.cpSecSsiPk;
	        ssiRulePopUp.retSecurityFlag = this.cashSecFlagSec;
	        ssiRulePopUp.retBrokerBicForSec = this.brokerBicSec;
	        ssiRulePopUp.retAcronymForSec = this.acronymSec;
	        ssiRulePopUp.retInstrumentTypeForSec = this.securityTypeSec;
	        ssiRulePopUp.retSettlementCcyForSec = this.ccySec;
	        ssiRulePopUp.retSettlementTypeForSec = this.stlTypeSec;
	        ssiRulePopUp.retBankNameForSec = this.bankNameSec;
	        ssiRulePopUp.retContraIdForSec = this.contraIdSec;
	        ssiRulePopUp.retDtcParticipantNumberForSec = this.dtcPartNoSec;
	        ssiRulePopUp.retCpExternalSettleActForSec = this.dtcExtStlAccSec;
	        ssiRulePopUp.retPriorityForSec = this.prioritySec;
	        ssiRulePopUp.retPlaceOfSettlementForSec = this.placeOfStlSec;
	        ssiRulePopUp.retParticipantIdForSec = this.partIdSec;
	        ssiRulePopUp.retParticipantId2ForSec = this.partId2Sec;
	        ssiRulePopUp.retStatusSec = this.statusSec;
	       
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
	   	this.cashSecFlagCash.text = "";
	   	this.brokerBicCash.text = "";
	   	this.acronymCash.text = "";
	   	this.securityTypeCash.text = "";
	   	this.ccyCash.text = "";
	   	this.stlTypeCash.text = "";
	   	this.bankNameCash.text = "";
	   	this.contraIdCash.text = "";
	   	this.dtcPartNoCash.text = "";
	   	this.dtcExtStlAccCash.text = "";
	   	this.priorityCash.text = "";
	   	this.placeOfStlCash.text = "";
	   	this.partIdCash.text = "";
	   	this.partId2Cash.text = "";
	   }
	   
	   private function selectCashSsi():void{
	   		var ssiRulePopUp:TrdSsiPopup = TrdSsiPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication), TrdSsiPopup , true));
		   	PopUpManager.centerPopUp(ssiRulePopUp);
            var recItem:ArrayCollection = new ArrayCollection();
            
            var accountNoArray:Array = new Array(1);
 	   	  	accountNoArray[0]= this.brokerAccNoTxt.text;
 	   	  	recItem.addItem(new HiddenObject("accountNo",accountNoArray));
 	   	  	
 	   	  	var stlCcyArray:Array = new Array(1);
 	   	  	var stlCcy:String = this.stlCcy.ccyText.text;
 	   	  	if(stlCcy != null){
 	   	  		if(stlCcy.indexOf("/") != -1){
 	   	  			stlCcy = stlCcy.split("/")[0];
 	   	  		}
 	   	  	}
 	   	  	stlCcyArray[0] = stlCcy;
 	   	  	recItem.addItem(new HiddenObject("settlementcurrency",stlCcyArray));
 	   	  	
 	   	  	var instrumentPkArray:Array = new Array(1);
 	   	  	instrumentPkArray[0]= this.instPkStr;
 	   	  	recItem.addItem(new HiddenObject("instrumentPk",instrumentPkArray));
 	   	  	
            var tradeTypeArray:Array = new Array(1);
 	   	  	tradeTypeArray[0]= this.trdTypeStr;
 	   	  	recItem.addItem(new HiddenObject("tradeType",tradeTypeArray));
 	   	  	
 	   	  	var cashFlagArray:Array = new Array(1);
 	   	  	cashFlagArray[0]= "CASH";
 	   	  	recItem.addItem(new HiddenObject("cashFlag",cashFlagArray));
 	   	  	
 	   	  	var moduleArray:Array = new Array(1);
 	   	  	moduleArray[0]= "TRD";
 	   	  	recItem.addItem(new HiddenObject("module",moduleArray));
 	   	  	
 	   	  	var settlementForArray:Array = new Array(1);
 	   	  	settlementForArray[0]= "SECURITY_TRADE";
 	   	  	recItem.addItem(new HiddenObject("settlementFor",settlementForArray));
 	   	  	
 	   	  	var deliveryMethodArray:Array = new Array(1);
 	   	  	deliveryMethodArray[0]= this.deliveryMethodStr;
 	   	  	//deliveryMethodArray[0]= "BOOK_ENTRY";
 	   	  	recItem.addItem(new HiddenObject("deliveryMethod",deliveryMethodArray));
 	   	  	
 	   	  	var executionMarketPkArray:Array = new Array(1);
 	   	  	executionMarketPkArray[0]= this.finInstPkStr;
 	   	  	recItem.addItem(new HiddenObject("executionMarketPk",executionMarketPkArray));
 	   	  	
 	   	  	var stlLocCashArray:Array = new Array(1);
 	   	  	stlLocCashArray[0]= this.stlLocationCashStr != null ? this.stlLocationCashStr: "";
 	   	  	recItem.addItem(new HiddenObject("stlLocCash",stlLocCashArray));
 	   	  	
 	   	  	ssiRulePopUp.showCloseButton=true; 		   	  	
	        ssiRulePopUp.owner = this;
	        ssiRulePopUp.receiveCtxItems = recItem;
	        
	        ssiRulePopUp.retCpCashSsiPk = this.cpCashSsiPk;
	        ssiRulePopUp.retCashFlag = this.cashSecFlagCash;
	        ssiRulePopUp.retBrokerBicForCash = this.brokerBicCash;
	        ssiRulePopUp.retAcronymForCash = this.acronymCash;
	        ssiRulePopUp.retInstrumentTypeForCash = this.securityTypeCash;
	        ssiRulePopUp.retSettlementCcyForCash = this.ccyCash;
	        ssiRulePopUp.retSettlementTypeForCash = this.stlTypeCash;
	        ssiRulePopUp.retBankNameForCash = this.bankNameCash;
	        ssiRulePopUp.retContraIdForCash = this.contraIdCash;
	        ssiRulePopUp.retDtcParticipantNumberForCash = this.dtcPartNoCash;
	        ssiRulePopUp.retCpExternalSettleActForCash = this.dtcExtStlAccCash;
	        ssiRulePopUp.retPriorityForCash = this.priorityCash;
	        ssiRulePopUp.retPlaceOfSettlementForCash = this.placeOfStlCash;
	        ssiRulePopUp.retParticipantIdForCash = this.partIdCash;
	        ssiRulePopUp.retParticipantId2ForCash = this.partId2Cash;
	        ssiRulePopUp.retStatusCash = this.statusCash;
	       
	        ssiRulePopUp.initSsiInfoPopup();
	   }
	   
	   private function checkTradeType():void{
   		if(isInFirstEntryScreen){
   			if(this.tradeType.selectedItem != null){
   				if(XenosStringUtils.equals(this.tradeType.selectedItem.value,"BOND") || 
	   			XenosStringUtils.equals(this.tradeType.selectedItem.value,"EARLY_RDM") ||
	   			XenosStringUtils.equals(this.tradeType.selectedItem.value,"FULL_CALL")||
	   			XenosStringUtils.equals(this.tradeType.selectedItem.value,"PART_CALL")||
	   			XenosStringUtils.equals(this.tradeType.selectedItem.value,"PUT")||
	   			XenosStringUtils.equals(this.tradeType.selectedItem.value,"WR_SUBS")||
	   			XenosStringUtils.equals(instrumentTypeParent,"FI")){
	   				this.bondRow1.visible = true;
	   				this.bondRow1.includeInLayout = true;
	   				this.bondRow2.visible = true;
	   				this.bondRow2addl.visible = true;
	   				this.bondRow2.includeInLayout = true;
	   				this.bondRow2addl.includeInLayout = true;
	   				this.bondRow3.visible = true;
	   				this.bondRow3.includeInLayout = true;
	   				this.poolFactor.text = "";
	   				this.plSuppressFlagLabel.includeInLayout = false;
	   				this.plSuppressFlagLabel.visible = false;
	   				this.plSuppressFlag.includeInLayout = false;
	   				this.plSuppressFlag.visible = false;
	   			}else{
	   				this.accruedStartDate.text = "";
	   				this.accruedStartDate.selectedDate = null;
	   				this.accrDays.text = ""
	   				this.accrInterestAmt.text = "";
	   				this.bondRow1.visible = false;
	   				this.bondRow1.includeInLayout = false;
	   				this.bondRow2.visible = false;
	   				this.bondRow2addl.visible = false;
	   				this.bondRow2.includeInLayout = false;
	   				this.bondRow2addl.includeInLayout = false;
	   				this.bondRow3.visible = false;
	   				this.bondRow3.includeInLayout = false;
	   				if(XenosStringUtils.equals(this.tradeType.selectedItem.value, "CASH_MGR")){
	   					this.plSuppressFlagLabel.includeInLayout = true;
	   					this.plSuppressFlagLabel.visible = true;
	   					this.plSuppressFlag.includeInLayout = true;
	   					this.plSuppressFlag.visible = true;
	   				}else{
	   					this.plSuppressFlagLabel.includeInLayout = false;
	   					this.plSuppressFlagLabel.visible = false;
	   					this.plSuppressFlag.includeInLayout = false;
	   					this.plSuppressFlag.visible = false;
	   				}
	   			}
   			}else if(!XenosStringUtils.isBlank(trdTypeStr)){
   				if(XenosStringUtils.equals(trdTypeStr,"BOND") || 
	   			XenosStringUtils.equals(trdTypeStr,"EARLY_RDM") ||
	   			XenosStringUtils.equals(trdTypeStr,"FULL_CALL")||
	   			XenosStringUtils.equals(trdTypeStr,"PART_CALL")||
	   			XenosStringUtils.equals(trdTypeStr,"PUT")||
	   			XenosStringUtils.equals(trdTypeStr,"WR_SUBS")||
	   			XenosStringUtils.equals(instrumentTypeParent,"FI")){
	   				this.bondRow1.visible = true;
	   				this.bondRow1.includeInLayout = true;
	   				this.bondRow2.visible = true;
	   				this.bondRow2addl.visible = true;
	   				this.bondRow2.includeInLayout = true;
	   				this.bondRow2addl.includeInLayout = true;
	   				this.bondRow3.visible = true;
	   				this.bondRow3.includeInLayout = true;
	   				this.poolFactor.text = "";
	   				this.plSuppressFlagLabel.includeInLayout = false;
	   				this.plSuppressFlagLabel.visible = false;
	   				this.plSuppressFlag.includeInLayout = false;
	   				this.plSuppressFlag.visible = false;
	   			}else{
	   				this.accruedStartDate.text = "";
	   				this.accruedStartDate.selectedDate = null;
	   				this.accrDays.text = ""
	   				this.accrInterestAmt.text = "";
	   				this.bondRow1.visible = false;
	   				this.bondRow1.includeInLayout = false;
	   				this.bondRow2.visible = false;
	   				this.bondRow2addl.visible = false;
	   				this.bondRow2.includeInLayout = false;
	   				this.bondRow2addl.includeInLayout = false;
	   				this.bondRow3.visible = false;
	   				this.bondRow3.includeInLayout = false;
	   				if(XenosStringUtils.equals(trdTypeStr, "CASH_MGR")){
	   					this.plSuppressFlagLabel.includeInLayout = true;
	   					this.plSuppressFlagLabel.visible = true;
	   					this.plSuppressFlag.includeInLayout = true;
	   					this.plSuppressFlag.visible = true;
	   				}else{
	   					this.plSuppressFlagLabel.includeInLayout = false;
	   					this.plSuppressFlagLabel.visible = false;
	   					this.plSuppressFlag.includeInLayout = false;
	   					this.plSuppressFlag.visible = false;
	   				}
	   			}
   			}else {
   				this.accruedStartDate.text = "";
   				this.accruedStartDate.selectedDate = null;
   				this.accrDays.text = ""
	   			this.accrInterestAmt.text = "";
   				this.bondRow1.visible = false;
	   			this.bondRow1.includeInLayout = false;
	   			this.bondRow2.visible = false;
	   			this.bondRow2addl.visible = false;
	   			this.bondRow2.includeInLayout = false;
	   			this.bondRow2addl.includeInLayout = false;
	   			this.bondRow3.visible = false;
	   			this.bondRow3.includeInLayout = false;
	   			this.plSuppressFlagLabel.includeInLayout = false;
	   			this.plSuppressFlagLabel.visible = false;
	   			this.plSuppressFlag.includeInLayout = false;
	   			this.plSuppressFlag.visible = false;
   			}
   			
   		}else{
   			if(XenosStringUtils.equals(trdTypeTxtStr,"Bond Trade") || 
   			XenosStringUtils.equals(trdTypeTxtStr,"Early Redemption") ||
   			XenosStringUtils.equals(trdTypeTxtStr,"Full Call")||
   			XenosStringUtils.equals(trdTypeTxtStr,"Partial Call")||
   			XenosStringUtils.equals(trdTypeTxtStr,"Put")||
   			XenosStringUtils.equals(trdTypeTxtStr,"Warrant Subs")||
	   		XenosStringUtils.equals(instrumentTypeParent,"FI")){
   				this.bondRow1.visible = true;
   				this.bondRow1.includeInLayout = true;
   				this.bondRow2.visible = true;
   				this.bondRow2addl.visible = true;
	   			this.bondRow2.includeInLayout = true;
	   			this.bondRow2addl.includeInLayout = true;
	   			this.bondRow3.visible = true;
	   			this.bondRow3.includeInLayout = true;
   				this.poolFactor.text = "";
   				this.plSuppressFlagLabel.includeInLayout = false;
	   			this.plSuppressFlagLabel.visible = false;
	   			this.plSuppressFlag.includeInLayout = false;
	   			this.plSuppressFlag.visible = false;
   			}else{
   				this.accruedStartDate.text = "";
   				this.accrDays.text = ""
	   			this.accrInterestAmt.text = "";
   				this.accruedStartDate.selectedDate = null;
   				this.bondRow1.visible = false;
   				this.bondRow1.includeInLayout = false;
   				this.bondRow2.visible = false;
   				this.bondRow2addl.visible = false;
	   			this.bondRow2.includeInLayout = false;
	   			this.bondRow2addl.includeInLayout = false;
	   			this.bondRow3.visible = false;
	   			this.bondRow3.includeInLayout = false;
   				if(XenosStringUtils.equals(trdTypeTxtStr, "Cash Merger")){
	   					this.plSuppressFlagLabel.includeInLayout = true;
	   					this.plSuppressFlagLabel.visible = true;
	   					this.plSuppressFlag.includeInLayout = true;
	   					this.plSuppressFlag.visible = true;
	   				}else{
	   					this.plSuppressFlagLabel.includeInLayout = false;
	   					this.plSuppressFlagLabel.visible = false;
	   					this.plSuppressFlag.includeInLayout = false;
	   					this.plSuppressFlag.visible = false;
	   				}
   			}
   		}
	   }
	   
	   private function checkBuySell():void{
	   	this.netAmt.text = "";
	   	this.netAmtInTrdCcy.text = "";
	   }
	   
	   /** 
	   * If PL Suppress Flag is Y and Quantity =0, then Principal Amount field will be editable
	   * This validation needs to be done in second trade entry screen only. As Amount field is present 
	   * in second Trade Entry Screen only.
	   */
	   private function checkPlSuppressFlag():void{
	   	if(!isInFirstEntryScreen){
	   		if(XenosStringUtils.equals(trdTypeTxtStr, "Cash Merger") && this.plSuppressFlag.selectedItem != null && this.plSuppressFlag.selectedItem.value == 'Y'){
	   				var qtyCurrentWOComma:String = clearComma(StringUtil.trim(quantity.text));
	   				var qtyCurrent:Number = new Number(qtyCurrentWOComma);
	   				if(qtyCurrent == 0){
		   				this.principalAmt.editable = true;
		   				this.principalAmt.enabled = true;	
	   				}else{
	   					this.principalAmt.editable = false;
	   					this.principalAmt.enabled = false;
	   				}
	   		}else{
	   				this.principalAmt.editable = false;
	   				this.principalAmt.enabled = false;
	   				//this.principalAmt.disabledColor ="0x000000";
	   		}
	   	}
	   }
	   
	   //XGA-105
	   /*
	   private function controlShortSellAndExemptFlag():void{
	   	if(XenosStringUtils.isBlank(this.shortSellFlag.selectedItem.value) && 
	   	   XenosStringUtils.isBlank(this.shortSellExemptFlag.selectedItem.value)){
	   		this.shortSellExemptFlag.visible = true;
	   		this.shortSellExemptFlag.includeInLayout = true;
	   		this.shortSellExemptFlagLbl.visible = true;
	   		this.shortSellExemptFlagLbl.includeInLayout = true;
	   		this.shortSellFlag.visible = true;
	   		this.shortSellFlag.includeInLayout = true;
	   		this.shortSellFlagLbl.visible = true;
	   		this.shortSellFlagLbl.includeInLayout = true;
	   	}else if(!XenosStringUtils.isBlank(this.shortSellFlag.selectedItem.value)){
	   		this.shortSellExemptFlag.visible = false;
	   		this.shortSellExemptFlag.includeInLayout = false;
	   		this.shortSellExemptFlagLbl.visible = false;
	   		this.shortSellExemptFlagLbl.includeInLayout = false;
	   		this.shortSellFlag.visible = true;
	   		this.shortSellFlag.includeInLayout = true;
	   		this.shortSellFlagLbl.visible = true;
	   		this.shortSellFlagLbl.includeInLayout = true;
	   	}else if(!XenosStringUtils.isBlank(this.shortSellExemptFlag.selectedItem.value)){
	   		this.shortSellExemptFlag.visible = true;
	   		this.shortSellExemptFlag.includeInLayout = true;
	   		this.shortSellExemptFlagLbl.visible = true;
	   		this.shortSellExemptFlagLbl.includeInLayout = true;
	   		this.shortSellFlag.visible = false;
	   		this.shortSellFlag.includeInLayout = false;
	   		this.shortSellFlagLbl.visible = false;
	   		this.shortSellFlagLbl.includeInLayout = false;
	   	}
	   }
	   */
	   
	   private function checkSecurity(event:Event):void{
	   		this.principalAmt.text = "";
		   	this.netAmt.text = "";
		   	this.netAmtInTrdCcy.text = "";
		   	this.accrDays.text = "";
		   	this.accruedStartDate.text = "";
		   	this.accruedStartDate.selectedDate = null;
		   	this.accrInterestAmt.text = "";
		   	this.executionMarket.text = "";
		   	this.exchangeRate.text = "";
		   	this.stlCcy.ccyText.text = "";
		   	this.tradeCcy.ccyText.text = "";
		   	this.interestRate.text = "";
		   	this.principalAmtInIssueCcy.text = "";
		   	this.price.text = "";
	   }
	   
	   private function checkQty():void{
	   		var qtyInitWOComma:String = clearComma(StringUtil.trim(qtyStr));
	   		var qtyCurrentWOComma:String = clearComma(StringUtil.trim(quantity.text));
		   	var qtyInit:Number = new Number(qtyInitWOComma);
		   	var qtyCurrent:Number = new Number(qtyCurrentWOComma);
		   	if(qtyInit != qtyCurrent){
		   		this.principalAmt.text = "";
			   	this.netAmt.text = "";
			   	this.netAmtInTrdCcy.text = "";
			   	this.accrDays.text = "";
			   	this.accrInterestAmt.text = "";
			   	this.currentFaceValue.text = "";
			   	this.principalAmtInIssueCcy.text = "";
			   	this.price.text = "";	
		   	}
	   }
	   
	   /**
	   *This api will check whether index taio has been changed from initial or not. 
	   * if changed, Then it will clear amount fields so that they are recalculated.	   
	   **/
	   private function checkIndexRatio():void{
	   		var indxRatioInitWOComma:String = clearComma(StringUtil.trim(indxRatioTempStr));
	   		var indxRatioCurrentWOComma:String = clearComma(StringUtil.trim(indexRatio.text));
		   	var indxRatioInit:Number = new Number(indxRatioInitWOComma);
		   	var indxRatioCurrent:Number = new Number(indxRatioCurrentWOComma);
		   	if(indxRatioInit != indxRatioCurrent){
		   		this.principalAmt.text = "";
			   	this.netAmt.text = "";
			   	this.netAmtInTrdCcy.text = "";
			   	this.accrDays.text = "";
			   	this.accrInterestAmt.text = "";
			   	this.principalAmtInIssueCcy.text = "";	
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
	   
	   private function checkGrossNetType():void{
	   	this.price.text = "";
	   	this.netAmt.text = "";
	   	this.netAmtInTrdCcy.text = "";
	   }
	   
	   private function checkInputPriceFormat():void{
	   	this.principalAmt.text = "";
	   	this.price.text = "";
	   	this.netAmt.text = "";
	   	this.netAmtInTrdCcy.text = "";
	   	this.accrInterestAmt.text = "";
	   }
	   
	   private function checkTradeCcy(event:FocusEvent):void{
		   	if(!XenosStringUtils.equals(trdCcyStr,tradeCcyTxt.text)){
		   		this.principalAmt.text = "";
			   	this.netAmt.text = "";
			   	this.netAmtInTrdCcy.text = "";
			   	this.principalAmtInIssueCcy.text = "";
		   	}
	   }
	   
	   private function checkExecutionMarket(event:Event):void{
	   	this.valueDate.selectedDate = null;
	   	this.netAmt.text = "";
	   	this.netAmtInTrdCcy.text = "";
	   }
	   
	   private function securityImgClickHandler(event:MouseEvent):void{
        this.securityCode.instrumentId.addEventListener(FlexEvent.VALUE_COMMIT,setFocusOnParent);
       }
       
       private function setFocusOnParent(event:Event):void{
        (TextInput(event.currentTarget)).setFocus();
        (TextInput(event.currentTarget)).removeEventListener(FlexEvent.VALUE_COMMIT,setFocusOnParent);
       }
       
       private function trdImgClickHandler(event:MouseEvent):void{
         tradeCcy.ccyText.addEventListener(FlexEvent.VALUE_COMMIT,setFocusOnParent);
       }
	   
	   private function checkExchngRateOrCalcType():void{
	   	this.netAmt.text = "";
	   }
	   
	   private function checkNegAccrIntFlag():void{
	   	this.netAmt.text = "";
	   	this.netAmtInTrdCcy.text = "";
	   }
	   
	   private function checkAccrIntAmt():void{
	   	this.netAmt.text = "";
	   	this.netAmtInTrdCcy.text = "";
	   }
	   private function checkAccruedDays():void{
	   	this.netAmt.text = "";
	   	this.netAmtInTrdCcy.text = "";
	   	this.accrInterestAmt.text = "";
	   }
	   
	   private function clearAmountFields():void{
	   	this.principalAmt.text = "";
	   	this.principalAmtInIssueCcy.text = "";
	   	this.price.text = "";
	   	this.netAmt.text = "";
	   	this.netAmtInTrdCcy.text = "";
	   }
	   
	   private function checkInputPrice():void{
	   		var ipPriceInitWOComma:String = clearComma(StringUtil.trim(ipPriceStr));
	   		var ipPriceCurrentWOComma:String = clearComma(StringUtil.trim(inputPrice.text));
		   	var inputPriceInit:Number = new Number(ipPriceInitWOComma);
		   	var inputPriceCurrent:Number = new Number(ipPriceCurrentWOComma);
		   	if(inputPriceInit != inputPriceCurrent){
		   		this.principalAmt.text = "";
			   	this.principalAmtInIssueCcy.text = "";
			   	this.price.text = "";
			   	this.netAmt.text = "";
			   	this.netAmtInTrdCcy.text = "";
		   	}
	   }
	   
	   private function calculateNetAmount():void{
	   	this.principalAmtTemp = this.principalAmt.text;
	   	this.clearAmountFields();
	   	this.checkValueDate();
	   	var reqObj:Object = new Object();
		reqObj.rnd = Math.random()+"";
		reqObj = populateRequestParams();
		reqObj.method = "recalculateAmounts";
		if(this.mode == 'amendment'){
			calcNetAmtRequest.url = 'trd/tradeEntryAmend.action?';
		}
		calcNetAmtRequest.request = reqObj;
        calcNetAmtRequest.send();
	   }
	   private function loadCalculatedNetAmount(event:ResultEvent):void{
	   	app.submitButtonInstance = submitAddlEntry;
	   	if(event != null){
	    		if(event.result != null){
	    			if(event.result.tradeEntryActionForm != null){
	    				if(event.result.tradeEntryActionForm.tradeScreenData != null){
							errPage.clearError(super.getInitResultEvent());
							this.accrInterestAmt.text = event.result.tradeEntryActionForm.tradeScreenData.accruedInterestAmountStr;
							this.accrDays.text = event.result.tradeEntryActionForm.tradeScreenData.accruedDaysStr;
							
							if(event.result.tradeEntryActionForm.tradeScreenData.accruedStartDateStr != null){
								this.accruedStartDate.selectedDate = DateUtils.toDate(event.result.tradeEntryActionForm.tradeScreenData.accruedStartDateStr);
							}
							
							this.price.text = event.result.tradeEntryActionForm.tradeScreenData.priceStr;
							this.principalAmt.text = event.result.tradeEntryActionForm.tradeScreenData.principalAmountStr;
							this.principalAmtInIssueCcy.text = event.result.tradeEntryActionForm.tradeScreenData.principalAmountInIssueStr;
							this.interestRate.text = event.result.tradeEntryActionForm.tradeScreenData.interestRateStr;
							this.netAmt.text = event.result.tradeEntryActionForm.tradeScreenData.netAmountStr;
							this.netAmtInTrdCcy.text = event.result.tradeEntryActionForm.tradeScreenData.netAmountInTradingCurrency;
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
	   
	   
	   private function doSubmitToCancelConf():void{
	   	cancelSubmit.enabled = false;
	   	var reqObj:Object = new Object();
		reqObj.rnd = Math.random()+"";
		reqObj.tradePk = this.tradePkStr;
		reqObj.updateDateStr = this.updateDateStr;
		reqObj.SCREEN_KEY = "11081";
		reqObj.method = "tradeCancelConfirm";
		cancelConfRequest.request = reqObj;
        cancelConfRequest.send();
	   }
	   
	   private function loadCancelConfirmation(event:ResultEvent):void{
	   	cancelSubmit.enabled = true;
	   	if(event != null){
	    		if(event.result != null){
	    			if(event.result.tradeCancelActionForm != null){
	    				app.submitButtonInstance = uCancelConfSubmit;
	    				cxlErrPage.clearError(super.getInitResultEvent());
						vstack.selectedChild = cancelConfs;
						uConfCxlLabel.text=this.parentApplication.xResourceManager.getKeyValue('trd.cancel.conf');
						cancelConfs.visible = true;
						cancelConfs.includeInLayout = true;
						cxlSysConf.visible = false;
						cxlSysConf.includeInLayout = false;
						this.cancelRemarks.text = "";
	    				if(event.result.tradeCancelActionForm.reasonList != null){
							item = new Object();
							initcol = new ArrayCollection();
							initcol.addItem({label:" ",value:" "});
							if((event.result.tradeCancelActionForm.reasonList.item) is ArrayCollection){
								for each(item in (data.filteredTaxFeeIdList.item as ArrayCollection)){
									initcol.addItem(item);
								}
							}else{
								initcol.addItem(event.result.tradeCancelActionForm.reasonList.item);
							}
							this.cxlReasonCombo.dataProvider = initcol;
						}
	    			}else if(event.result.XenosErrors != null){
	    				cxlErrPage.clearError(super.getInitResultEvent());
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
						cxlErrPage.showError(errorInfoList);
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
	   
	   private function doSubmitToSystemConf():void{
	   	var reqObj:Object = new Object();
		reqObj.rnd = Math.random()+"";
		reqObj.tradePk = this.tradePkStr;
		reqObj.updateDateStr = this.updateDateStr;
		reqObj.remarks = this.cancelRemarks.text;
		reqObj.reason = this.cxlReasonCombo.selectedItem != null ? this.cxlReasonCombo.selectedItem.value : "";
		reqObj.SCREEN_KEY = "11082";
		reqObj.method = "tradeCancelPerform";
		cancelSystemConfForRequest.request = reqObj;
		if(!XenosStringUtils.isBlank(StringUtil.trim(cancelRemarks.text))){
			uCancelConfSubmit.enabled = false;
			cancelBtn.enabled = false;
			cancelSystemConfForRequest.send();
		}else{
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.remarks.missing'));
		}
	   }
	   
	   private function loadSystemConfirmationForCancel(event:ResultEvent):void{
	   	uCancelConfSubmit.enabled = true;
	   	cancelBtn.enabled = true;
	   	if(event != null){
	    		if(event.result != null){
	    			if(event.result.tradeCancelActionForm != null){
	    				app.submitButtonInstance = sConfCxlOk;
						cxlErrPage.clearError(super.getInitResultEvent());
						uConfCxlLabel.text=this.parentApplication.xResourceManager.getKeyValue('trd.cancel.system.conf');
						uCancelConfSubmit.visible = false;
						uCancelConfSubmit.includeInLayout = false;
						cancelBtn.visible = false;
						cancelBtn.includeInLayout = false;
						sConfCxlOk.visible = true;
						sConfCxlOk.includeInLayout = true;
						cxlSysConf.visible = true;
						cxlSysConf.includeInLayout = true;
						cxlConf.visible = false;
						cxlConf.includeInLayout = false;
						this.refNoCxl.text = event.result.tradeCancelActionForm.referenceNo;
						this.cancelRefNo.text = event.result.tradeCancelActionForm.cancelReferenceNo;
	    			}else if(event.result.XenosErrors != null){
	    				cxlErrPage.clearError(super.getInitResultEvent());
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
						cxlErrPage.showError(errorInfoList);
						cxlSysConf.visible = false;
						cxlSysConf.includeInLayout = false;
						cxlConf.visible = true;
						cxlConf.includeInLayout = true;
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
	   
	    private function onChangeFundAccountNo(event:Event):void{
    		OnDataChangeUtil.onChangeFundAccountNo(fundAccName,fundAccountPopup.accountNo.text);
//    		fundAccName.setFocus();
	    }
	    
	    private function onChangeBrokerAccountNo(event:Event):void{
    		OnDataChangeUtil.onChangeAccountNo(brokerAccName,brokerAccPopUp.accountNo.text);
//    		brokerAccName.setFocus();
	    }
	    
	    private function onChangeSecurityCode(event:Event):void{
	    	OnDataChangeUtil.onChangeSecurityCode(securityName,securityCode.instrumentId.text);
//	    	securityName.setFocus();
	    } 
	    
	    private function onChangeFundAccountNoTxt(event:Event):void{
    		OnDataChangeUtil.onChangeFundAccountNo(fundAccName,fundAccNoTxt.text);
    		fundAccNoTxt.removeEventListener(FlexEvent.VALUE_COMMIT,onChangeFundAccountNoTxt);
	    }
	    
	    private function onChangeBrokerAccountNoTxt(event:Event):void{
    		OnDataChangeUtil.onChangeAccountNo(brokerAccName,brokerAccNoTxt.text);
    		brokerAccNoTxt.removeEventListener(FlexEvent.VALUE_COMMIT,onChangeBrokerAccountNoTxt);
	    }
	    
	    private function onChangeSecurityCodeTxt(event:Event):void{
	    	OnDataChangeUtil.onChangeSecurityCode(securityName,securityCodeTxt.text);
	    	securityCodeTxt.removeEventListener(FlexEvent.VALUE_COMMIT,onChangeSecurityCodeTxt);
	    } 
